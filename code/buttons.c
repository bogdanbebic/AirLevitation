
extern int is_auto;
extern int reference;

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
    const int increment = 1;
    const int max_reference = 100;
    if (is_auto && reference + increment <= max_reference)
    {
        reference += increment;
    }
}

void handle_button_decrease_event(void)
{
    const int decrement = 1;
    const int min_reference = 0;
    if (is_auto && reference - decrement >= min_reference)
    {
        reference -= decrement;
    }
}

static int button_auto_oldstate;
static int button_manual_oldstate;
static int button_increase_oldstate;
static int button_decrease_oldstate;

enum ButtonIndex { AUTO, MANUAL, INCREASE, DECREASE };

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
        handle_button_auto_event();
        button_manual_oldstate = 0;
    }
}

void check_and_handle_button_increase_event(void)
{
    if (Button(&PORTB, INCREASE, 1, 1))
        button_increase_oldstate = 1;
    if (button_increase_oldstate && Button(&PORTB, INCREASE, 1, 0))
    {
        handle_button_auto_event();
        button_increase_oldstate = 0;
    }
}

void check_and_handle_button_decrease_event(void)
{
    if (Button(&PORTB, DECREASE, 1, 1))
        button_decrease_oldstate = 1;
    if (button_decrease_oldstate && Button(&PORTB, DECREASE, 1, 0))
    {
        handle_button_auto_event();
        button_decrease_oldstate = 0;
    }
}
