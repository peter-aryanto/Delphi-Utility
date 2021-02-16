program UserInterfaceTest;

uses
  Vcl.Forms,
  Main.Form in 'Main.Form.pas' {MainForm},
  CalculateTextAreaHeightTest.View in 'CalculateTextAreaHeightTest.View.pas' {CalculateTextAreaHeightTestView},
  VclUtil in 'VclUtil.pas',
  FactoryUsingSpring.View in 'FactoryUsingSpring.View.pas' {FactoryUsingSpringView},
  Feature1 in '..\Feature1\Feature1.pas',
  Cryptography in '..\Cryptography\Cryptography.pas',
  CryptographyTest.View in 'CryptographyTest.View.pas' {CryptographyTestView},
  MultiColumnComboBoxTest.View in 'MultiColumnComboBoxTest.View.pas' {MultiColumnComboBoxTestView},
  MultiColumnSearchLookupComboBox in '..\Lib\Internal\MultiColumnSearchLookupComboBox.pas',
  JsonObjectConverterTest.View in 'JsonObjectConverterTest.View.pas' {JsonObjectConverterTestView};

{$R *.res}

begin
ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
