L1_PAVEMENT_COLOUR equ %01111000
L1_ROAD_COLOUR equ %01000111
L1_WHITELINE_Y equ 96

SPAWN_CHANCE_1 equ 15


SHOP_X equ 8
SHOP_Y equ 192-24

SHOP_W equ 6

SHOP_H equ 24
SHOP_DOOR_OFFSET equ 1


roadline_sprite:
    db %00000000
    db %00000000
    db %11111111
    db %11111111
    db %11111111
    db %11111111
    db %00000000
    db %00000000
;


; ASM data file from a ZX-Paintbrush picture with 48 x 24 pixels (= 6 x 3 characters)
; line based output of pixel data:
shop_sprite:
    db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
    db %00000000, %11111111, %11111111, %11111111, %11111111, %00000000
    db %00000001, %00001111, %11111111, %11111110, %11111111, %10000000
    db %00000010, %11110111, %11111111, %11111101, %11111111, %10000000
    db %00000101, %11111011, %11111111, %11111101, %11111111, %11000000
    db %00001011, %11111101, %11100000, %00000000, %00000011, %11100000
    db %00010111, %11111110, %11110000, %00000000, %00000011, %11100000
    db %00101111, %11111111, %01111111, %11110111, %11111111, %11110000
    db %01011111, %11111111, %10111111, %11110111, %11111111, %11111000
    db %10111111, %11111111, %11011111, %10000011, %11111111, %11111100
    db %01111111, %00000111, %11101111, %11111111, %11111111, %11111110
    db %11111110, %00000011, %11000000, %00000000, %00000000, %00000011
    db %11011110, %00000011, %11011111, %11111111, %11111111, %11111111
    db %00011110, %00000011, %11011111, %11000000, %11011101, %10111100
    db %00011110, %00000011, %11011111, %11011111, %11011011, %10111100
    db %00011110, %00000011, %11011111, %11011111, %11010111, %10111100
    db %00011110, %00000011, %11011111, %11000000, %11001111, %10111100
    db %00011110, %00000011, %11011111, %11111110, %11001111, %10111100
    db %00011110, %00000011, %11011111, %11111110, %11010111, %10111100
    db %00011110, %00000011, %11011111, %11111110, %11011011, %10111100
    db %00011110, %00000011, %11011111, %11000000, %11011101, %10111100
    db %00011110, %00000011, %11011111, %11111111, %11111111, %11111100
    db %00011110, %00000011, %11011111, %11111111, %11111111, %11111100
    db %00011110, %00000011, %11011111, %11111111, %11111111, %11111100
;

l1_start:
    call paint_background
    call draw_ui
    ret

l1_update:
    call increment_score1
    ; call setborderblue
    call getrandom
    cp SPAWN_CHANCE_1
    call c, spawn_vehicle_right
    call getrandom
    cp SPAWN_CHANCE_1
    call c, spawn_vehicle_left

    call vehicles_update

    call player_update

    
    
    ret



l1_draw:
    call vehicles_draw
    call l1_draw_whitelines

    call player_draw
    call l1_draw_shop
    ret


l1_draw_whitelines: 
    xor a
    ld d,a
    ld a,L1_WHITELINE_Y
    ld e,a
    call l1_drw_wl
    ret

l1_drw_wl:
    push de
    ld bc,roadline_sprite
    call drawsprite8_8
    pop de
    inc d
    inc d
    ld a,d
    cp GAME_WINDOW_WIDTH
    jp c, l1_drw_wl
    ret

l1_draw_shop:
    ld bc, shop_sprite
    ld a,SHOP_X
    ld d,a
    ld a,SHOP_Y
    ld e,a
    call drawsprite48_24
    ret