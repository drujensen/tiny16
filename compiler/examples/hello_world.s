; print hello world
init:	 LDI  s0, :txt       ; load direct "txt" address to A
next:  LDP  s1, s0	        ; load indirect value at A1 to A2
			 OUT  s1             ; output A
			 LDI  a0, 0xFFFF		 ; load direct 0xFFFF to A1
			 JSR  :delay         ; delay
			 ADDI s0, 0x1         ; increment A1
			 BNE  s1, zero, :next  ; branch to init if equal
       JMP  :init

delay: PSHR
			 LD   s0, a0
loop:  SUBI s0, 0x1
			 NOP
			 BNE  s0, zero, :loop
			 POPR
			 RET

txt:  "Hello World!"
