object CalculateTextAreaHeightTestView: TCalculateTextAreaHeightTestView
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Calculate Text Area Height'
  ClientHeight = 149
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AdditionalPanel: TPanel
    Left = 0
    Top = 0
    Width = 539
    Height = 35
    Align = alTop
    TabOrder = 0
    object NewLabel: TLabel
      Left = 8
      Top = 8
      Width = 523
      Height = 13
      AutoSize = False
      Caption = 'New Label'
    end
  end
  object ExistingPanel: TPanel
    Left = 0
    Top = 35
    Width = 539
    Height = 65
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 10
      Width = 100
      Height = 13
      AutoSize = False
      Caption = 'Existing Label'
    end
    object Edit1: TEdit
      Left = 16
      Top = 30
      Width = 121
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 0
      Text = 'Existing Edit'
    end
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 100
    Width = 539
    Height = 49
    Align = alBottom
    TabOrder = 2
    object MinusButton: TButton
      Left = 140
      Top = 8
      Width = 75
      Height = 25
      Caption = '-'
      TabOrder = 0
      OnClick = MinusButtonClick
    end
    object PlusButton: TButton
      Left = 236
      Top = 8
      Width = 75
      Height = 25
      Caption = '+'
      TabOrder = 1
      OnClick = PlusButtonClick
    end
    object ExtendButton: TButton
      Left = 331
      Top = 8
      Width = 75
      Height = 25
      Caption = '>>'
      TabOrder = 2
      OnClick = ExtendButtonClick
    end
  end
end
