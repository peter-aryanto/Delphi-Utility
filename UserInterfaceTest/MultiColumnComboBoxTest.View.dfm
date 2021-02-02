object MultiColumnComboBoxTestView: TMultiColumnComboBoxTestView
  Left = 0
  Top = 0
  Caption = 'Multi-Column ComboBox'
  ClientHeight = 249
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxLookupComboBox1: TcxLookupComboBox
    Left = 200
    Top = 59
    Properties.HideSelection = False
    Properties.KeyFieldNames = 'Desc'
    Properties.ListColumns = <
      item
        FieldName = 'Id'
      end
      item
        FieldName = 'Desc'
      end>
    Properties.ListFieldIndex = 1
    Properties.ListOptions.ColumnSorting = False
    Properties.ListOptions.ShowHeader = False
    TabOrder = 1
    Width = 145
  end
  object ComboBox1: TComboBox
    Left = 200
    Top = 23
    Width = 145
    Height = 22
    Style = csOwnerDrawFixed
    TabOrder = 0
    OnDrawItem = ComboBox1DrawItem
    Items.Strings = (
      'One'
      'Two')
  end
  object DataSource1: TDataSource
    Left = 448
    Top = 120
  end
end
