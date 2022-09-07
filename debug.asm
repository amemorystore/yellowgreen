;  ......_ ......
; org [b]71b0 // 29104
; y el lowg reen
;....................................
ld hl,$005e
call $3c36
xor a
call SwitchMenu
;....................................
forever: ; fff5
db $fa,$1a,$c2
ld c,a
add a,a
add a,c
ld c,a
ld b,$00
ld hl,MenuList
add hl,bc
inc hl
ld e,(hl)
inc hl
ld d,(hl)
inc de
ld h,d
ld l,e
ld bc,forever
push bc
ld bc,$0003
db $f0,$f5 ; ld a,(fff5)
and $40
jp nz,DerefPointer
add hl,bc
db $f0,$f5 ; ld a,(fff5)
and $80
jp nz,DerefPointer
add hl,bc
db $f0,$f5 ; ld a,(fff5)
and $20
jp nz,DerefPointer
add hl,bc
db $f0,$f5 ; ld a,(fff5)
and $10
jp nz,DerefPointer
add hl,bc
db $f0,$f5 ; ld a,(fff5)
and $02
jp nz,DerefPointer
add hl,bc
db $f0,$f5 ; ld a,(fff5)
and $01
jp nz,DerefPointer
pop bc
halt
jp forever
;....................................
DerefPointer:
push af
ld e,(hl)
inc hl
ld d,(hl)
ld h,d
ld l,e
ld bc,DerefRets
push bc
jp (hl)
;....................................
DerefRets:
pop af
ld b,a
;....................................
DerefRets_L1:
db $f0,$f5
and b
cp $00
jp nz,DerefRets_L1
ret
;....................................
ReturnControlCall:
pop bc
pop bc
pop bc
;....................................
ReturnControl:
ld a,$b6
call $2238
call $373e
ld a,$03
jp $3ffa
;....................................
BackToMain:
xor a
call SwitchMenu
ret
;....................................
ConfirmSound:
ld a,$b2
call $2238
call $373e
ret
;....................................
DrawTextbox:
ld a,$79
ld de,$0014
dec b
push bc
push hl
db $22 ; LDI (HL),A
inc a
dec c
dec c
call MemSet
inc a
db $22 ; LDI (HL),A
;....................................
DrawTextbox_L1:
ld a,$7c
pop hl
add hl,de
pop bc
dec b
jr z,DrawTextbox_L2
push bc
push hl
db $22 ; LDI (HL),A
dec c
dec c
ld a,$7f
call MemSet
ld (hl),$7c
jr DrawTextbox_L1
DrawTextbox_L2:
ld a,$7d
db $22 ; LDI (HL),A
ld a,$7a
dec c
dec c
call MemSet
ld (hl),$7e
ret
;....................................
MemSet:
db $22 ; LDI (HL),A
dec c
jr nz,MemSet
ret
;....................................
PutASCIIMultiline:
push de
ld a,(hl)
cp $0d
jr nz,PutASCIIMultiline_L2
inc hl
pop de
ld de,$c4a5
push de
;....................................
PutASCIIMultiline_L2:
call PutASCII
dec hl
ld a,(hl)
inc hl
cp $00
jr z,PutASCIIMultiline_R1
pop de
ld c,$14
;....................................
PutASCIIMultiline_L1:
inc de
dec c
jr nz,PutASCIIMultiline_L1
push de
jr PutASCIIMultiline_L2
;....................................
PutASCIIMultiline_R1:
pop de
ret
;....................................
PutASCII:
db $2a ; LDI A,(HL)
cp $00
ret z
cp $0a
ret z
push hl
ld hl,ASCLookupTable
ld b,$00
sub $20
ld c,a
add hl,bc
ld a,(hl)
pop hl
ld (de),a
inc de
jr PutASCII
;....................................
ASCLookupTable:
db $7f,$e7,$00,$00,$00,$00,$00,$e0,$e1,$e2,$00,$00,$f4,$e3,$e8,$f3
db $f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff,$9c,$9d,$00,$00,$00,$e6
db $00,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e
db $8f,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9e,$f3,$9f,$00,$00
db $00,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae
db $af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9
;....................................
SwitchMenu:
push af
;....................................
SwitchMenu_L1:
db $f0,$f5
cp $00
jp nz,SwitchMenu_L1
pop af
db $ea,$1a,$c2
ld b,$00
ld c,a
add a,a
add a,c
inc a
ld c,a
ld hl,MenuList
add hl,bc
ld d,(hl)
inc hl
ld e,(hl)
ld h,e
ld l,d
ld c,$13
add hl,bc
ld d,(hl)
inc hl
ld e,(hl)
ld h,e
ld l,d
push hl
ld hl,$c3de
ld bc,$0912
call DrawTextbox
pop hl
ld bc,SwitchMenuBack
push bc
jp (hl)
;....................................
SwitchMenuBack:
ret
;....................................
MenuList:
ld bc,Menu1Properties
ld bc,Menu2Properties
ld bc,Menu3Properties
ld bc,Menu4Properties
ld bc,Menu5Properties
ld bc,Menu6Properties
ld bc,Menu7Properties
;....................................
Menu1Properties:
ld bc,MenuCursorUp    ; [UP]
ld bc,MenuCursorDown  ; [DOWN]
ld bc,SwitchMenuBack  ; [LEFT]
ld bc,SwitchMenuBack  ; [RIGHT]
ld bc,ReturnControlCall ; [B]
ld bc,Menu1Perform        ; [A]
ld bc,Menu1Constructor      ; .ctor
ld bc,Menu1Desc1 ; desc1
ld bc,Menu1Desc2 ; desc1
ld bc,Menu1Desc3 ; desc1
ld bc,Menu1Desc4 ; desc1
ld bc,Menu1Desc5 ; desc1
ld bc,Menu1Desc6 ; desc1
ld bc,Menu1Desc7 ; desc1
;....................................
Menu1Text:
db "write memory", $0a
db "Hhx viewer", $0a
db "anti-crasher", $0a
db "memcorruptor", $0a
db "miscellanous", $0a
db "address list",$0a
db "eXit",$00
;....................................
Menu1Desc1:
db "write single and",$0a,$0a
db "multi-byte values",$00
;....................................
Menu1Desc2:
db "wiew contents of",$0a,$0a
db "ROM, RAM, etc.",$00
;....................................
Menu1Desc3:
db "hook RST vectors",$0a,$0a
db "to stop crashes",$00
;....................................
Menu1Desc4:
db "corrupt blocks",$0a,$0a
db "of memory",$00
;....................................
Menu1Desc5:
db "perform common",$0a,$0a
db "tasks and hacks",$00
;....................................
Menu1Desc6:
db "most important",$0a,$0a
db "addresses to know",$00
;....................................
Menu1Desc7:
db "quit this menu",$00
;....................................
Menu1Constructor:
xor a
db $ea,$1b,$c2 ; ld ($c21b),a ; cursor position at 0
ld hl,Menu1Text
ld de,$c3f4
call PutASCIIMultiline
call MenuCursorRedraw
ret
;....................................
Menu1Perform:
db $fa,$1b,$c2
cp $06
jp z,ReturnControlCall
inc a
call SwitchMenu
ret
;....................................
HexCycleTbl:
db $f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff,$80,$81,$82,$83,$84,$85
;....................................
ReadHexExpr:
ld a,(hl)
ld c,$00
ld de,HexCycleTbl
;....................................
ReadHexExpr_L1:
ld a,(de)
cp (hl)
jr z,ReadHexExpr_L2
inc c
inc de
jr ReadHexExpr_L1
ReadHexExpr_L2:
ld a,c
ret
;....................................
ReadDblHexExpr:
xor a
call ReadHexExpr
db $cb,$37 ;swap a
inc hl
push af
call ReadHexExpr
ld c,a
pop af
add a,c
ret
;....................................
WriteHexExpr:
push de
push hl
ld hl,HexCycleTbl
ld b,$00
ld c,a
add hl,bc
ld d,h
ld e,l
ld a,(hl)
pop hl
db $22 ; LDI (HL),A
pop de
ret
;....................................
WriteDblHexExpr:
ld b,a
push bc
db $cb,$37 ;swap a
and $0f
call WriteHexExpr
pop bc
ld a,b
and $0f
call WriteHexExpr
ret
;....................................
Menu2Properties:
ld bc,Menu2CycUp  ; [UP]
ld bc,Menu2CycDown  ; [DOWN]
ld bc,Menu2CurLeft  ; [LEFT]
ld bc,Menu2CurRight ; [RIGHT]
ld bc,BackToMain    ; [B]
ld bc,Menu2Perform  ; [A]
ld bc,Menu2Constructor ; .ctor
ld bc,Menu2Desc1        ; desc1
;....................................
Menu2Constructor:
xor a
db $ea,$1b,$c2 ; ld ($c21b),a ; cursor position at 0
inc a
db $ea,$1c,$c2 ; ld ($c21c),a ; length at 1
call MenuCursorRedraw
ld hl,Menu2Text
ld de,$c3f3
call PutASCIIMultiline
ld a,$f6
ld c,$0f
ld hl,$c42f
call MemSet
ld hl,$c433
ld (hl),$9c
ld hl,Menu2Text2
ld de,$c46b
call PutASCIIMultiLine
jp Menu2Redraw
;....................................
Menu2Text:
db " -write memory-", $00
;....................................
Menu2Text2:
db "expr. length: 1",$00
;....................................
Menu2Desc1:
db $0d,"start and a: len",$0a
db "d-pad: modify",$0a
db "a button: OK",$0a
db "b button: canCel",$00
;....................................
Menu2LenCyc:
ld hl,$c21c
ld a,(hl)
inc a
ld (hl),a
cp $06
jr nz,Menu2LenCyc_L1
ld (hl),$01
;....................................
Menu2LenCyc_L1:
ld a,(hl)
ld hl,$c479
add a,$f6
ld (hl),a
ret
;....................................
Menu2Perform:
db $f0,$f5
and $08
cp $00
jr nz,Menu2LenCyc
ld hl,$c42f
call ReadDblHexExpr
ld d,a
push de
inc hl
call ReadDblHexExpr
pop de
ld e,a
db $fa,$1c,$c2 ; ld a,(c21c)
ld c,a
ld hl,$c434
;....................................
Menu2Perform_1L:
push bc
push de
call ReadDblHexExpr
inc hl
pop de
ld (de),a
inc de
pop bc
dec c
jr nz,Menu2Perform_1L
call ConfirmSound
jp BackToMain
;....................................
Menu2CurLeft:
ld hl,$c21b
ld a,(hl)
cp $00
ret z
dec (hl)
jr Menu2Redraw
;....................................
Menu2CurRight:
ld hl,$c21b
ld a,(hl)
cp $0e
ret z
inc (hl)
jr Menu2Redraw
;....................................
Menu2Redraw:
ld hl,$c41b
ld a,$7f
ld c,$10
push hl
call MemSet
pop hl
db $fa,$1b,$c2
add a,l
ld l,a
ld (hl),$ee
ret
;....................................
DrawBottomBox:
ld hl,$c490
ld bc,$0614
call DrawTextbox
ret
;....................................
Menu2CycUp:
ld hl,$c42f
db $fa,$1b,$c2
add a,l
ld l,a
inc (hl)
ld a,(hl)
cp $9d
jr z,MenuCycRestore
cp $00
jr z,Menu2CycUp_L1
cp $86
ret nz
ld (hl),$f6
ret
;....................................
Menu2CycUp_L1:
ld (hl),$80
ret
;....................................
MenuCycRestore:
ld (hl),$9c
ret
;....................................
Menu2CycDown:
ld hl,$c42f
db $fa,$1b,$c2
add a,l
ld l,a
dec (hl)
ld a,(hl)
cp $9b
jr z,MenuCycRestore
cp $f5
jr z,Menu2CycDown_L1
cp $7f
ret nz
ld (hl),$ff
ret
;....................................
Menu2CycDown_L1:
ld (hl),$85
ret
;....................................
Menu3Properties:
ld bc,Menu3Up   ; [UP]
ld bc,Menu3Down ; [DOWN]
ld bc,Menu3Left ; [LEFT]
ld bc,Menu3Right ; [RIGHT]
ld bc,BackToMain ; [B]
ld bc,Menu3AutoRefresh   ; [A]
ld bc,Menu3Constructor    ; .ctor
ld bc,Menu3Desc1           ; desc1
;....................................
Menu3Constructor:
xor a
db $ea,$1b,$c2 ; ld ($c21b),a ; starting address hi byte
db $ea,$1c,$c2 ; ld ($c21c),a ; starting address lo byte
call MenuCursorRedraw
ld hl,$c3f3
ld (hl),$7f
jr Menu3Redraw
;....................................
Menu3Desc1:
db $0d,"up/down: mov. 100"
db $0a,"left/right: mov.10"
db $0a,"hold a: autoupdate"
db $0a,"b button: canCel",$00
;....................................
Menu3Redraw:
ld hl,$c3f3
ld c,$07
db $fa,$1b,$c2 ; ld a,(c21b)
ld d,a
db $fa,$1c,$c2 ; ld a,(c21c)
ld e,a
;....................................
Menu3Redraw_L1:
push bc
push hl
ld a,d
call WriteDblHexExpr
ld a,e
call WriteDblHexExpr
ld (hl),$9c
inc hl
ld a,(de)
call WriteDblHexExpr
inc de
ld (hl),$7f
inc hl
ld a,(de)
call WriteDblHexExpr
inc de
ld (hl),$7f
inc hl
ld a,(de)
call WriteDblHexExpr
inc de
ld (hl),$7f
inc hl
ld a,(de)
call WriteDblHexExpr
inc de
pop hl
ld bc,$0014
add hl,bc
pop bc
dec c
jr nz,Menu3Redraw_L1
ret
;....................................
Menu3Up:
ld hl,$c21b
db $f0,$f5 ;ld a,(fff5)
and $08
jr z,Menu3Up_L1
ld a,(hl)
sub $0f
ld (hl),a
Menu3Up_L1:
dec (hl)
jp Menu3Redraw
;....................................
Menu3Down:
ld hl,$c21b
db $f0,$f5 ;ld a,(fff5)
and $08
jr z,Menu3Down_L1
ld a,(hl)
add a, $0f
ld (hl),a
;....................................
Menu3Down_L1:
inc (hl)
jp Menu3Redraw
Menu3Left:
ld hl,$c21c
ld a,(hl)
cp $00
jr nz,Menu3HiDecRet
dec hl
dec (hl)
inc hl
;....................................
Menu3HiDecRet:
sub $10
ld (hl),a
jp Menu3Redraw
;....................................
Menu3Right:
ld hl,$c21c
ld a,(hl)
cp $f0
jr nz,Menu3HiIncRet
dec hl
inc (hl)
inc hl
;....................................
Menu3HiIncRet:
add a,$10
ld (hl),a
jp Menu3Redraw
;....................................
Menu3AutoRefresh:
pop hl
pop de
ld de,$0000 ; disables debounce checks
push de ; since every x and 0 equals 0
pop hl
jp Menu3Redraw
;....................................
Menu4Properties:
ld bc,MenuCursorUp   ; [UP]
ld bc,MenuCursorDown ; [DOWN]
ld bc,SwitchMenuBack ; [LEFT]
ld bc,SwitchMenuBack ; [RIGHT]
ld bc,BackToMain ; [B]
ld bc,Menu4Perform   ; [A]
ld bc,Menu4Constructor ; .ctor
ld bc,Menu4Desc1 ; desc1
ld bc,Menu4Desc2 ; desc2
ld bc,Menu4Desc3 ; desc3
ld bc,Menu4Desc3 ; desc4
ld bc,Menu4Desc4 ; desc5
;....................................
Menu4Constructor:
xor a
db $ea,$1b,$c2 ; ld ($c21b),a ; cursor position at 0
call MenuCursorRedraw
ld hl,Menu4Text
ld de,$c3f4
call PutASCIIMultiline
ret
;....................................
Menu4Desc1:
db "turn off RST",$0a,$0a
db "crash prevention",$00
;....................................
Menu4Desc2:
db $0d,"fixes the RST",$0a
db "vectors with an",$0a
db "absolute jump",$0a
db "instruction.",$00
;....................................
Menu4Desc3:
db $0d,"fixes the RST",$0a
db "vectors using",$0a
db "return instru-",$0a
db "ctions.",$00
;....................................
Menu4Desc4:
db $0d,"fixes the RST",$0a
db "vectors through",$0a
db "stack manipula-",$0a
db "tions.",$00
;....................................
Menu4Text:
db "turn off",$0a
db "jump fix",$0a
db "return fix",$0a
db "dbl-return fix",$0a
db "stack fix",$00
;....................................
Menu4FixList:
db $00,$00,$00,$00
db $c1,$c3,$b9,$01
db $c9,$de,$ad,$00
db $e1,$e1,$e1,$e9
db $e1,$e1,$e9,$00
;....................................
Menu4Perform:
db $fa,$1b,$c2 ; load cursor position
add a,a
add a,a ; multiply 4 times
ld b,$00
ld c,a
ld hl,Menu4FixList
add hl,bc
ld de,$ffa6
ld c,$04
;....................................
Menu4Perform_L1:
db $2a ; LDI A,(HL)
ld (de),a
inc de
dec c
jr nz,Menu4Perform_L1
call ConfirmSound
jp BackToMain
;....................................
Menu5Properties:
ld bc,Menu5CycUp    ; [UP]
ld bc,Menu5CycDown  ; [DOWN]
ld bc,Menu5CurLeft  ; [LEFT]
ld bc,Menu5CurRight ; [RIGHT]
ld bc,BackToMain    ; [B]
ld bc,Menu5Perform   ; [A]
ld bc,Menu5Constructor ; .ctor
ld bc,Menu5Desc1        ; desc1
;....................................
Menu5Constructor:
xor a
db $ea,$1b,$c2 ; ld ($c21b),a ; cursor position at 0
call MenuCursorRedraw
ld hl,Menu5Text
ld de,$c3f3
call PutASCIIMultiline
ld a,$f6
ld c,$09
ld hl,$c45a
call MemSet
ld hl,$c45e
ld (hl),$e3
jp Menu5Redraw
;....................................
Menu5Desc1:
db $0d,"d-pad: modify",$0a
db "a button: corrupt",$0a
db "b button: canCel",$0a
db "[select RAM only]",$00
;....................................
Menu5Text:
db "-mem corruptor-",$0a
db "hover over the",$0a
db "dash and hold a",$0a
db "to fuzz randomly",$00
;....................................
Menu5CycUp:
ld hl,$c45a
db $fa,$1b,$c2
add a,l
ld l,a
inc (hl)
ld a,(hl)
cp $e4
jr z,Menu5CycRestore
cp $00
jr z,Menu5CycUp_L1
cp $86
ret nz
ld (hl),$f6
ret
;....................................
Menu5CycUp_L1:
ld (hl),$80
ret
;....................................
Menu5CycRestore:
ld (hl),$e3
ret
;....................................
Menu5CycDown:
ld hl,$c45a
db $fa,$1b,$c2
add a,l
ld l,a
dec (hl)
ld a,(hl)
cp $e2
jr z,Menu5CycRestore
cp $f5
jr z,Menu5CycDown_L1
cp $7f
ret nz
ld (hl),$ff
ret
;....................................
Menu5CycDown_L1:
ld (hl),$85
ret
;....................................
Menu5CurLeft:
ld hl,$c21b
ld a,(hl)
cp $00
ret z
dec (hl)
jr Menu5Redraw
;....................................
Menu5CurRight:
ld hl,$c21b
ld a,(hl)
cp $08
ret z
inc (hl)
;....................................
Menu5Redraw:
ld hl,$c446
ld a,$7f
ld c,$9
push hl
call MemSet
pop hl
db $fa,$1b,$c2
add a,l
ld l,a
ld (hl),$ee
ret
;....................................
Menu5RandomFuzz:
pop hl
pop de
ld de,$0000 ; disables debounce checks
push de ; since every x and 0 equals 0
pop hl
call $3e6d ; random
ld l,a
call $3e6d ; random
and $1f
add a,$c0
ld h,a
call $3e6d ; random
ld (hl),a
ld hl,$c44a
ld a,(hl)
cp $7f
jr z,Menu5RandomFuzz_L1
ld (hl),$7f
ret
;....................................
Menu5RandomFuzz_L1:
ld (hl),$ee
ret
;....................................
Menu5Perform:
db $fa,$1b,$c2
cp $04
jr z,Menu5RandomFuzz
ld hl,$c45a
call ReadDblHexExpr
ld d,a
push de
inc hl
call ReadDblHexExpr
pop de
ld e,a
inc hl
inc hl
push de
call ReadDblHexExpr
ld d,a
push de
inc hl
call ReadDblHexExpr
pop de
ld e,a
pop hl
inc de
;....................................
Menu5Perform_L1:
call $3e6d ; random
db $22 ; LDI (HL),A
ld a,h
cp d
jr nz,Menu5Perform_L1
ld a,l
cp e
jr nz,Menu5Perform_L1
call ConfirmSound
jp BackToMain
;....................................
Menu6Properties:
ld bc,Menu6CursorUp  ; [UP]
ld bc,Menu6CursorDown ; [DOWN]
ld bc,Menu6ParamL   ; [LEFT]
ld bc,Menu6ParamR ; [RIGHT]
ld bc,BackToMain ; [B]
ld bc,Menu6Perform   ; [A]
ld bc,Menu6Constructor ; .ctor
ld bc,Menu6Desc1 ; desc1
ld bc,Menu6Desc1 ; desc2
ld bc,Menu6Desc1 ; desc3
ld bc,Menu6Desc1 ; desc4
ld bc,Menu6Desc1 ; desc5
ld bc,Menu6Desc1 ; desc6
ld bc,Menu6Desc1 ; desc7
;....................................
Menu6Constructor:
xor a
db $ea,$1b,$c2 ; ld ($c21b),a ; cursor position at 0
db $ea,$1c,$c2 ; ld ($c21b),a ; param at 0
call MenuCursorRedraw
ld hl,Menu6Text
ld de,$c3f4
call PutASCIIMultiline
jp Menu6Redraw
;....................................
Menu6Desc1:
db $0d,"l/r: mod.param",$0a
db "a button: aCcept",$0a
db "b button: canCel",$0a
db "parameter:",$00
;....................................
Menu6Text:
db "give ()",$0a
db "give item",$0a
db "clear () box",$0a
db "all fly locs.",$0a
db "predef [7 heal]",$0a
db "max money",$0a
db "display area tX",$00
;....................................
Menu6Redraw:
db $fa,$1c,$c2 ; ld a,(c21c)
ld hl,$c4ec
call WriteDblHexExpr
ret
;....................................
Menu6ParamL:
ld hl,$c21c
ld a,(hl)
add a,$10
ld (hl),a
jr Menu6Redraw
;....................................
Menu6ParamR:
ld hl,$c21c
inc (hl)
jr Menu6Redraw
;....................................
Menu6CursorUp:
ld bc,Menu6Redraw
push bc
jp MenuCursorUp
;....................................
Menu6CursorDown:
ld bc,Menu6Redraw
push bc
jp MenuCursorDown
;....................................
Menu6Cursor0:
ld c,$05
call $3e59
jr Menu6Finish
;....................................
Menu6Cursor1:
ld c,$01
call $3e3f
jr Menu6Finish
;....................................
Menu6Cursor2:
xor a
db $ea,$7f,$da ; da7f=0
jr Menu6Finish
;....................................
Menu6Perform:
db $fa,$1c,$c2 ; load param
ld b,a
db $fa,$1b,$c2 ; load cursor position
cp $00
jr z,Menu6Cursor0
cp $01
jr z,Menu6Cursor1
cp $02
jr z,Menu6Cursor2
cp $03
jr z,Menu6Cursor3
cp $04
jr z,Menu6Cursor4
cp $05
jr z,Menu6Cursor5
jr Menu6Cursor6
;....................................
Menu6Finish:
call ConfirmSound
jp BackToMain
;....................................
Menu6Cursor3:
xor a
dec a
ld hl,$d70a
db $22 ; LDI (HL),A
ld (hl),a
jr Menu6Finish
;....................................
Menu6Cursor4:
ld a,b
call $3eb4
jr Menu6Finish
;....................................
Menu6Cursor5:
ld hl,$d346
ld a,$99
db $22 ; LDI (HL),A
db $22 ; LDI (HL),A
db $22 ; LDI (HL),A
jr Menu6Finish
;....................................
Menu6Cursor6:
ld a,b
db $e0,$8c
call $2817
pop bc
jp ReturnControlCall
;....................................
Menu7Properties:
ld bc,SwitchMenuBack     ; [UP]
ld bc,SwitchMenuBack  ; [DOWN]
ld bc,Menu7TurnL     ; [LEFT]
ld bc,Menu7TurnR ; [RIGHT]
ld bc,BackToMain    ; [B]
ld bc,SwitchMenuBack   ; [A]
ld bc,Menu7Constructor   ; .ctor
ld bc,Menu7Desc1 ; desc1
;....................................
Menu7Constructor:
xor a
db $ea,$1b,$c2 ; ld ($c21b),a ; page at 0
call MenuCursorRedraw
ld hl,Menu7Text1
ld de,$c3f3
call PutASCIIMultiline
ret
;....................................
Menu7Desc1:
db "left/right - page",$0a,$0a
db "b button: canCel",$00
;....................................
Menu7Texts:
ld bc,Menu7Text1
ld bc,Menu7Text2
ld bc,Menu7Text3
ld bc,Menu7Text4
;....................................
Menu7Text1:
db "C000: sound i/o ",$0a
db "C100: spritedata",$0a
db "CC28: menu keys ",$0a
db "CFC6: battleinfo",$0a
db "CF7A: mart items",$0a
db "D058: encounter ",$0a
db "D162: party ()  ",$00
;....................................
Menu7Text2:
db "D31C: item count",$0a
db "D356: cur badges",$0a
db "D361: X/Y coords",$0a
db "D36E: map script",$0a
db "D53A: items box ",$0a
db "D888: wild data ",$0a
db "DA80: () in box ",$00
;....................................
Menu7Text3:
db "1st () settings:",$0a
db "D18B: level     ",$0a
db "D172: moveset   ",$0a
db "D188: PP        ",$0a
db "D18F: stats     ",$0a
db "----------------",$0a
db "D5AB: evt flags ",$00
;....................................
Menu7Text4:
db "C3A0: screendata",$0a
db "CD80: screenbuff",$0a
db "CF4B: last name ",$0a
db "D05C: team iD   ",$0a
db "D12B: textbox iD",$0a
db "D157: playername",$0a
db "D349: other name",$00
;....................................
Menu7TurnL:
ld hl,$c21b
ld a,(hl)
cp $00
ret z
dec (hl)
jr Menu7Redraw
;....................................
Menu7TurnR:
ld hl,$c21b
ld a,(hl)
cp $03
ret z
inc (hl)
jr Menu7Redraw
;....................................
Menu7Redraw:
ld a,(hl)
ld hl,Menu7Texts
ld e,a
add a,a
add a,e
inc a
ld c,a
ld b,$00
add hl,bc
ld a,(hl)
ld e,a
inc hl
ld a,(hl)
ld h,a
ld l,e
ld de,$c3f3
jp PutASCIIMultiline
;....................................
MenuCursorUp:
ld hl,$c21b
ld a,(hl)
cp $00
ret z
dec (hl)
call MenuCursorRedraw
ret
;....................................
MenuCursorDown:
ld hl,$c21b
db $fa,$1a,$c2
db $cb,$37 ;swap a
xor (hl)
cp $06
ret z
cp $34
ret z
inc (hl)
call MenuCursorRedraw
ret
;....................................
MenuCursorRedraw:
call DrawBottomBox
ld hl,$c3f3
ld d,h
ld e,l
push hl
ld bc,$0014
push bc
ld hl,MenuCursorRedrawStr
call PutASCIIMultiline
pop bc
pop hl
db $fa,$1b,$c2
push af
;....................................
MenuCursorRedraw_L1:
cp $00
jr z,MenuCursorRedraw_L2
add hl,bc
dec a
jr nz,MenuCursorRedraw_L1
;....................................
MenuCursorRedraw_L2:
ld (hl),$ed
db $fa,$1a,$c2
ld c,a
add a,a
add a,c
ld c,a
ld b,$00
ld hl,MenuList
add hl,bc
inc hl
ld e,(hl)
inc hl
ld d,(hl)
ld h,d
ld l,e
ld bc,$0016
pop af
ld d,a
add a,a
add a,d
add a,c
ld c,a
add hl,bc
ld e,(hl)
inc hl
ld d,(hl)
ld h,d
ld l,e
ld de,$c4b9
call PutASCIIMultiline
ret
;....................................
MenuCursorRedrawStr:
db $20,$0a,$20,$0a,$20,$0a,$20,$0a,$20,$0a,$20,$0a,$20,$00
;....................................
