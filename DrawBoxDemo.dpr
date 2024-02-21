program DrawBoxDemo;

uses
  Vcl.Forms,
  DrawBoxDemo_Main in 'DrawBoxDemo_Main.pas' {DrawBoxDemoApp};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDrawBoxDemoApp, DrawBoxDemoApp);
  Application.Run;
end.
