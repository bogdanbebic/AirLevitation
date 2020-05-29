#line 1 "C:/Users/ku170228d/Desktop/urv_mikroC/Kostur/pid_regulation.c"




int reference = 0;
int measurement = 0;

static int filtered_reference = 0;
static int filtered_measurement = 0;


int actuator_value = 0;
static int upper_limit = 1000;
static int lower_limit = 0;

const double kp = 0.5;


const double ti = 1;


int is_auto = 0;
static int is_auto_previous = 0;

static int error = 0;
static int error_previous = 0;


int control_aggregated = 0;
static int control_proportional = 0;
static int control_integral = 0;
static int control_integral_previous = 0;

static int stop_integral_control = 0;

void pid()
{

 if (!is_auto_previous) {
 reference = measurement;
 filtered_reference = reference;
 filtered_measurement = measurement;
 error_previous = reference - measurement;
 }

 filtered_reference = 1.0 / (1.0 +  0.02 ) * reference +  0.02  / (1.0 +  0.02 ) * filtered_reference;
 filtered_measurement = 1.0 / (1.0 +  0.02 ) * measurement +  0.02  / (1.0 +  0.02 ) * filtered_measurement;

 error = filtered_reference - filtered_measurement;

 control_proportional = kp * error;


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
 control_integral = control_integral + kp *  0.02  / ti * error;
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
