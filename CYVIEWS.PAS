Unit Cyviews;

Interface
{$I FLAGS}
{$D+}
Uses Objects,CySystem,Cydriver,CyGraph,Cyequ;

Const
  Unlocked      = 00000;
  Locked        = 00001;

  sfVisible     = $0001;
  sfCursorVis   = $0002;
  sfCursorIns   = $0004;
  sfActive      = $0010;
  Sfredraw      = $0020;
  Sfrefresh     = $0040;
  sfDragging    = $0080;
  sfDisabled    = $0100;
  sfModal       = $0200;
  sfDefault     = $0400;
  sfExposed     = $0800;
  sfMaximized   = $1000;
  sfMinimized   = $2000;
  sfnodraw      = $4000;

  offocusable   = $0001;
  ofTopSelect   = $0002;
  ofFirstClick  = $0004;
  ofFramed      = $0008;
  ofPreProcess  = $0010;
  ofPostProcess = $0020;
  ofTileable    = $0080;
  ofCenterX     = $0100;
  ofCenterY     = $0200;
  ofCentered    = $0300;
  ofResizeAble  = $0400;
  ofMoveAble    = $0800;
  ofValidate    = $1000;

  gfGrowLoX     = $01;
  gfGrowHiX     = $02;
  gfGrowLoY     = $04;
  gfGrowHiY     = $08;
  gfGrowRel     = gfGrowHiX+gfGrowHiY;
  gfGrowAll     = gfGrowLoX+gfGrowHiX+gfGrowLoY+gfGrowHiY;

  wfMove        = $01;
  Wfresize      = $02;
  wfClose       = $04;
  Wfmaximize    = $08;
  Wfminimize    = $10;
  Wfframed      = $20;
  Wfcaption     = $40;
  Wfmenu        = $80;
  Wfdefault     = wfMove+Wfresize+wfClose+Wfmaximize+Wfminimize+Wfframed+Wfcaption+Wfmenu;

  rzupper       = 01;
  rzlower       = 02;
  rzleft        = 03;
  rzright       = 04;
  rzany         = $FF;

  bs_normal     = 00;
  bs_upper      = 01;
  bs_lower      = 02;

Type
  TTitleStr=String[80];

  Pview = ^TView;
  Pgroup = ^TGroup;

  TView = Object(TObject)
    Prev,Next : Pview;
    Owner     : Pgroup;
    Bound     : TRect;
    Clip      : TRect;
    Cursor    : TPoint;
    Options   : Word;
    Helpctx   : Word;
    State     : Word;
    Eventmask : Word;
    Dragmode  : Byte;
    Growmode  : Byte;
    Resizeflag: Byte;
    Constructor Init(Bounds : TRect);
    Function Nextview:Pview;
    Function Prevview:Pview;
    Function Mouseinview(Mouse: TPoint): Boolean;
    Function Exposed:Boolean;
    Function Valid(Command:Word):Boolean;Virtual;
    Function Focus:Boolean;
    Function Focused:Boolean;
    Function Mouseevent(Var Event: TEvent; Mask: Word): Boolean;
    Procedure Clearevent(Var Event:TEvent);
    Procedure Keyevent(Var Event: TEvent);
    Procedure Getextent(Var Extent: TRect);
    Procedure Makefirst;
    procedure Makeselect;
    Procedure MakeLocal(Source: TPoint; Var Dest: TPoint);
    Procedure MakeGlobal(Source: TPoint; Var Dest: TPoint);
    Procedure Resetcliprect;
    Procedure Show;
    Procedure Hide;
    Procedure Dragview(Event:TEvent);Virtual;
    Procedure Resizeview(Event:TEvent;MinSize:TPoint);Virtual;
    Procedure Changemousecursor;Virtual;
    Procedure ChangeBound(R:TRect);Virtual;
    Procedure Setstate(Astate: Word; Enable: Boolean); Virtual;
    Procedure Handleevent(Var Event:TEvent);Virtual;
    Procedure Unfocus;Virtual;
    Procedure Unfocusview;
    Procedure Draw;Virtual;
    Procedure Drawbackground(lower:boolean);Virtual;
    Procedure Drawview;
    Procedure Redraw(r:TRect);
    Destructor Done; Virtual;

    Procedure Setdrawport(R:TRect);
    Procedure PutPixel(Location : TPoint; Color : Word);
    Procedure Line(Coords : TRect);
    Procedure Rectangle(Rect : TRect);
    Procedure Bar(Rect : TRect);
    Procedure Bicolorrectangle(Rect : TRect; Light,Dark :Word;Down:Boolean);
    Procedure Bicolorline(Rect : TRect; Light,Dark :Word;Down:Boolean);

    Procedure Arc (Center:TPoint; Stangle, Endangle, Radius: Word);
    Procedure Circle(Center:TPoint;Radius:Word);
    Procedure FillEllipse(Center : TPoint; Xradius,Yradius : Word);
    Procedure Writetext(S : String);
    Procedure Writetextxy(Point : TPoint; S : String);
    Procedure Writetextxy3D(Point : TPoint;Light,Dark:Word;S : String);
    Procedure Writectextxy(Point : TPoint; S : String);
    Procedure PutImage(Location : TPoint; Var Bitmap; BitBlt : Byte);
  End;

  TGroup=Object(TView)
    First  :Pview;
    Last   :Pview;
    Endstate:Word;
    Constructor Init(Bounds:TRect);
    Procedure Foreach(P:Pointer);
    Function Firstthat(P:Pointer):Pview;
    Function Lastthat(P:Pointer):Pview;
    Procedure Delete(P:Pview);
    Procedure Selectnext(Forwards:Boolean);
    Procedure ChangeBound(R:TRect);Virtual;
    Procedure Setstate(Astate:Word;Enable:Boolean);Virtual;
    Procedure Handleevent(Var Event:TEvent);Virtual;
    Procedure Unfocus;Virtual;
    Procedure Draw;Virtual;
    Procedure Insert(P: Pview);Virtual;
    Function Run:Word;
    Destructor Done;Virtual;
    Private
    Function Findnext(p:pview;forwards:boolean):pview;
    Procedure Drawsubviews;
  End;

  Pbackground=^TBackground;
  TBackground=Object(TView)
    Style:Byte;
    Color,Backcolor:Word;
    Flag:Word;
    Constructor Init(R:TRect;Astyle,Acolor,Abackcolor,Aflag:Word);
    Procedure Draw;Virtual;
  End;

  Pspace=^Tspace;
  Tspace=Object(TGroup)
    Procedure Draw;Virtual;
    procedure handleevent(Var event:Tevent);virtual;
  End;

  Pwindow=^TWindow;
  TWindow=Object(TGroup)
    Flags:Byte;
    Minmaxrect:TRect;
    Title:PString;
    Titlebar:Pview;
    Space:Pgroup;
    Constructor Init(R:TRect;Atitle:TTitleStr;Aflags:Word);
    Procedure Close;
    Procedure InitClient;Virtual;
    Procedure Insert(P: Pview);Virtual;
    Procedure Draw;Virtual;
    Procedure Zoom;
    Procedure Changemousecursor;Virtual;
    Procedure Setstate(Astate:Word;Enable:Boolean);Virtual;
    Procedure Handleevent(Var Event:TEvent);Virtual;
    Destructor Done;Virtual;
    Private
    Menubutton,Closebutton,Maxbutton,Minbutton:Pview;
    Oldgrowflag:Byte;
  End;

