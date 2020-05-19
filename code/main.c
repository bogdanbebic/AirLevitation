/*
 *  Description:
 *  This program demonstrates simple control of temperature 
 *  and air levitation using the basic knowledge about PI regulators
 * 
 *  Test configuration:
 *  MCU:             P18F4520
 *  Dev.Board:       EasyPIC4
 *  SW:              mikroC PRO v5.6.1
 *  Oscillator:      HS, 08.0000 MHz
 *  Ext. Modules:    D/A Converter
 */

const char _CHIP_SELECT = 1;

unsigned short int oldstate;
float u, y;
int y_int, u_int;
char *text = "  TEMPERATURA";
unsigned int timerTicks;
int dig1;
char cifra1;

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

// Timed Interrupt on 0.02 sec
void interrupt()
{
    timerTicks++;
    TMR1H = 99;      // 40000 counts until overflow 40000=65535-(99*256+192)
    TMR1L = 192;     // 40000/2000000=0.02sec on 8MHz, 2000000=8MHz/4
    T1CON = 0x01;    // TMR1ON: Timer1 On bit 1 = Enables Timer1
    PIR1.TMR1IF = 0; // Clear interrupt request bit
    PIE1 = 1;        // TMR1IE: TMR1 Overflow Interrupt Enable bit, 1 = Enables
    INTCON = 0xC0;   // Interrupts enable
}

// DAC increments (0..4095) --> output voltage (0..5V)
void DAC_Output(unsigned int valueDAC)
{
    char temp;
    PORTC &= ~(_CHIP_SELECT);      // ClearBit(PORTC,CHIP_SELECT);
                                   // Prepare for data transfer
    temp = (valueDAC >> 8) & 0x0F; // Prepare hi-byte for transfer
    temp |= 0x30;                  // It's a 12-bit number, so only
    SPI1_write(temp);              //   lower nibble of high byte is used
    temp = valueDAC;               // Prepare lo-byte for transfer
    SPI1_write(temp);

    PORTC |= _CHIP_SELECT; // SetBit(PORTC,CHIP_SELECT);
}

void main()
{
    // Inicijalizacija portova i periferija
    ADCON1 = 0x0F;            // Turn off A/D converters on PORTB
    TRISA = 0xFF;             // Set PORTA pins as input pins(to work with A/D converter)
    TRISB = 0xFF;             // Set PORTB pins as input pins(to work with keybord)
    TRISC &= ~(_CHIP_SELECT); // SPI ClearBit(TRISC,CHIP_SELECT);
    TRISD = 0x00;             // Set PORTD pins as output pins(to work with LCD display)
    SPI1_init();              // Initialisation of SPI communication

    // inicijalizacija interapt rutine
    timerTicks = 0;
    TMR1H = 99;      // 40000 counts until overflow 40000=65535-(99*256+192)
    TMR1L = 192;     // 40000/2000000=0.02sec on 8MHz, 2000000=8MHz/4
    T1CON = 0x01;    // TMR1ON: Timer1 On bit 1 = Enables Timer1
    PIR1.TMR1IF = 0; // Clear interrupt request bit
    PIE1 = 1;        // TMR1IE: TMR1 Overflow Interrupt Enable bit, 1 = Enables
    INTCON = 0xC0;   // Interrupts enable

    //  Odavde ide korisnicki kod

    // inicijalizacija i brisanje display-a
    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
    dig1 = 5;
    cifra1 = dig1 + 48;     // Dodavanje ASCII koda (na 48 pocinju cifre)
    Lcd_Chr(2, 12, cifra1); // ispisivanje cifre1
    Lcd_Chr(2, 13, '%');    // ispisivanje procenta

    // citanje pina RB0 porta B

    oldstate = 0;
    if (Button(&PORTB, 0, 1, 1)) // detect logical one on RB0 pin
        oldstate = 1;
    if (oldstate && Button(&PORTB, 0, 1, 0)) // detect one-to-zero transition on RB0 pin
    {
        // Ovde idu komande koje se izvrsavaju ukoliko je pritisnut taster na pinu RB0

        oldstate = 0; // Poslednja komanda koja se izvrsava ukoliko je pritisnut taster
    }

    // AD i DA konverzija
    y_int = Adc_Read(3); // citanje sa AD konvertora, kanal 3 (vraca vrednost u opsegu 0-1023)
    DAC_Output(u_int);   // upis na DA konvertor (0-4095)
}
