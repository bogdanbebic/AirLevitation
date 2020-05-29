
_lcd_show_height_percentage:

;lcd.c,6 :: 		void lcd_show_height_percentage(int height_percentage)
;lcd.c,8 :: 		LCD_Out(1, 1, "Height:");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lcd.c,9 :: 		if (height_percentage <= 1000)
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_lcd_show_height_percentage_height_percentage+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__lcd_show_height_percentage7
	MOVF        FARG_lcd_show_height_percentage_height_percentage+0, 0 
	SUBLW       232
L__lcd_show_height_percentage7:
	BTFSS       STATUS+0, 0 
	GOTO        L_lcd_show_height_percentage0
;lcd.c,11 :: 		LCD_Chr(1, TENTHS, '0' + height_percentage % 10);
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       15
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_lcd_show_height_percentage_height_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_height_percentage_height_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,12 :: 		LCD_Chr(1, DECIMAL_POINT, '.');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       46
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,13 :: 		LCD_Chr(1, UNITS, '0' + height_percentage / 10 % 10);
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_lcd_show_height_percentage_height_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_height_percentage_height_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,14 :: 		LCD_Chr(1, TENS, '0' + height_percentage / 100 % 10);
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_lcd_show_height_percentage_height_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_height_percentage_height_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,15 :: 		LCD_Chr(1, HUNDREDS, '0' + height_percentage / 1000 % 10);
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        FARG_lcd_show_height_percentage_height_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_height_percentage_height_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,16 :: 		}
	GOTO        L_lcd_show_height_percentage1
L_lcd_show_height_percentage0:
;lcd.c,19 :: 		LCD_Out(1, HUNDREDS, "100.0");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lcd.c,20 :: 		}
L_lcd_show_height_percentage1:
;lcd.c,22 :: 		LCD_Out(1, LCD_END_INDEX, "%");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       16
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lcd.c,23 :: 		}
L_end_lcd_show_height_percentage:
	RETURN      0
; end of _lcd_show_height_percentage

_lcd_show_reference_percentage:

;lcd.c,25 :: 		void lcd_show_reference_percentage(int reference_percentage)
;lcd.c,27 :: 		LCD_Out(2, 1, "Reference:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lcd.c,28 :: 		if (reference_percentage <= 1000)
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_lcd_show_reference_percentage_reference_percentage+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__lcd_show_reference_percentage9
	MOVF        FARG_lcd_show_reference_percentage_reference_percentage+0, 0 
	SUBLW       232
L__lcd_show_reference_percentage9:
	BTFSS       STATUS+0, 0 
	GOTO        L_lcd_show_reference_percentage2
;lcd.c,30 :: 		LCD_Chr(2, TENTHS, '0' + reference_percentage % 10);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       15
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_lcd_show_reference_percentage_reference_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_reference_percentage_reference_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,31 :: 		LCD_Chr(2, DECIMAL_POINT, '.');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       46
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,32 :: 		LCD_Chr(2, UNITS, '0' + reference_percentage / 10 % 10);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_lcd_show_reference_percentage_reference_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_reference_percentage_reference_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,33 :: 		LCD_Chr(2, TENS, '0' + reference_percentage / 100 % 10);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_lcd_show_reference_percentage_reference_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_reference_percentage_reference_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,34 :: 		LCD_Chr(2, HUNDREDS, '0' + reference_percentage / 1000 % 10);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        FARG_lcd_show_reference_percentage_reference_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_reference_percentage_reference_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,35 :: 		}
	GOTO        L_lcd_show_reference_percentage3
L_lcd_show_reference_percentage2:
;lcd.c,38 :: 		LCD_Out(2, HUNDREDS, "100.0");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lcd.c,39 :: 		}
L_lcd_show_reference_percentage3:
;lcd.c,41 :: 		LCD_Out(2, LCD_END_INDEX, "%");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       16
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lcd.c,42 :: 		}
L_end_lcd_show_reference_percentage:
	RETURN      0
; end of _lcd_show_reference_percentage

_lcd_show_control_percentage:

;lcd.c,44 :: 		void lcd_show_control_percentage(int control_percentage)
;lcd.c,46 :: 		LCD_Out(2, 1, "Control:  ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lcd.c,47 :: 		if (control_percentage <= 1000)
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_lcd_show_control_percentage_control_percentage+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__lcd_show_control_percentage11
	MOVF        FARG_lcd_show_control_percentage_control_percentage+0, 0 
	SUBLW       232
L__lcd_show_control_percentage11:
	BTFSS       STATUS+0, 0 
	GOTO        L_lcd_show_control_percentage4
;lcd.c,49 :: 		LCD_Chr(2, TENTHS, '0' + control_percentage % 10);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       15
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_lcd_show_control_percentage_control_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_control_percentage_control_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,50 :: 		LCD_Chr(2, DECIMAL_POINT, '.');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       46
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,51 :: 		LCD_Chr(2, UNITS, '0' + control_percentage / 10 % 10);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_lcd_show_control_percentage_control_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_control_percentage_control_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,52 :: 		LCD_Chr(2, TENS, '0' + control_percentage / 100 % 10);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_lcd_show_control_percentage_control_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_control_percentage_control_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,53 :: 		LCD_Chr(2, HUNDREDS, '0' + control_percentage / 1000 % 10);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        FARG_lcd_show_control_percentage_control_percentage+0, 0 
	MOVWF       R0 
	MOVF        FARG_lcd_show_control_percentage_control_percentage+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,54 :: 		}
	GOTO        L_lcd_show_control_percentage5
L_lcd_show_control_percentage4:
;lcd.c,57 :: 		LCD_Out(2, HUNDREDS, "100.0");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr8_lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr8_lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lcd.c,58 :: 		}
L_lcd_show_control_percentage5:
;lcd.c,60 :: 		LCD_Out(2, LCD_END_INDEX, "%");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       16
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr9_lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr9_lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lcd.c,61 :: 		}
L_end_lcd_show_control_percentage:
	RETURN      0
; end of _lcd_show_control_percentage
