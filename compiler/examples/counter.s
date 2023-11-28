; count up to 255 and wrap around

			LD# a1, 0x0
			LD# a2, 0x1
loop:	ADD a1, a2 
			OUT a1 
			LLI bp, :loop
			BEQ x0, x0
