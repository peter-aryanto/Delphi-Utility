unit FactoryUsingSpring.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFactoryUsingSpringView = class(TForm)
    TopPanel: TPanel;

    MainPanel: TPanel;
    Label1: TLabel;
    Edit1: TEdit;

    ButtonPanel: TPanel;
    ActiveFactoryMadeComponent2aButton: TButton;
    ActiveFactoryMadeComponent2bButton: TButton;
    ClearButton: TButton;

    procedure FormShow(Sender: TObject);
    procedure ActiveFactoryMadeComponent2aButtonClick(Sender: TObject);
    procedure ActiveFactoryMadeComponent2bButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
  private
    procedure RunTest;
  end;

implementation

{$R *.dfm}

uses
  Spring.Container
  , Feature1
  , System.StrUtils
  ;

procedure TFactoryUsingSpringView.FormShow(Sender: TObject);
begin
  GlobalContainer.Build;

  RunTest;

  ActiveFactoryMadeComponent2aButton.SetFocus;
end;

procedure TFactoryUsingSpringView.ActiveFactoryMadeComponent2aButtonClick(Sender: TObject);
begin
  GlobalContainer.Resolve<ISampleSetting>.ComponentType := ct2a;
  RunTest;
end;

procedure TFactoryUsingSpringView.ActiveFactoryMadeComponent2bButtonClick(Sender: TObject);
begin
  GlobalContainer.Resolve<ISampleSetting>.ComponentType := ct2b;
  RunTest;
end;

procedure TFactoryUsingSpringView.ClearButtonClick(Sender: TObject);
begin
  GlobalContainer.Resolve<ISampleSetting>.ComponentType := ctUnknown;
  RunTest;
end;

procedure TFactoryUsingSpringView.RunTest;
var
  LTestInterface: ISampleFactoryDependant;
  LTestResult: string;
begin
  LTestInterface := GlobalContainer.Resolve<ISampleFactoryDependant>;
  LTestResult := LTestInterface.OpeningText
    + LTestInterface.PassiveFactoryMadeComponent.ComponentName + ';'
    + LTestInterface.ClosingText;
  Edit1.Text := ReplaceStr(LTestResult, ';', '; ');
end;

end.
