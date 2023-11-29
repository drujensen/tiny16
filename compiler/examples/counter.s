; count up to 255 and wrap around

			LLI a1, 0x0
			LLI a2, 0x1
loop:	ADD a1, a2 
			OUT a1 
			LUI ba, :loop
			LLI ba, :loop
			JMP ba
