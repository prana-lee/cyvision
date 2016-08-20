Unit Cyequ;

Interface

uses cygraph;

Const
  Cmnothing =000;
  Cmcancel  =001;
  Cmok      =002;
  Cmyes     =003;
  Cmno      =004;
  cmClose   =005;
  cmMinimize=006;
  cmMaximize=007;

  cmEnableArrows   = 008;
  cmDisableArrows  = 009;
  cmLeftArrow      = 010;
  cmRightArrow     = 011;
  cmPageLeft       = 012;
  cmPageRight      = 013;
  cmUpArrow        = 014;
  cmDownArrow      = 015;
  cmPageUp         = 016;
  cmPageDown       = 017;
  cmIndicatorMoved = 018;
  cmSBValueChanged = 019;

  Cmquit    =100;



Const
  Fonts:Array[0..2] Of LongInt=
   (dragonfont,{titlebar font}
    font8x8thin,  {button font}
    modernfont);

  Colors:Array[0..12] Of Word=
   (24,        { 0 background}
    lightgray,{ 1 light border}
    Black,    { 2 dark border}
    lightblue,{ 3 active title background}
    darkgray, { 4 inactive title background}
    White,    { 5 active title color}
    lightgray,{ 6 inactive title color}
    Orange,   { 6 drag color }
    White,    { 7 fillcolor for desktop background}
    Brown,    { 8 fill_backcolor for desktop background}
    black,    { 9 focused button}
    black,    {10 button text color}
    black);   {11 statictext color}


  Hicolors:Array[0..12] Of Word=
  ( $fe14,    { 0 background}
    $Fffe,    { 1 light border}
    Black,    { 2 dark border}
    $5678,    { 3 active title background}
    $1234,    { 4 inactive title background}
    $Ffff,    { 5 active title color}
    $a514,    { 6 inactive title color}
    $Ffff,    { 6 drag color }
    $5ff,     { 7 fillcolor for desktop background}
    $ff,      { 8 fill_backcolor for desktop background}
    Lavender, { 9 focused button}
    black,    {10 button text color}
    black);   {11 statictext color}

Implementation

End.