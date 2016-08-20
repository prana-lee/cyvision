unit cybutton;

{$I FLAGS}
interface

uses objects,cyequ,cyviews,cydriver;

const
  bfNormal      = $00;
  bfDefault     = $01;
  bfAuto        = $02;
  bfOneClick    = $04;
  bfBroadCast   = $08;
  bfleftjust    = $10;
  bfNoFocus     = $20;

  ar_up=cmuparrow;
  ar_down=cmdownarrow;
  ar_left=cmleftarrow;
  ar_right=cmrightarrow;

type
  Pbutton=^TButton;
  TButton=Object(TView)
    command:word;
    flags:byte;
    down:boolean;
    Constructor Init(R:TRect;ACommand:Word;Aflags:byte);
    procedure press;virtual;
    Procedure Draw;Virtual;
    Procedure Handleevent(Var Event:TEvent);Virtual;
  End;

  PDrawbutton=^TDrawButton;
  DrawButtonProc=procedure(p:pdrawbutton);
  TDrawButton=Object(TButton)
    DrawFunc:DrawButtonProc;
    Constructor Init(R:TRect;ACommand:Word;Aflags:byte;Adrawfunc:Drawbuttonproc);
    Procedure Draw;Virtual;
  End;

  Parrow=^Tarrow;
  Tarrow=Object(Tdrawbutton)
    direction:word;
    Constructor Init(Where:TPoint;Adirection:word);
    Procedure Handleevent(Var Event:TEvent);Virtual;
  End;


  PTextbutton=^TTextButton;
  TTextButton=Object(TButton)
    Title:pstring;
    presschar:word;
    Constructor Init(R:TRect;atitle:string;ACommand:Word;Aflags:byte);
    procedure unfocus;virtual;
    destructor done;virtual;
    Procedure Draw;Virtual;
    Procedure Handleevent(Var Event:TEvent);Virtual;
  End;

implementation

uses cysystem,cyapp,cygraph;

{*********************************TButton***********************************}
Constructor TButton.Init(R:TRect;ACommand:Word;Aflags:byte);
Begin
  Inherited Init(R);
  flags:=aflags;
  if aflags and bfnofocus = 0 then options:=options or offocusable;
  command:=acommand;
End;

Procedure TButton.Draw;
Var
  R:TRect;

Begin
  setwritemode(copyput);
  drawbackground(down);
End;

procedure tbutton.press;
var
  E: TEvent;
begin
 if Flags and bfBroadcast <> 0 then Message(Owner, evMessage, Command, @Self)
 else message(owner,evcommand,command,@self);
{  begin
    E.What := evCommand;
    E.Command := Command;
    E.InfoPtr := @Self;
    PutEvent(E);
  end;}
end;

const
 soundfreq=1200;
 soundend =2400;
 delaytime=1;

procedure tbutton.handleevent(var event:tevent);
var
 clickrect:trect;
 mouse:tpoint;
 prevdown:boolean;

begin
  if (event.what=evmousedown) and (event.buttons=mbleftbutton) and
     (state and sfdisabled=0) then
  begin
  if flags and bfnofocus = 0 then focus;
  sound(soundfreq);
  delay(delaytime);
  nosound;
  getextent(clickrect);
  if flags and bfoneclick = 0 then down:=false else prevdown:=down;
  repeat
   MakeLocal(Event.Where,Mouse);
   if Down <> ClickRect.Contains(Mouse) then
   begin
    if flags and bfoneclick = 0 then
    Down := not Down else down:=not prevdown;
    DrawView;
   end;
  if (Flags and bfAuto <> 0) and (Event.What =  evMouseAuto) then
  if Down then
   begin
    Press;
    down:=not down;
    DrawView;
   end;
   until not MouseEvent(Event, evMouseMove + evMouseAuto);
   sound(soundend);
   delay(delaytime);
   nosound;
   if Down then
   begin
    Press;
    if flags and bfoneclick <> 0 then down:=not prevdown else
    Down := false;
    DrawView;
   end;
   ClearEvent(Event);
 end;
end;

{*********************************TDrawButton*********************************}
constructor tdrawbutton.init(R:TRect;ACommand:Word;Aflags:byte;adrawfunc:drawbuttonproc);
begin
 inherited init(R,acommand,aflags);
 drawfunc:=adrawfunc;
