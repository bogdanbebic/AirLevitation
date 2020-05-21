/*
    -Project name:
           Regulator (Demonstation by Kvascev & Todorov & Marjanovic)
    -Description:
           This program demonstrates simple control of temperature 
           and air levitation using the basic knowledge about PI regulators
    -Test configuration:
     MCU:             P18F4520
     Dev.Board:       EasyPIC4
     SW:              mikroC PRO v5.6.1
     Oscillator:      HS, 08.0000 MHz
     Ext. Modules:    D/A Converter
     Date:            20.11.2012.
*/
const char _CHIP_SELECT = 1;

unsigned short int oldstate;
float     u, y;
int       y_int, u_int;
char      *text = "  TEMPERATURA" ;
unsigned int  timerTicks;
int       dig1;
char      cifra1;


// Lcd pinout settings
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

// Pin direction
sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

int timer_flag = 0;

// Timed Interrupt on 0.02 sec
void interrupt() {
    timer_flag = 0;
    timerTicks++;
    TMR1H      =   99;               // 40000 counts until overflow 40000=65535-(99*256+192)
    TMR1L      =   192;              // 40000/2000000=0.02sec on 8MHz, 2000000=8MHz/4
    T1CON      =   0x01;             // TMR1ON: Timer1 On bit 1 = Enables Timer1
    PIR1.TMR1IF=   0;                // Clear interrupt request bit
    PIE1       =   1;                // TMR1IE: TMR1 Overflow Interrupt Enable bit, 1 = Enables
    INTCON     =   0xC0;             // Interrupts enable
}


// DAC increments (0..4095) --> output voltage (0..5V)
void DAC_Output(unsigned int valueDAC) {
  char temp;
  PORTC &= ~(_CHIP_SELECT);           // ClearBit(PORTC,CHIP_SELECT);
                                      // Prepare for data transfer
  temp = (valueDAC >> 8) & 0x0F;      // Prepare hi-byte for transfer
  temp |= 0x30;                       // It's a 12-bit number, so only
  SPI1_write(temp);                   //   lower nibble of high byte is used
  temp = valueDAC;                    // Prepare lo-byte for transfer
  SPI1_write(temp);

  PORTC |= _CHIP_SELECT;              // SetBit(PORTC,CHIP_SELECT);
}

void initialize()
{
// Inicijalizacija portova i periferija
    ADCON1 = 0x0F;                    // Turn off A/D converters on PORTB
    TRISA  = 0xFF;                    // Set PORTA pins as input pins(to work with A/D converter)
    TRISB  = 0xFF;                    // Set PORTB pins as input pins(to work with keybord)
    TRISC &= ~(_CHIP_SELECT);         // SPI ClearBit(TRISC,CHIP_SELECT);
    TRISD  = 0x00;                    // Set PORTD pins as output pins(to work with LCD display)
    SPI1_init();                      // Initialisation of SPI communication

// inicijalizacija interapt rutine
    timerTicks =   0;
    TMR1H      =   99;               // 40000 counts until overflow 40000=65535-(99*256+192)
    TMR1L      =   192;              // 40000/2000000=0.02sec on 8MHz, 2000000=8MHz/4
    T1CON      =   0x01;             // TMR1ON: Timer1 On bit 1 = Enables Timer1
    PIR1.TMR1IF=   0;                // Clear interrupt request bit
    PIE1       =   1;                // TMR1IE: TMR1 Overflow Interrupt Enable bit, 1 = Enables
    INTCON     =   0xC0;             // Interrupts enable

// inicijalizacija i brisanje display-a
    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
}


void show_height_percentage_to_lcd(int height_percentage)
{
   char *txt;
   LCD_Out(1, 1, "Visina:");
   ShortToStr(height_percentage, txt);
   LCD_Out(1, 8, txt);
   LCD_Out(1, 16, "%");
}


void show_reference_percentage_to_lcd(int reference_percentage)
{
   char *txt;
   LCD_Out(2, 1, "Referenca:");
   ShortToStr(reference_percentage, txt);
   LCD_Out(2, 11, txt);
   LCD_Out(2, 16, "%");
}

void show_control_percentage_to_lcd(int control_percentage)
{
   char *txt;
   LCD_Out(2, 1, "Upravljanje:");
   ShortToStr(control_percentage, txt);
   LCD_Out(2, 11, txt);
   LCD_Out(2, 16, "%");
}

int convert_height_to_percentage(int height)
{
    const int min_height = 85, max_height = 1023;
    return (height - min_height) * 100L / (max_height - min_height);
}

// pid

const float SAMPLE_PERIOD = 0.02;

// inputs
long reference;
long measurement;

long filtered_reference;
long filtered_measurement;

// input
long actuator_value;
long upper_limit;
long lower_limit;

