#line 1 "C:/Users/ku170228d/Desktop/urv_mikroC/Kostur/KosturPRO.c"
#line 1 "c:/users/ku170228d/desktop/urv_mikroc/kostur/buttons.h"

void handle_button_auto_event(void);

void handle_button_manual_event(void);

void handle_button_increase_event(void);

void handle_button_decrease_event(void);

void check_and_handle_button_auto_event(void);

void check_and_handle_button_manual_event(void);

void check_and_handle_button_increase_event(void);

void check_and_handle_button_decrease_event(void);
#line 1 "c:/users/ku170228d/desktop/urv_mikroc/kostur/lcd.h"

void lcd_show_height_percentage(int height_percentage);

void lcd_show_reference_percentage(int reference_percentage);

void lcd_show_control_percentage(int control_percentage);
#line 19 "C:/Users/ku170228d/Desktop/urv_mikroC/Kostur/KosturPRO.c"
const char _CHIP_SELECT = 1;

unsigned short int oldstate;
float u, y;
int y_int, u_int;
char *text = "  TEMPERATURA" ;
unsigned int timerTicks;
int dig1;
char cifra1;



sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;


sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

int timer_flag = 0;


void interrupt() {
 timerTicks++;
 timer_flag = 1;
 TMR1H = 99;
 TMR1L = 192;
 T1CON = 0x01;
 PIR1.TMR1IF= 0;
 PIE1 = 1;
 INTCON = 0xC0;
}



void DAC_Output(unsigned int valueDAC) {
 char temp;
 PORTC &= ~(_CHIP_SELECT);

 temp = (valueDAC >> 8) & 0x0F;
 temp |= 0x30;
 SPI1_write(temp);
 temp = valueDAC;
 SPI1_write(temp);

 PORTC |= _CHIP_SELECT;
}

int convert_height_to_percentage(int height)
{
 const int min_height = 85, max_height = 1023;
 return (height - min_height) * 1000L / (max_height - min_height);
}

int convert_percentage_to_actuator(int percentage)
{
 const int min_actuator = 3300, max_actuator = 4095;
 return min_actuator + (max_actuator - min_actuator) * (long)percentage / 1000L;
}

extern int is_auto;
extern int reference;
extern int control_aggregated;
extern int measurement;
extern int actuator_value;
extern void pid();

void main() {



 ADCON1 = 0x0F;
 TRISA = 0xFF;
 TRISB = 0xFF;
 TRISC &= ~(_CHIP_SELECT);
 TRISD = 0x00;
 SPI1_init();


 timerTicks = 0;
 TMR1H = 99;
 TMR1L = 192;
 T1CON = 0x01;
 PIR1.TMR1IF= 0;
 PIE1 = 1;
 INTCON = 0xC0;







 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);


 while (1)
 {
 measurement = convert_height_to_percentage(Adc_Read(3));
 lcd_show_height_percentage(measurement);
 check_and_handle_button_auto_event();
 check_and_handle_button_manual_event();
 check_and_handle_button_increase_event();
 check_and_handle_button_decrease_event();
 if (is_auto)
 {
 lcd_show_reference_percentage(reference);
 }
 else
 {
 lcd_show_control_percentage(actuator_value);
 }
 if (timer_flag)
 {
 pid();
 DAC_Output(convert_percentage_to_actuator(control_aggregated));
 timer_flag = 0;
 }
 }
#line 171 "C:/Users/ku170228d/Desktop/urv_mikroC/Kostur/KosturPRO.c"
}
