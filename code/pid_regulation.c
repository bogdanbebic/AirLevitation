
#define SAMPLE_PERIOD 0.02

// inputs
int reference = 0;
int measurement = 0;

static int filtered_reference = 0;
static int filtered_measurement = 0;

// input
int actuator_value = 0;
static int upper_limit = 1000;
static int lower_limit = 0;

const double kp = 0.5;

// const double ki;
const double ti = 1;

// input/output -> state
int is_auto = 0;
static int is_auto_previous = 0;

static int error = 0;
static int error_previous = 0;

// output
int control_aggregated = 0;
static int control_proportional = 0;
static int control_integral = 0;
static int control_integral_previous = 0;

static int stop_integral_control = 0;

void pid()
{
    // initialization when MAN -> AUTO transfer
    if (!is_auto_previous)
    {
        reference = measurement;
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
    else
    {
        actuator_value = control_aggregated;
    }

    is_auto_previous = is_auto;
}