Procedure Message(Receiver: Pview; What, Command: Word;Infoptr: Pointer);

Var
  Lockdraw:Byte;
  Lockmousecursor:Byte;
  Mouseowner:Pview;

Implementation

Uses Cyapp,Cybutton;

{**********************************TVIEW*************************************}

Procedure Message(Receiver: Pview; What, Command: Word;Infoptr: Pointer);
Var
  Event: TEvent;

Begin
  If Receiver <> Nil Then
  Begin
    Event.What := What;
    Event.Command := Command;
    Event.Infoptr := Infoptr;
    Receiver^.Handleevent(Event);
  End;
End;

Constructor TView.Init(Bounds:TRect);
Begin
  Inherited Init;
  Eventmask := evMouseDown + evKeyDown + evCommand;
  State := sfVisible;
  resizeflag:=rzany;
  With Bound Do
  Begin
    Copy(Bounds);
    If B.X < A.X Then SwapWord(A.X,B.X);
    If B.Y < A.Y Then SwapWord(A.Y,B.Y);
  End;
End;

Function TView.Nextview:Pview;
Begin
  If Assigned(Next) Then Nextview:=Next Else Nextview:=Owner^.First;
End;

Function TView.Prevview:Pview;
Begin
  If Assigned(Prev) Then Prevview:=Prev Else Prevview:=Owner^.Last;
End;

Function TView.Mouseinview(Mouse: TPoint): Boolean;
Var
  Extent: TRect;
Begin
  MakeLocal(Mouse, Mouse);
  Getextent(Extent);
  Mouseinview := Extent.Contains(Mouse);
End;

Procedure TView.Getextent(Var Extent: TRect);Assembler;
Asm
  Push    DS
  LDS     SI,Self
  Add     SI,Offset TView.Bound
  LES     DI,Extent
  Cld
  XOr     AX,AX
  StosW
  StosW
  Lodsw
  Mov CX,AX
  Lodsw
  Mov DX,AX
  Lodsw
  Sub AX,CX {dikurangin bound.a.x}
  StosW
  Lodsw
  Sub AX,DX {dikurangin bound.a.y}
  StosW
  Pop     DS
End;

Procedure TView.MakeGlobal(Source: TPoint; Var Dest: TPoint); Assembler;
Asm
  LES     DI,Self
  XOr     AX,AX
  Mov     DX,AX
  @@1:    Add     AX,ES:[DI].TView.Bound.A.X
  Add     DX,ES:[DI].TView.Bound.A.Y
  LES     DI,ES:[DI].TView.Owner
  Mov     SI,ES
  Or      SI,DI
  Jne     @@1
  Add     AX,Source.X
  Add     DX,Source.Y
  LES     DI,Dest
  Cld
  StosW
  Xchg    AX,DX
  StosW
End;

Procedure TView.MakeLocal(Source: TPoint; Var Dest: TPoint); Assembler;
Asm
  LES     DI,Self
  XOr     AX,AX
  Mov     DX,AX
  @@1:    Add     AX,ES:[DI].TView.Bound.A.X
  Add     DX,ES:[DI].TView.Bound.A.Y
  LES     DI,ES:[DI].TView.Owner
  Mov     SI,ES
  Or      SI,DI
  Jne     @@1
  Neg     AX
  Neg     DX
  Add     AX,Source.X
  Add     DX,Source.Y
  LES     DI,Dest
  Cld
  StosW
  Xchg    AX,DX
  StosW
End;

Procedure TView.Drawbackground(lower:boolean);
Var
  R:TRect;

Begin
  SetLineStyle(SolidLn);
  Getextent(R);
  Bicolorrectangle(R,Colors[1],Colors[2],lower);
  R.Grow(-1,-1);
  SetFillStyle(solidFill,Colors[0],0);
  Bar(R);
End;

Procedure TView.Changemousecursor;
Begin
  If (Owner <> Nil) And (Mouseowner <> @Self) Then
  Begin
    SetMouseShape(Arrowbeam);
    Mouseowner:=@Self;
  End;
End;

procedure tview.ChangeBound(r:trect);
label godraw;
var
 old:trect;
 d:tpoint;

begin
 d.x:=(r.b.x-r.a.x)-(bound.b.x-bound.a.x);
 d.y:=(r.b.y-r.a.y)-(bound.b.y-bound.a.y);
 inc(d.x,d.y);
 if (state and sfmaximized <> 0)
 or ((r.a.x <= bound.a.x) and (r.a.y <= bound.a.y) and (r.b.x >= bound.b.x) and (r.b.y >= bound.b.y))
 then
 begin
  bound.copy(R);
  drawview;
 end else
 begin
 if d.x=0 then setstate(sfnodraw,true);
 old.copy(bound);
 bound.copy(r);
 if owner <> nil then with owner^ do
  begin
   setstate(sfredraw,true);
   old.intersect(clip);
   clip.intersect(old);
   with bound do clip.move(a.x,a.y);
   drawview;
   setstate(sfredraw,false);
  end;
 if d.x=0 then
  begin
   setstate(sfnodraw,false);
   drawview;
  end;
 end;
