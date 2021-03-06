FLAG_WIDTH equ 1
FLAG_HEIGHT equ 16

FLAG_START_Y equ 176

FLAG_START_GAP equ 6
FLAG_MIN_GAP equ 3

flag_current_gap equ 5



FLAG_MIN_X equ 4
FLAG_MAX_X equ 16


SKI_UNIT equ 16


FLAGY1 equ 120
FLAGY2 equ 200
FLAGY3 equ 384
FLAGY4 equ 456
FLAGY5 equ 568
FLAGY6 equ 656
FLAGY7 equ 728
FLAGY8 equ 864
FLAGY9 equ 920

NUM_FLAGS equ 9
flag_y_positions:
    ds 9*2
flag_x_positions:
    db 16
    db 16
    db 3
    db 3
    db 7
    db 14
    db 14
    db 4
    db 4
; 


flagsprite:
    db %11111111
    db %01111110
    db %00111100
    db %01111110
    db %11111111
    db %00011000
    db %00011000
    db %00011000
    ;
    db %00011000
    db %00011000
    db %00011000
    db %00011000
    db %00011000
    db %00011000
    db %00011000
    db %00011000
;

endflagsprite:
    db %11111111
    db %11111111
    db %11111111
    db %11111111
    db %11111111
    db %11111111
    db %11111111
    db %11111111
    ;
    db %00011000
    db %00011000
    db %00011000
    db %00011000
    db %00011000
    db %00011000
    db %00011000
    db %00011000
    ;

;

reset_flags_y:
    ld hl,flag_y_positions
    ld de,FLAGY1
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld de,FLAGY2
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld de,FLAGY3
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld de,FLAGY4
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld de,FLAGY5
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld de,FLAGY6
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld de,FLAGY7
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld de,FLAGY8
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld de,FLAGY9
    ld (hl),e
    inc hl
    ld (hl),d

    ret
;







;IX=flag
;HL=flag y
move_flag_slow:
    ld a,h
    or l
    ret z ;ret if y=0
    push bc
    ld bc,PLAYER_SKI_SPEED_SLOW
    sbc hl,bc


    pop bc
    ret

;IX=flag
;HL=flag y
move_flag_medium:
    ld a,h
    or l
    ret z ;ret if y=0
    push bc
    ld bc,PLAYER_SKI_SPEED_MEDIUM
    sbc hl,bc


    pop bc
    ret

;IX=flag
;HL=flag y
move_flag_fast:
    ld a,h
    or l
    ret z ;ret if y=0
    push bc
    ld bc,PLAYER_SKI_SPEED_FAST
    sbc hl,bc
   
    pop bc
    ret


;HL=(flag y)
draw_flag:
    xor a
    cp h
    ret nz
    ld a,l
    cp FLAG_START_Y+1
    ret nc
    or a ;cp 0 same
    ret z

    push de
    
    
    ld a,(de)
    ld e,l
    ld d,a

    
    
    push bc 
    ld bc,flagsprite
    push de
    call drawsprite8_16
    pop de
    ld b,FLAG_COLOUR_L
    call paint_sprite_1_2
    pop bc
    pop de
    
    ret
;
    

;HL=(flag y)
draw_flag_pair:
    xor a
    cp h
    ret nz
    ld a,l
    cp FLAG_START_Y+1
    ret nc
    or a ;cp 0 same
    ret z


    push de
    
    
    ld a,(de)
    add a,4
    ld e,l
    ld d,a

    
    
    push bc 
    ld bc,flagsprite
    push de
    call drawsprite8_16
    pop de
    ld b,FLAG_COLOUR_R
    call paint_sprite_1_2
    pop bc
    pop de
    
    ret
;
    
