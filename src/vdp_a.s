* Wrapper for SGDK VDP functions
        .globl go.vdp.DrawImage
go.vdp.DrawImage:
        jmp     VDP_drawImage

        .globl go.vdp.DrawImageEx
go.vdp.DrawImageEx:
        jmp     VDP_drawImageEx

        .globl go.vdp.DrawText
go.vdp.DrawText:
* Go passes strings as two parameters
* Shift the X and Y to work around that
        move.l  12(sp),8(sp)
        move.l  16(sp),12(sp)
        .globl go.vdp.DrawTextAddr
go.vdp.DrawTextAddr:
        jmp     VDP_drawText

        .globl go.vdp.WaitVsync
go.vdp.WaitVsync: 
        jmp     VDP_waitVSync
