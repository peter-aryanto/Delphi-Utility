object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Main Form'
  ClientHeight = 259
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TestViewComboBox: TComboBox
    Left = 48
    Top = 96
    Width = 361
    Height = 21
    TabOrder = 0
    OnKeyUp = TestViewComboBoxKeyUp
  end
  object RunButton: TButton
    Left = 424
    Top = 94
    Width = 75
    Height = 25
    Caption = '&Run'
    TabOrder = 1
    OnClick = RunButtonClick
  end
end
