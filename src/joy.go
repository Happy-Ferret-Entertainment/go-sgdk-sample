package joy

const (
	BtnUp    = 0x0001
	BtnDown  = 0x0002
	BtnLeft  = 0x0004
	BtnRight = 0x0008
	BtnA     = 0x0040
	BtnB     = 0x0010
	BtnC     = 0x0020
	BtnStart = 0x0080
	BtnX     = 0x0400
	BtnY     = 0x0200
	BtnZ     = 0x0100
	BtnMode  = 0x0800
)

func ReadJoypad(joy uint16) uint16
