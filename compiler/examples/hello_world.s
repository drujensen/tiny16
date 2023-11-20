; print hello world
init: LDI   A1  :txt  ; load direct "txt" address to A
			LD    A2, *A1	; load indirect value at A to A
			CMPI  A2, 0x00  ; compare to 0x00
			BR    EQ  :end  ; branch to end if equal
			OUT		A2  ; output A
      JMP       :init  ; endless loop
end:  HLT
txt:  "Hello World!"
