
_pid:

;pid_regulation.c,36 :: 		void pid()
;pid_regulation.c,39 :: 		if (!is_auto_previous) {
	MOVF        pid_regulation_is_auto_previous+0, 0 
	IORWF       pid_regulation_is_auto_previous+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_pid0
;pid_regulation.c,40 :: 		reference = measurement;
	MOVF        _measurement+0, 0 
	MOVWF       _reference+0 
	MOVF        _measurement+1, 0 
	MOVWF       _reference+1 
;pid_regulation.c,41 :: 		filtered_reference = reference;
	MOVF        _measurement+0, 0 
	MOVWF       pid_regulation_filtered_reference+0 
	MOVF        _measurement+1, 0 
	MOVWF       pid_regulation_filtered_reference+1 
;pid_regulation.c,42 :: 		filtered_measurement = measurement;
	MOVF        _measurement+0, 0 
	MOVWF       pid_regulation_filtered_measurement+0 
	MOVF        _measurement+1, 0 
	MOVWF       pid_regulation_filtered_measurement+1 
;pid_regulation.c,43 :: 		error_previous = reference - measurement;
	CLRF        pid_regulation_error_previous+0 
	CLRF        pid_regulation_error_previous+1 
;pid_regulation.c,44 :: 		}
L_pid0:
;pid_regulation.c,46 :: 		filtered_reference = 1.0 / (1.0 + SAMPLE_PERIOD) * reference + SAMPLE_PERIOD / (1.0 + SAMPLE_PERIOD) * filtered_reference;
	MOVF        _reference+0, 0 
	MOVWF       R0 
	MOVF        _reference+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVLW       251
	MOVWF       R4 
	MOVLW       250
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__pid+0 
	MOVF        R1, 0 
	MOVWF       FLOC__pid+1 
	MOVF        R2, 0 
	MOVWF       FLOC__pid+2 
	MOVF        R3, 0 
	MOVWF       FLOC__pid+3 
	MOVF        pid_regulation_filtered_reference+0, 0 
	MOVWF       R0 
	MOVF        pid_regulation_filtered_reference+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVLW       161
	MOVWF       R4 
	MOVLW       160
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       121
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        FLOC__pid+0, 0 
	MOVWF       R4 
	MOVF        FLOC__pid+1, 0 
	MOVWF       R5 
	MOVF        FLOC__pid+2, 0 
	MOVWF       R6 
	MOVF        FLOC__pid+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__pid+4 
	MOVF        R1, 0 
	MOVWF       FLOC__pid+5 
	MOVF        FLOC__pid+4, 0 
	MOVWF       pid_regulation_filtered_reference+0 
	MOVF        FLOC__pid+5, 0 
	MOVWF       pid_regulation_filtered_reference+1 
;pid_regulation.c,47 :: 		filtered_measurement = 1.0 / (1.0 + SAMPLE_PERIOD) * measurement + SAMPLE_PERIOD / (1.0 + SAMPLE_PERIOD) * filtered_measurement;
	MOVF        _measurement+0, 0 
	MOVWF       R0 
	MOVF        _measurement+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVLW       251
	MOVWF       R4 
	MOVLW       250
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__pid+0 
	MOVF        R1, 0 
	MOVWF       FLOC__pid+1 
	MOVF        R2, 0 
	MOVWF       FLOC__pid+2 
	MOVF        R3, 0 
	MOVWF       FLOC__pid+3 
	MOVF        pid_regulation_filtered_measurement+0, 0 
	MOVWF       R0 
	MOVF        pid_regulation_filtered_measurement+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVLW       161
	MOVWF       R4 
	MOVLW       160
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       121
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        FLOC__pid+0, 0 
	MOVWF       R4 
	MOVF        FLOC__pid+1, 0 
	MOVWF       R5 
	MOVF        FLOC__pid+2, 0 
	MOVWF       R6 
	MOVF        FLOC__pid+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       pid_regulation_filtered_measurement+0 
	MOVF        R1, 0 
	MOVWF       pid_regulation_filtered_measurement+1 
