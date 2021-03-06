player_distance_travelled_l2 dw 0




player_init_l2:
    xor a
    ld hl,player_distance_travelled_l2
    ld (hl),a
    inc hl
    ld (hl),a
    ld a,L2_PLAYER_START_X
    ld (playerx),a
    ld a,L2_PLAYER_START_Y
    ld (playery),a
    ld a,L2_PLAYER_START_FACING
    ld (player_direction),a
    call set_state_skiingwaiting
    ret
;

player_check_level_complete_l2:
    ;todo 
    ret
;

plyr_upd_dead_l2:  
    ;todo
    ret
;

player_update_l2:
    call player_check_level_complete_l2
    call check_keys
   
    ld a,(player_state)
    cp SKIING_WAITING
    call z, plyr_upd_skiingwaiting_l2
    cp SKIING
    call z, plyr_upd_skiing_l2
    ld a,(player_state)
    cp PLAYER_DEAD
    call z, plyr_upd_dead_l2
    ret
;


plyr_upd_skiingwaiting_l2:
    ld a,(keypressed_S)
    cp TRUE
    call z,set_state_skiing
    ret
;





plyr_upd_skiing_l2:
    ld hl,tree_y_positions
    ld de,tree_x_positions
    call player_check_collision_trees  

    ld ix,flag_y_positions
    ld b,NUM_FLAGS
    call move_flags
    ld ix,tree_y_positions
    ld b,NUM_TREES
    call move_trees
    ld a,(player_direction)
    cp LEFT
    call z,increment_distance_slow

     

    ld a,(player_direction)
    cp DIAG_LEFT
    call z,increment_distance_medium

    ld a,(player_direction)
    cp RIGHT
    call z,increment_distance_slow

    ld a,(player_direction)
    cp DIAG_RIGHT
    call z,increment_distance_medium

    ld a,(player_direction)
    cp DOWN
    call z,increment_distance_fast

    ld de,(player_distance_travelled_l2)      ;a is high byte???
    ld a,d
    cp 4 ;end of level is 1024                ;is high byte >= 4? if so its higher than endflag
    call nc, do_finish_line
  
    

    ld a,(keypressed_A)
    cp 1
    call z,turn_left_l2

    ld a,(keypressed_D)
    cp 1
    call z,turn_right_l2

    

    ld a,(player_direction)
    cp LEFT
    call z,player_move_left_l2

    ld a,(player_direction)
    cp DIAG_LEFT
    call z,player_move_diagleft_l2

    ld a,(player_direction)
    cp RIGHT
    call z,player_move_right_l2

    ld a,(player_direction)
    cp DIAG_RIGHT
    call z,player_move_diagright_l2

    ret
;

increment_distance_slow:
    ld hl,(player_distance_travelled_l2)
    ld bc,PLAYER_SKI_SPEED_SLOW
    add hl,bc
    ld (player_distance_travelled_l2),hl
    ret
increment_distance_medium:
    ld hl,(player_distance_travelled_l2)
    ld bc,PLAYER_SKI_SPEED_MEDIUM
    add hl,bc
    ld (player_distance_travelled_l2),hl
    ret
increment_distance_fast:
    ld hl,(player_distance_travelled_l2)
    ld bc,PLAYER_SKI_SPEED_FAST
    add hl,bc
    ld (player_distance_travelled_l2),hl
    ret

do_finish_line:
    ld bc,endflagsprite
    ld d,L2_END_FLAG_X
    ld e,L2_END_FLAG_Y
    call drawsprite8_16
    ld bc,endflagsprite
    ld d,L2_END_FLAG_X+1
    ld e,L2_END_FLAG_Y
    call drawsprite8_16
    ld bc,endflagsprite
    ld d,L2_END_FLAG_X+2
    ld e,L2_END_FLAG_Y
    call drawsprite8_16
    

    call player_check_collision_endline


    call player_move_at_end


    ret



player_move_at_end:
    ld a,(playery)
    cp PLAYER_MAX_Y
    ret nc
    ;switch between move speeds:
    ld a,(player_direction)
    cp DOWN
    jp z, pme_fast
    cp DIAG_LEFT
    jp z, pme_medium
    cp DIAG_RIGHT
    jp z, pme_medium
    jp pme_slow