end;

Procedure TView.Unfocus;
Begin
End;

Procedure TView.Unfocusview;
Begin
  Resetcliprect;
  If Exposed And (Not Clip.Empty) Then
  Begin
    HideMouse;
    Setdrawport(Clip);
    Unfocus;
    ShowMouse;
  End;
End;

Procedure TView.Draw;Assembler;
Asm
End;

Procedure TView.Drawview;
Begin
  Resetcliprect;
  If Exposed And (Not Clip.Empty) Then
  Begin
    HideMouse;
    Setdrawport(Clip);
    Draw;
    ShowMouse;
  End;
End;

Procedure Tview.Redraw(R:Trect);
begin
 r.move(bound.a.x,bound.a.y);
 if owner <> nil then with owner^ do
 begin
  setstate(sfredraw,true);
  clip.intersect(r);
  with bound do clip.move(a.x,a.y);
  drawview;
  setstate(sfredraw,false);
 end;
end;

Procedure TView.Resetcliprect;
Begin
  With Clip Do
  Begin
    If (State And Sfredraw = 0) Then Copy(Bound);
    If Owner <> Nil Then Intersect(Owner^.Clip);
  End;
  With Bound Do Clip.Move(-A.X,-A.Y);
End;

Destructor TView.Done;
Begin
  If Assigned(Owner) Then
  Begin
    Hide;
    Owner^.Delete(@Self);
  End;
  Inherited Done;
End;

Procedure TView.Setdrawport(R:TRect);
Begin
  With R Do
  Begin
    MakeGlobal(A,A);
    MakeGlobal(B,B);
    SetViewPort(A.X,A.Y,B.X,B.Y);
  End;
End;

Procedure TView.Setstate(Astate:Word;Enable:Boolean);
var
 oldstate:word;
 r:trect;

Begin
oldstate:=state;
if Enable then State := State or AState else State := State and not AState;
case astate of
 sfvisible:if enable then drawview else
 begin
  getextent(r);
  redraw(r);
 end;
 sfredraw:if not enable then resetcliprect;
end;
End;

Procedure TView.Makefirst;
Var
  Mine:Pview;

Begin
  Mine:=Pview(@Self);
  With Mine^ Do
  Begin
    If Mine=Owner^.Last Then Owner^.Last:=Prev;
    If Prev <> Nil Then Prev^.Next:=Next;
    If Next <> Nil Then Next^.Prev:=Prev;
    Next:=Owner^.First;
    Owner^.First^.Prev:=@Self;
    Owner^.First:=@Self;
    Prev:=Nil;
  End;
End;

procedure tview.makeselect;
{susah juga, gelo euy ! Algoritmanya lumayan ! 20/4/1997}
Var
  Mine:Pview;

Begin
  Mine:=Pview(@Self);
  if mine <> owner^.first then With Mine^ Do
  Begin
     owner^.first^.prev:=owner^.last;
     owner^.last^.next:=owner^.first;
     prev^.next:=nil;
     owner^.last:=prev;
     prev:=nil;
     owner^.first:=mine;
  End;
End;

Procedure TView.Show;
Begin
 Setstate(sfVisible,TRUE);
End;

Procedure TView.Hide;
Begin
 Setstate(sfVisible,FALSE);
End;

Procedure TView.PutPixel(Location : TPoint; Color :Word);
Begin
  With Location Do
  Begin
    Dec(X,Clip.A.X);
    Dec(Y,Clip.A.Y);
    CyGraph.PutPixel(X,Y,Color);
  End;
End;

Procedure TView.Line(Coords : TRect);
Begin
  With Clip Do Coords.Move(-A.X,-A.Y);
  With Coords Do CyGraph.Line(A.X,A.Y,B.X,B.Y);
End;

Procedure TView.Rectangle(Rect : TRect);
Begin
  With Clip Do Rect.Move(-A.X,-A.Y);
  With Rect Do CyGraph.Rectangle(A.X,A.Y,B.X,B.Y);
End;

Procedure TView.Bar(Rect : TRect);
Begin
  With Clip Do Rect.Move(-A.X,-A.Y);
  With Rect Do CyGraph.Bar(A.X,A.Y,B.X,B.Y);
End;

Procedure TView.Bicolorline(Rect : TRect; Light,Dark :Word;Down:Boolean);
Begin
  With Clip Do Rect.Move(-A.X,-A.Y);
  If Down Then SwapWord(Light,Dark);
  With Rect Do
  Begin
    SetColor(Light);
    CyGraph.Line(A.X,A.Y,B.X,A.Y);
    Move(1,0);
    SetColor(Dark);
    CyGraph.Line(A.X,A.Y,B.X,A.Y);
  End;
End;

Procedure TView.Bicolorrectangle(Rect:TRect;Light,Dark:Word;Down:Boolean);
Begin
  With Clip Do Rect.Move(-A.X,-A.Y);
  If Down Then SwapWord(Light,Dark);
  With Rect Do
  Begin
    SetColor(Light);
    CyGraph.Line(A.X,A.Y,B.X-1,A.Y);
    CyGraph.Line(A.X,A.Y,A.X,B.Y-1);
    SetColor(Dark);
    CyGraph.Line(B.X,A.Y,B.X,B.Y);
    CyGraph.Line(A.X,B.Y,B.X-1,B.Y);
  End;
End;

Procedure TView.PutImage(Location : TPoint; Var Bitmap; BitBlt : Byte);
Begin
  SetWriteMode(BitBlt);
  CyGraph.PutImage(Location.X,Location.Y,Bitmap);
End;

Procedure TView.Writetext(S : String);
Begin
  OutText(S);
End;

Procedure TView.Writetextxy(Point : TPoint; S : String);
Begin
 With Clip.A Do
  Begin
    Dec(Point.X,X);
    Dec(Point.Y,Y);
  End;
  With Point Do OutTextXY(X,Y,s);
End;

Procedure TView.Writetextxy3D(Point : TPoint;Light,Dark:Word;S : String);
var
 c:word;

