{$D-}
Uses Objects,Cytext,CySystem,Cydriver,CyGraph,Cyviews,Cyapp,Cybutton,Cyequ;

Type
  Tapp=Object(TDesktop)
    Procedure Handleevent(Var Event:TEvent);Virtual;
  End;

Var
  App:Tapp;
  A,B,C,D:Pwindow;
  R:TRect;
  P:Pview;
  Y:Byte;

Procedure Tapp.Handleevent;
Var
  P,Me:Pview;
  R1,R2:TRect;

Function Inside:Boolean;
Begin
  With R1 Do
    Inside:=(R2.A.X <= R1.A.X) And (R2.A.Y <= R1.A.Y) And
    (R2.B.X >= R1.B.X) And (R2.B.Y >= R1.B.Y);
End;

Begin
  Inherited Handleevent(Event);
  If Event.What = evKeyDown Then
  Begin
 {cobain Handleevent teu balek, euy !!!
  me:=last^.prev;
  p:=me^.prev;
  r1.copy(me^.clip);
  with me^.bound do r1.move(a.x,a.y);
  with me^.clip do writeln(a.x:4,a.y:4,b.x:4,b.y:4);
  while p <> nil do
   begin
    r2.copy(p^.clip);
    with p^.bound do r2.move(a.x,a.y);
    with r2 do writeln(a.x:4,a.y:4,b.x:4,b.y:4,inside);
    p:=p^.prev;
   end;}
  End;
End;

Var
  X:LongInt;

Begin
{You Can Change this one !!!!}
  App.Init(v640x480x64k,pyramidFill);
{You Can Change this one !!!!}
  R.Assign(10,20,417,190);
  A:=New(Pwindow,Init(R,'Test Window 123456 - Prana''s PC',Wfdefault));
  R.Assign(90,160,500,400);
  App.Insert(New(Pwindow,Init(R,'Test Window 2 - Prana''s PC',Wfdefault)));
  R.Assign(70,90,390,270);
  C:=New(Pwindow,Init(R,'Test Window 3 - Cyest Vision',Wfdefault));
  R.Assign(60,90,589,390);
  D:=New(Pwindow,Init(R,'Test Button Window 4',Wfdefault));
  R.Assign(10,50,100,50+40);
  D^.Insert(New(Ptextbutton,Init(R,'Bu&tton A',Cmok,bfNormal)));
  R.Move(120,0);
  D^.Insert(New(Ptextbutton,Init(R,'&Press Me !',Cmok,bfNormal)));
  R.Move(120,0);
  D^.Insert(New(Ptextbutton,Init(R,'TestAB&CD',Cmok,bfNormal)));
  R.Move(120,0);
  R.Assign(10,100,18,18);
  {  D^.Insert(New(Ptextbutton,Init(R,'Button 4',Cmok,bfNormal)));}
  D^.Insert(New(Parrow,Init(R.a,ar_left)));
  R.Move(120,0);
  D^.Insert(New(Parrow,Init(R.a,ar_right)));
  r.assign(10+18+1,100,129,118);
  d^.insert(new(pbackground,init(R,halfgrayfill,colors[1],colors[2],bs_lower)));
  R.Assign(120,50,260,300);
  C^.Insert(New(Pwindow,Init(R,'1: I''m inside parents window',Wfdefault)));
  R.Assign(10,20,150,200);
  C^.Insert(New(Pwindow,Init(R,'2: I''m inside parents window',Wfdefault)));
  R.Assign(10,20,400,40);
  D^.Insert(New(Pstatictext,Init(R,'Change the Mode : V800x600x32k / 256 !!!',Tfframed+Tfchar+Tfcentered)));
  App.Insert(A);
  App.Insert(C);
  App.Insert(D);
  App.Run;
  App.Done;
End.
