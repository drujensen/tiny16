; print hello world
init:	LDI   A1  :txt  ; load direct "txt" address to A
next: LD    A2, *A1	; load indirect value at A1 to A2
			OUT		A2  ; output A
			ADDI  A1, 0x1  ; increment A1
			CMPI  A2, 0x0  ; compare to 0x0
			BRI   NE  :next  ; branch to init if equal
      JMP   :init
txt:  "Hello World!"
