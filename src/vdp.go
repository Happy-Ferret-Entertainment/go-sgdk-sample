package vdp

const (
	PlanA = 0
	PlanB = 1
	PlanW = 2

	CPU      = 0
	DMA      = 1
	DMAQueue = 2
)

func DrawImage(plan uint16, img uint32, x uint16, y uint16)
func DrawImageEx(plan uint16, img uint32, basetile uint16, x uint16, y uint16, loadpal uint16, method uint16)

func DrawText(text string, x uint16, y uint16)
func DrawTextAddr(addr uint32, x uint16, y uint16)

func SetPalette(num uint16, pal uint32)

func WaitVsync()
