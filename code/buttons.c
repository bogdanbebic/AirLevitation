
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
