
_handle_button_auto_event:

;buttons.c,10 :: 		void handle_button_auto_event(void)
;buttons.c,12 :: 		is_auto = 1;
	MOVLW       1
	MOVWF       _is_auto+0 
	MOVLW       0
	MOVWF       _is_auto+1 
;buttons.c,13 :: 		}
L_end_handle_button_auto_event:
	RETURN      0
; end of _handle_button_auto_event

_handle_button_manual_event:

;buttons.c,15 :: 		void handle_button_manual_event(void)
;buttons.c,17 :: 		is_auto = 0;
	CLRF        _is_auto+0 
	CLRF        _is_auto+1 
;buttons.c,18 :: 		}
L_end_handle_button_manual_event:
	RETURN      0
; end of _handle_button_manual_event

_handle_button_increase_event:

;buttons.c,20 :: 		void handle_button_increase_event(void)
;buttons.c,24 :: 		if (is_auto && reference + increment <= max_reference)
	MOVF        _is_auto+0, 0 
	IORWF       _is_auto+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_handle_button_increase_event2
	MOVLW       5
	ADDWF       _reference+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _reference+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__handle_button_increase_event39
	MOVF        R1, 0 
	SUBLW       232
L__handle_button_increase_event39:
	BTFSS       STATUS+0, 0 
	GOTO        L_handle_button_increase_event2
L__handle_button_increase_event29:
;buttons.c,26 :: 		reference += increment;
	MOVLW       5
	ADDWF       _reference+0, 1 
	MOVLW       0
	ADDWFC      _reference+1, 1 
;buttons.c,27 :: 		}
L_handle_button_increase_event2:
;buttons.c,29 :: 		if (!is_auto && actuator_value + increment <= max_actuator)
	MOVF        _is_auto+0, 0 
	IORWF       _is_auto+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_handle_button_increase_event5
	MOVLW       5
	ADDWF       _actuator_value+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _actuator_value+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__handle_button_increase_event40
	MOVF        R1, 0 
	SUBLW       232
L__handle_button_increase_event40:
	BTFSS       STATUS+0, 0 
	GOTO        L_handle_button_increase_event5
L__handle_button_increase_event28:
;buttons.c,31 :: 		actuator_value += increment;
	MOVLW       5
	ADDWF       _actuator_value+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _actuator_value+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _actuator_value+0 
	MOVF        R1, 0 
	MOVWF       _actuator_value+1 
;buttons.c,32 :: 		DAC_Output(convert_percentage_to_actuator(actuator_value));
	MOVF        R0, 0 
	MOVWF       FARG_convert_percentage_to_actuator_percentage+0 
	MOVF        R1, 0 
	MOVWF       FARG_convert_percentage_to_actuator_percentage+1 
	CALL        _convert_percentage_to_actuator+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_DAC_Output_valueDAC+0 
	MOVF        R1, 0 
	MOVWF       FARG_DAC_Output_valueDAC+1 
	CALL        _DAC_Output+0, 0
;buttons.c,33 :: 		}
L_handle_button_increase_event5:
;buttons.c,34 :: 		}
L_end_handle_button_increase_event:
	RETURN      0
; end of _handle_button_increase_event

_handle_button_decrease_event:

;buttons.c,36 :: 		void handle_button_decrease_event(void)
;buttons.c,40 :: 		if (is_auto && reference - decrement >= min_reference)
	MOVF        _is_auto+0, 0 
	IORWF       _is_auto+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_handle_button_decrease_event8
	MOVLW       5
	SUBWF       _reference+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _reference+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__handle_button_decrease_event42
	MOVLW       0
	SUBWF       R1, 0 
L__handle_button_decrease_event42:
	BTFSS       STATUS+0, 0 
	GOTO        L_handle_button_decrease_event8
L__handle_button_decrease_event31:
;buttons.c,42 :: 		reference -= decrement;
	MOVLW       5
	SUBWF       _reference+0, 1 
	MOVLW       0
	SUBWFB      _reference+1, 1 
;buttons.c,43 :: 		}
L_handle_button_decrease_event8:
;buttons.c,45 :: 		if (!is_auto && actuator_value - decrement >= min_actuator)
	MOVF        _is_auto+0, 0 
	IORWF       _is_auto+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_handle_button_decrease_event11
	MOVLW       5
	SUBWF       _actuator_value+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      _actuator_value+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__handle_button_decrease_event43
	MOVLW       0
	SUBWF       R1, 0 
L__handle_button_decrease_event43:
	BTFSS       STATUS+0, 0 
	GOTO        L_handle_button_decrease_event11
L__handle_button_decrease_event30:
;buttons.c,47 :: 		actuator_value -= decrement;
	MOVLW       5
	SUBWF       _actuator_value+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      _actuator_value+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _actuator_value+0 
	MOVF        R1, 0 
	MOVWF       _actuator_value+1 
;buttons.c,48 :: 		DAC_Output(convert_percentage_to_actuator(actuator_value));
	MOVF        R0, 0 
	MOVWF       FARG_convert_percentage_to_actuator_percentage+0 
	MOVF        R1, 0 
	MOVWF       FARG_convert_percentage_to_actuator_percentage+1 
	CALL        _convert_percentage_to_actuator+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_DAC_Output_valueDAC+0 
	MOVF        R1, 0 
	MOVWF       FARG_DAC_Output_valueDAC+1 
	CALL        _DAC_Output+0, 0
;buttons.c,49 :: 		}
L_handle_button_decrease_event11:
;buttons.c,50 :: 		}
L_end_handle_button_decrease_event:
	RETURN      0
