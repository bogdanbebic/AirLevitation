
#define LCD_END_INDEX 16

static char *txt;

void lcd_show_height_percentage(short height_percentage)
{
   LCD_Out(1, 1, "Visina:");
   ShortToStr(height_percentage, txt);
   LCD_Out(1, 8, txt);
   LCD_Out(1, LCD_END_INDEX, "%");
}

void lcd_show_reference_percentage(short reference_percentage)
{
   LCD_Out(2, 1, "Referenca:");
   ShortToStr(reference_percentage, txt);
   LCD_Out(2, 11, txt);
   LCD_Out(2, LCD_END_INDEX, "%");
}

void lcd_show_control_percentage(short control_percentage)
{
   LCD_Out(2, 1, "Upravljanje:");
   ShortToStr(control_percentage, txt);
   LCD_Out(2, 11, txt);
   LCD_Out(2, LCD_END_INDEX, "%");
}
