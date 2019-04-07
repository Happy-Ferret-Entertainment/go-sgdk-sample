.section .text

    .org    0x00000000

_Start_Of_Rom:
_Vecteurs_68K:
        dc.l    0x000000, _Entry_Point
        dc.l    0, AddressError, IllegalInst, ZeroDivide
        dc.l	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        dc.l	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        dc.l	_EXTINT, 0, _HINT, 0, _VINT, 0
.rept 8
        dc.l	0, 0, 0, 0
.endr

RomHeader:
        .ascii	"SEGA MEGA DRIVE "
        .ascii	"GRIND   2019.APR"
        .ascii	"Go + SGDK Example                               "
        .ascii	"Go + SGDK Example                               "
        .ascii	"GM ANDYG012-00"
        dc.w	0
        .ascii	"J               "
        dc.l	0x000000
        dc.l	0x3FFFFF
        dc.l	0xFF0000
        dc.l	0xFFFFFF
        .ascii	"RA"
        dc.w	0xF820
        dc.l	0x200001
        dc.l	0x20FFFF
        .ascii	"            "
        .ascii	"https://github.com/andwn/go-sgdk-sample "
        .ascii	"JUE             "

_Entry_Point:
        move    #0x2700,sr
        tst.l   0xA10008
        bne.s   SkipJoyDetect
        tst.w   0xA1000C
SkipJoyDetect:
	move.b	(0xA10001),d0
        andi.b  #0x0F,d0
        beq.s   NoTMSS
        move.l  (0x100),0xA14000
NoTMSS:
        move.w  (0xC00004),d0
        move.w  #0x0100,(0xA11100)
        move.w  #0x0100,(0xA11200)

        .globl 	_hard_reset
_hard_reset:
* clear Genesis RAM
        lea     0xFF0000,a0
        moveq   #0,d0
        move.w  #0x3FFF,d1
ClearRam:
        move.l  d0,(a0)+
        dbra    d1,ClearRam
* copy initialized variables from ROM to Work RAM
        lea     _stext,a0
        lea     0xFF0000,a1
        move.l  #_sdata,d0
        addq.l  #1,d0
        lsr.l   #1,d0
        beq     NoCopy
        subq.w  #1,d0
CopyVar:
        move.w  (a0)+,(a1)+
        dbra    d0,CopyVar
NoCopy:
        jmp     _start_entry

* SGDK tries to jump to main(), but our Go main symbol is main.main
        .globl main
main:
        jmp main.main


* Error handling

AddressDump:
        move.w 4(sp),ext1State
        move.l 6(sp),addrState
        move.w 10(sp),ext2State
        move.w 12(sp),srState
        move.l 14(sp),pcState
        bra.s  RegDump
IllegalDump:
        move.w 10(sp),ext1State
ZeroDump:
        move.w 4(sp),srState
        move.l 6(sp),pcState
RegDump:
        move.l d0,registerState+0
        move.l d1,registerState+4
        move.l d2,registerState+8
        move.l d3,registerState+12
        move.l d4,registerState+16
        move.l d5,registerState+20
        move.l d6,registerState+24
        move.l d7,registerState+28
        move.l a0,registerState+32
        move.l a1,registerState+36
        move.l a2,registerState+40
        move.l a3,registerState+44
        move.l a4,registerState+48
        move.l a5,registerState+52
        move.l a6,registerState+56
        move.l a7,registerState+60
        rts

AddressError:
        jsr AddressDump
        movem.l %d0-%d1/%a0-%a1,-(%sp)
        move.l  addressErrorCB, %a0
        jsr    (%a0)
        movem.l (%sp)+,%d0-%d1/%a0-%a1
        rte

IllegalInst:
        jsr IllegalDump
        movem.l %d0-%d1/%a0-%a1,-(%sp)
        move.l  illegalInstCB, %a0
        jsr    (%a0)
        movem.l (%sp)+,%d0-%d1/%a0-%a1
        rte

ZeroDivide:
        jsr ZeroDump
        movem.l %d0-%d1/%a0-%a1,-(%sp)
        move.l  zeroDivideCB, %a0
        jsr    (%a0)
        movem.l (%sp)+,%d0-%d1/%a0-%a1
        rte

* Standard interrupts

_EXTINT:
        movem.l %d0-%d1/%a0-%a1,-(%sp)
        move.l  internalExtIntCB, %a0
        jsr    (%a0)
        movem.l (%sp)+,%d0-%d1/%a0-%a1
        rte

_HINT:
        movem.l %d0-%d1/%a0-%a1,-(%sp)
        move.l  internalHIntCB, %a0
        jsr    (%a0)
        movem.l (%sp)+,%d0-%d1/%a0-%a1
        rte

_VINT:
        movem.l %d0-%d1/%a0-%a1,-(%sp)
        move.l  internalVIntCB, %a0
        jsr    (%a0)
        movem.l (%sp)+,%d0-%d1/%a0-%a1
        rte
