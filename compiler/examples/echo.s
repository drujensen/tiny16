next:  IN  s1
			 BEQ s1, zero, :next
			 OUT s1
			 LDI  a0, 0xFFFF
			 JSR  :delay
			 JMP :next

delay: PSHR
			 LD   s0, a0
loop:  SUBI s0, 0x1
			 NOP
			 BNE  s0, zero, :loop
			 POPR
			 RET
