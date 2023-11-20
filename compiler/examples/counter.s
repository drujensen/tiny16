; count up to 255 and wrap around

			LDI a1, 0x0
			LDI a2, 0x1
loop:	ADD a1, a2 
			OUT a1 
			JMP :loop
