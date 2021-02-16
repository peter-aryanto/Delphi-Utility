object JsonObjectConverterTestView: TJsonObjectConverterTestView
  Left = 0
  Top = 0
  Caption = 'JsonObjectConverterTestView'
  ClientHeight = 231
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    505
    231)
  PixelsPerInch = 96
  TextHeight = 13
  object ConvertButton: TButton
    Left = 24
    Top = 8
    Width = 75
    Height = 25
    Caption = 'To Object'
    TabOrder = 0
    OnClick = ConvertButtonClick
  end
  object ResultRichEdit: TRichEdit
    Left = 8
    Top = 43
    Width = 489
    Height = 180
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    Zoom = 100
  end
end
