; count up to 255 and wrap around

			LLI a0, 0x0
			LLI a1, 0x1
loop:	ADD a0, a1
			OUT a0
			JMP :loop
