unit DrawBoxDemo_Main;

// -----------------------------------------------------------------------------
// Description:     Demo for the usage of the TDrawBox drawing component based .
//                  on the TPaintBox component with advanced functionaleties   .
//                  missing in the original TPaintBox:                         .
//                  1. Center Zoom, 2. Panning,                                .
//                  3. Current mouse coordinate display, 4. Measurements       .
//                  5. Grid and Frame display, 6. Scalebar display             .
// Version:         1.0                                                        .
// Date:            OCT-2021                                                   .
// Target:          Win32, Delphi (11, Athens)                                 .
// Author:          Bert Laegel,   bert.laegel@web.de                          .
// Copyright        © 2021 Bert Laegel                                         .
// GitHub:          https://github.com/BertLaegel/DrawBox-Demo                 .
//                                                                             .
//                                                                             .
// Preliminarys:    Installation of the TDrawbox Component                     .
// -----------------------------------------------------------------------------

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DrawBox, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList;

type
  TDrawBoxDemoApp = class(TForm)
    DrawBox: TDrawBox;
    CoordinateDisp_pnl: TPanel;
    Coord_Bar: TStatusBar;
    DisplayUnitSelect_CB: TComboBox;
    DrawBoxInfoPanel: TPanel;
    GridSizeSelect_Lbl: TLabel;
    ShowGrid_sBtn: TSpeedButton;
    GridSizeSelect_CB: TComboBox;
    StepSizeCombo_Lbl: TLabel;
    StepSizeSelect_CB: TComboBox;
    ConversionPostProc_Img24: TImageList;
    Close_Btn: TButton;
    MeasureDistance_tBtn: TSpeedButton;
    MainMenuIcons: TImageList;
    ZoomAll_tbtn: TSpeedButton;
    ShowGraphics_btn: TSpeedButton;

    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure ShowGrid_sBtnClick(Sender: TObject);
    procedure Close_BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridSizeSelect_CBChange(Sender: TObject);
    procedure DisplayUnitSelect_CBChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DrawBoxDraw(Sender: TObject);
    procedure ZoomAll_tbtnClick(Sender: TObject);
    procedure MeasureDistance_tBtnClick(Sender: TObject);
    procedure ShowGraphics_btnClick(Sender: TObject);
  private
    FDisplayUnitStr: string;
  public
    { Public-Deklarationen }
  end;

var
  DrawBoxDemoApp: TDrawBoxDemoApp;

implementation

{$R *.dfm}

/// Set 'Painted' to true for now and set the correct grid size
procedure TDrawBoxDemoApp.FormCreate(Sender: TObject);
begin
  DrawBox.Painted:= true;
  GridSizeSelect_CBChange(nil);
end;

/// Show all elements in DrawBox when the Forms is shown
procedure TDrawBoxDemoApp.FormShow(Sender: TObject);
begin
  // set the coordinate system of the drawing, here lower left corner = 0,0,
  // uppper right = 100µm, 100µm
  DrawBox.SetDesignExtend(0, 0, 500, 500);
  //DrawBox.BaseUnit:= nm; // set the base unit to 'nm'
  GridSizeSelect_CBChange(nil);
  DrawBox.ZoomAll;  // show complete field first
end;

/// Close the App
procedure TDrawBoxDemoApp.Close_BtnClick(Sender: TObject);
begin
  Close;
end;

/// Set the new unit for coordinate and measurement display in the
/// 'CoordBar' that has been selected by the user
procedure TDrawBoxDemoApp.DisplayUnitSelect_CBChange(Sender: TObject);
var
  NewDisplayUnit: TLengthUnit;
begin
  // OldDisplayUnit:= FDisplayUnit;
  FDisplayUnitStr := DisplayUnitSelect_CB.Items[DisplayUnitSelect_CB.ItemIndex];
  //
  case DisplayUnitSelect_CB.ItemIndex of
//    0:
//      NewDisplayUnit := 1; // =µm
//    1:
//      NewDisplayUnit := 1000; // =mm
//    2:
//      NewDisplayUnit := 10000; // =cm
//    3:
//      NewDisplayUnit := 25400; // =inch
//    4:
//      NewDisplayUnit := 1000000; // =m
//    // 5: FDisplayUnit:= 1000000000;  //=m
    0: NewDisplayUnit:= nm;    //=nm
    1: NewDisplayUnit:= µm; //=µm
    2: NewDisplayUnit:= mm;  //=mm
    3: NewDisplayUnit:= cm; //=cm
    4: NewDisplayUnit:= inch;  //=inch
    5: NewDisplayUnit:= m;  //=m
  end;
  DrawBox.SetDisplayUnit(NewDisplayUnit);
