init:		LLI A1 0x05
				LLI A2 0x07
				JSR :add
				OUT A1
				HLT
add: 		ADD A1 A2
				RET