Begin
  With Clip.A Do
  Begin
    Dec(Point.X,X);
    Dec(Point.Y,Y);
  End;
  With Point Do
  Begin
{   Inc(X,Dif);
    Inc(Y,Dif);
    SetColor(Dark);
    OutTextXY(X,Y,S);
    Dec(X,Dif);
    Dec(Y,Dif);
    SetColor(Light);
    OutTextXY(X,Y,S);}
  c:=getcolor;
  setcolor(light);
  outtextxy(x-1,y-1,s);
  setcolor(dark);
  outtextxy(x+1,y+1,s);
  setcolor(c);
  outtextxy(x,y,s);
  End;
End;

Procedure TView.Writectextxy(Point : TPoint; S : String);
var
 b,l:byte;

Begin
 With Clip.A Do
  Begin
    Dec(Point.X,X);
    Dec(Point.Y,Y);
  End;
  With Point Do
  begin
   s:=normalstr(s,b);
   OutTextXY(X,Y,s);
   if b <> 0 then
   begin
    inc(y,2);
    case textsettings.horiz of
     lefttext:x:=b*textwidth;
     centertext:begin
                 l:=length(s);
                 x:=x-(((l+1) shr 1)-b)*textwidth;
                 if not odd(l) then dec(x,textwidth shr 1);
                end;
     righttext:x:=x-((length(s)-b-2)*textwidth);
    end;
    outtextxy(x,y,'_');
   end;
  end;
End;

Procedure TView.FillEllipse(Center : TPoint; Xradius,Yradius : Word);
Begin
  CyGraph.FillEllipse(Center.X,Center.Y,Xradius,Yradius);
End;

Procedure TView.Arc(Center:TPoint; Stangle, Endangle, Radius: Word);
Begin
  With Clip.A Do
  Begin
    Dec(Center.X,X);
    Dec(Center.Y,Y);
  End;
  With Center Do CyGraph.Arc(X,Y,Stangle,Endangle,Radius);
End;

Procedure TView.Circle(Center : TPoint; Radius : Word);
Begin
  With Clip.A Do
  Begin
    Dec(Center.X,X);
    Dec(Center.Y,Y);
  End;
  With Center Do CyGraph.Circle(X,Y,Radius);
End;

Function TView.Focus:Boolean;
Var
  Me:Pview;
  r:trect;

Begin
  Focus:=TRUE;
  Me:=Pview(@Self);
  If (Owner <> Nil) And not focused Then
  Begin
    focus:=Owner^.Focus;
    With Me^ Do
    Begin
      if options and oftopselect <> 0 then
      begin
       Makefirst;
       If Next <> Nil Then Next^.Unfocusview;
      end else
      begin
       owner^.first^.unfocusview;
       makeselect;
      end;
      drawview;
    End;
    Focus:=FALSE;
  End;
End;

Function TView.Focused:Boolean;
Begin
  Focused:=TRUE;
  If Owner <> Nil Then Focused:=(Owner^.First=@Self);
End;

Function TView.Exposed:Boolean;
Var
  P:Pview;
  Inside:Boolean;
  Test,R:TRect;

Begin
  Inside:=FALSE;
  If (State And sfVisible = 0) Or (state and sfnodraw <> 0) or (Lockdraw <> 0) Then
  Begin
    Exposed:=FALSE;
    Exit;
  End;
  R.Copy(Clip);
  With Bound Do R.Move(A.X,A.Y);
  P:=Prev;
  While (P <> Nil) And (Not Inside) Do
  Begin
    P^.Resetcliprect;
    Test.Copy(P^.Clip);
    With P^.Bound Do Test.Move(A.X,A.Y);
    Inside:=(p^.state and sfvisible <> 0) and (Test.A.X <= R.A.X) And (Test.A.Y <= R.A.Y) And
    (Test.B.X >= R.B.X) And (Test.B.Y >= R.B.Y);
    P:=P^.Prev;
  End;
  If Owner <> Nil Then Exposed:=(Not Inside) And Owner^.Exposed Else
   Exposed:=Not Inside;
End;

Function TView.Valid(Command:Word):Boolean;
Begin
  Valid:=TRUE;
End;

Function TView.Mouseevent(Var Event: TEvent; Mask: Word): Boolean;
Begin
  Repeat
    Desktop^.Getevent(Event)
  Until Event.What And (Mask Or evMouseUp) <> 0;
  Mouseevent := Event.What <> evMouseUp;
End;

Procedure TView.Clearevent(Var Event:TEvent);
Begin
  Event.What:=evNothing;
  Event.Infoptr:=@Self;
End;

Procedure TView.Keyevent(Var Event: TEvent);
Begin
  Repeat Desktop^.Getevent(Event) Until Event.What = evKeyDown;
End;

Procedure TView.Resizeview(Event:TEvent;MinSize:TPoint);
function Min(I, J: Integer): Integer;
begin
  if I < J then Min := I else Min := J;
end;

function Max(I, J: Integer): Integer;
begin
  if I > J then Max := I else Max := J;
end;

Label Nouse;
Var
  R,temp:TRect;
  Old:TPoint;
  D:TPoint;
  Dr:TPoint;

