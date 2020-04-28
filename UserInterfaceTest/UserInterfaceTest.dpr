program UserInterfaceTest;

uses
  Vcl.Forms,
  Main.Form in 'Main.Form.pas' {MainForm},
  CalculateTextAreaHeightTest.View in 'CalculateTextAreaHeightTest.View.pas' {CalculateTextAreaHeightTestView},
  VclUtil in 'VclUtil.pas';

{$R *.res}

begin
ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
