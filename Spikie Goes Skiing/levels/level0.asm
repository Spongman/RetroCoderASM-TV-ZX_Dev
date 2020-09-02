mainmenu_init:
    ld a,22
    rst 16
    ld a,4
    rst 16
    ld a,2
    rst 16
    ld de,title_string
    ld bc,eo_title_string-title_string
    call 8252

    ld a,22
    rst 16
    ld a,6
    rst 16
    ld a,4
    rst 16
    ld de,presskey_string
    ld bc,eo_presskey_string-presskey_string
    call 8252

    ret

mainmenu_update:
    call check_keys

    ld a,(keypressed_W)
    cp TRUE
    jp z, begin_level_1

    jp mainmenu_update



;;;; DATA ;;;;;;;;;;


title_string db 'SPIKIE GOES SKIING!'
eo_title_string equ $


presskey_string db 'PRESS W TO BEGIN..'
eo_presskey_string equ $