Begin
  If State And sfMaximized=0 Then
  Begin
    Inc(Lockmousecursor);
    R.Copy(Bound);
    With Owner^ Do
    Begin
      Resetcliprect;
      Setdrawport(Clip);
    End;
    SetColor(Colors[7]);
    SetLineStyle(SolidLn);
    Old:=Event.Where;
    SetWriteMode(XORPut);
    Owner^.Rectangle(R);
    Repeat
      D.Y:=Event.Where.Y-Old.Y;
      D.X:=Event.Where.X-Old.X;
      Dr.X:=R.B.X-R.A.X;
      Dr.Y:=R.B.Y-R.A.Y;
      HideMouse;
      SetWriteMode(XORPut);
      Owner^.Rectangle(R);
      Case Resizeflag Of
        rzupper:If (D.Y > 0) And (Dr.Y < Minsize.Y) Then Goto Nouse Else Inc(R.A.Y,D.Y);
        rzlower:If (D.Y < 0) And (Dr.Y < Minsize.Y) Then Goto Nouse Else Inc(R.B.Y,D.Y);
        rzleft :If (D.X > 0) And (Dr.X < Minsize.X) Then Goto Nouse Else Inc(R.A.X,D.X);
        rzright:If (D.X < 0) And (Dr.X < Minsize.X) Then Goto Nouse Else Inc(R.B.X,D.X);
        5:Begin
          if ((event.where.x>r.a.x) and (d.x > 0)) or
             ((event.where.x<r.a.x) and (d.x < 0)) then
          r.a.x:=min((r.a.x+d.x),minsize.x);
          if ((event.where.y>r.a.y) and (d.y > 0)) or
             ((event.where.y<r.a.y) and (d.y < 0)) then
          r.a.y:=min((r.a.y+d.y),minsize.y);
        End;
        6:Begin
          if ((event.where.x>r.b.x) and (d.x > 0)) or
             ((event.where.x<r.b.x) and (d.x < 0)) then
          r.b.x:=max((r.b.x+d.x),minsize.x);
          if ((event.where.y>r.b.y) and (d.y > 0)) or
             ((event.where.y<r.b.y) and (d.y < 0)) then
          r.b.y:=max((r.b.y+d.y),minsize.y);
        End;
        7:Begin
          r.b.x:=max((r.b.x+d.x),minsize.x);
          if ((event.where.y>r.a.y) and (d.y > 0)) or
              (event.where.y<r.a.y) and (d.y < 0) then
          r.a.y:=min((r.a.y+d.y),minsize.y);
         End;
        8:Begin
          if ((event.where.x>r.a.x) and (d.x > 0)) or
              (event.where.x<r.a.x) and (d.x < 0) then
          r.a.x:=min((r.a.x+d.x),minsize.x);
          if ((event.where.y>r.b.y) and (d.y > 0)) or
             ((event.where.y<r.b.y) and (d.y < 0)) then
          r.b.y:=max((r.b.y+d.y),minsize.y);
        End;
      End;
      Old:=Event.Where;
      Nouse:
      Owner^.Rectangle(R);
      ShowMouse;
    Until Not Mouseevent(Event,evMouseMove);
    If Not Bound.Equals(R) Then ChangeBound(r) Else
    Begin
      SetWriteMode(XORPut);
      Owner^.Rectangle(R);
    End;
    Dec(Lockmousecursor);
  End;
  resizeflag:=rzany;
End;

Procedure TView.Dragview(Event:TEvent);
Var
  R:TRect;
  Old:TPoint;

Begin
  If State And sfMaximized=0 Then
  Begin
    Inc(Lockmousecursor);
    R.Copy(Bound);
    With Owner^ Do
    Begin
      Resetcliprect;
      Setdrawport(Clip);
    End;
    SetColor(Colors[7]);
    SetLineStyle(SolidLn);
    Old:=Event.Where;
    SetWriteMode(XORPut);
    Owner^.Rectangle(R);
    Repeat
      HideMouse;
      SetWriteMode(XORPut);
      Owner^.Rectangle(R);
      R.Move(Event.Where.X-Old.X,Event.Where.Y-Old.Y);
      Old:=Event.Where;
      Owner^.Rectangle(R);
      ShowMouse;
    Until Not Mouseevent(Event,evMouseMove);
    If Not Bound.Equals(R) Then ChangeBound(R) Else
    Begin
      HideMouse;
      SetWriteMode(XORPut);
      Owner^.Rectangle(R);
      ShowMouse;
    End;
    Dec(Lockmousecursor);
  End;
End;

Procedure TView.Handleevent(Var Event:TEvent);
Begin
  If Mouseinview(Event.Where) Then
    Case Event.What Of
      evMouseDown:
      If (State And (sfMinimized + sfDisabled) = 0) And
         (Options And Offocusable <> 0) And (Not Focus) Then Clearevent(Event);
    End;
End;

{*********************************TGROUP*************************************}
Constructor TGroup.Init(Bounds:TRect);
Begin
  Inherited Init(Bounds);
  Eventmask:=evMouse+evKeyboard+evMessage;
End;

Procedure TGroup.Insert(P:Pview);{masukin view-nya secara reversing order}
Begin
  If Assigned(P) Then
  Begin
    If First <> Nil Then
    Begin
      P^.Next:=First;
      First^.Prev:=P;
    End Else Last:=P;
    First:=P;
    With P^ Do
    Begin
      Owner:=@Self;
      If Next <> Nil Then Next^.Unfocusview;
      Drawview;
    End;
  End;
End;

Procedure TGroup.Unfocus;

Procedure Relfocus(P:Pview);Far;
Begin
  P^.Unfocusview;
End;

Begin
  Foreach(@Relfocus);
End;

Procedure TGroup.Draw;
Begin
  Drawsubviews;
End;

Procedure TGroup.Drawsubviews;
Var
  P:Pview;


Begin
  HideMouse;
  P:=Last;
  While (P <> Nil) Do With P^ Do
  Begin
    Drawview;
    P:=Prev;
  End;
  ShowMouse;
End;

Destructor TGroup.Done;
Var
  T,P:Pview;

Begin
  P:=First;
  Inc(Lockdraw);
  While P <> Nil Do
  Begin
    T:=P^.Next;
    P^.Free;
    P:=T;
  End;
  Dec(Lockdraw);
  First:=Nil;
  Last:=Nil;
  Inherited Done;
End;

Procedure TGroup.Foreach(P: Pointer); Assembler;
Asm
  LES DI,Self
  LES DI,ES:[DI].TGroup.First
  @Cari_View:
  Mov AX,ES
  Or AX,DI
  Jz @Noview
  Push ES
  Push DI

  Push ES
  Push DI
  Push Word Ptr [BP]
  Call P

  Pop DI
  Pop ES
  LES DI,ES:[DI].Next
  Jmp @Cari_View
  @Noview:
End;

Function TGroup.Firstthat(P: Pointer):Pview; Assembler;
Asm
  LES DI,Self
  LES DI,ES:[DI].TGroup.First
  @Cari_View:
  Mov AX,ES
  Or AX,DI
  Jnz @Notnil
  XOr AX,AX
  Mov DX,AX
  Jmp @Noview
  @Notnil:
  Push ES
  Push DI

  Push ES
  Push DI
  Push Word Ptr [BP]
  Call P

  Pop DI
  Pop ES
  Mov BX,AX
  Mov DX,ES
  Mov AX,DI
  LES DI,ES:[DI].Next
  Or BL,BL
  Jz @Cari_View
  @Noview:
End;

