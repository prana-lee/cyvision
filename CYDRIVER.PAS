(*******************************************************)
{                                                       }
{       Cyest Desk version 3.0                          }
{       Cyest Desk Driver Unit                          }
{                                                       }
{       Copyright (c) 1996 Prana's PC Corp.             }
{                                                       }
(*******************************************************)

Unit Cydriver;

Interface

{$I Flags}
Uses Objects, CySystem, CyGraph;

Const
  { Event codes }
  evMouseDown = $0001;
  evMouseUp   = $0002;
  evMouseMove = $0004;
  evMouseAuto = $0008;
  evKeyDown   = $0010;
  evCommand   = $0100;
  evBroadcast = $0200;

  { Event masks }
  evNothing   = $0000;
  evMouse     = $000F;
  evKeyboard  = $0010;
  evMessage   = $Ff00;

  PositionalEvents= evMouse;
  FocusedEvents   = evKeyboard + evCommand;

  { Extended key codes }
  kbEsc       = $011B;  kbAltSpace  = $0200;  kbCtrlIns   = $0400;
  kbShiftIns  = $0500;  kbCtrlDel   = $0600;  kbShiftDel  = $0700;
  kbBack      = $0E08;  kbCtrlBack  = $0E7F;  kbShiftTab  = $0F00;
  kbTab       = $0F09;  kbAltQ      = $1000;  kbAltW      = $1100;
  kbAltE      = $1200;  kbAltR      = $1300;  kbAltT      = $1400;
  kbAltY      = $1500;  kbAltU      = $1600;  kbAltI      = $1700;
  kbAltO      = $1800;  kbAltP      = $1900;  kbCtrlEnter = $1C0A;
  kbEnter     = $1C0D;  kbAltA      = $1E00;  kbAltS      = $1F00;
  kbAltD      = $2000;  kbAltF      = $2100;  kbAltG      = $2200;
  kbAltH      = $2300;  kbAltJ      = $2400;  kbAltK      = $2500;
  kbAltL      = $2600;  kbAltZ      = $2C00;  kbAltX      = $2D00;
  kbAltC      = $2E00;  kbAltV      = $2F00;  kbAltB      = $3000;
  kbAltN      = $3100;  kbAltM      = $3200;  kbF1        = $3B00;
  kbF2        = $3C00;  kbF3        = $3D00;  kbF4        = $3E00;
  kbF5        = $3F00;  kbF6        = $4000;  kbF7        = $4100;
  kbF8        = $4200;  kbF9        = $4300;  kbF10       = $4400;
  kbHome      = $4700;  kbUp        = $4800;  kbPgUp      = $4900;
  kbGrayMinus = $4A2D;  kbLeft      = $4B00;  kbRight     = $4D00;
  kbGrayPlus  = $4E2B;  kbEnd       = $4F00;  kbDown      = $5000;
  kbPgDn      = $5100;  kbIns       = $5200;  kbDel       = $5300;
  kbShiftF1   = $5400;  kbShiftF2   = $5500;  kbShiftF3   = $5600;
  kbShiftF4   = $5700;  kbShiftF5   = $5800;  kbShiftF6   = $5900;
  kbShiftF7   = $5A00;  kbShiftF8   = $5B00;  kbShiftF9   = $5C00;
  kbShiftF10  = $5D00;  kbCtrlF1    = $5E00;  kbCtrlF2    = $5F00;
  kbCtrlF3    = $6000;  kbCtrlF4    = $6100;  kbCtrlF5    = $6200;
  kbCtrlF6    = $6300;  kbCtrlF7    = $6400;  kbCtrlF8    = $6500;
  kbCtrlF9    = $6600;  kbCtrlF10   = $6700;  kbAltF1     = $6800;
  kbAltF2     = $6900;  kbAltF3     = $6A00;  kbAltF4     = $6B00;
  kbAltF5     = $6C00;  kbAltF6     = $6D00;  kbAltF7     = $6E00;
  kbAltF8     = $6F00;  kbAltF9     = $7000;  kbAltF10    = $7100;
  kbCtrlPrtSc = $7200;  kbCtrlLeft  = $7300;  kbCtrlRight = $7400;
  kbCtrlEnd   = $7500;  kbCtrlPgDn  = $7600;  kbCtrlHome  = $7700;
  kbAlt1      = $7800;  kbAlt2      = $7900;  kbAlt3      = $7A00;
  kbAlt4      = $7B00;  kbAlt5      = $7C00;  kbAlt6      = $7D00;
  kbAlt7      = $7E00;  kbAlt8      = $7F00;  kbAlt9      = $8000;
  kbAlt0      = $8100;  kbAltMinus  = $8200;  kbAltEqual  = $8300;
  kbCtrlPgUp  = $8400;  Kbaltback   = $0800;  kbNoKey     = $0000;

  { Keyboard state and shift masks }
  kbRightShift  = $0001;
  kbLeftShift   = $0002;
  kbCtrlShift   = $0004;
  kbAltShift    = $0008;
  kbScrollState = $0010;
  kbNumState    = $0020;
  kbCapsState   = $0040;
  kbInsState    = $0080;
  { Mouse button state masks }
  mbLeftButton  = $01;
  mbRightButton = $02;

Type
 TEvent = record
  What: Word;
  case Word of
    evNothing: ();
    evMouse: (
      Buttons: Byte;
      Double: Boolean;
      Where: TPoint);
    evKeyDown: (
      case Integer of
        0: (KeyCode: Word);
        1: (CharCode: Char;
  ScanCode: Byte));
    evMessage: (
      Command: Word;
      case Word of
        0: (InfoPtr: Pointer);
        1: (InfoLong: Longint);
        2: (InfoWord: Word);
        3: (InfoInt: Integer);
        4: (InfoByte: Byte);
        5: (InfoChar: Char));
end;

Const
    { Initialized variables }
  ButtonCount: Byte = 0;
  DoubleDelay: Word = 8;
  RepeatDelay: Word = 8;
  Mousevisflag : integer=-1;

Var
 { Uninitialized variables }
 drawbusy:byte;
 Shiftstate: Byte Absolute $40 :$17;
 MouseEvents: Boolean;
 MouseReverse: Boolean;
{ MouseIntFlag: Byte;}
 MouseButtons: Byte;
 MouseWhere: TPoint;
 Savecursorarea : Pointer;

Procedure GetMouseEvent (Var Event: TEvent);
Procedure GetKeyEvent (Var Event: TEvent);
Procedure SetMouseShape (Shape: Byte);
Procedure InitEvents;
Procedure DoneEvents;
Procedure ShowMouse;
Procedure HideMouse;

Function MouseinRect(point:tpoint;R:Trect):boolean;
Function GetAltCode (CH: Char): Word;
Function Getctrlchar (Keycode: Word): Char;
Function Getctrlcode (CH: Char): Word;
Function CtrlToArrow (Keycode: Word): Word;

function normalstr(s:String;var b:byte):string;

Implementation

Const
  Eventqsize = 16;

  { Event manager variables }

Var
  Ticks: Word Absolute $40 :$6C;
  Savesize      : Word;
  Mwhere        : TPoint;
  Downbuttons: Byte;
  Lastbuttons: Byte;
  Lastdouble: Boolean;
  Lastwhere: TPoint;
  Downwhere: TPoint;
  Downticks: Word;
  Autoticks: Word;
  Autodelay: Word;
  Eventcount: Word;
  Eventqhead: Word;
  Eventqtail: Word;
  Eventqueue: Array [0..Eventqsize - 1] Of TEvent;
  Eventqlast: Record End;

  { Store event in GetMouseEvent and GetKeyEvent }
Procedure Storeevent; Near; Assembler;
Asm
  Mov	DI, Sp
  LES	DI, Ss: [DI+ 8]
  Cld
  StosW
  Xchg	AX, BX
  StosW
  Xchg	AX, CX
  StosW
  Xchg	AX, DX
  StosW
End;

  {GETMOUSESTATE}
  { Get mouse state }
  { Out	BL = Button mask }
  {	CX = X coordinate }
  {	DX = Y coordinate }
  {	DI = Timer ticks }

Procedure GetKeyEvent(Var Event: TEvent); Assembler;
Asm
  	Mov	AH,1
  	Int	16H
  	Mov	AX,0
  	Mov	BX,AX
  	Je	@@1
  	Mov	AH,0
  	Int	16H
  	Xchg	AX,BX
  	Mov	AX,evKeyDown
  @@1:	XOr	CX,CX
  	Mov	DX,CX
  	Call	Storeevent
End;

procedure GetMouseState; near; assembler;
asm
	CLI
	CMP	EventCount,0
	JNE	@@1
	MOV	BL,MouseButtons
	MOV	CX,MouseWhere.Word[0]
	MOV	DX,MouseWhere.Word[2]
	MOV	DI,SEG Ticks
	MOV	ES,DI
	MOV	DI,ES:Ticks
	JMP	@@3
@@1:	MOV	SI,EventQHead
	CLD
	LODSW
	XCHG	AX,DI
	LODSW
	XCHG	AX,BX
	LODSW
	XCHG	AX,CX
	LODSW
	XCHG	AX,DX
	CMP	SI,OFFSET EventQLast
	JNE	@@2
	MOV	SI,OFFSET EventQueue
@@2:	MOV	EventQHead,SI
	DEC	EventCount
@@3:	STI
	CMP	MouseReverse,0
	JE	@@4
	MOV	BH,BL
	AND	BH,3
	JE	@@4
	CMP	BH,3
	JE	@@4
	XOR	BL,3
@@4:
end;

procedure GetMouseEvent(var Event: TEvent); assembler;
asm
	CMP	MouseEvents,0
	JE	@@2
	CALL	GetMouseState
	MOV	BH,LastDouble
	MOV	AL,LastButtons
	CMP	AL,BL
	JE	@@1
	OR	AL,AL
	JE	@@3
	OR	BL,BL
	JE	@@5
	MOV	BL,AL
@@1:	CMP	CX,LastWhere.X
	JNE	@@6
	CMP	DX,LastWhere.Y
	JNE	@@6
	OR	BL,BL
	JE	@@2
	MOV	AX,DI
	SUB	AX,AutoTicks
	CMP	AX,AutoDelay
	JAE	@@7
@@2:	XOR	AX,AX
	MOV	BX,AX
	MOV	CX,AX
	MOV	DX,AX
	JMP	@@9
@@3:	MOV	BH,0
	CMP	BL,DownButtons
	JNE	@@4
	CMP	CX,DownWhere.X
	JNE	@@4
	CMP	DX,DownWhere.Y
	JNE	@@4
	MOV	AX,DI
	SUB	AX,DownTicks
	CMP	AX,DoubleDelay
	JAE	@@4
	MOV	BH,1
@@4:	MOV	DownButtons,BL
	MOV	DownWhere.X,CX
	MOV	DownWhere.Y,DX
	MOV	DownTicks,DI
	MOV	AutoTicks,DI
	MOV	AX,RepeatDelay
	MOV	AutoDelay,AX
	MOV	AX,evMouseDown
	JMP	@@8
@@5:	MOV	AX,evMouseUp
	JMP	@@8
@@6:	MOV	AX,evMouseMove
	JMP	@@8
@@7:	MOV	AutoTicks,DI
	MOV	AutoDelay,1
	MOV	AX,evMouseAuto
@@8:    MOV	LastButtons,BL
	MOV	LastDouble,BH
	MOV	LastWhere.X,CX
	MOV	LastWhere.Y,DX
@@9:	CALL	StoreEvent
end;

Var
  Oldx,Oldy:Integer;

Procedure Mouseint; Far; Assembler;
Asm
  Mov	SI,Seg @Data
  Mov	DS,SI
  Mov	SI,CX
  Cmp Mousevisflag,0
  Jl @notvisible
  cmp drawbusy,0
  jne @notvisible
  Mov	MouseButtons,BL
  Mov	MouseWhere.X,SI
  Mov	MouseWhere.Y,DX
  cli
  Push AX
  Push BX
  Push CX
  Push DX
  Push SI
  Push DI
  push vp.word[0]
  push vp.word[2]

  inc drawbusy                  {BUSY}
  xor ax,ax
  mov vp.word[0],ax
  mov vp.word[2],ax

  Push CopyPut
  Call SetWriteMode
  Mov AX,Oldx
  Mov BX,Oldy
  Sub AX,Mouseshape.Hotspot.X
  Sub BX,Mouseshape.Hotspot.Y
  Push AX
  Push BX
  Push Savecursorarea.Word[2]
  Push Savecursorarea.Word[0]
  Call PutImage

  Mov AX,MouseWhere.X
  Mov BX,MouseWhere.Y
  Sub AX,Mouseshape.Hotspot.X
  Sub BX,Mouseshape.Hotspot.Y
  Push AX
  Push BX
  Add AX,16
  Add BX,16
  Push AX
  Push BX
  Push Savecursorarea.Word[2]
  Push Savecursorarea.Word[0]
  Call GetImage
  Push MouseWhere.X
  Push MouseWhere.Y
  Call Drawmouse
  dec drawbusy          {BUSY}

  pop vp.word[2]
  pop vp.word[0]

  Pop DI
  Pop SI
  Pop DX
  Pop CX
  Pop BX
  Pop AX
  sti
  Mov Oldx,CX
  Mov Oldy,DX
@Notvisible:

  	Test	AX,11110B
  	Je	@@2
  	Cmp	Eventcount,Eventqsize
  	Je	@@2
  	Mov	DI,Seg Ticks
  	Mov	ES,DI
  	Mov	AX,ES:Ticks
  	Mov	DI,Eventqtail
  	Push	DS
  	Pop	ES
  	Cld
  	StosW
  	Xchg	AX,BX
  	StosW
  	Xchg	AX,SI
  	StosW
  	Xchg	AX,DX
  	StosW
  	Cmp	DI,Offset Eventqlast
  	Jne	@@1
 	Mov	DI,Offset Eventqueue
@@1:	Mov	Eventqtail,DI
	Inc	Eventcount
@@2:{	Mov	MouseIntFlag,1}
End;

Procedure SetMouseShape(Shape:Byte);Assembler;
Asm
  Call HideMouse
  Push Word Ptr [BP+6]
  Call Setmousestyle
  Call ShowMouse
End;

Procedure InitEvents; Assembler;
Asm
  XOr	AX,AX
  Int	33H
  Or	AX,AX
  Je	@@E
  Push	BX
  Mov	AX,4
  XOr	CX,CX
  XOr	DX,DX
  Int	33H
  Pop	AX
  @@E:	Mov	ButtonCount,AL

  XOr	AX,AX
  Cmp	AL,ButtonCount
  Je	@@1
  Mov	Downbuttons,AL
  Mov	Lastdouble,AL
  Mov	Eventcount,AX
  Mov	AX,Offset DS:Eventqueue
  Mov	Eventqhead,AX
  Mov	Eventqtail,AX
  Mov	AX,3
  Int	33H
  Xchg	AX,CX
  Mov	MouseButtons,BL
  Mov	MouseWhere.X,AX
  Mov	MouseWhere.Y,DX
  Mov	Lastbuttons,BL
  Mov	Lastwhere.X,AX
  Mov	Lastwhere.Y,DX
  Mov	AX,12
  Mov	CX,0Ffffh
  Mov	DX,Offset Cs:Mouseint
  Push	Cs
  Pop	ES
  Int	33H
  Push 0
  Push 0
  Push 16
  Push 16
  Call ImageSize
  Mov Savesize,AX

  Push DS
  Push Offset Savecursorarea

  Push AX
  Call GetMem
  Push 0
  Push 0
  Push GetMaxX
  Push GetMaxY
  Call Setmousewindow
  Mov	MouseEvents,1
  call showmouse
  @@1:
End;

Procedure ShowMouse;Assembler;
Asm
  Cmp Mousevisflag,$FFFF
  Jne @Alreadyvisible
  cmp drawbusy,0
  jne @alreadyvisible
  push vp.word[0]
  push vp.word[2]

  xor ax,ax
  mov vp.word[0],ax
  mov vp.word[2],ax

  inc drawbusy
  Mov AX,MouseWhere.X
  Mov BX,MouseWhere.Y
  Sub AX,Mouseshape.Hotspot.X
  Sub BX,Mouseshape.Hotspot.Y
  Push AX
  Push BX
  Add AX,16
  Add BX,16
  Push AX
  Push BX
  Push Savecursorarea.Word[2]
  Push Savecursorarea.Word[0]
  Call GetImage
  Push MouseWhere.X
  Push MouseWhere.Y
  Call Drawmouse
  pop vp.word[2]
  pop vp.word[0]
  dec drawbusy
  @Alreadyvisible:
  Inc Mousevisflag
End;

Procedure HideMouse;Assembler;
Asm
  Cmp Mousevisflag,0
  Jne @Hidden
  cmp drawbusy,0
  jne @hidden

  inc drawbusy
  Push CopyPut
  Call SetWriteMode
  Mov AX,Oldx
  Mov BX,Oldy
  Sub AX,Mouseshape.Hotspot.X
  Sub BX,Mouseshape.Hotspot.Y
  Push AX
  Push BX
  Push Savecursorarea.Word[2]
  Push Savecursorarea.Word[0]
  Call PutImage
  dec drawbusy
  @Hidden:
  Dec Mousevisflag
End;

Function MouseinRect(point:tpoint;R:Trect):boolean;
begin
 mouseinrect:=r.contains(point);
end;

Procedure DoneEvents;Assembler;
Asm
  mov mouseevents,0
  je @nomouse
  Call HideMouse
  Push DS
  Push Offset Savecursorarea
  Push Savesize
  Call FreeMem
  @nomouse:
  mov mouseevents,0
End;

Const

  Altcodes1: Array[$10..$32] Of Char =
  'QWERTYUIOP'#0#0#0#0'ASDFGHJKL'#0#0#0#0#0'ZXCVBNM';

  Altcodes2: Array[$78..$83] Of Char =
  '1234567890-=';
  Altcodescyr : Array[$10..$34] Of Char =
  'âñìäÖçÉòôáïö'#0#0'îõÇÄèêéãÑÜù'#0#0#0'üóëåàíúÅû';

Function GetAltCode(CH: Char): Word;
Var
  I: Word;
Begin
  GetAltCode := 0;
  If CH = #0 Then Exit;
  CH := System.UpCase(CH);
  If CH = #240 Then
  Begin
    GetAltCode := $0200;
    Exit;
  End;
  For I := $10 To $32 Do
    If Altcodes1[I] = CH Then
    Begin
      GetAltCode := I ShL 8;
      Exit;
    End;
  For I := $78 To $83 Do
    If Altcodes2[I] = CH Then
    Begin
      GetAltCode := I ShL 8;
      Exit;
    End;
End;

Function Getctrlchar(Keycode: Word): Char;
Begin
  Getctrlchar := #0;
  If (Lo(Keycode) <> 0) And (Lo(Keycode) <= Byte('Z') - Byte('A') + 1) Then
    Getctrlchar := Char(Lo(Keycode) + Byte('A') - 1);
End;

Function Getctrlcode(CH: Char): Word;
Begin
  Getctrlcode := GetAltCode(CH) Or (Byte(System.UpCase(CH)) - Byte('A') + 1);
End;


Function CtrlToArrow(Keycode: Word): Word;
Const
  Numcodes = 10;
  Ctrlcodes: Array[0..Numcodes-1] Of Char = ^S^D^E^X^A^F^G^V^R^C;
  Arrowcodes: Array[0..Numcodes-1] Of Word =
  (kbLeft, kbRight, kbUp, kbDown, kbHome, kbEnd, kbDel, kbIns,
    kbPgUp, kbPgDn);
Var
  I: Integer;
Begin
  CtrlToArrow := Keycode;
  For I := 0 To Numcodes - 1 Do
    If WordRec(Keycode).Lo = Byte(Ctrlcodes[I]) Then
    Begin
      CtrlToArrow := Arrowcodes[I];
      Exit;
    End;
End;

function normalstr(s:String;var b:byte):string;
begin
 b:=pos('&',s);
 delete(s,b,1);
 normalstr:=s;
end;

End.