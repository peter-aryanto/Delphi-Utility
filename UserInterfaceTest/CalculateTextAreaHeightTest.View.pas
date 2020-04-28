unit CalculateTextAreaHeightTest.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TCalculateTextAreaHeightTestView = class(TForm)
    ExistingPanel: TPanel;
    Label1: TLabel;
    Edit1: TEdit;

    AdditionalPanel: TPanel;
    NewLabel: TLabel;

    ButtonPanel: TPanel;
    MinusButton: TButton;
    PlusButton: TButton;
    ExtendButton: TButton;

    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure PlusButtonClick(Sender: TObject);
    procedure MinusButtonClick(Sender: TObject);
    procedure ExtendButtonClick(Sender: TObject);

  private const
    CNewLabelPrefix = 'This is line #';

  private
    FOriginalHeight: Integer;
    FAdditionalPanelMinHeight: Integer;
    FSingleLineTextMinHeight: Integer;

    FNewLabelTextList: TStringList;

    procedure AdjustDisplay;
  end;

implementation

{$R *.dfm}

uses
  VclUtil
  ;

procedure TCalculateTextAreaHeightTestView.FormShow(Sender: TObject);
begin
  FOriginalHeight := Self.Height;

  FAdditionalPanelMinHeight := AdditionalPanel.Height;
  FSingleLineTextMinHeight := NewLabel.Height;

  FNewLabelTextList := TStringList.Create;

// WordWrap is needed to cater of extremely long text on a single line.
NewLabel.WordWrap := True;

AdjustDisplay;

  PlusButton.SetFocus;
end;

procedure TCalculateTextAreaHeightTestView.FormDestroy(Sender: TObject);
begin
  FNewLabelTextList.Free;
end;

procedure TCalculateTextAreaHeightTestView.PlusButtonClick(Sender: TObject);
begin
  FNewLabelTextList.Add(CNewLabelPrefix + IntToStr(FNewLabelTextList.Count + 1));

AdjustDisplay;
end;

procedure TCalculateTextAreaHeightTestView.MinusButtonClick(Sender: TObject);
begin
  if FNewLabelTextList.Count = 0 then
    Exit;

  FNewLabelTextList.Delete(FNewLabelTextList.Count - 1);

AdjustDisplay;
end;

procedure TCalculateTextAreaHeightTestView.ExtendButtonClick(Sender: TObject);
begin
  if FNewLabelTextList.Count = 0 then
    Exit;

  FNewLabelTextList[FNewLabelTextList.Count - 1] := FNewLabelTextList[FNewLabelTextList.Count - 1]
      + '; ' + CNewLabelPrefix + IntToStr(FNewLabelTextList.Count);

AdjustDisplay;
end;

procedure TCalculateTextAreaHeightTestView.AdjustDisplay;
var
  LText: string;
  LHeight: Integer;
  LHeightAdjustment: Integer;
begin
// Trim is needed to remove new line (#13#10) at the end of <TStringList>.Text output.
LText := Trim(FNewLabelTextList.Text);
  NewLabel.Caption := LText;

  if NewLabel.Caption = '' then
  begin
    AdditionalPanel.Visible := False;

    LHeightAdjustment := - FAdditionalPanelMinHeight;

    NewLabel.Height := 0;
  end
  else
  begin
    AdditionalPanel.Visible := True;

    LHeight := CalculateTextAreaHeight(
      LText,
      NewLabel.Width,
      NewLabel.Canvas,
      FSingleLineTextMinHeight,
      NewLabel.Font
    );

    LHeightAdjustment := LHeight - FSingleLineTextMinHeight;

    NewLabel.Height := LHeight;
  end;

  Self.Height := FOriginalHeight + LHeightAdjustment;
  AdditionalPanel.Height := FAdditionalPanelMinHeight + LHeightAdjustment;

  Edit1.Text := IntToStr(NewLabel.Height) + ' in ' + IntToStr(AdditionalPanel.Height);
end;

end.
