program ShellBreadcrumbEditDemoD24;

uses
  Forms,
  AboutDemoForm in '..\AboutDemoForm.pas',
  ShellBreadcrumbEditDemoMain in 'ShellBreadcrumbEditDemoMain.pas' {dxBreadcrumbEditDemoForm};

  {$R *.res}
  {$R WindowsXP.res}


begin
  Application.Initialize;
  Application.CreateForm(TdxBreadcrumbEditDemoForm, dxBreadcrumbEditDemoForm);
  Application.Run;
end.