end;

procedure tdrawbutton.draw;
begin
 inherited draw;
 drawfunc(@self);
end;

{*********************************TArrow**************************************}
Procedure DrawArrow(P:Pdrawbutton);Far;
Const
  Center=9;
  Center2=9-3;
  Center3=9+4;
  Center4=9+1;

  Tup: Array[1..4] Of PointType = (
    (X: Center-6; Y: Center2+6),
    (X: Center; Y:Center2),
    (X: Center+6; Y: Center2+6),
    (X: Center-6; Y:Center2+6));

  Tdown: Array[1..4] Of PointType = (
    (X: Center+6; Y:Center3-6),
    (X: Center  ; Y:Center3),
    (X: Center-6; Y:Center3-6),
    (X: Center+6; Y:Center3-6));

  Tright: Array[1..4] Of PointType = (
    (X: Center3-6; Y:Center4+6),
    (X: Center3  ; Y:Center4),
    (X: Center3-6; Y:Center4-6),
    (X: Center3-6; Y:Center4+6));

  Tleft: Array[1..4] Of PointType = (
    (X: Center2+6; Y:Center4-6),
    (X: Center2  ; Y:Center4),
    (X: Center2+6; Y:Center4+6),
    (X: Center2+6; Y:Center4-6));
    polysize=sizeof(tup);

Var
  I:Integer;
  T:Array[1..4] Of PointType;

Begin
case parrow(P)^.direction of
 ar_up   :Move(Tup,T,polysize);
 ar_down :Move(Tdown,T,polysize);
 ar_left :Move(Tleft,T,polysize);
 ar_right:Move(Tright,T,polysize);
 else writeln(parrow(p)^.direction);
end;
  SetColor(Colors[2]);
  For I:=1 To 4 Do
  Begin
  End;
  DrawPoly(4,T);
  For I:=1 To 4 Do
  Begin
    dec(T[I].Y,1);
    dec(T[i].x,1);
  End;
  SetColor(colors[1]);
  DrawPoly(4,T);
End;

Constructor tarrow.Init(Where:TPoint;Adirection:word);
var
 r:trect;

begin
with where do r.assign(x,y,x+18,y+18);
inherited init(R,adirection,bfnofocus,DrawArrow);
direction:=adirection;
end;

Procedure tarrow.Handleevent(Var Event:TEvent);
begin
 inherited handleevent(event);
end;

{*********************************TtextButton*********************************}
constructor ttextbutton.init(R:TRect;Atitle:string;aCommand:Word;Aflags:byte);
var
 b:Byte;

begin
 inherited init(R,acommand,aflags);
 options:=options or ofpreprocess;
 b:=pos('&',atitle);
 if b <> 0 then presschar:=getaltcode(atitle[b+1]) else presschar:=$FFFF;
 title:=newstr(atitle);
end;

destructor ttextbutton.done;
begin
 inherited done;
 disposestr(title);
end;

procedure ttextbutton.draw;
var
 r:trect;

begin
 inherited draw;
 getextent(R);
 r.grow(-3,-3);
 if focused then
  begin
   setlinestyle(closedottedln);
   setcolor(colors[10]);
   rectangle(r);
  end;
 setcolor(colors[11]);
 selectfont(fonts[1],0,0);
 r.grow(-1,1);
 getextent(R);
 r.a.y:=r.b.y shr 1;
 r.a.x:=r.b.x shr 1;
 settextjustify(centertext,centertext);
 writectextxy(r.a,title^);
end;

procedure  ttextbutton.unfocus;
var
 r:Trect;

begin
   getextent(R);
   setlinestyle(closedottedln);
   r.grow(-3,-3);
   setcolor(colors[0]);
   rectangle(r);
end;

procedure ttextbutton.handleevent(var event:tevent);
begin
inherited handleevent(event);
if (state and sfdisabled=0) and
(event.what=evkeydown) then
 begin
  if event.keycode=presschar then
  begin
   focus;
   sound(soundfreq);
   delay(delaytime);
   nosound;
   press;
   clearevent(event);
  end;
 end;
end;

end.