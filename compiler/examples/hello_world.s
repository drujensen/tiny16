; print hello world
			 LLI s0, 0x01
init:	 LLI a1, :txt       ; load direct "txt" address to A
next:  LDP a2, a1	        ; load indirect value at A1 to A2
			 OUT a2             ; output A
			 JSR :delay         ; delay
			 ADD a1, s0         ; increment A1
			 BNE a2, zero, :next  ; branch to init if equal
       JMP :init

delay: LLI a3, :timer
			 LDP a3, a3
loop:  SUB a3, s0
			 NOP
			 BNE a3, zero, :loop
			 RET

timer: 0xFFFF

txt:  "Hello World!"
