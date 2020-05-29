
_interrupt:

;KosturPRO.c,49 :: 		void interrupt() {
;KosturPRO.c,50 :: 		timerTicks++;
	INFSNZ      _timerTicks+0, 1 
	INCF        _timerTicks+1, 1 
;KosturPRO.c,51 :: 		timer_flag = 1;
	MOVLW       1
	MOVWF       _timer_flag+0 
	MOVLW       0
	MOVWF       _timer_flag+1 
;KosturPRO.c,52 :: 		TMR1H      =   99;               // 40000 counts until overflow 40000=65535-(99*256+192)
	MOVLW       99
	MOVWF       TMR1H+0 
;KosturPRO.c,53 :: 		TMR1L      =   192;              // 40000/2000000=0.02sec on 8MHz, 2000000=8MHz/4
	MOVLW       192
	MOVWF       TMR1L+0 
;KosturPRO.c,54 :: 		T1CON      =   0x01;             // TMR1ON: Timer1 On bit 1 = Enables Timer1
	MOVLW       1
	MOVWF       T1CON+0 
;KosturPRO.c,55 :: 		PIR1.TMR1IF=   0;                // Clear interrupt request bit
	BCF         PIR1+0, 0 
;KosturPRO.c,56 :: 		PIE1       =   1;                // TMR1IE: TMR1 Overflow Interrupt Enable bit, 1 = Enables
	MOVLW       1
	MOVWF       PIE1+0 
;KosturPRO.c,57 :: 		INTCON     =   0xC0;             // Interrupts enable
	MOVLW       192
	MOVWF       INTCON+0 
;KosturPRO.c,58 :: 		}
L_end_interrupt:
L__interrupt6:
	RETFIE      1
; end of _interrupt

_DAC_Output:

;KosturPRO.c,62 :: 		void DAC_Output(unsigned int valueDAC) {
;KosturPRO.c,64 :: 		PORTC &= ~(_CHIP_SELECT);           // ClearBit(PORTC,CHIP_SELECT);
	MOVLW       254
	ANDWF       PORTC+0, 1 
;KosturPRO.c,66 :: 		temp = (valueDAC >> 8) & 0x0F;      // Prepare hi-byte for transfer
	MOVF        FARG_DAC_Output_valueDAC+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
;KosturPRO.c,67 :: 		temp |= 0x30;                       // It's a 12-bit number, so only
	MOVLW       48
	IORWF       FARG_SPI1_Write_data_+0, 1 
;KosturPRO.c,68 :: 		SPI1_write(temp);                   //   lower nibble of high byte is used
	CALL        _SPI1_Write+0, 0
;KosturPRO.c,70 :: 		SPI1_write(temp);
	MOVF        FARG_DAC_Output_valueDAC+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;KosturPRO.c,72 :: 		PORTC |= _CHIP_SELECT;              // SetBit(PORTC,CHIP_SELECT);
	BSF         PORTC+0, 0 
;KosturPRO.c,73 :: 		}
L_end_DAC_Output:
	RETURN      0
; end of _DAC_Output

_convert_height_to_percentage:

;KosturPRO.c,75 :: 		int convert_height_to_percentage(int height)
;KosturPRO.c,78 :: 		return (height - min_height) * 1000L / (max_height - min_height);
	MOVLW       85
	SUBWF       FARG_convert_height_to_percentage_height+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_convert_height_to_percentage_height+1, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       R2 
	MOVWF       R3 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       170
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_S+0, 0
;KosturPRO.c,79 :: 		}
L_end_convert_height_to_percentage:
	RETURN      0
; end of _convert_height_to_percentage

_convert_percentage_to_actuator:

;KosturPRO.c,81 :: 		int convert_percentage_to_actuator(int percentage)
;KosturPRO.c,84 :: 		return min_actuator + (max_actuator - min_actuator) * (long)percentage / 1000L;
	MOVF        FARG_convert_percentage_to_actuator_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_convert_percentage_to_actuator_percentage+1, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       FARG_convert_percentage_to_actuator_percentage+1, 7 
	MOVLW       255
	MOVWF       R2 
	MOVWF       R3 
	MOVLW       27
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Div_32x32_S+0, 0
	MOVLW       228
	ADDWF       R0, 1 
	MOVLW       12
	ADDWFC      R1, 1 
;KosturPRO.c,85 :: 		}
L_end_convert_percentage_to_actuator:
	RETURN      0
; end of _convert_percentage_to_actuator

_main:

