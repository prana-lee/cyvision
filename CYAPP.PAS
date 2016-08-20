unit Cyapp;

Interface
{$I FLAGS}
Uses objects,CySystem,CyGraph,Cydriver,Cyviews;

Type
  Pdesktop=^TDesktop;
  TDesktop=Object(TGroup)
   background:pbackground;
    Constructor Init(Graphmode:Word;astyle:byte);
    procedure getevent(var event:tevent);virtual;
    procedure handleevent(var event:tevent);virtual;
    procedure idle;virtual;
    Destructor Done;Virtual;
  End;

procedure putevent(event:tevent);

var
 desktop:pdesktop;

Implementation

uses cyequ;

var
 pending:tevent;

procedure putevent(event:tevent);
begin
 pending:=event;
end;

Constructor tdesktop.Init(Graphmode:Word;astyle:Byte);
var
 r:trect;

begin
  InitSystem;
  InitGraph(Graphmode);
  if hicolor then move(hicolors,colors,sizeof(colors));
  InitEvents;
  desktop:=@self;
  owner:=nil;
  Bound.Assign(0,0,GetMaxX,GetMaxY);
  Inherited Init(Bound);
  state:=state or sfmaximized;
  resetcliprect;
  getextent(r);
  background:=new(pbackground,init(r,astyle,colors[8],colors[9],0));
  insert(background);
End;

procedure tdesktop.GetEvent(var Event: TEvent);
var
  R: TRect;

begin
  if Pending.What <> evNothing then
  begin
    Event := Pending;
    Pending.What := evNothing;
  end else
  begin
    GetMouseEvent(Event);
    if Event.What = evNothing then
    begin
      GetKeyEvent(Event);
      if Event.What = evNothing then Idle;
    end
  end;
end;

procedure tdesktop.handleevent(var event:tevent);
begin
 if (event.what=evkeydown) and (event.keycode=kbaltx) then endstate:=cmquit;
 inherited handleevent(event);
end;

procedure tdesktop.idle;assembler;
asm
end;

Destructor TDesktop.Done;
Begin
 inherited done;
 hidemouse;
 doneevents;
 restorecrtmode;
End;

End.