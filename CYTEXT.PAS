Unit Cytext;

Interface
{$I FLAGS}

Uses Objects,CySystem,Cydriver,Cyviews,Cyequ;

Const
  Tfnormal =$00;
  Tfcenterx=$01;
  Tfrightx =$02;
  Tfcentery=$04;
  Tftopy   =$08;
  Tf3Dstyle=$10;
  Tfchar   =$20;
  Tfdown   =$40;
  Tfframed =$80;
  Tfhuge   =$100;
  TfCentered=tfcenterx+tfcentery;

Type
  Pstatictext=^TStaticText;
  TStaticText=Object(TView)
    Text:PString;
    Flags:word;
    Constructor Init(R: TRect;Atext: String;Aflags:Byte);
    Function Gettext(S:String):String;Virtual;
    Procedure Change(S:String);
    Procedure Draw;Virtual;
    Destructor Done;Virtual;
  End;

Implementation

Uses CyGraph;

Constructor TStaticText.Init(R: TRect; Atext: String;Aflags:Byte);
Begin
  Inherited Init(R);
  Text:=NewStr(Atext);
  Flags:=Aflags;
End;

Function TStaticText.Gettext(S:String):String;
Begin
  Gettext:=S;
End;

Procedure TStaticText.Change(S:String);
Begin
  If Text <> Nil Then
  Begin
    DisposeStr(Text);
    Text:=NewStr(S);
    Drawview;
  End;
End;

Procedure TStaticText.Draw;
Var
  R:TRect;
  B,B2:Byte;
  S:String;

Begin
  If Flags And Tfhuge <> 0 Then B:=1 Else B:=0;
  SetColor(Colors[12]);
  If Flags And Tfframed <> 0 Then Drawbackground(Flags And Tfdown <> 0);
  selectfont(fonts[2],0,0);
  B:=LeftText;
  B2:=Bottomtext;
  Getextent(R);
  If Flags And Tfcentery <> 0 Then
  Begin
    B2:=CenterText;
    R.A.Y:=R.B.Y shr 1;
  End else
  If Flags And Tftopy <> 0 Then
  Begin
    B2:=TopText;
    R.A.X:=R.B.X;
  End;
  If Flags And Tfcenterx <> 0 Then
  Begin
    B:=CenterText;
    R.A.X:=R.B.X ShR 1;
  End else
  If Flags And Tfrightx <> 0 Then
  Begin
    B:=RightText;
    R.A.X:=R.B.X;
  End;
  SetTextJustify(B,B2);
  s:=gettext(text^);
  If Flags And Tf3Dstyle <> 0 Then Writetextxy3D(R.A,Colors[1],Colors[2],s) Else
  if flags and tfchar <> 0 then writectextxy(R.A,s) else
  Writetextxy(R.A,s);
End;

Destructor TStaticText.Done;
Begin
  DisposeStr(Text);
  Inherited Done;
End;

End.