const long kp;

const long ki;
const long ti;

// input/output -> state
long is_auto;
long is_auto_previous;

long error;
long error_previous;

// output
long control_aggregated;
long control_proportional;
long control_integral;
long control_integral_previous;

long stop_integral_control;

void pid()
{
    // initialization when MAN -> AUTO transfer
    if (!is_auto_previous) {
        filtered_reference = reference;
        filtered_measurement = measurement;
        error_previous = reference - measurement;
    }

    filtered_reference = 1.0 / (1.0 + SAMPLE_PERIOD) * reference + SAMPLE_PERIOD / (1.0 + SAMPLE_PERIOD) * filtered_reference;
    filtered_measurement = 1.0 / (1.0 + SAMPLE_PERIOD) * measurement + SAMPLE_PERIOD / (1.0 + SAMPLE_PERIOD) * filtered_measurement;

    error = filtered_reference - filtered_measurement;

    control_proportional = kp * error;

    // initialization when MAN -> AUTO transfer
    if (!is_auto_previous)
    {
        control_integral = actuator_value - control_proportional;
        control_integral_previous = control_integral;
        stop_integral_control = 0;
    }

    if (stop_integral_control)
    {
        control_integral = control_integral_previous;
    }
    else
    {
        control_integral = control_integral + kp * SAMPLE_PERIOD / ti * error;
    }

    control_aggregated = control_proportional + control_integral;
    if (control_aggregated >= upper_limit)
    {
        control_aggregated = upper_limit;
        stop_integral_control = 1;
        control_integral_previous = control_integral;
    }

    if (control_aggregated < lower_limit)
    {
        control_aggregated = lower_limit;
        stop_integral_control = 1;
        control_integral_previous = control_integral;
    }

    error_previous = error;

    if (!is_auto)
    {
        control_aggregated = actuator_value;
    }

    is_auto_previous = is_auto;
}

// end pid

int value;
char *ocitani_value_text;
void main() {
    initialize();
    DAC_Output(0);
    show_control_percentage_to_lcd(60);
    // Delay_ms(5000);
    value = Adc_Read(3);
    show_height_percentage_to_lcd(convert_height_to_percentage(value));
    show_reference_percentage_to_lcd(100);
    /*
    LCD_Chr(1, 4, '0' + value % 10);
    LCD_Chr(1, 3, '0' + value / 10 % 10);
    LCD_Chr(1, 2, '0' + value / 100 % 10);
    LCD_Chr(1, 1, '0' + value / 1000 % 10);
    */
    while (1)
    {
        if (Button(&PORTB, 0, 1, 1))                // detect logical one on RB1 pin
            oldstate = 1;
        if (oldstate && Button(&PORTB, 0, 1, 0))  // detect one-to-zero transition on RB1 pin
        {
            is_auto = 1;
            oldstate = 0;
        }
        
        if (Button(&PORTB, 2, 1, 1))                // detect logical one on RB1 pin
            oldstate = 1;
        if (oldstate && Button(&PORTB, 2, 1, 0))  // detect one-to-zero transition on RB1 pin
        {
            is_auto = 0;
            oldstate = 0;
        }
        
        if (Button(&PORTB, 3, 1, 1))                // detect logical one on RB1 pin
            oldstate = 1;
        if (oldstate && Button(&PORTB, 3, 1, 0))  // detect one-to-zero transition on RB1 pin
        {
            is_auto = 3;
            oldstate = 0;
        }

        if (Button(&PORTB, 4, 1, 1))                // detect logical one on RB1 pin
            oldstate = 1;
        if (oldstate && Button(&PORTB, 4, 1, 0))  // detect one-to-zero transition on RB1 pin
        {
            is_auto = 4;
            oldstate = 0;
        }
        
        LCD_Chr(1, 1,'0' + is_auto);
        
        // show_height_percentage_to_lcd(Adc_Read(3));
        if (timer_flag)
        {
            // TODO: pid
            timer_flag = 0;
        }
    }
    
// citanje pina RB0 porta B
     /*
     oldstate = 0;
     if (Button(&PORTB, 0, 1, 1))                // detect logical one on RB0 pin
      oldstate = 1;
     if (oldstate && Button(&PORTB, 0, 1, 0))    // detect one-to-zero transition on RB0 pin
      {
      // Ovde idu komande koje se izvrsavaju ukoliko je pritisnut taster na pinu RB0

      oldstate = 0;                              // Poslednja komanda koja se izvrsava ukoliko je pritisnut taster
      }

// AD i DA konverzija
     y_int = Adc_Read(3);             // citanje sa AD konvertora, kanal 3 (vraca vrednost u opsegu 0-1023)
     DAC_Output(u_int);               // upis na DA konvertor (0-4095)
     */
}