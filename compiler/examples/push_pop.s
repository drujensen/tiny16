			LDI A1 0x8
			PSH A1
			LDI A1 0x2
			PSH A1
			POP A2
			LD  A1 A2
			POP A2
			ADD A1 A2
			OUT A1
			HLT