Function TGroup.Lastthat(P: Pointer):Pview; Assembler;
Asm
  LES DI,Self
  LES DI,ES:[DI].TGroup.Last
  @Cari_View:
  Mov AX,ES
  Or AX,DI
  Jnz @Notnil
  XOr AX,AX
  Mov DX,AX
  Jmp @Noview
  @Notnil:

  Push ES
  Push DI

  Push ES
  Push DI
  Push Word Ptr [BP]
  Call P

  Pop DI
  Pop ES
  Mov BX,AX
  Mov DX,ES
  Mov AX,DI
  LES DI,ES:[DI].Prev
  Or BL,BL
  Jz @Cari_View
  @Noview:
End;

Procedure TGroup.Selectnext(Forwards:Boolean);
var
 p:pview;

Begin
 p:=findnext(first,forwards);
 if p <> nil then p^.focus;
End;

Procedure TGroup.Delete(P:Pview);
Begin
  With P^ Do
  Begin
    If Next <> Nil Then Next^.Prev:=Prev;
    If Prev <> Nil Then Prev^.Next:=Next;
    if (p=first) and (p=last) then
    begin
     last:=nil;
     first:=nil;
    end else
    begin
    If P=First Then
    Begin
      First:=P^.Next;
      First^.Drawview;
    End;
    If P=Last Then Last:=P^.Prev;
    end;
  End;
End;

Function TGroup.Run:Word;
Var
  Event: TEvent;
Begin
  Repeat
    Endstate := 0;
    Repeat
      Desktop^.Getevent(Event);
      Handleevent(Event);
    Until Endstate <> 0;
  Until Valid(Endstate);
  Run:= Endstate;
End;

Procedure TGroup.ChangeBound(R:TRect);
Var
  Gp:TPoint;
  Temp:TRect;

Procedure Changerect(P:Pview);Far;
Begin
  if p^.growmode <> 0 then with p^ do
  Begin
    With Temp Do
    Begin
      Copy(Bound);
      If Growmode And gfGrowLoX <> 0 Then Dec(b.X,Gp.X);
      If Growmode And gfGrowLoY <> 0 Then Dec(b.Y,Gp.Y);
      If Growmode And gfGrowHiX <> 0 Then Inc(B.X,Gp.X);
      If Growmode And gfGrowHiY <> 0 Then Inc(B.Y,Gp.Y);
    End;
    ChangeBound(Temp);
  End;
End;

Begin
  Gp.X:=(R.B.X-R.A.X)-(Bound.B.X-Bound.A.X);
  Gp.Y:=(R.B.Y-R.A.Y)-(Bound.B.Y-Bound.A.Y);
  inc(lockdraw);
  If Gp.X+Gp.Y <> 0 Then Foreach(@Changerect);
  dec(lockdraw);
  Inherited ChangeBound(R);
End;

Function tgroup.Findnext(p:pview;forwards:boolean):pview;
var
 child:pview;

begin
 child:=p;
 repeat
  if forwards then child:=child^.prevview else child:=child^.nextview;
 until ((child^.options and offocusable <> 0) and (child^.state and sfdisabled=0)) or (child=p);
 if child=p then child:=nil;
 findnext:=child;
end;

Procedure TGroup.Setstate(Astate:Word;Enable:Boolean);

Procedure Dosetstate(P: Pview); Far;
Begin
  P^.Setstate(Astate, Enable);
End;

Begin
  Inherited Setstate(Astate,Enable);
  Case Astate Of
    Sfredraw:
    Begin
      Astate:=Sfrefresh;
      Foreach(@Dosetstate);
    End;
  End;
End;

Procedure TGroup.Handleevent(Var Event: TEvent);
Type
  Tphase=(Phfocused, Phpreprocess, Phpostprocess);

Var
  Phase:Tphase;
  Child:Pview;

Procedure Dohandleevent(P: Pview);Far;
Begin
  If (P <> Nil) Or ((P^.State And sfDisabled = 0)
       And (Event.What And (PositionalEvents Or FocusedEvents) = 0)) Then
  Begin
    Case Phase Of
      Phpreprocess: If P^.Options And ofPreProcess = 0 Then Exit;
      Phpostprocess: If P^.Options And ofPostProcess = 0 Then Exit;
    End;
    If (Event.What And P^.Eventmask) <> 0 Then P^.Handleevent(Event);
  End;
End;

Function Containsmouse(P: Pview): Boolean; Far;
Begin
  Containsmouse := (P^.State And sfVisible <> 0) And (P^.Mouseinview(Event.Where));
End;

Begin
  Inherited Handleevent(Event);
  If Event.What And FocusedEvents <> 0 Then
  Begin
    Phase := Phpreprocess;
    Foreach(@Dohandleevent);
    Phase := Phfocused;
    Dohandleevent(First);
    Phase := Phpostprocess;
    Foreach(@Dohandleevent);
  End Else
  Begin
    Phase := Phfocused;
    If (Event.What And PositionalEvents <> 0) Then
    Begin
      Child:=Firstthat(@Containsmouse);
      If (Event.What=evMouseMove) And Assigned(Child) And (Lockmousecursor=0) Then Child^.Changemousecursor;
      Dohandleevent(Child);
    End
    Else Foreach(@Dohandleevent);
  End;
End;

{*******************************Tbackground**********************************}
Constructor TBackground.Init(R:TRect;Astyle,Acolor,Abackcolor,Aflag:Word);
Begin
  Inherited Init(R);
  Eventmask:=evMouseMove;
  flag:=aflag;
  Style:=Astyle;
  Color:=Acolor;
  Backcolor:=Abackcolor;
End;

Procedure TBackground.Draw;
Var
  R:TRect;

Begin
  Inherited Draw;
  SetFillStyle(Style,Color,Backcolor);
  Getextent(R);
  Bar(R);
  if flag <> bs_normal then
  bicolorrectangle(r,colors[1],colors[2],flag=bs_lower);
End;

{*********************************TTitleBar***********************************}
Const
  Ca=5;
  Buttonsize=18;
  Addca=5;

Type
  Ptitlebar=^Ttitlebar;
  Ttitlebar=Object(TView)
    Procedure Changemousecursor;Virtual;
    Procedure Draw;Virtual;
    Procedure Unfocus;Virtual;
    Procedure Handleevent(Var Event:TEvent);Virtual;
  End;

Procedure Tspace.Draw;
Var
  R:TRect;

