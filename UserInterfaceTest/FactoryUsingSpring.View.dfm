object FactoryUsingSpringView: TFactoryUsingSpringView
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Factory Using Spring4D'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 539
    Height = 35
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 549
  end
  object MainPanel: TPanel
    Left = 0
    Top = 35
    Width = 539
    Height = 65
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 549
    object Label1: TLabel
      Left = 16
      Top = 10
      Width = 100
      Height = 13
      AutoSize = False
      Caption = 'Info'
    end
    object Edit1: TEdit
      Left = 16
      Top = 30
      Width = 505
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 100
    Width = 539
    Height = 49
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 110
    ExplicitWidth = 549
    object ActiveFactoryMadeComponent2aButton: TButton
      Left = 145
      Top = 8
      Width = 75
      Height = 25
      Caption = '2&a'
      TabOrder = 0
      OnClick = ActiveFactoryMadeComponent2aButtonClick
    end
    object ActiveFactoryMadeComponent2bButton: TButton
      Left = 241
      Top = 8
      Width = 75
      Height = 25
      Caption = '2&b'
      TabOrder = 1
      OnClick = ActiveFactoryMadeComponent2bButtonClick
    end
    object ClearButton: TButton
      Left = 338
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Clear'
      TabOrder = 2
      OnClick = ClearButtonClick
    end
  end
end
