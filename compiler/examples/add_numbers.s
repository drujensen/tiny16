waix: IN A1         ; get char from input
      CMPI A1, 0x0  ; compare input with 0
      OUT A1        ; echo input
      BEQ :waix     ; wait until input has a value
      SUBI A1, '0'  ; convert to number
      LD A2, A1     ; store in a2
			LDI A6, '+'		; store + in a4
      OUT A6        ; print +
waiy: IN A1         ; get char from input
      CMPI A1, 0x0  ; compare input with 0
      OUT A1        ; echo input
      BEQ :waiy     ; wait until input has a value
      SUBI A1, '0'  ; convert to number
      ADD A1, A2    ; add a2 to a1
      CMPI A1, 0xA  ; compare to 10
			LDI A6, '='
      OUT A6        ; print =
      BEQ :tens     ; equal to 10
      BCC :ones     ; less than 10
tens: LDI A6, '1'
		  OUT A6        ; output 1 for 10's spot
      SUBI A1, 0xA  ; subtract 10
ones: ADDI A1, '0'  ; convert to ascii
      OUT A1        ; print results
      LDI A6, 0xA   ; print nl
			OUT A6
      LDI A6, 0xD   ; print cr
			OUT A6
      JMP :waix     ; start over
