/*
    -Project name:
           Regulator
    -Description:
           This program demonstrates simple air levitation using the basic knowledge about PI regulators
    -Test configuration:
     MCU:             P18F4520
     Dev.Board:       EasyPIC4
     SW:              mikroC PRO v5.6.1
     Oscillator:      HS, 08.0000 MHz
     Ext. Modules:    D/A Converter
     Date:            20.11.2012.
*/

#include "buttons.h"
#include "lcd.h"

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

int timer_flag = 0;

// Timed Interrupt on 0.02 sec
void interrupt()
{
    timerTicks++;
    timer_flag = 1;
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

    // inicijalizacija i brisanje display-a
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
}
