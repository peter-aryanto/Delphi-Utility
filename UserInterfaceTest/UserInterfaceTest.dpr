program UserInterfaceTest;

uses
  Vcl.Forms,
  CalculateTextAreaHeightTest.View in 'CalculateTextAreaHeightTest.View.pas' {CalculateTextAreaHeightTestView},
  VclUtil in 'VclUtil.pas';

{$R *.res}

procedure DisplayUserInterface(const AView: TCustomFormClass);
var
  LView: TCustomForm;
begin
  LView := AView.Create(nil);
  try
    LView.ShowModal;
  finally
    LView.Free;
  end;
end;

begin
ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

//  Application.CreateForm(TCalculateTextAreaHeightTestView, CalculateTextAreaHeightTestView);
  DisplayUserInterface(TCalculateTextAreaHeightTestView);

  Application.Run;
end.
