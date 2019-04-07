package main

import (
	"joy"
	"res"
	"vdp"
)

func main() {
	vdp.DrawText("Hello, Go!", 4, 2)
	vdp.DrawImage(vdp.PlanA, res.Gopher(), 8, 5)
	for {
		btn := joy.ReadJoypad(0)
		vdp.DrawText("    ", 30, 12)
		vdp.DrawText("    ", 30, 13)
		vdp.DrawText("    ", 30, 14)
		if btn&joy.BtnUp > 0 {
			vdp.DrawText("U", 30, 12)
		}
		if btn&joy.BtnDown > 0 {
			vdp.DrawText("D", 31, 12)
		}
		if btn&joy.BtnLeft > 0 {
			vdp.DrawText("L", 32, 12)
		}
		if btn&joy.BtnRight > 0 {
			vdp.DrawText("R", 33, 12)
		}
		if btn&joy.BtnA > 0 {
			vdp.DrawText("A", 30, 13)
		}
		if btn&joy.BtnB > 0 {
			vdp.DrawText("B", 31, 13)
		}
		if btn&joy.BtnC > 0 {
			vdp.DrawText("C", 32, 13)
		}
		if btn&joy.BtnStart > 0 {
			vdp.DrawText("S", 33, 13)
		}
		if btn&joy.BtnX > 0 {
			vdp.DrawText("X", 30, 14)
		}
		if btn&joy.BtnY > 0 {
			vdp.DrawText("Y", 31, 14)
		}
		if btn&joy.BtnZ > 0 {
			vdp.DrawText("Z", 32, 14)
		}
		if btn&joy.BtnMode > 0 {
			vdp.DrawText("M", 33, 14)
		}
		vdp.WaitVsync()
	}
}
