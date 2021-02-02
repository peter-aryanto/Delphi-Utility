inherited EditorsStylesDemoDemoMainForm: TEditorsStylesDemoDemoMainForm
  Left = 243
  Top = 108
  Caption = 'ExpressEditors StylesDemo'
  ClientHeight = 623
  ClientWidth = 843
  Position = poScreenCenter
  ShowHint = True
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited lbDescription: TLabel
    Width = 843
    Height = 32
    Caption = 
      'This demo provides examples of the editors and controls which sh' +
      'ip with the ExpressQuantumGrid Suite. To learn more about these ' +
      'components, click '#39'About this demo'#39' for explanatory notes.'
  end
  object cxGroupBox: TcxGroupBox [1]
    Left = 235
    Top = 32
    Align = alClient
    ParentColor = False
    Style.Color = clBtnFace
    TabOrder = 1
    Height = 591
    Width = 608
  end
  object cxGroupBox1: TcxGroupBox [2]
    Left = 0
    Top = 32
    Align = alLeft
    TabOrder = 0
    Height = 591
    Width = 227
    object cxTreeView: TcxTreeView
      Left = 2
      Top = 5
      Width = 223
      Height = 220
      Align = alClient
      TabOrder = 0
      HideSelection = False
      ReadOnly = True
      OnChange = cxTreeViewChange
    end
    object gbDescription: TcxGroupBox
      Left = 2
      Top = 233
      Align = alBottom
      Caption = 'Brief Description'
      ParentColor = False
      Style.Color = clBtnFace
      TabOrder = 2
      Height = 356
      Width = 223
      object PageControl: TcxPageControl
        Left = 2
        Top = 18
        Width = 219
        Height = 336
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Properties.HotTrack = True
        Properties.MultiLine = True
        Properties.RaggedRight = True
        Properties.TabPosition = tpBottom
        OnChange = PageControlChange
        ClientRectBottom = 336
        ClientRectRight = 219
        ClientRectTop = 0
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 2
      Top = 225
      Width = 223
      Height = 8
      HotZoneClassName = 'TcxMediaPlayer8Style'
      AlignSplitter = salBottom
      Control = gbDescription
    end
  end
  object cxSplitter: TcxSplitter [3]
    Left = 227
    Top = 32
    Width = 8
    Height = 591
    Hint = 'cxSplitter'
    HotZoneClassName = 'TcxMediaPlayer9Style'
    Control = cxGroupBox1
  end
  inherited mmMain: TMainMenu
    inherited miFile: TMenuItem
      object miFileOpen: TMenuItem [0]
        Caption = '&Open'
        ImageIndex = 3
        OnClick = miFileOpenClick
      end
      object miFileSave: TMenuItem [1]
        Caption = '&Save'
        ImageIndex = 4
        OnClick = miFileSaveClick
      end
      object N1: TMenuItem [2]
        Caption = '-'
      end
    end
    object miStyle: TMenuItem [1]
      Caption = '&Style'
      object miStyleCurrentPage: TMenuItem
        Caption = '&Current Page'
        object miCurDisplayStyle: TMenuItem
          Caption = '&Display style'
          object miCurDefLightBlue: TMenuItem
            Caption = 'Light &Blue'
            RadioItem = True
            OnClick = miCurDisplayStyleClick
          end
          object miCurDefLightGray: TMenuItem
            Tag = 1
            Caption = 'Light &Gray'
            RadioItem = True
            OnClick = miCurDisplayStyleClick
          end
          object miCurDefWood: TMenuItem
            Tag = 2
            Caption = '&Wood'
            RadioItem = True
            OnClick = miCurDisplayStyleClick
          end
          object miCurDefRainyDay: TMenuItem
            Tag = 3
            Caption = '&Rainy Day'
            RadioItem = True
            OnClick = miCurDisplayStyleClick
          end
          object miCurDefBrick: TMenuItem
            Tag = 4
            Caption = 'Bri&ck'
            RadioItem = True
            OnClick = miCurDisplayStyleClick
          end
          object miCurDefDeepSea: TMenuItem
            Tag = 5
            Caption = 'Deep &Sea'
            RadioItem = True
            OnClick = miCurDisplayStyleClick
          end
        end
        object miCurHintStyle: TMenuItem
          Caption = '&Hint Style'
          object nohints1: TMenuItem
            Tag = 5
            Caption = '&No hints'
            RadioItem = True
            OnClick = miCurHintStyleClick
          end
          object N3: TMenuItem
            Caption = '-'
          end
          object miCurHintStyleLightInfo: TMenuItem
            Caption = 'Light &Info'
            RadioItem = True
            OnClick = miCurHintStyleClick
          end
          object miCurHintStyleLightSlideLeft: TMenuItem
            Tag = 1
            Caption = 'Light Slide &Left'
            RadioItem = True
            OnClick = miCurHintStyleClick
          end
          object miCurHintStyleBlueSlideUp: TMenuItem
            Tag = 2
            Caption = 'Blue Slide &Up'
            RadioItem = True
            OnClick = miCurHintStyleClick
          end
          object miCurHintStyleRoundedInfo: TMenuItem
            Tag = 3
            Caption = '&Rounded Info'
            RadioItem = True
            OnClick = miCurHintStyleClick
          end
          object miCurHintStyleStandard: TMenuItem
            Tag = 4
            Caption = '&Standard'
            RadioItem = True
            OnClick = miCurHintStyleClick
          end
        end
      end
      object miStyleAllPages: TMenuItem
        Caption = '&All Pages'
        object miDefDisplayStyle: TMenuItem
          Caption = '&Display Style'
          object miDefLightBlue: TMenuItem
            Caption = 'Light &Blue'
            RadioItem = True
            OnClick = miDefaultDisplayStyleClick
          end
          object miDefLightGray: TMenuItem
            Tag = 1
            Caption = 'Light &Gray'
            RadioItem = True
            OnClick = miDefaultDisplayStyleClick
          end
          object miDefWood: TMenuItem
            Tag = 2
            Caption = '&Wood'
            RadioItem = True
            OnClick = miDefaultDisplayStyleClick
          end
          object miDefRainyDay: TMenuItem
            Tag = 3
            Caption = '&Rainy Day'
            RadioItem = True
            OnClick = miDefaultDisplayStyleClick
          end
          object miDefBrick: TMenuItem
            Tag = 4
            Caption = 'Bri&ck'
            RadioItem = True
            OnClick = miDefaultDisplayStyleClick
          end
          object miDefDeepSea: TMenuItem
            Tag = 5
            Caption = 'Deep &Sea'
            RadioItem = True
            OnClick = miDefaultDisplayStyleClick
          end
        end
        object miDefHintStyle: TMenuItem
          Caption = '&Hint Style'
          object nohints2: TMenuItem
            Tag = 5
            Caption = '&No hints'
            RadioItem = True
            OnClick = miHintStyleClick
          end
          object N4: TMenuItem
            Caption = '-'
          end
          object miHintStyleLightInfo: TMenuItem
            Caption = 'Light &Info'
            RadioItem = True
            OnClick = miHintStyleClick
          end
          object miHintStyleLightSlideLeft: TMenuItem
            Tag = 1
            Caption = 'Light Slide &Left'
            RadioItem = True
            OnClick = miHintStyleClick
          end
          object miHintStyleBlueSlideUp: TMenuItem
            Tag = 2
            Caption = 'Blue Slide &Up'
            RadioItem = True
            OnClick = miHintStyleClick
          end
          object miHintStyleRoundedInfo: TMenuItem
            Tag = 3
            Caption = '&Rounded Info'
            RadioItem = True
            OnClick = miHintStyleClick
          end
          object miHintStyleStandard: TMenuItem
            Tag = 4
            Caption = '&Standard'
            RadioItem = True
            OnClick = miHintStyleClick
          end
        end
      end
    end
  end
  object ilMain: TImageList
    Left = 472
    Bitmap = {
      494C010105000900200010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080808000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00080808000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      800080808000FF000000C0C0C000FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFF
      FF0000FFFF00FFFFFF00C0C0C00080808000000000000000000000000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000808080000000000000000000000000000000
      0000000000000000000000000000800080008000800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FF00
      0000FF000000FF000000C0C0C000FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000808080000000000000000000FF000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000808080000000000000000000000000000000
      0000000000008000800080008000FFFFFF00FFFFFF00C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000080808000FF000000FF00
      0000FF000000FF000000C0C0C000FFFFFF0000FFFF0080808000808080008080
      8000C0C0C000FFFFFF00C0C0C0008080800000000000FF000000808080008080
      8000808080008080800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000808080000000000000000000000000008000
      800080008000FFFFFF00FFFFFF000000000000000000C0C0C000C0C0C0008080
      8000000000000000000000000000000000000000000000FFFF00000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000080808000FF000000FF00
      0000FF000000FF000000C0C0C000FFFFFF0080808000FF000000FF000000FF00
      000080808000FFFFFF00C0C0C0008080800080808000FF000000808080008080
      8000FF000000FF000000FF000000FF00000080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C00080808000808080008000800080008000FFFF
      FF00FFFFFF000000000000000000800080008000800000000000C0C0C000C0C0
      C0008080800000000000000000000000000000000000FFFFFF0000FFFF000000
      0000008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000080808000FF000000FF000000FF00
      0000FF000000FF000000C0C0C000FFFFFF0080808000C0C0C00080808000FF00
      000080808000FFFFFF00C0C0C00080808000808080008080800080808000FF00
      0000FF000000C0C0C000C0C0C00080808000FF00000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000808080008080800080008000FFFFFF000000
      000000000000800080008000800080008000800080008000800000000000C0C0
      C000C0C0C0008080800000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000084840000848400008484000084840000848400008484000084
      84000084840000848400000000000000000080808000FF000000FF000000FF00
      00008080800080808000C0C0C000FFFFFF0080808000FFFFFF00C0C0C0008080
      800080808000FFFFFF00C0C0C0008080800080808000C0C0C00080808000FF00
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000808080008080800000000000000000008000
      800080008000800080000080800000FFFF008000800080008000800080000000
      0000C0C0C000C0C0C000808080000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FF000000FF0000008080
      80008080800080808000C0C0C000FFFFFF0000FFFF0080808000808080008080
      8000C0C0C000FFFFFF00C0C0C00080808000000000008080800000FFFF00FF00
      0000FF000000FF000000FF000000FF000000FF00000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000808080008080800080008000800080008000
      8000800080008000800080008000008080008000800080008000800080008000
      800000000000C0C0C00000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      00000000000000000000000000000000000080808000FF000000FF0000008080
      80008080800080808000C0C0C000FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF008080800080808000808080008080800000000000000000008080800000FF
      FF00FF000000FFFFFF00FFFFFF0080808000FF00000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000808080000000000080008000FFFFFF008000
      80008000800080008000800080008000800000FFFF0000FFFF00800080008000
      80008000800000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      00000000000000000000000000000000000080808000FF000000FF000000C0C0
      C0008080800080808000C0C0C000FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C000FFFFFF00C0C0C000000000000000000000000000000000008080
      800000FFFF00FF000000FF000000FF00000080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C00080808000000000000000000080008000FFFF
      FF0080008000800080008000800080008000800080000080800000FFFF0000FF
      FF00800080008000800000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FF000000FF00
      0000FFFFFF00C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00C0C0C000C0C0C0000000000000000000000000000000000000000000C0C0
      C000FF000000FF000000FF00000080808000FFFFFF00FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000808080000000000000000000000000008000
      8000FFFFFF00800080008000800080008000008080008000800000FFFF0000FF
      FF00800080008000800080008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FF000000FFFF
      FF00C0C0C000FFFFFF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000808080000000000000000000000000000000000000000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFF
      FF00808080008080800080808000808080000000000000000000000000000000
      000080008000FFFFFF00800080008000800000FFFF0000FFFF0000FFFF008000
      8000800080008000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000FF00
      0000FF000000C0C0C000FFFFFF00C0C0C0008080800080808000808080008080
      800080808000000000000000000000000000000000000000000000000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C000FFFFFF00C0C0C000000000000000000000000000000000000000
      00000000000080008000FFFFFF00800080008000800080008000800080008000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000FF000000FF000000FFFFFF00C0C0C00080808000808080008080
      800000000000000000000000000000000000000000000000000000000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000080008000FFFFFF008000800080008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800080008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000C001000000000000
      8031000000000000803100000000000080310000000000008001000000000000
      800100000000000080010000000000008FF10000000000008FF1000000000000
      8FF10000000000008FF10000000000008FF10000000000008FF5000000000000
      8001000000000000FFFF000000000000FC00E000FFFFFFFFF800E000FE3FFFFF
      E000E000F81F001FC000C000E00F000F80008000800700078000000000030003
      00000000000100010000000000000000000080000001001F0000C0008001001F
      0001E000C001001F8003E000E0008FF18003E000F000FFF9C007E001F803FF75
      E00FE003FC0FFF8FF83FE007FE3FFFFF00000000000000000000000000000000
      000000000000}
  end
  object OpenDialog: TOpenDialog
    Left = 440
  end
  object cxHintStyleController: TcxHintStyleController
    Global = False
    HintStyleClassName = 'TcxHintStyle'
    HintStyle.AnimationDelay = 300
    HintStyle.CallOutPosition = cxbpAuto
    HintStyle.CaptionFont.Charset = DEFAULT_CHARSET
    HintStyle.CaptionFont.Color = clWindowText
    HintStyle.CaptionFont.Height = -11
    HintStyle.CaptionFont.Name = 'MS Sans Serif'
    HintStyle.CaptionFont.Style = []
    HintStyle.Font.Charset = DEFAULT_CHARSET
    HintStyle.Font.Color = clWindowText
    HintStyle.Font.Height = -11
    HintStyle.Font.Name = 'MS Sans Serif'
    HintStyle.Font.Style = []
    HintStyle.Icon.Data = {
      0000010001002020000001000800A80800001600000028000000200000004000
      0000010008000000000080040000000000000000000000000000000000000000
      0000999999000000CC00CCCCCC00FFFFFF000000FF00FF000000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000030304040400000000000000000000000000000000000000
      0000000000000000000101000000000000000000000000000000000000000000
      0000000000000000000001000000000000000000000000000000000000000000
      0000000000000000000004000000000000000000000000000000000000000000
      0000000000000000000003000000000000000000000000010000000000000000
      0000000400000000000001000000000000000000000101030000000000000000
      0000000000000000000001000000000000000000010103030000000000000000
      0000000000000000000001000000000000000001010304000000000000000000
      0000000000000000000001000000000000000101030400000000000000000000
      0000000000000000000001000000000101010003040000000000000000000000
      0000000000000000000001000000000101030300000000000000000000000000
      0000000000000000000000000000010103030400000000000000000000000000
      0000000000000000000000000000010103040100000000000000000000000000
      0000000000000000000001010101000304010000000000000000000000000000
      0000000000000000000101010103030001000000000000000000000000000000
      0000000000010100000101010303030000000000000000000000000000000000
      0000000001010101010001030303030400000202020202000000000000000000
      0000000001010101010100030303040100000202020202020000000000000000
      0001000700000001010303000304010000000000000000000000000000000000
      0101000607060700030303030001000000000000000000000000000000000000
      0104040006070607000303030000000002020505050502020200000000000000
      0004030300060706040003000400000002050505050505020200000000000000
      0003030303000604040700040000000002050505050505020200000000000000
      0000030303030004040600010100000002050404050505020200000000000000
      0000000301010100000000010000000000020405050502020000000000000000
      0000000001010101010100000000000000000202020202000000000000000000
      0000000000000101000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FFFFFFFFFFFFF8000FFFFF007FFFFFC1FFFFFFE3FFFFFFE3FFFFF1E3FE3FF1E3
      FC1FF1E3F81FFEE3F03FFF63807FFFA300FFFFC201FFFFE003FFFFE003FFFFC0
      07FFFC000FFFF800107FF000103FE000101FC000200F8000400180004000C000
      800EC0008001E000800FF001C01FF803E03FFC07F07FFF1FFFFFFFFFFFFF}
    Left = 536
  end
end