Begin
  Getextent(R);
  SetFillStyle(solidFill,Colors[0],0);
  Bar(R);
  Inherited Draw;
End;

procedure tspace.handleevent(var event:Tevent);
begin
inherited handleevent(event);
case event.what of
    evKeyDown:case Event.Keycode of
     kbtab     :Selectnext(true);
     kbShiftTab:Selectnext(false);
    end;
end;
end;

Procedure Ttitlebar.Changemousecursor;
Begin
  If (Owner^.Focused) And (Owner^.State And sfMaximized=0) And
     (Owner^.Options And ofMoveAble <> 0) And (Mouseowner <> @Self) Then
  Begin
    SetMouseShape(Movebeam);
    Mouseowner:=@Self;
  End;
End;

Procedure Ttitlebar.Unfocus;
Begin
  Draw;
End;

Procedure Ttitlebar.Draw;
Var
  R:TRect;
  S:String;
  Col:Word;
  T:TPoint;

Begin
  SetWriteMode(CopyPut);
  Col:=4;
  If Owner^.Focused Then Dec(Col);
  Col:=Colors[Col];
  SetFillStyle(SolidFill,Col,0);
  Getextent(R);
  r.grow(-1,-1);
  Bar(R);
  SelectFont(Fonts[0],0,0);
  SetTextJustify(Bottomtext,LeftText);
  Settextdirection(HorizDir);
  col:=6;
  if owner^.focused then dec(col);
  SetColor(Colors[col]);
  SetTextJustify(CenterText,CenterText);
  with r do
  begin
   grow(1,1);
   a.y:=b.y shr 1;
   a.x:=b.x shr 1;
  end;
  Writetextxy(R.A,Pwindow(Owner)^.Title^);
  getextent(R);
  Bicolorrectangle(R,Colors[1],Colors[2],FALSE);
End;

Procedure Ttitlebar.Handleevent(Var Event:TEvent);
Begin
  Inherited Handleevent(Event);
  Case Event.What Of evMouseDown:
  Begin
    If (Event.Buttons=mbLeftButton) Then
    Begin
      If Event.Double Then Message(Owner,evCommand,Cmmaximize,Nil) Else
        Owner^.Dragview(Event);
    End;
  End;
  End;
End;

{*********************************TWINDOW*************************************}
Procedure Drawclose(P:Pdrawbutton);Far;
Var
  R:TRect;
  I:Byte;


Begin
  With P^ Do
  Begin
    I:=0;
    SetWriteMode(CopyPut);
    Getextent(R);
    R.Grow(-5,-5);
    SetColor(Colors[2]);
    Line(R);
    With R Do Assign(A.X,B.Y,B.X,A.Y);
    Line(R);
  End;
End;

Procedure Drawmenu(P:Pdrawbutton);Far;
Var
  T:TPoint;
  R:TRect;
Begin
  With P^ Do
  Begin
    Getextent(R);
    SetWriteMode(CopyPut);
{    SetColor(Colors[0]);
    Rectangle(R);}
    SetColor(Colors[1]);
    With R Do
    Begin
      T.X:=B.X ShR 1-A.X;
      T.Y:=B.Y ShR 1-A.Y;
    End;
    If Down Then SwapWord(Colors[1],Colors[2]);
    SetColor(Colors[1]);
    Arc(T,40,260,(Buttonsize-1) ShR 1);
    SetColor(Colors[2]);
    Arc(T,225,50+360,(Buttonsize-1) ShR 1);
    If Down Then SwapWord(Colors[1],Colors[2]);
  End;
End;

Procedure Drawmin(P:Pdrawbutton);Far;
Var
  R:TRect;

Begin
  With P^ Do
  Begin
    Getextent(R);
    R.Grow(-8,-8);
    R.Move(1,1);
    SetColor(Colors[2]);
    Rectangle(R);
    R.Move(-1,-1);
    SetColor(Colors[1]);
    Rectangle(R);
  End;
End;

Procedure Drawmax(P:Pdrawbutton);Far;
Var
  R:TRect;
Begin
  With P^ Do
  Begin
    Getextent(R);
    If Owner^.State And sfMaximized <> 0 Then R.Grow(-2,-3);
    R.Grow(-3,-3);
    R.Move(1,1);
    SetColor(Colors[2]);
    Rectangle(R);
    SetColor(Colors[1]);
    R.Move(-2,-2);
    Rectangle(R);
  End;
End;

Constructor TWindow.Init(R:TRect;Atitle:TTitleStr;Aflags:Word);
Var
  Xs:Byte;

Begin
  Inherited Init(R);
  Options := Options Or Offocusable;
  Minmaxrect.Copy(R);
  Flags:=Aflags;
  Title:=NewStr(Atitle);
  Oldgrowflag:=0;
  options:=options or oftopselect;
  Xs:=0;
  If Aflags And Wfresize <> 0 Then Options:=Options Or ofResizeAble;
  If Aflags And wfMove <> 0 Then Options:=Options Or ofMoveAble;
  If Aflags And Wfcaption <> 0 Then
  Begin
    R.Assign(succ(Ca),Ca,succ(Ca+Buttonsize),Ca+Buttonsize);
    If Flags And Wfmenu <> 0 Then
    Begin
      Menubutton:=New(Pdrawbutton,Init(R,Cmminimize,bfNoFocus,Drawmenu));
      Inc(Xs,Succ(Buttonsize));
      R.Move(Succ(Buttonsize),0);
    End;
    If Flags And Wfminimize <> 0 Then
    Begin
      Minbutton:=New(Pdrawbutton,Init(R,Cmminimize,bfNoFocus,Drawmin));
      Inc(Xs,Succ(Buttonsize));
      R.Move(Succ(Buttonsize),0);
    End;
    If Flags And Wfmaximize <> 0 Then
    Begin
      Maxbutton:=New(Pdrawbutton,Init(R,Cmmaximize,bfNoFocus,Drawmax));
      Inc(Xs,Succ(Buttonsize));
      R.Move(Succ(Buttonsize),0);
    End;
    If Flags And wfClose <> 0 Then
    Begin
      Closebutton:=New(Pdrawbutton,Init(R,Cmclose,bfNoFocus,Drawclose));
      Inc(Xs,Succ(Buttonsize));
    End;
    TGroup.Insert(Menubutton);
    TGroup.Insert(Minbutton);
    TGroup.Insert(Maxbutton);
    TGroup.Insert(Closebutton);
    Getextent(R);
    With R Do Assign(Succ(Xs+Ca),Ca,B.X-Ca-1,Ca+Buttonsize);
    Titlebar:=New(Ptitlebar,Init(R));
    Inc(Titlebar^.Eventmask,evMouseMove);
    Titlebar^.Growmode:=gfGrowHiX;
    TGroup.Insert(Titlebar);
  End;
  InitClient;