;pid_regulation.c,49 :: 		error = filtered_reference - filtered_measurement;
	MOVF        R0, 0 
	SUBWF       FLOC__pid+4, 0 
	MOVWF       R0 
	MOVF        R1, 0 
	SUBWFB      FLOC__pid+5, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       pid_regulation_error+0 
	MOVF        R1, 0 
	MOVWF       pid_regulation_error+1 
;pid_regulation.c,51 :: 		control_proportional = kp * error;
	CALL        _int2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       pid_regulation_control_proportional+0 
	MOVF        R1, 0 
	MOVWF       pid_regulation_control_proportional+1 
;pid_regulation.c,54 :: 		if (!is_auto_previous)
	MOVF        pid_regulation_is_auto_previous+0, 0 
	IORWF       pid_regulation_is_auto_previous+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_pid1
;pid_regulation.c,56 :: 		control_integral = actuator_value - control_proportional;
	MOVF        pid_regulation_control_proportional+0, 0 
	SUBWF       _actuator_value+0, 0 
	MOVWF       R0 
	MOVF        pid_regulation_control_proportional+1, 0 
	SUBWFB      _actuator_value+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       pid_regulation_control_integral+0 
	MOVF        R1, 0 
	MOVWF       pid_regulation_control_integral+1 
;pid_regulation.c,57 :: 		control_integral_previous = control_integral;
	MOVF        R0, 0 
	MOVWF       pid_regulation_control_integral_previous+0 
	MOVF        R1, 0 
	MOVWF       pid_regulation_control_integral_previous+1 
;pid_regulation.c,58 :: 		stop_integral_control = 0;
	CLRF        pid_regulation_stop_integral_control+0 
	CLRF        pid_regulation_stop_integral_control+1 
;pid_regulation.c,59 :: 		}
L_pid1:
;pid_regulation.c,61 :: 		if (stop_integral_control)
	MOVF        pid_regulation_stop_integral_control+0, 0 
	IORWF       pid_regulation_stop_integral_control+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_pid2
;pid_regulation.c,63 :: 		control_integral = control_integral_previous;
	MOVF        pid_regulation_control_integral_previous+0, 0 
	MOVWF       pid_regulation_control_integral+0 
	MOVF        pid_regulation_control_integral_previous+1, 0 
	MOVWF       pid_regulation_control_integral+1 
;pid_regulation.c,64 :: 		}
	GOTO        L_pid3
L_pid2:
;pid_regulation.c,67 :: 		control_integral = control_integral + kp * SAMPLE_PERIOD / ti * error;
	MOVF        pid_regulation_error+0, 0 
	MOVWF       R0 
	MOVF        pid_regulation_error+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       215
	MOVWF       R5 
	MOVLW       35
	MOVWF       R6 
	MOVLW       120
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__pid+0 
	MOVF        R1, 0 
	MOVWF       FLOC__pid+1 
	MOVF        R2, 0 
	MOVWF       FLOC__pid+2 
	MOVF        R3, 0 
	MOVWF       FLOC__pid+3 
	MOVF        pid_regulation_control_integral+0, 0 
	MOVWF       R0 
	MOVF        pid_regulation_control_integral+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        FLOC__pid+0, 0 
	MOVWF       R4 
	MOVF        FLOC__pid+1, 0 
	MOVWF       R5 
	MOVF        FLOC__pid+2, 0 
	MOVWF       R6 
	MOVF        FLOC__pid+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       pid_regulation_control_integral+0 
	MOVF        R1, 0 
	MOVWF       pid_regulation_control_integral+1 
;pid_regulation.c,68 :: 		}
L_pid3:
;pid_regulation.c,70 :: 		control_aggregated = control_proportional + control_integral;
	MOVF        pid_regulation_control_integral+0, 0 
	ADDWF       pid_regulation_control_proportional+0, 0 
	MOVWF       R1 
	MOVF        pid_regulation_control_integral+1, 0 
	ADDWFC      pid_regulation_control_proportional+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _control_aggregated+0 
	MOVF        R2, 0 
	MOVWF       _control_aggregated+1 