pme_slow:
    ld a,(playery)
    add a,PLAYER_SKI_SPEED_SLOW
    ld (playery),a
    ret
pme_medium:
    ld a,(playery)
    add a,PLAYER_SKI_SPEED_MEDIUM
    ld (playery),a
    ret
pme_fast:
    ld a,(playery)
    add a,PLAYER_SKI_SPEED_FAST
    ld (playery),a
    ret



player_check_collision_endline:
    ld a,L2_END_FLAG_X
    ld b,a
    ld a,(playerx)
    add a,PLAYER_WIDTH
    cp b
    ret c

    ld a,(playerx)
    ld b,a
    ld a, L2_END_FLAG_X
    add a,L2_END_FLAG_W
    cp b
    ret c

    ld a,L2_END_FLAG_Y
    ld b,a
    ld a,(playery)
    add a,PLAYER_HEIGHT
    cp b
    ret c

    call setborderpink
    jp begin_level_1_withski
    

    ret



;IX=flags
;B=num flags
move_flags:
    ;switch between move speeds:
    ld a,(player_direction)
    cp DOWN
    jp z, pmf_fast
    cp DIAG_LEFT
    jp z, pmf_medium
    cp DIAG_RIGHT
    jp z, pmf_medium
    jp pmf_slow
pmf_slow:
    ld l,(ix)
    ld h,(ix+1)
    call move_flag_slow
    ld (ix),l
    ld (ix+1),h
    inc ix
    inc ix
    djnz move_flags
    ret
pmf_medium:
    ld l,(ix)
    ld h,(ix+1)
    call move_flag_medium
    ld (ix),l
    ld (ix+1),h
    inc ix
    inc ix   
    djnz move_flags
    ret
pmf_fast:
    ld l,(ix)
    ld h,(ix+1)
    call move_flag_fast
    ld (ix),l
    ld (ix+1),h
    inc ix
    inc ix   
    call increment_score1
    djnz move_flags
    ret
;


;IX=trees
;B=num trees
move_trees:
    ;switch between move speeds:
    ld a,(player_direction)
    cp DOWN
    jp z, pmt_fast
    cp DIAG_LEFT
    jp z, pmt_medium
    cp DIAG_RIGHT
    jp z, pmt_medium
    jp pmt_slow
pmt_slow:
    ld l,(ix)
    ld h,(ix+1)
    call move_tree_slow
    ld (ix),l
    ld (ix+1),h
    inc ix
    inc ix
    djnz move_trees
    ret
pmt_medium:
    ld l,(ix)
    ld h,(ix+1)
    call move_tree_medium
    ld (ix),l
    ld (ix+1),h
    inc ix
    inc ix
    djnz move_trees
    ret
pmt_fast:
    ld l,(ix)
    ld h,(ix+1)
    call move_tree_fast
    ld (ix),l
    ld (ix+1),h
    inc ix
    inc ix
    djnz move_trees
    ret
;



;keyboard input will call the 'turn' functions, which sets the player direction.
;movement is based upon the direction and handled later
turn_left_l2:
    ;UP not needed
    ;LEFT do nothing
    ld a,(player_direction)
    cp DOWN
    jp z,set_direction_diagleft
    cp RIGHT
    jp z,set_direction_diagright
    cp DIAG_LEFT
    jp z,set_direction_left
    cp DIAG_RIGHT
    jp z,set_direction_down
    ret
;
turn_right_l2:
    ;UP not needed
    ;RIGHT do nothing
    ld a,(player_direction)
    cp DOWN
    jp z,set_direction_diagright
    cp LEFT
    jp z,set_direction_diagleft
    cp DIAG_LEFT
    jp z,set_direction_down
    cp DIAG_RIGHT
    jp z,set_direction_right
    ret
;


;player moves in the direction he faces automatically
;depending what way he faces, the speed differs
player_move_left_l2:
    ld a,(playerx)
    cp PLAYER_MIN_X+1
    ret c
    sub PLAYER_SPEED_X
    ld (playerx),a
    ret

