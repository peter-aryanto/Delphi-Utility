unit Main.Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls
  , Spring.Collections
  ;

type
  TMainForm = class(TForm)
    TestViewComboBox: TComboBox;
    RunButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure TestViewComboBoxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FTestViewDictionary: IDictionary<string,TCustomFormClass>;
    procedure AddTestView(const AName: string; ATestViewClass: TCustomFormClass);
    function GetTestViewClass: TCustomFormClass;
    procedure DisplayTestView(const AView: TCustomFormClass);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  System.UITypes
  , CalculateTextAreaHeightTest.View
  , FactoryUsingSpring.View
  , CryptographyTest.View
  , MultiColumnComboBoxTest.View
  ;

procedure TMainForm.FormCreate(Sender: TObject);
begin
UseLatestCommonDialogs := False;

  FTestViewDictionary := TCollections.CreateDictionary<string,TCustomFormClass>;

  AddTestView('PBKDF2 and SHA1', TCryptographyTestView);
  AddTestView('Factory Using ''Spring''', TFactoryUsingSpringView);
  AddTestView('Text Area Height', TCalculateTextAreaHeightTestView);
  AddTestView('Multi-Column Combo Box', TMultiColumnComboBoxTestView);

  TestViewComboBox.ItemIndex := -1;
end;

procedure TMainForm.AddTestView(const AName: string; ATestViewClass: TCustomFormClass);
begin
  FTestViewDictionary.Add(AName, ATestViewClass);
  TestViewComboBox.Items.Add(AName);
end;

procedure TMainForm.RunButtonClick(Sender: TObject);
var
  LTestViewClass: TCustomFormClass;
begin
  if TestViewComboBox.ItemIndex = -1 then
  begin
    MessageDlg('Please select something.', mtError, [mbOK], 0);

    if TestViewComboBox.CanFocus then
      TestViewComboBox.SetFocus;

    Exit;
  end;

  LTestViewCLass := GetTestViewClass;
  if LTestViewClass <> nil then
    DisplayTestView(LTestViewClass)
  else
    MessageDlg('Cannot start the test!', mtError, [mbOK], 0);
end;

//procedure TMainForm.TestViewComboBoxKeyPress(Sender: TObject; var Key: Char);
procedure TMainForm.TestViewComboBoxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  LTestViewClass: TCustomFormClass;
begin
//  if Key = #13 then
  if Key = 13 then
  begin
    LTestViewClass := GetTestViewClass;
    if LTestViewClass <> nil then
      DisplayTestView(LTestViewClass);
  end;
end;

function TMainForm.GetTestViewClass: TCustomFormClass;
var
  LTestViewClass: TCustomFormClass;
begin
  if FTestViewDictionary.TryGetValue(
    TestViewComboBox.Items[TestViewComboBox.ItemIndex],
    LTestViewClass
  )
  then
    Result := LTestViewClass
  else
    Result := nil;
end;

procedure TMainForm.DisplayTestView(const AView: TCustomFormClass);
var
  LView: TCustomForm;
begin
  LView := AView.Create(nil);
  try
    LView.ShowModal;
  finally
    LView.Free;

    if TestViewComboBox.CanFocus then
      TestViewComboBox.SetFocus;
  end;
end;

end.
