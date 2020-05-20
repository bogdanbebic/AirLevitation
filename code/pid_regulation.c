
#define SAMPLE_PERIOD 0.02

// inputs
int reference;
int measurement;

static int filtered_reference;
static int filtered_measurement;

// input
int actuator_value;
static int upper_limit;
static int lower_limit;

const int kp;

const int ki;
const int ti;

// input/output -> state
int is_auto;
static int is_auto_previous;

static int error;
static int error_previous;

// output
int control_aggregated;
static int control_proportional;
static int control_integral;
static int control_integral_previous;

static int stop_integral_control;

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
