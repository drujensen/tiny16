init:		LDI A1 0x5
				LDI A2 0x7
				JSR :add
				OUT A1
				HLT
add: 		ADD A1 A2
				RET