;KosturPRO.c,94 :: 		void main() {
;KosturPRO.c,98 :: 		ADCON1 = 0x0F;                    // Turn off A/D converters on PORTB
	MOVLW       15
	MOVWF       ADCON1+0 
;KosturPRO.c,99 :: 		TRISA  = 0xFF;                    // Set PORTA pins as input pins(to work with A/D converter)
	MOVLW       255
	MOVWF       TRISA+0 
;KosturPRO.c,100 :: 		TRISB  = 0xFF;                    // Set PORTB pins as input pins(to work with keybord)
	MOVLW       255
	MOVWF       TRISB+0 
;KosturPRO.c,101 :: 		TRISC &= ~(_CHIP_SELECT);         // SPI ClearBit(TRISC,CHIP_SELECT);
	MOVLW       254
	ANDWF       TRISC+0, 1 
;KosturPRO.c,102 :: 		TRISD  = 0x00;                    // Set PORTD pins as output pins(to work with LCD display)
	CLRF        TRISD+0 
;KosturPRO.c,103 :: 		SPI1_init();                      // Initialisation of SPI communication
	CALL        _SPI1_Init+0, 0
;KosturPRO.c,106 :: 		timerTicks =   0;
	CLRF        _timerTicks+0 
	CLRF        _timerTicks+1 
;KosturPRO.c,107 :: 		TMR1H      =   99;               // 40000 counts until overflow 40000=65535-(99*256+192)
	MOVLW       99
	MOVWF       TMR1H+0 
;KosturPRO.c,108 :: 		TMR1L      =   192;              // 40000/2000000=0.02sec on 8MHz, 2000000=8MHz/4
	MOVLW       192
	MOVWF       TMR1L+0 
;KosturPRO.c,109 :: 		T1CON      =   0x01;             // TMR1ON: Timer1 On bit 1 = Enables Timer1
	MOVLW       1
	MOVWF       T1CON+0 
;KosturPRO.c,110 :: 		PIR1.TMR1IF=   0;                // Clear interrupt request bit
	BCF         PIR1+0, 0 
;KosturPRO.c,111 :: 		PIE1       =   1;                // TMR1IE: TMR1 Overflow Interrupt Enable bit, 1 = Enables
	MOVLW       1
	MOVWF       PIE1+0 
;KosturPRO.c,112 :: 		INTCON     =   0xC0;             // Interrupts enable
	MOVLW       192
	MOVWF       INTCON+0 
;KosturPRO.c,120 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;KosturPRO.c,121 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;KosturPRO.c,122 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;KosturPRO.c,125 :: 		while (1)
L_main0:
;KosturPRO.c,127 :: 		measurement = convert_height_to_percentage(Adc_Read(3));
	MOVLW       3
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_convert_height_to_percentage_height+0 
	MOVF        R1, 0 
	MOVWF       FARG_convert_height_to_percentage_height+1 
	CALL        _convert_height_to_percentage+0, 0
	MOVF        R0, 0 
	MOVWF       _measurement+0 
	MOVF        R1, 0 
	MOVWF       _measurement+1 
;KosturPRO.c,128 :: 		lcd_show_height_percentage(measurement);
	MOVF        R0, 0 
	MOVWF       FARG_lcd_show_height_percentage_height_percentage+0 
	MOVF        R1, 0 
	MOVWF       FARG_lcd_show_height_percentage_height_percentage+1 
	CALL        _lcd_show_height_percentage+0, 0
;KosturPRO.c,129 :: 		check_and_handle_button_auto_event();
	CALL        _check_and_handle_button_auto_event+0, 0
;KosturPRO.c,130 :: 		check_and_handle_button_manual_event();
	CALL        _check_and_handle_button_manual_event+0, 0
;KosturPRO.c,131 :: 		check_and_handle_button_increase_event();
	CALL        _check_and_handle_button_increase_event+0, 0
;KosturPRO.c,132 :: 		check_and_handle_button_decrease_event();
	CALL        _check_and_handle_button_decrease_event+0, 0
;KosturPRO.c,133 :: 		if (is_auto)
	MOVF        _is_auto+0, 0 
	IORWF       _is_auto+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main2
;KosturPRO.c,135 :: 		lcd_show_reference_percentage(reference);
	MOVF        _reference+0, 0 
	MOVWF       FARG_lcd_show_reference_percentage_reference_percentage+0 
	MOVF        _reference+1, 0 
	MOVWF       FARG_lcd_show_reference_percentage_reference_percentage+1 
	CALL        _lcd_show_reference_percentage+0, 0
;KosturPRO.c,136 :: 		}
	GOTO        L_main3
L_main2:
;KosturPRO.c,139 :: 		lcd_show_control_percentage(actuator_value);
	MOVF        _actuator_value+0, 0 
	MOVWF       FARG_lcd_show_control_percentage_control_percentage+0 
	MOVF        _actuator_value+1, 0 
	MOVWF       FARG_lcd_show_control_percentage_control_percentage+1 
	CALL        _lcd_show_control_percentage+0, 0
;KosturPRO.c,140 :: 		}
L_main3:
;KosturPRO.c,141 :: 		if (timer_flag)
	MOVF        _timer_flag+0, 0 
	IORWF       _timer_flag+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
;KosturPRO.c,143 :: 		pid();
	CALL        _pid+0, 0
;KosturPRO.c,144 :: 		DAC_Output(convert_percentage_to_actuator(control_aggregated));
	MOVF        _control_aggregated+0, 0 
	MOVWF       FARG_convert_percentage_to_actuator_percentage+0 
	MOVF        _control_aggregated+1, 0 
	MOVWF       FARG_convert_percentage_to_actuator_percentage+1 
	CALL        _convert_percentage_to_actuator+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_DAC_Output_valueDAC+0 
	MOVF        R1, 0 
	MOVWF       FARG_DAC_Output_valueDAC+1 
	CALL        _DAC_Output+0, 0
;KosturPRO.c,145 :: 		timer_flag = 0;
	CLRF        _timer_flag+0 
	CLRF        _timer_flag+1 
;KosturPRO.c,146 :: 		}
L_main4:
;KosturPRO.c,147 :: 		}
	GOTO        L_main0
;KosturPRO.c,171 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