player_move_diagleft_l2:
    ld a,(playerx)
    cp PLAYER_MIN_X+1
    ret c
    sub PLAYER_SPEED_X*2
    ld (playerx),a
    ret

player_move_right_l2:
    ld a,(playerx)
    cp PLAYER_MAX_X-1
    ret nc
    add a,PLAYER_SPEED_X
    ld (playerx),a
    ret

player_move_diagright_l2:
    ld a,(playerx)
    cp PLAYER_MAX_X-1
    ret nc
    add a,PLAYER_SPEED_X*2
    ld (playerx),a
    
    ret













;draws the correct animation frame for the player
;depending on direction (the ski level is not animated in any cycle)
drawplayer_l2:    
    ld a,(player_direction)
    cp DIAG_LEFT
    jp z, drawplayer_l2_diag_left
    cp DIAG_RIGHT
    jp z, drawplayer_l2_diag_right
    cp DOWN
    jp z, drawplayer_l2_down
    cp LEFT
    jp z, drawplayer_l2_left
    cp RIGHT
    jp z, drawplayer_l2_right
drawplayer_l2_diag_left:
    ld bc,playersprite_dl_ski
    ld de,(playery)
    call drawplayer16_24
    jp drawplayer_l2_end
drawplayer_l2_diag_right:
    ld bc,playersprite_dr_ski
    ld de,(playery)
    call drawplayer16_24
    jp drawplayer_l2_end
drawplayer_l2_down:
    ld bc,playersprite_down_ski
    ld de,(playery)
    call drawplayer16_24
    jp drawplayer_l2_end
drawplayer_l2_left:
    ld bc,playersprite_l_ski
    ld de,(playery)
    call drawplayer16_24
    jp drawplayer_l2_end
drawplayer_l2_right:
    ld bc,playersprite_r_ski
    ld de,(playery)
    call drawplayer16_24
    jp drawplayer_l2_end
drawplayer_l2_end:
    ret





  ; ld a,ASCII_AT
    ; rst 16
    ; ld a,CASH_LABEL_Y+8
    ; rst 16
    ; ld a,CASH_LABEL_X
    ; rst 16
    ; ld b,0
    ; ld c,(hl)
    ; call 11563
    ; call 11747


;hl=trees y
;de=trees x
player_check_collision_trees:
  
    call setborderdefault

    ld a,(hl)
    inc hl
    or (hl)
    dec hl
    jp z,pcct_gonext ;if High AND low bytes=00 , go next

    inc hl ;move to high byte
    ld a,(hl) ;take its value
    dec hl ;move back
    cp 0 ;is high byte == 0 ? ;or a is quicker than cp 0
    ret nz ; return if high byte != 0

    ld a,(de) ;get x pos value
    cp 255 ; check for 255 (end of array)
    ret z ; return if equal

    ld a,(playerx) ;player x
    ld b,a ;B=player x
    ld a,(de) ;A=tree X
    add a,TREE_WIDTH ;+=tree width
    cp b ; tree right side < player left side ?
    jp c, pcct_gonext ;if a < b gonext

    ld a,(de) ;tree x
    ld b,a ;B=tree x
    ld a,(playerx) ;p x
    add a,PLAYER_WIDTH ;+= width
    cp b ; if player right side < tree left, 
    jp c, pcct_gonext ; then go next

    ld a,(hl) ;A= lower byte, tree Y (we only care about lower byte because upper byte must be zero already)
    ld b,a ;B= tree y
    ld a,(playery) 
    add a,PLAYER_HEIGHT ;A= player feet
    cp b ; is player feet < tree top?
    jp c, pcct_gonext ;if yes, go next

    ld a,(playery) 
    ld b,a ; B= player head
    ld a,(hl)
    add a,TREE_HEIGHT ; A=tree bottom
    cp b ;is tree bottom < player head
    jp c, pcct_gonext ;if so go next

    ;if here, we collided with a tree....
    call setborderpink
    ; call kill player
    ret
pcct_gonext:
    inc de ;inc once for 8bit value
    inc hl 
    inc hl ;twice for 16bit
    jp player_check_collision_trees ;jump to next tree