;pid_regulation.c,71 :: 		if (control_aggregated >= upper_limit)
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       pid_regulation_upper_limit+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pid9
	MOVF        pid_regulation_upper_limit+0, 0 
	SUBWF       R1, 0 
L__pid9:
	BTFSS       STATUS+0, 0 
	GOTO        L_pid4
;pid_regulation.c,73 :: 		control_aggregated = upper_limit;
	MOVF        pid_regulation_upper_limit+0, 0 
	MOVWF       _control_aggregated+0 
	MOVF        pid_regulation_upper_limit+1, 0 
	MOVWF       _control_aggregated+1 
;pid_regulation.c,74 :: 		stop_integral_control = 1;
	MOVLW       1
	MOVWF       pid_regulation_stop_integral_control+0 
	MOVLW       0
	MOVWF       pid_regulation_stop_integral_control+1 
;pid_regulation.c,75 :: 		control_integral_previous = control_integral;
	MOVF        pid_regulation_control_integral+0, 0 
	MOVWF       pid_regulation_control_integral_previous+0 
	MOVF        pid_regulation_control_integral+1, 0 
	MOVWF       pid_regulation_control_integral_previous+1 
;pid_regulation.c,76 :: 		}
L_pid4:
;pid_regulation.c,78 :: 		if (control_aggregated < lower_limit)
	MOVLW       128
	XORWF       _control_aggregated+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       pid_regulation_lower_limit+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pid10
	MOVF        pid_regulation_lower_limit+0, 0 
	SUBWF       _control_aggregated+0, 0 
L__pid10:
	BTFSC       STATUS+0, 0 
	GOTO        L_pid5
;pid_regulation.c,80 :: 		control_aggregated = lower_limit;
	MOVF        pid_regulation_lower_limit+0, 0 
	MOVWF       _control_aggregated+0 
	MOVF        pid_regulation_lower_limit+1, 0 
	MOVWF       _control_aggregated+1 
;pid_regulation.c,81 :: 		stop_integral_control = 1;
	MOVLW       1
	MOVWF       pid_regulation_stop_integral_control+0 
	MOVLW       0
	MOVWF       pid_regulation_stop_integral_control+1 
;pid_regulation.c,82 :: 		control_integral_previous = control_integral;
	MOVF        pid_regulation_control_integral+0, 0 
	MOVWF       pid_regulation_control_integral_previous+0 
	MOVF        pid_regulation_control_integral+1, 0 
	MOVWF       pid_regulation_control_integral_previous+1 
;pid_regulation.c,83 :: 		}
L_pid5:
;pid_regulation.c,85 :: 		error_previous = error;
	MOVF        pid_regulation_error+0, 0 
	MOVWF       pid_regulation_error_previous+0 
	MOVF        pid_regulation_error+1, 0 
	MOVWF       pid_regulation_error_previous+1 
;pid_regulation.c,87 :: 		if (!is_auto)
	MOVF        _is_auto+0, 0 
	IORWF       _is_auto+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_pid6
;pid_regulation.c,89 :: 		control_aggregated = actuator_value;
	MOVF        _actuator_value+0, 0 
	MOVWF       _control_aggregated+0 
	MOVF        _actuator_value+1, 0 
	MOVWF       _control_aggregated+1 
;pid_regulation.c,90 :: 		}
	GOTO        L_pid7
L_pid6:
;pid_regulation.c,93 :: 		actuator_value = control_aggregated;
	MOVF        _control_aggregated+0, 0 
	MOVWF       _actuator_value+0 
	MOVF        _control_aggregated+1, 0 
	MOVWF       _actuator_value+1 
;pid_regulation.c,94 :: 		}
L_pid7:
;pid_regulation.c,96 :: 		is_auto_previous = is_auto;
	MOVF        _is_auto+0, 0 
	MOVWF       pid_regulation_is_auto_previous+0 
	MOVF        _is_auto+1, 0 
	MOVWF       pid_regulation_is_auto_previous+1 
;pid_regulation.c,97 :: 		}
L_end_pid:
	RETURN      0
; end of _pid
