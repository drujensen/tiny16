main:          LLI  s1, 'r'
							 LLI  s2, 'w'
							 LLI  s3, 'e'
							 LLI  s4, 'h'
prompt:				 LLI  s0, '>'
							 OUT  s0
init:          IN   s0
							 BEQ  s0, zero, :init
							 BEQ  s0, s1, :read
							 BEQ  s0, s2, :write
							 BEQ  s0, s3, :execute
							 BEQ  s0, s4, :help
							 OUT  s0
							 JMP  :prompt

read:          LDI  a0, :txt
							 LDI  a1, 0x0006
							 JSR  :print
							 LDI  a0, :address
							 LDI  a1, 0x0004
							 JSR  :readaddr
							 LDI  s0, 0x000D
							 OUT  s0
							 LDI  a0, :address
							 LDI  a1, 0x0004
							 JSR  :print
							 JMP  :prompt

write:         NOP 
execute:       NOP
help:          NOP
							 JMP  :prompt

readaddr:      PSHR
							 LD   s0, a0
							 LD   s1, a1
readaddrnext:  IN   s2
							 BEQ  s2, zero, :readaddrnext
							 OUT  s2
							 STP  s2, s0
							 ADDI s0, 0x1
							 SUBI s1, 0x1
							 BNE  s1, zero, :readaddrnext
							 POPR
							 RET


print:         PSHR
							 LD   s0, a0
							 LD   s1, a1
printnext:		 LDP  s2, s0
							 OUT  s2
							 ADDI s0, 0x1
							 SUBI s1, 0x1
							 BNE  s1, zero, :printnext
							 POPR
							 RET


delay:         PSHR
			         LD   s0, a0
loop:          SUBI s0, 0x1
			         NOP
			         BNE  s0, zero, :loop
			         POPR
			         RET

txt:           "addr: "
address:       "0000"
