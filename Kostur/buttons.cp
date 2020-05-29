#line 1 "C:/Users/ku170228d/Desktop/urv_mikroC/Kostur/buttons.c"
#line 1 "c:/users/ku170228d/desktop/urv_mikroc/kostur/lcd.h"

void lcd_show_height_percentage(int height_percentage);

void lcd_show_reference_percentage(int reference_percentage);

void lcd_show_control_percentage(int control_percentage);
#line 3 "C:/Users/ku170228d/Desktop/urv_mikroC/Kostur/buttons.c"
int convert_percentage_to_actuator(int percentage);
void DAC_Output(unsigned int valueDAC);

extern int is_auto;
extern int reference;
extern int actuator_value;

void handle_button_auto_event(void)
{
 is_auto = 1;
}

void handle_button_manual_event(void)
{
 is_auto = 0;
}

void handle_button_increase_event(void)
{
 const int increment = 5;
 const int max_reference = 1000, max_actuator = 1000;
 if (is_auto && reference + increment <= max_reference)
 {
 reference += increment;
 }

 if (!is_auto && actuator_value + increment <= max_actuator)
 {
 actuator_value += increment;
 DAC_Output(convert_percentage_to_actuator(actuator_value));
 }
}

void handle_button_decrease_event(void)
{
 const int decrement = 5;
 const int min_reference = 0, min_actuator = 0;
 if (is_auto && reference - decrement >= min_reference)
 {
 reference -= decrement;
 }

 if (!is_auto && actuator_value - decrement >= min_actuator)
 {
 actuator_value -= decrement;
 DAC_Output(convert_percentage_to_actuator(actuator_value));
 }
}

static int button_auto_oldstate;
static int button_manual_oldstate;
static int button_increase_oldstate;
static int button_decrease_oldstate;

enum ButtonIndex { AUTO = 0, MANUAL = 1, INCREASE = 2, DECREASE = 3 };

void check_and_handle_button_auto_event(void)
{
 if (Button(&PORTB, AUTO, 1, 1))
 button_auto_oldstate = 1;
 if (button_auto_oldstate && Button(&PORTB, AUTO, 1, 0))
 {
 handle_button_auto_event();
 button_auto_oldstate = 0;
 }
}

void check_and_handle_button_manual_event(void)
{
 if (Button(&PORTB, MANUAL, 1, 1))
 button_manual_oldstate = 1;
 if (button_manual_oldstate && Button(&PORTB, MANUAL, 1, 0))
 {
 handle_button_manual_event();
 button_manual_oldstate = 0;
 }
}

void check_and_handle_button_increase_event(void)
{
 if (Button(&PORTB, INCREASE, 1, 1))
 button_increase_oldstate = 1;
 if (button_increase_oldstate && Button(&PORTB, INCREASE, 1, 0))
 {
 handle_button_increase_event();
 button_increase_oldstate = 0;
 }
}

void check_and_handle_button_decrease_event(void)
{
 if (Button(&PORTB, DECREASE, 1, 1))
 button_decrease_oldstate = 1;
 if (button_decrease_oldstate && Button(&PORTB, DECREASE, 1, 0))
 {
 handle_button_decrease_event();
 button_decrease_oldstate = 0;
 }
}