; end of _handle_button_decrease_event

_check_and_handle_button_auto_event:

;buttons.c,59 :: 		void check_and_handle_button_auto_event(void)
;buttons.c,61 :: 		if (Button(&PORTB, AUTO, 1, 1))
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_auto_event12
;buttons.c,62 :: 		button_auto_oldstate = 1;
	MOVLW       1
	MOVWF       buttons_button_auto_oldstate+0 
	MOVLW       0
	MOVWF       buttons_button_auto_oldstate+1 
L_check_and_handle_button_auto_event12:
;buttons.c,63 :: 		if (button_auto_oldstate && Button(&PORTB, AUTO, 1, 0))
	MOVF        buttons_button_auto_oldstate+0, 0 
	IORWF       buttons_button_auto_oldstate+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_auto_event15
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_auto_event15
L__check_and_handle_button_auto_event32:
;buttons.c,65 :: 		handle_button_auto_event();
	CALL        _handle_button_auto_event+0, 0
;buttons.c,66 :: 		button_auto_oldstate = 0;
	CLRF        buttons_button_auto_oldstate+0 
	CLRF        buttons_button_auto_oldstate+1 
;buttons.c,67 :: 		}
L_check_and_handle_button_auto_event15:
;buttons.c,68 :: 		}
L_end_check_and_handle_button_auto_event:
	RETURN      0
; end of _check_and_handle_button_auto_event

_check_and_handle_button_manual_event:

;buttons.c,70 :: 		void check_and_handle_button_manual_event(void)
;buttons.c,72 :: 		if (Button(&PORTB, MANUAL, 1, 1))
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_manual_event16
;buttons.c,73 :: 		button_manual_oldstate = 1;
	MOVLW       1
	MOVWF       buttons_button_manual_oldstate+0 
	MOVLW       0
	MOVWF       buttons_button_manual_oldstate+1 
L_check_and_handle_button_manual_event16:
;buttons.c,74 :: 		if (button_manual_oldstate && Button(&PORTB, MANUAL, 1, 0))
	MOVF        buttons_button_manual_oldstate+0, 0 
	IORWF       buttons_button_manual_oldstate+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_manual_event19
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_manual_event19
L__check_and_handle_button_manual_event33:
;buttons.c,76 :: 		handle_button_manual_event();
	CALL        _handle_button_manual_event+0, 0
;buttons.c,77 :: 		button_manual_oldstate = 0;
	CLRF        buttons_button_manual_oldstate+0 
	CLRF        buttons_button_manual_oldstate+1 
;buttons.c,78 :: 		}
L_check_and_handle_button_manual_event19:
;buttons.c,79 :: 		}
L_end_check_and_handle_button_manual_event:
	RETURN      0
; end of _check_and_handle_button_manual_event

_check_and_handle_button_increase_event:

;buttons.c,81 :: 		void check_and_handle_button_increase_event(void)
;buttons.c,83 :: 		if (Button(&PORTB, INCREASE, 1, 1))
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_increase_event20
;buttons.c,84 :: 		button_increase_oldstate = 1;
	MOVLW       1
	MOVWF       buttons_button_increase_oldstate+0 
	MOVLW       0
	MOVWF       buttons_button_increase_oldstate+1 
L_check_and_handle_button_increase_event20:
;buttons.c,85 :: 		if (button_increase_oldstate && Button(&PORTB, INCREASE, 1, 0))
	MOVF        buttons_button_increase_oldstate+0, 0 
	IORWF       buttons_button_increase_oldstate+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_increase_event23
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_increase_event23
L__check_and_handle_button_increase_event34:
;buttons.c,87 :: 		handle_button_increase_event();
	CALL        _handle_button_increase_event+0, 0
;buttons.c,88 :: 		button_increase_oldstate = 0;
	CLRF        buttons_button_increase_oldstate+0 
	CLRF        buttons_button_increase_oldstate+1 
;buttons.c,89 :: 		}
L_check_and_handle_button_increase_event23:
;buttons.c,90 :: 		}
L_end_check_and_handle_button_increase_event:
	RETURN      0
; end of _check_and_handle_button_increase_event

_check_and_handle_button_decrease_event:

;buttons.c,92 :: 		void check_and_handle_button_decrease_event(void)
;buttons.c,94 :: 		if (Button(&PORTB, DECREASE, 1, 1))
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_decrease_event24
;buttons.c,95 :: 		button_decrease_oldstate = 1;
	MOVLW       1
	MOVWF       buttons_button_decrease_oldstate+0 
	MOVLW       0
	MOVWF       buttons_button_decrease_oldstate+1 
L_check_and_handle_button_decrease_event24:
;buttons.c,96 :: 		if (button_decrease_oldstate && Button(&PORTB, DECREASE, 1, 0))
	MOVF        buttons_button_decrease_oldstate+0, 0 
	IORWF       buttons_button_decrease_oldstate+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_decrease_event27
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_check_and_handle_button_decrease_event27
L__check_and_handle_button_decrease_event35:
;buttons.c,98 :: 		handle_button_decrease_event();
	CALL        _handle_button_decrease_event+0, 0
;buttons.c,99 :: 		button_decrease_oldstate = 0;
	CLRF        buttons_button_decrease_oldstate+0 
	CLRF        buttons_button_decrease_oldstate+1 
;buttons.c,100 :: 		}
L_check_and_handle_button_decrease_event27:
;buttons.c,101 :: 		}
L_end_check_and_handle_button_decrease_event:
	RETURN      0
; end of _check_and_handle_button_decrease_event
