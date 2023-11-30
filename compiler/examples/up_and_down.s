; up to 255 and down to 0 in a loop

			LLI  a0, 0x00 ; counter
			LLI  s0, 0x01 ; step
			LLI  a1, 0xFF ; max
up:   OUT  a0
		  JSR  :delay
      ADD  a0, s0
			BEQ  a0, a1, :down
			JMP :up

down: OUT  a0
		  JSR  :delay
      SUB  a0, s0
			BEQ a0, x0, :up
			JMP :down

delay: LLI  a2, :timer
			 LDP a2, a2
loop:  SUB a2, s0
			 NOP
			 BNE a2, x0, :loop
			 RET

timer: 0xFF 0xFF
