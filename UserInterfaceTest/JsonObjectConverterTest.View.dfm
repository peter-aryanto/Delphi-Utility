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
  PixelsPerInch = 96
  TextHeight = 13
  object ConvertButton: TButton
    Left = 25
    Top = 12
    Width = 75
    Height = 25
    Caption = 'To Object'
    TabOrder = 0
    OnClick = ConvertButtonClick
  end
  object ResultMemo: TMemo
    Left = 25
    Top = 48
    Width = 456
    Height = 175
    Lines.Strings = (
      'ResultMemo')
    ReadOnly = True
    TabOrder = 1
  end
end
