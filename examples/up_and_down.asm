// count up to 255 and output the result
// then count down to 0 and output the result

1A00  LD x2, #0

up:
0220  OUT x2
3A01  ADD x2, #1
EAFF  CMP x2, #255
F801  BREQ :down
C805  JMP :up
down:
0220  OUT x2
4A01  SUB x2, #1
EA00  CMP x2, #0
F889  BREQ :up
C805  JMP :down