end;


/// The actual procedure where the drawing goes. All Values here in the baseunit!
procedure TDrawBoxDemoApp.DrawBoxDraw(Sender: TObject);
var sText: string;
begin
  if ShowGraphics_btn.Down then

    with DrawBox.Drawing_PB.Canvas do begin
      // line
      Pen.Color := clBlack;
      Pen.Width := 0;
      Pen.Style := psSolid;
      MoveTo(500 + DrawBox.FPanOffsetX,
             500  + DrawBox.FPanOffsetY);
      LineTo(150  + DrawBox.FPanOffsetX,
             150  + DrawBox.FPanOffsetY);

      // circle
      Pen.Color := clBlue;
      Pen.Width := 5;  // = 5µm
      Pen.Style := psSolid;
      //MoveTo(0+ DrawBox.FPanOffsetX,0+ DrawBox.FPanOffsetY);
      Ellipse(500  + DrawBox.FPanOffsetX,
              500  + DrawBox.FPanOffsetY,
              200  + DrawBox.FPanOffsetX,
              200  + DrawBox.FPanOffsetY);
      // text
      Font.Name := 'Arial';
      Font.Color := clRed;
      Font.Height := 50 ; // = 50µm here
      Font.Style := [fsBold];
      sText := 'Hello, world!';
      TextOut(0  + DrawBox.FPanOffsetX,
              500 + DrawBox.FPanOffsetY, sText);
     end;
end;


/// To keep the DrawBox at the same aspect ratio (1:1)
procedure TDrawBoxDemoApp.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
var
  AspectRatio: double;

begin
//make sure we get the aspect ratio with the correct dimensions!
  if (Height >= Constraints.MinHeight) and
    (Width >= Constraints.MinWidth) then
  begin
    AspectRatio := Height / Width; // current aspect ratio
    NewHeight := Round(AspectRatio * NewWidth); // keep it
    Resize := true;
  end;
end;

/// Changes the 'GridSize' of the DrawBox according to the current selection
procedure TDrawBoxDemoApp.GridSizeSelect_CBChange(Sender: TObject);
begin
 // if  GridSizeSelect_CB.ItemIndex = -1 then GridSizeSelect_CB.ItemIndex:= 4 //default
  with DrawBox do begin
    case GridSizeSelect_CB.ItemIndex of
      0:
        GridSize := 1; // =um
      1:
        GridSize := 5;
      2:
        GridSize := 10;
      3:
        GridSize := 50;
      4:
        GridSize := 100; // = default Gridsize = 100um
      5:
        GridSize := 500;
      6:
        GridSize := 1000; // 1mm
      7:
        GridSize := 5000;
      8:
        GridSize := 10000;
    end;
    Draw(Sender);
  end;
end;

/// Sets the DrawBox into 'Measurement' mode if down
procedure TDrawBoxDemoApp.MeasureDistance_tBtnClick(Sender: TObject);
begin
  if MeasureDistance_tBtn.Down then begin
    DrawBox.Panning:= false;
    DrawBox.MeasureMode:= true; // go into measurement mode
  end
  else begin
    //DrawBox.Panning:= true;
    DrawBox.MeasureMode:= false;
  end;
end;

/// Sets the property 'Grid' of the DrawBox to show a grid ('true) or not ='false'
procedure TDrawBoxDemoApp.ShowGrid_sBtnClick(Sender: TObject);
begin
  DrawBox.ShowGrid := not DrawBox.ShowGrid; // toggle FGrid
  ShowGrid_sBtn.Down := DrawBox.ShowGrid;
  DrawBox.Draw(Sender)
end;

/// Call the 'Draw' procedure to show or hide the graphics drawn in 'DrawBoxDraw'
procedure TDrawBoxDemoApp.ShowGraphics_btnClick(Sender: TObject);
begin
  //DrawBox.ClearAll(Sender);
  DrawBox.Draw(Sender)
end;

/// Zoom the DrawBox to the extend of the current drawing to show all elements
procedure TDrawBoxDemoApp.ZoomAll_tbtnClick(Sender: TObject);
begin
  DrawBox.ZoomAll;
end;

end.
