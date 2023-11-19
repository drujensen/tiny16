; count up to 255 and output the result
; then count down to 0 and output the result

      LDI  x2, 0x0
up:   OUT  x2
      ADDI x2, 0x1
      CMPI x2, 0xFF
      BRI  EQ, :down
      JMP  :up
down: OUT  x2
      SUBI x2, 0x1
      CMPI x2, 0x0
      BRI  EQ, :up
      JMP  :down
