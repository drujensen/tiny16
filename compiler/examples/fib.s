; print fibanocci numbers using 32 bit number
start: LDI A1 0x0 ; high 16 bits
       LDI A2 0x0 ; low 16 bits
       LDI A3 0x0 ; high 16 bits
       LDI A4 0x1 ; low 16 bits
			 LDI A5 0x0 ; high 16 bits
			 LDI A6 0x0 ; low 16 bits
calc:  LD A5 A1   ; load first number
			 LD A6 A2   ; load first number
			 ADD A5 A3  ; add second number to first
			 ADD A6 A4  ; add second number to first
			 BRI CC :shift  ; unless carry, shift
			 JSR :carry ; if carry, add 1 to high 16 bits
shift: OUT A5     ; print low 16 bits
			 LD A1 A3	  ; move second number to first
			 LD A2 A4   ; move second number to first
			 LD A3 A5   ; move third number to second
			 LD A4 A6   ; move third number to second
       JMP :calc  ; repeat
carry: ADDI A5 0x1 ; add 1 to high 16 bits
			 RET        ; return
