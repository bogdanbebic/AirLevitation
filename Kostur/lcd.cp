#line 1 "C:/Users/ku170228d/Desktop/urv_mikroC/Kostur/lcd.c"



enum PercentageLcdIndex { HUNDREDS =  16  - 5, TENS, UNITS, DECIMAL_POINT, TENTHS };

void lcd_show_height_percentage(int height_percentage)
{
 LCD_Out(1, 1, "Height:");
 if (height_percentage <= 1000)
 {
 LCD_Chr(1, TENTHS, '0' + height_percentage % 10);
 LCD_Chr(1, DECIMAL_POINT, '.');
 LCD_Chr(1, UNITS, '0' + height_percentage / 10 % 10);
 LCD_Chr(1, TENS, '0' + height_percentage / 100 % 10);
 LCD_Chr(1, HUNDREDS, '0' + height_percentage / 1000 % 10);
 }
 else
 {
 LCD_Out(1, HUNDREDS, "100.0");
 }

 LCD_Out(1,  16 , "%");
}

void lcd_show_reference_percentage(int reference_percentage)
{
 LCD_Out(2, 1, "Reference:");
 if (reference_percentage <= 1000)
 {
 LCD_Chr(2, TENTHS, '0' + reference_percentage % 10);
 LCD_Chr(2, DECIMAL_POINT, '.');
 LCD_Chr(2, UNITS, '0' + reference_percentage / 10 % 10);
 LCD_Chr(2, TENS, '0' + reference_percentage / 100 % 10);
 LCD_Chr(2, HUNDREDS, '0' + reference_percentage / 1000 % 10);
 }
 else
 {
 LCD_Out(2, HUNDREDS, "100.0");
 }

 LCD_Out(2,  16 , "%");
}

void lcd_show_control_percentage(int control_percentage)
{
 LCD_Out(2, 1, "Control:  ");
 if (control_percentage <= 1000)
 {
 LCD_Chr(2, TENTHS, '0' + control_percentage % 10);
 LCD_Chr(2, DECIMAL_POINT, '.');
 LCD_Chr(2, UNITS, '0' + control_percentage / 10 % 10);
 LCD_Chr(2, TENS, '0' + control_percentage / 100 % 10);
 LCD_Chr(2, HUNDREDS, '0' + control_percentage / 1000 % 10);
 }
 else
 {
 LCD_Out(2, HUNDREDS, "100.0");
 }

 LCD_Out(2,  16 , "%");
}