End;

Procedure TWindow.InitClient;
Var
  R:TRect;
Begin
  Getextent(R);
  If Flags And Wfcaption <> 0 Then With R Do Assign(Ca,Addca+Ca+Buttonsize+1,B.X-Ca,B.Y-Ca);
  R.Grow(-1,-1);
  Space:=New(Pspace,Init(R));
  Space^.Growmode:=gfGrowRel;
  TGroup.Insert(Space);
End;

Procedure TWindow.Insert(P: Pview);
Begin
  Space^.Insert(P);
End;

procedure twindow.zoom;
begin
 swapbyte(oldgrowflag,growmode);
 setstate(sfmaximized,state and sfmaximized=0);
 if state and sfmaximized<>0 then growmode:=gfgrowrel;
end;

Procedure TWindow.Draw;
Var
  R:TRect;
  s:tpoint;
Begin
{  If (State And Sfrefresh <> 0) Or Focused Then
  Begin}
    setwritemode(copyput);
    setlinestyle(solidln);
    If (Flags And Wfcaption) <> 0 Then
    Begin
      getextent(R);
      s:=r.b;
      setfillstyle(solidfill,colors[0],0);
      r.assign(0,0,r.b.x,ca+succ(buttonsize)+addca);
      bar(r);
      Getextent(R);
      r.assign(0,ca,ca,r.b.y);
      bar(r);
      r.move(s.x-ca,0);
      bar(r);
      getextent(R);
      r.assign(ca,r.b.y-ca,r.b.x-ca,r.b.y);
      bar(r);
      getextent(R);
      R.Grow(-Pred(Ca),-Pred(Ca));
      Inc(R.A.Y,Succ(Buttonsize)+Addca);
      R.Grow(-1,-1);
      If Flags And Wfframed <> 0 Then Bicolorrectangle(R,Colors[1],Colors[2],TRUE);
      Getextent(R);
      R.Assign(Ca,Pred(Ca),R.B.X-Ca,Ca+Buttonsize+1);
      If Flags And Wfcaption <> 0 Then
        Bicolorrectangle(R,Colors[2],Colors[1],FALSE);
    End;
    getextent(r);
    bicolorrectangle(r,colors[1],colors[2],false);
{  End;}
  Inherited Draw;
End;

Procedure twindow.Setstate(astate:word;enable:boolean);
var
 temp:trect;

begin
 inherited setstate(astate,enable);
 case astate of
  sfmaximized:begin
              if enable then
               begin
                minmaxrect.copy(bound);
                owner^.getextent(temp);
                temp.grow(+1,+1);
                ChangeBound(temp);
               end else
               begin
                temp.copy(minmaxrect);
                ChangeBound(temp);
               end;
              end;
 end;
end;

Procedure TWindow.Changemousecursor;
Var
  Mouse:TPoint;
  R:TRect;
  R1,R2,R3,R4,R5,R6,R7,R8:TRect;
  Aresizeflag,X:Byte;

Begin
  If Focused And (State And sfMaximized=0) And (Options And ofResizeAble <> 0) Then
  Begin
    MakeLocal(MouseWhere,Mouse);
    Getextent(R);
    Aresizeflag:=0;
    With R Do
    Begin
      R1.Assign(0+Ca,0,B.X-Ca,Ca);
      R2.Assign(0+Ca,B.Y-Ca,B.X-Ca,B.Y);
      R3.Assign(0,Ca,Ca,B.Y-Ca);
      R4.Assign(B.X-Ca,Ca,B.X,B.Y-Ca);
      R5.Assign(0,0,Ca,Ca);                 {kiri atas}
      R6.Assign(B.X-Ca,B.Y-Ca,B.X,B.Y);     {kanan bawah}
      R7.Assign(B.X-Ca,0,B.X,Ca);           {kanan atas}
      R8.Assign(0,B.Y-Ca,Ca,B.Y);           {kiri bawah}
    End;
    If R1.Contains(Mouse) Then Aresizeflag:=1 Else
      If R2.Contains(Mouse) Then Aresizeflag:=2 Else
        If R3.Contains(Mouse) Then Aresizeflag:=3 Else
          If R4.Contains(Mouse) Then Aresizeflag:=4 Else
            If R5.Contains(Mouse) Then Aresizeflag:=5 Else
              If R6.Contains(Mouse) Then Aresizeflag:=6 Else
                If R7.Contains(Mouse) Then Aresizeflag:=7 Else
                  If R8.Contains(Mouse) Then Aresizeflag:=8;
    Case Aresizeflag Of
      0  :X:=Arrowbeam;
      1,2:X:=Resizevertbeam;
      3,4:X:=Resizehorizbeam;
      5,6:X:=Resizediagforwardbeam;
      7,8:X:=Resizediagbackbeam;
    End;
    Resizeflag:=Aresizeflag;
    Cydriver.SetMouseShape(X);
    Mouseowner:=@Self;
  End Else Inherited Changemousecursor;
End;

Procedure TWindow.Close;
Begin
  If Valid(Cmclose) Then Free;
End;

Const
  MinWinSize:TPoint=(X:175;Y:175);

Procedure TWindow.Handleevent(Var Event:TEvent);
Begin
  Case Event.What Of
    evMouseDown:
    If (Resizeflag In[1..8]) And Focused Then
    Begin
      Resizeview(Event,MinWinSize);
      Clearevent(Event);
    End;
    evCommand:
    Case Event.Command Of
      Cmclose:Begin
        Close;
        Clearevent(Event);
      End;
      Cmmaximize:Begin
        Zoom;
        Clearevent(Event);
      End;
    End;
  End;
  Inherited Handleevent(Event);
End;

Destructor TWindow.Done;
Begin
  DisposeStr(Title);
  Inherited Done;
End;

End.
