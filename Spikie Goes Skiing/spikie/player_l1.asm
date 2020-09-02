


player_update_l1:
    call check_keys
    
    ld ix,vehicles_r
    call player_check_collision_cars

    call plyr_upd_noski_l1
    ; ld a,(player_state)
    ; cp NO_SKI
    ; call z, plyr_upd_noski_l1
    ; cp WITH_SKI
    ; call z, plyr_upd_withski_l1


    ret


plyr_upd_noski_l1:
    ld a,(keypressed_W)
    cp 1
    call z,try_move_up_l1

    ld a,(keypressed_S)
    cp 1
    call z,try_move_down_l1

    ld a,(keypressed_A)
    cp 1
    call z,try_move_left_l1

    ld a,(keypressed_D)
    cp 1
    call z,try_move_right_l1
    ret

plyr_upd_withski_l1:
    ld a,(keypressed_W)
    cp 1
    call z,try_move_up_l1

    ld a,(keypressed_S)
    cp 1
    call z,try_move_down_l1

    ld a,(keypressed_A)
    cp 1
    call z,try_move_left_l1

    ld a,(keypressed_D)
    cp 1
    call z,try_move_right_l1
    ret



;these move the targetpos. call them on keypress for example
try_move_left_l1:
    ld a,LEFT
    ld (player_direction),a
    ld a,(playerx)
    cp MIN_X
    ret c
    ld a,(playerx)
    sub PLAYER_SPEED_X
    ld (playerx),a
    ret

try_move_right_l1:
    ld a,RIGHT
    ld (player_direction),a
    ld a,(playerx)
    cp MAX_X
    ret nc
    ld a,(playerx)
    add a,PLAYER_SPEED_X
    ld (playerx),a
    ret

try_move_up_l1:
    ld a,UP
    ld (player_direction),a
    ld a,(playery)
    cp MIN_Y
    ret c
    ld a,(playery)
    sub PLAYER_SPEED_Y
    ld (playery),a
    ret

try_move_down_l1:
    ld a,DOWN
    ld (player_direction),a
    ld a,(playery)
    cp MAX_Y
    ret nc
    ld a,(playery)
    add a,PLAYER_SPEED_Y
    ld (playery),a
    ret
;







