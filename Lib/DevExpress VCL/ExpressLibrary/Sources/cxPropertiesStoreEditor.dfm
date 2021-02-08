object frmPropertiesStoreEditor: TfrmPropertiesStoreEditor
  Left = 412
  Top = 178
  Caption = 'PropertiesStore Editor'
  ClientHeight = 484
  ClientWidth = 321
  Color = clBtnFace
  Constraints.MinHeight = 518
  Constraints.MinWidth = 329
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  object pnlClient: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 315
    Height = 437
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlLeftTree: TPanel
      Left = 0
      Top = 0
      Width = 315
      Height = 437
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 4
      TabOrder = 0
      object pnlLeftTreeTop: TPanel
        Left = 4
        Top = 4
        Width = 307
        Height = 27
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object lblFindComponent: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 82
          Height = 20
          Margins.Bottom = 4
          Align = alLeft
          Caption = 'Find Component:'
          Layout = tlCenter
        end
        object edFindComponent: TEdit
          AlignWithMargins = True
          Left = 91
          Top = 3
          Width = 213
          Height = 21
          Align = alClient
          TabOrder = 0
          OnKeyDown = edFindComponentKeyDown
        end
      end
      object Tree: TTreeView
        AlignWithMargins = True
        Left = 7
        Top = 34
        Width = 301
        Height = 362
        Align = alClient
        Indent = 19
        ReadOnly = True
        RightClickSelect = True
        TabOrder = 0
        OnExpanding = TreeExpanding
        OnKeyPress = TreeKeyPress
        OnKeyUp = TreeKeyUp
        OnMouseUp = TreeMouseUp
      end
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 7
        Top = 402
        Width = 301
        Height = 31
        Margins.Bottom = 0
        Align = alBottom
        BevelOuter = bvNone
        FullRepaint = False
        TabOrder = 2
        object btnOK: TButton
          AlignWithMargins = True
          Left = 115
          Top = 3
          Width = 90
          Height = 25
          Align = alRight
          Caption = 'OK'
          ModalResult = 1
          TabOrder = 0
        end
        object btnCancel: TButton
          AlignWithMargins = True
          Left = 211
          Top = 3
          Width = 90
          Height = 25
          Margins.Right = 0
          Align = alRight
          Cancel = True
          Caption = 'Cancel'
          ModalResult = 2
          TabOrder = 1
        end
      end
    end
  end
  object ToolBar: TToolBar
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 305
    Height = 33
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    ButtonHeight = 30
    ButtonWidth = 31
    Caption = 'ToolBar'
    Images = cxImageList2
    TabOrder = 1
    object btnGroupByComponents: TToolButton
      Left = 0
      Top = 0
      Hint = 'Group by components'
      Action = actGroupByComponents
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
    end
    object btnGroupByProperties: TToolButton
      Left = 31
      Top = 0
      Hint = 'Group by properties'
      Action = actGroupByProperties
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton3: TToolButton
      Left = 62
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object btnReset: TToolButton
      Left = 70
      Top = 0
      Hint = 'Reset'
      Caption = 'btnReset'
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnResetClick
    end
    object btnCheckAll: TToolButton
      Left = 101
      Top = 0
      Hint = 'Check all'
      Caption = 'btnCheckAll'
      ImageIndex = 3
      ParentShowHint = False
      ShowHint = True
      OnClick = btnCheckAllClick
    end
    object btnUncheckAll: TToolButton
      Left = 132
      Top = 0
      Hint = 'Uncheck all'
      Caption = 'btnUncheckAll'
      ImageIndex = 4
      ParentShowHint = False
      ShowHint = True
      OnClick = btnUncheckAllClick
    end
  end
  object ActionList1: TActionList
    Left = 284
    Top = 4
    object actGroupByComponents: TAction
      Caption = 'GroupByComponents'
      OnExecute = actGroupByComponentsExecute
    end
    object actGroupByProperties: TAction
      Caption = 'GroupByProperties'
      OnExecute = actGroupByPropertiesExecute
    end
  end
  object cxImageList1: TcxImageList
    FormatVersion = 1
    DesignInfo = 524512
  end
  object cxImageList2: TcxImageList
    Height = 24
    Width = 24
    FormatVersion = 1
    DesignInfo = 524480
    ImageInfo = <
      item
        Image.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          2000000000000009000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000020000000A00000012000000130000000A0000
          0002000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000936221C88784B3FFF774B3EFF35221C880000
          0009000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000010000
          00050000000D0000000D00000017674137E1D5C5BDFFC8B1A7FF684137E40000
          00190000000F0000000E00000005000000010000000000000000000000000000
          000000000000000000000000000000000000000000000000000000000005130C
          0B3C6E473DE45E3C32CC4029239B7D5043FED8C9BEFFD3C1B6FF7B4E42FE3F28
          219E613E33D6694238E20E090735000000050000000000000000000000000000
          00000000000000000000000000000000000000000000000000000000000B6E48
          3CE1E0D6D0FFC6B1A7FF9E7B70FFBDA499FFD8C7BDFFD6C6BBFFBAA196FF9975
          69FFBBA398FFC6AEA4FF644035D80000000C0000000000000000000000000000
          00000000000000000000000000000000000000000000000000000000000B6542
          39CEDBCDC9FFE9E0DAFFDBCDC2FFDACBC1FFD9CAC0FFD8C9BEFFD7C7BCFFD6C6
          BBFFD5C5BAFFC8B4ABFF593930C10000000C0000000000000000000000000000
          000000000000000000000000000000000000000000010000000600000011442E
          2797AC8F85FFE4D8D0FFDDD0C6FFE1D7CEFFF0EAE6FFF5F1EEFFEEE7E2FFDED0
          C7FFD7C7BDFF9F7D71FF3F292396000000140000000800000002000000000000
          00000000000000000000000000000000000000000006412C2585734D43DE885C
          4FFFCDB8AEFFE0D4CBFFDFD2C9FFD1C3BDFF8F7065FF927367FFD8CCC7FFECE4
          DFFFD9CABFFFC3ACA1FF825549FF6D483DE03E28238B00000008000000000000
          00000000000100000004000000090000000D00000016895F51FDE8E0DCFFE9DE
          D8FFE4D9D1FFE4D7D1FFE7DDD6FF84675CFF3B2B257A3C2C267A8D6E63FFF2EC
          E8FFDDCEC5FFDACBC0FFDACAC1FFCFBDB3FF845849FF0000000D000000000000
          0001000000082513095067351BBC874523EBB69280F48E6355FFE8DEDBFFF8F6
          F4FFFAF8F7FFF2ECE8FFEFE7E3FF7C5C52FF3625217937272279836459FFECE5
          E1FFE8DED7FFE5DAD3FFECE5E1FFE1D6D2FF865A4BFF0000000C000000010000
          000747271485A2603AFFD4B495FFEAD9BDFFF1E9DBFFB79C8DFF987060FF8F64
          55FEE4D9D5FFF8F6F4FFF1EAE6FFCEC1BBFF866A62FF886B63FFCEC0B9FFECE5
          DFFFECE4DEFFD9CAC4FF875C4FFD6E4B3ED4422D268700000006000000032716
          0C4CA86D47FCE8D4B1FFE4C99AFFE1C28DFFE7D1A8FFEDDDC3FFEAE1D1FFA885
          76FEB69A8FFFF5F2EFFFF2EDEAFFF2ECE9FFF2ECE8FFF0EAE7FFF0EAE5FFEFE8
          E4FFEEE6E3FFAC8D82FF442F288C0000000D0000000500000001000000067D49
          2AC9D5B28DFFDDB883FFDAB67AFFDCB87EFFDCB981FFDCB77EFFE7D5B8FFA37D
          6EFFE3D7D3FFF8F5F4FFFBF9F9FFFBF9F8FFF6F3F1FFF3EDEBFFF5F0EEFFFAF7
          F5FFF9F6F4FFD9C9C4FF69493FC3000000070000000000000000000000079E61
          3BF2DFC095FFD7AE73FFD8AF75FFD9B377FFD9B378FFD9B378FFE5CFAEFFA17A
          6BFFF0EAE8FFE6DCD9FFBB9F96FFDFD1CDFFFDFDFCFFF5F1EEFFDDCFC9FFB99C
          93FFE5DAD7FFE8E0DDFF745245D100000006000000000000000000000006A26A
          42F1DCB584FFD6AC72FFDEBB86FFE2C291FFE2C292FFDFBC89FFE7D0AFFFDDC9
          B3FFA17A69FFB09184FFAF8C7CFF976D5EFEFAF9F8FFF7F2F1FF956B5CFE4B37
          2F8B725146C97A564AD6100B092400000002000000000000000000000004885C
          3BC7CDA373FFE6CCA2FFE9D1A7FFE9D1A8FFE9D2A8FFEAD1A8FFEAD1AAFFE3C9
          ADFFD6BDA7FFF3EDE2FFF1EADFFFA27A69FFEFE9E7FFF1EBE8FF835E52DE0000
          0007000000040000000400000002000000000000000000000000000000012D1F
          1544BA885CFCEEDABBFFF4E4C6FFF3E4C3FFF4E4C3FFF4E4C6FFEEDABBFFBD8B
          5FFFDEC9AFFFEBD7B7FFF1E4CDFFC3A798FF9C7262FF9C7161FF46322B780000
          0002000000000000000000000000000000000000000000000000000000000000
          0002583F2B7CBE8C5FFFDCBD99FFF1E3CAFFF1E3CAFFDCBD99FFBE8C5FFFD3B4
          94FFEDDEC5FFE6CDA1FFEBD8B6FFF3E9D9FFCEAF9BFA0000000C000000020000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000022E221842836142B5BC8E65FEC1946AFFC9A47FFFE2CEB3FFF2E6
          CFFFEEDAB7FFEBD3ACFFE4CA9CFFE7CFA9FFA66F47F200000007000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000100000005B39C87DCE9D8C3FFF5E9D4FFF4E6CCFFF2E1
          C1FFF2E2C0FFF3E1C0FFF0DFBDFFD8B68FFF896040C500000005000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000012E211644BF8F67FCF3E4C9FFF9EED3FFF8EC
          D0FFF8ECD0FFF9EED3FFF3E4CAFFBF9069FC2B1F154400000002000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000259422E7CC29368FFE1C6A7FFF4E8
          D1FFF4E8D1FFE1C6A7FFC29368FF59422E7D0000000300000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000022F241942856447B3AA81
          5CE5AB815CE5856547B42F241944000000020000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000001000000010000
          0002000000020000000100000001000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
      end
      item
        Image.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          2000000000000009000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000002000000080000000C0000000D0000
          000D0000000D0000000D0000000D0000000D0000000D0000000D0000000C0000
          0008000000020000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000077E5E53BFAF8373FFAE8272FFAE81
          72FFAE8070FFAC7F6FFFAC7E6FFFAB7E6EFFAB7D6DFFAA7C6CFFAA7C6CFF7958
          4CBF000000080000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000BB18677FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAA7C
          6DFF0000000B0000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000BB38879FFFFFFFFFFF5EEE8FFF5EE
          E7FFF5EDE7FFF6EDE7FFF5ECE7FFF5ECE6FFF5ECE5FFF5ECE5FFFFFFFFFFAC7F
          6FFF0000000B0000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000AB58C7CFFFFFFFFFFAC7F6FFFAC7F
          6FFFF5EEE9FFAC7F6FFFAC7F6FFFAC7F6FFFAC7F6FFFAC7F6FFFFFFFFFFFAD80
          71FF0000000B0000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000AB78E7FFFFFFFFFFFF6F0EAFFF6EF
          EAFFF6EEE9FFF6EFE8FFF5EEE9FFF6EEE8FFF6EDE8FFF5EDE6FFFFFFFFFFAE82
          72FF0000000A0000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000009B99182FFFFFFFFFFAC7F6FFFAC7F
          6FFFF7F0EAFFAC7F6FFFAC7F6FFFAC7F6FFFAC7F6FFFB2897BFFF4F4F4FFB99F
          94FF000000150000000100000000000000000000000000000000000000000000
          000100000004000000090000000D00000015BA9384FFFFFFFFFFF7F1ECFFF8F0
          ECFFF6F0ECFFEDE9E5FFE8E4E0FFF0ECE8FFF5EDEAFFECE8E4FFA0ADBFFF0B30
          71FF030C1C690000000E00000001000000000000000000000000000000010000
          00082513095067351BBC874523EBB89483F4BD9687FFFFFFFFFFAC7F6FFFAC7F
          6FFFEFEBE8FF728CADFF194D92FFA3ADBCFFE4E1DDFFA0AAB9FF0B2768FF82CA
          F1FF215492FF030D1D650000001D000000170000000D00000003000000074727
          1485A2603AFFD4B495FFEAD9BDFFEFE6D9FFBE988AFFFFFFFFFFF8F3EFFFF8F3
          EFFFECE8E6FF3C73ADFFA5DBF7FF0D2E70FFA0B5C9FF0D2B6DFF90D2F4FF2154
          9AFF89CDF2FF215695FF174990FF16498FFF071A3B9B0000001327160C4CA86D
          47FCE8D4B1FFE4C99AFFE1C28DFFE9DCC2FFC19B8CFFFFFFFFFFAC7F6FFFAC7F
          6FFFF4F1EEFFB0BBC9FF4078B2FFAEE0F8FF0F3275FF9BD8F6FF275CA0FF9DD9
          F7FF25599DFF8BCDF1FF53ACE4FF47A3E0FF296DAEFF081C3D987D492AC9D5B2
          8DFFDDB883FFDAB67AFFDCB87EFFE8D7BBFFC29D8FFFFFFFFFFFFFFFFFFFFFFF
          FFFFFEFEFEFFF6F6F6FFB1BFCFFF457DB6FFB8E6FAFF2B62A5FFA9E0F9FF2960
          A3FFA5DDF8FF74C3EEFF62B6E9FF54ADE5FF4DA8E3FF174383FF9E613BF2DFC0
          95FFD7AE73FFD8AF75FFD9B377FFE7D5B8FFC4A091FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFF9F9F9FF768FB6FF1B4F94FF4A82B8FFC0EBFCFF2E66A7FFB5E6
          FBFF98DBF8FF89D1F4FF76C4EFFF67BAEBFF7DC5EEFF235190FFA26A42F1DCB5
          84FFD6AC72FFDEBB86FFE2C291FFEEDEC7FFCDAF9EFFC5A193FFC5A192FFC49F
          91FFC39E90FFCFB6ACFF2C609EFF94D7F5FF79BBE3FF4F87BBFFCBF1FEFFC1ED
          FDFFC0ECFDFFBCEAFCFFB3E5FAFFABDFF8FF6EA6D2FF1D38568D885C3BC7CDA3
          73FFE6CCA2FFE9D1A7FFE9D1A8FFF0E2C7FFF2E5D2FFF0E3CFFFE3CEB6FFDBC4
          B1FFF3EEE4FFF3EEE7FF92A7BBFF528BBEFF5089BDFF558DC0FF5990C1FF558D
          BFFF5189BDFF4D86BAFF4981B7FF578DBFFF2A445E8A000000092D1F1544BA88
          5CFCEEDABBFFF4E4C6FFF3E4C3FFF4E4C3FFF4E4C6FFEEDABBFFBD8B5FFFDEC9
          AFFFEBD7B7FFEDDBBAFFE4D2BEFF9A7660D60000000D00000006000000060000
          000700000007000000070000000800000007000000040000000100000002583F
          2B7CBE8C5FFFDCBD99FFF1E3CAFFF1E3CAFFDCBD99FFBE8C5FFFD3B494FFEDDE
          C5FFE6CDA1FFE5CB9EFFEBD6B6FFA46A43F50000000900000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00022E221842836142B5BC8E65FEC1946AFFC9A47FFFE2CEB3FFF2E6CFFFEEDA
          B7FFEBD3ACFFE4CA9CFFE7CFA9FFA66F47F20000000700000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000100000005B39C87DCE9D8C3FFF5E9D4FFF4E6CCFFF2E1C1FFF2E2
          C0FFF3E1C0FFF0DFBDFFD8B68FFF896040C50000000500000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000012E211644BF8F67FCF3E4C9FFF9EED3FFF8ECD0FFF8EC
          D0FFF9EED3FFF3E4CAFFBF9069FC2B1F15440000000200000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000259422E7CC29368FFE1C6A7FFF4E8D1FFF4E8
          D1FFE1C6A7FFC29368FF59422E7D000000030000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000022F241942856447B3AA815CE5AB81
          5CE5856547B42F24194400000002000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000100000001000000020000
          0002000000010000000100000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
      end
      item
        Image.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          2000000000000009000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000001000000050000
          000A0000000E00000010000000100000000E0000000A00000005000000010000
          0001000000050000000500000001000000000000000000000000000000000000
          000000000000000000000000000000000001000000040000000D2C190B596136
          19A9814820D6A25928FFA35A28FF824820D6613617AA2C180A590000000A0000
          0008311A0A5E331B0B6100000007000000010000000000000000000000000000
          000000000000000000000000000100000007170D06377D4821CDAF6D3DFFC691
          5DFFD5A872FFE1B882FFE1B881FFD5A670FFC6915FFFA86433FF361E0E650804
          0222935326EA935225EA0804021F000000030000000000000000000000000000
          000000000000000000010000000627170B4F99582BF0C38D5EFFE1BC87FFE8CB
          9FFFF0DCBDFFF6E7D1FFF7ECD8FFF5E7D0FFEBD4B8FF864D26D80201011B5A31
          14A1CA9B6FFFC48C58FF5D3114A40000000B0000000100000000000000000000
          00000000000000000003170E0735A06033F3D7B082FFE6C492FFEDD7B5FFDABA
          9AFFC69974FFB88156FFBA865AFFCAA17BFFC2956EFD1F1209471E100748AE6F
          3FFDE2BD8AFFDFB67FFFAC6A37FD201107480000000500000000000000000000
          0000000000010000000B804D29C9D2AA82FFE6C594FFE9D0ACFFBF8C64FF885D
          3BCA38271960110C0829120D09293A2A1D5F513C2B7A02010018844A22D7DBB7
          8BFFE1BA84FFE1B983FFD5A770FF84491FD70201001200000002000000000000
          0000000000032C1B0F51B87F54FFEBD3A9FFE9D0A7FFBE8B62FF5F4129960000
          000D000000050000000200000002000000040000000B47281280C59268FFE3BF
          8AFFE3BD87FFE2BC87FFE1BB85FFBE8551FF4828108300000008000000000000
          000000000006664024A2D8B594FFEFDBB0FFD5B08CFF885C3AC80201010F0000
          000200000000000000000000000000000003120A052BA7683BF6E5C596FFE3C0
          8CFFE3BF8BFFE3BE8AFFE2BD89FFDFB783FFA26132F61109042C000000000000
          000000000008915D36DAEDDCC1FFF0DCB4FFBE8B61FF2B1D134B000000040000
          000000000000000000000000000000000008764523BDE0C5ABFFF8EEDDFFF8ED
          DCFFF0DDBCFFE4C18EFFF1DDBDFFF8EDDBFFDFC2A7FF73401DBE000000080000
          000A00000011A66C41F2F6EDD5FFF1E0B8FFB27447FF0B0705220000000B0000
          000800000002000000000000000000000008B88155FFB77F53FFB57D51FFB174
          46FFF2DFC0FFE6C694FFAD6D3EFFB27548FFB07346FFB07244FFAB6B3BFFAB6A
          3AFFAA6939FFB17649FFF3E5BDFFF3E4BCFFB4784BFFA86333FFA76232FFA762
          31FF00000007000000000000000000000002000000080000000B0A060323AC6B
          3CFFF0DBB8FFE6C597FFAB6F41FA000000130000000B000000097B5435B5E5D0
          BAFFF9F3DDFFF5E9C3FFF5E8C1FFF4E6C0FFF4E6BFFFF4E6BFFFE3CCAEFF7C52
          33B80000000600000000000000000000000000000000000000032A190E4DBC86
          5BFFEDD5ADFFE3C49BFF98623CE0000000090000000000000000130D0925B686
          5EF5F8F2E3FFF8F1D6FFF6EAC5FFF5E9C4FFF5E9C3FFF5E9CCFFB4845BF5130D
          082600000002000000000000000000000000000000010201010C814F2AC9D3AD
          88FFE9CE9FFFD5B18CFF69462BA0000000060000000000000000000000034E37
          2475D5B496FFFBF7E5FFF7EFCDFFF6ECC7FFF7EDCCFFD5B292FF503724790000
          0006000000030000000100000001000000030000000859361C91B77E52FFECD4
          A8FFEED9B3FFC08D64FF2F20144D000000030000000000000000000000010202
          0109966B48D1EFE2D1FFFAF4DFFFF7EECAFFEEDFC4FF966B47D40202010E472B
          1773341F1156120B0624120B0624331F10587F4C28C6B77F52FFECD8B3FFF3E5
          C1FFDABB9AFF895F3DC600000007000000010000000000000000000000000000
          000223191137C59B77FDFBF8E9FFF9F5DEFFC59A75FD2319113A2319113AAF73
          47FCBB8659FFAA6737FFAA6737FFBC8658FFD5B288FFF3E7C3FFF8F0D4FFE9D7
          BFFFAE7D54EF1A130C2D00000002000000000000000000000000000000000000
          000000000003694D3593E0C8B0FFE1C9B1FF6A4E36960202010C9A714FD3ECDD
          C6FFFAF4DBFFF8F1D0FFF7EECAFFF8F0CFFFF9F3D8FFFAF3E1FFDABCA0FFAF7F
          57EF2C2016440000000300000000000000000000000000000000000000000000
          00000000000109070511AD8460E6AD8460E6090705133F2E2059C2926BFFE1C9
          B1FFF0E4D5FFFCFAF0FFFCFAF0FFF0E4D4FFE2CCB4FFC9A07CFF906B4BC41B14
          0E2B000000030000000000000000000000000000000000000000000000000000
          00000000000000000002382A1E4F382A1E4F000000020000000335291E4A765A
          429D9D7958CFC2956EFCC4976EFF9D7857CF7559419E35281D4C000000040000
          0001000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000001000000010000000000000000000000010000
          0002000000030000000400000004000000030000000300000001000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
      end
      item
        Image.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          2000000000000009000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0002000000070000000A0000000B0000000B0000000B0000000B0000000B0000
          000B0000000C0000000C0000000C0000000B0000000700000002000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000679594DBEA77A6AFFA67868FFA57666FFA47565FFA27364FFA27362FFA072
          61FFA07060FF9F6F5FFF9E6F5EFF9E6D5CFF704D41BF00000007000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0009B28676FFFBF8F6FFFBF8F6FFFBF7F5FFFBF7F4FFFBF7F4FFFBF7F4FFFAF6
          F3FFFAF6F3FFFAF5F2FFFAF5F2FFFAF5F1FFA97B6BFF0000000A000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0009B38879FFFCF9F7FFF7EEE9FFF7EEE9FFE8E7DEFFE8E6DEFFF7EDE8FFF6ED
          E8FFF6EDE8FFF6EDE7FFF6EDE7FFFAF6F3FFAB7D6DFF0000000B000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0009B68C7DFFFDFAF9FFF7F0EBFFDAE1D6FF1D7041FF1D6C40FFD7DED2FFF6EF
          E9FFF6EEE9FFF6EEE8FFF6EEE8FFFBF8F5FFAD7F70FF0000000A000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0008B99081FFFDFBFAFFDBE3D8FF1D7545FF00773BFF00743BFF1D7042FFD7DF
          D4FFF7EFEAFFF7EFEAFFF7EFE9FFFCF9F7FFAF8272FF00000009000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0007BB9385FFFEFCFBFF1D7A48FF007F41FF7DB798FF7DB697FF00773BFF1D73
          43FFD8E1D5FFF8F1ECFFF7F0ECFFFCFAF8FFB18576FF00000009000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0007BE9688FFFEFDFCFF008545FF7EBC9BFFF9F2EEFFF9F2EEFF7EB898FF0079
          3EFF1D7444FFD8E2D6FFF8F2EDFFFDFBF9FFB38879FF00000008000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0006BF9A8CFFFEFEFDFFDDE8DDFFFAF4F1FFFAF3F0FFF9F4F0FFFAF3F0FF7EBA
          99FF007D40FF1D7646FFD9E3D7FFFDFCFBFFB58B7DFF00000008000000020000
          00070000000A0000000B0000000B0000000B0000000B0000000B0000000B0000
          0012C29D8FFFFFFEFEFFFBF6F2FFFBF5F2FFFAF6F2FFFBF4F1FFFAF5F1FFFAF4
          F1FF7EBC9AFF007F41FF1D7747FFFEFDFCFFB78F80FF00000007000000067F5E
          53BEAE8170FFAD7F6FFFAB7D6CFFA97C6BFFA87969FFA67767FFA57665FFCEB6
          AFFFC5A093FFFFFEFEFFFBF6F4FFFCF7F4FFFCF6F3FFFBF6F3FFFBF6F3FFFBF6
          F3FFFBF5F2FF7FBE9DFF008342FFFEFDFDFFBA9383FF0000000700000009BC91
          80FFFBF8F6FFFBF8F6FFFBF7F5FFFBF7F4FFFBF7F4FFFBF7F4FFFAF6F3FFF8F6
          F4FFC7A396FFFFFFFFFFFCF8F5FFFCF8F5FFFCF7F5FFFCF7F4FFFCF7F4FFFCF7
          F4FFFBF6F4FFFBF6F4FFDBE8DDFFFEFEFDFFBD9588FF0000000600000009BD93
          83FFFCF9F7FFF7EEE9FFF7EEE9FFE8E7DEFFE8E6DEFFF7EDE8FFF6EDE8FFF7F2
          F0FFC9A698FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE
          FEFFFFFFFEFFFFFEFEFFFFFEFEFFFFFEFEFFBF998AFF0000000500000009C097
          87FFFDFAF9FFF7F0EBFFDAE1D6FF1D7041FF1D6C40FFD7DED2FFF6EFE9FFF8F4
          F1FFD6BEB2FFCDAD9FFFCDAC9EFFCCAC9EFFCCAB9DFFCCAA9DFFCBAA9CFFCAA9
          9BFFCAA89AFFC9A799FFC9A598FFC8A496FF94786FC00000000300000008C29B
          8CFFFDFBFAFFDBE3D8FF1D7545FF00773BFF00743BFF1D7042FFD7DFD4FFF7F0
          ECFFF8F3F0FFF7F3F0FFFAF8F7FFD9C3BBFF0000000D00000004000000040000
          000400000004000000040000000500000004000000030000000100000007C49E
          90FFFEFCFBFF1D7A48FF007F41FF7DB798FF7DB697FF00773BFF1D7343FFD8E1
          D5FFF8F1ECFFF7F0ECFFFCFAF8FFBB9080FF0000000900000000000000000000
          000000000000000000000000000000000000000000000000000000000007C7A1
          93FFFEFDFCFF008545FF7EBC9BFFF9F2EEFFF9F2EEFF7EB898FF00793EFF1D74
          44FFD8E2D6FFF8F2EDFFFDFBF9FFBD9383FF0000000800000000000000000000
          000000000000000000000000000000000000000000000000000000000006C8A5
          97FFFEFEFDFFDDE8DDFFFAF4F1FFFAF3F0FFF9F4F0FFFAF3F0FF7EBA99FF007D
          40FF1D7646FFD9E3D7FFFDFCFBFFBF9687FF0000000800000000000000000000
          000000000000000000000000000000000000000000000000000000000006CBA8
          9AFFFFFEFEFFFBF6F2FFFBF5F2FFFAF6F2FFFBF4F1FFFAF5F1FFFAF4F1FF7EBC
          9AFF007F41FF1D7747FFFEFDFCFFC19A8BFF0000000700000000000000000000
          000000000000000000000000000000000000000000000000000000000005CEAB
          9EFFFFFEFEFFFBF6F4FFFCF7F4FFFCF6F3FFFBF6F3FFFBF6F3FFFBF6F3FFFBF5
          F2FF7FBE9DFF008342FFFEFDFDFFC39E8EFF0000000700000000000000000000
          000000000000000000000000000000000000000000000000000000000005CFAE
          A1FFFFFFFFFFFCF8F5FFFCF8F5FFFCF7F5FFFCF7F4FFFCF7F4FFFCF7F4FFFBF6
          F4FFFBF6F4FFDBE8DDFFFEFEFDFFC6A093FF0000000600000000000000000000
          000000000000000000000000000000000000000000000000000000000004D1B0
          A3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFFFFFF
          FEFFFFFEFEFFFFFEFEFFFFFEFEFFC8A495FF0000000500000000000000000000
          0000000000000000000000000000000000000000000000000000000000029A82
          77C0CFAFA1FFCFAEA1FFCFAEA1FFCEAEA1FFCEAEA0FFCEAEA0FFCEADA0FFCEAD
          9FFFCEAD9FFFCDAB9EFFCDAA9CFF977E74C00000000300000000000000000000
          0000000000000000000000000000000000000000000000000000000000010000
          0002000000040000000400000004000000040000000400000004000000040000
          0004000000040000000500000004000000030000000100000000000000000000
          0000000000000000000000000000000000000000000000000000}
      end
      item
        Image.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          2000000000000009000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0002000000070000000A0000000B0000000B0000000B0000000B0000000B0000
          000B0000000C0000000C0000000C0000000B0000000700000002000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000679594DBEA77A6AFFA67868FFA57666FFA47565FFA27364FFA27362FFA072
          61FFA07060FF9F6F5FFF9E6F5EFF9E6D5CFF704D41BF00000007000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0009B28676FFFBF8F6FFFBF8F6FFFBF7F5FFFBF7F4FFFBF7F4FFFBF7F4FFFAF6
          F3FFFAF6F3FFFAF5F2FFFAF5F2FFFAF5F1FFA97B6BFF0000000A000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0009B38879FFFCF9F7FFF7EEE9FFF7EEE9FFF7EEE8FFF6EEE9FFF7EDE8FFF6ED
          E8FFF6EDE8FFF6EDE7FFF6EDE7FFFAF6F3FFAB7D6DFF0000000B000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0009B68C7DFFFDFAF9FFF7F0EBFFF7EFEBFFF7EFEAFFF7EFE9FFF7EEE9FFF6EF
          E9FFF6EEE9FFF6EEE8FFF6EEE8FFFBF8F5FFAD7F70FF0000000A000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0008B99081FFFDFBFAFFF8F1ECFFF7F1EBFFF8F0EBFFF8F0EBFFF8F0EBFFF7F0
          EBFFF7EFEAFFF7EFEAFFF7EFE9FFFCF9F7FFAF8272FF00000009000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0007BB9385FFFEFCFBFFF8F1EEFFF8F2EDFFF8F1EEFFF8F1ECFFF9F1EDFFF8F1
          ECFFF8F1ECFFF8F1ECFFF7F0ECFFFCFAF8FFB18576FF00000009000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0007BE9688FFFEFDFCFFFAF3EFFFF9F3EFFFF9F2EEFFF9F2EEFFF9F2EEFFF9F2
          EEFFF8F1EDFFF8F2EDFFF8F2EDFFFDFBF9FFB38879FF00000008000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0006BF9A8CFFFEFEFDFFFAF4F1FFFAF4F1FFFAF3F0FFF9F4F0FFFAF3F0FFF9F3
          EFFFF9F3EFFFF9F3EFFFF9F3EEFFFDFCFBFFB58B7DFF00000008000000020000
          00070000000A0000000B0000000B0000000B0000000B0000000B0000000B0000
          0012C29D8FFFFFFEFEFFFBF6F2FFFBF5F2FFFAF6F2FFFBF4F1FFFAF5F1FFFAF4
          F1FFFAF4F0FFFAF4F0FFFAF3F0FFFEFDFCFFB78F80FF00000007000000067F5E
          53BEAE8170FFAD7F6FFFAB7D6CFFA97C6BFFA87969FFA67767FFA57665FFCEB6
          AFFFC5A093FFFFFEFEFFFBF6F4FFFCF7F4FFFCF6F3FFFBF6F3FFFBF6F3FFFBF6
          F3FFFBF5F2FFFBF5F2FFFAF5F2FFFEFDFDFFBA9383FF0000000700000009BC91
          80FFFBF8F6FFFBF8F6FFFBF7F5FFFBF7F4FFFBF7F4FFFBF7F4FFFAF6F3FFF8F6
          F4FFC7A396FFFFFFFFFFFCF8F5FFFCF8F5FFFCF7F5FFFCF7F4FFFCF7F4FFFCF7
          F4FFFBF6F4FFFBF6F4FFFBF6F3FFFEFEFDFFBD9588FF0000000600000009BD93
          83FFFCF9F7FFF7EEE9FFF7EEE9FFF7EEE8FFF6EEE9FFF7EDE8FFF6EDE8FFF7F2
          F0FFC9A698FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE
          FEFFFFFFFEFFFFFEFEFFFFFEFEFFFFFEFEFFBF998AFF0000000500000009C097
          87FFFDFAF9FFF7F0EBFFF7EFEBFFF7EFEAFFF7EFE9FFF7EEE9FFF6EFE9FFF8F4
          F1FFD6BEB2FFCDAD9FFFCDAC9EFFCCAC9EFFCCAB9DFFCCAA9DFFCBAA9CFFCAA9
          9BFFCAA89AFFC9A799FFC9A598FFC8A496FF94786FC00000000300000008C29B
          8CFFFDFBFAFFF8F1ECFFF7F1EBFFF8F0EBFFF8F0EBFFF8F0EBFFF7F0EBFFF7F0
          ECFFF8F3F0FFF7F3F0FFFAF8F7FFD9C3BBFF0000000D00000004000000040000
          000400000004000000040000000500000004000000030000000100000007C49E
          90FFFEFCFBFFF8F1EEFFF8F2EDFFF8F1EEFFF8F1ECFFF9F1EDFFF8F1ECFFF8F1
          ECFFF8F1ECFFF7F0ECFFFCFAF8FFBB9080FF0000000900000000000000000000
          000000000000000000000000000000000000000000000000000000000007C7A1
          93FFFEFDFCFFFAF3EFFFF9F3EFFFF9F2EEFFF9F2EEFFF9F2EEFFF9F2EEFFF8F1
          EDFFF8F2EDFFF8F2EDFFFDFBF9FFBD9383FF0000000800000000000000000000
          000000000000000000000000000000000000000000000000000000000006C8A5
          97FFFEFEFDFFFAF4F1FFFAF4F1FFFAF3F0FFF9F4F0FFFAF3F0FFF9F3EFFFF9F3
          EFFFF9F3EFFFF9F3EEFFFDFCFBFFBF9687FF0000000800000000000000000000
          000000000000000000000000000000000000000000000000000000000006CBA8
          9AFFFFFEFEFFFBF6F2FFFBF5F2FFFAF6F2FFFBF4F1FFFAF5F1FFFAF4F1FFFAF4
          F0FFFAF4F0FFFAF3F0FFFEFDFCFFC19A8BFF0000000700000000000000000000
          000000000000000000000000000000000000000000000000000000000005CEAB
          9EFFFFFEFEFFFBF6F4FFFCF7F4FFFCF6F3FFFBF6F3FFFBF6F3FFFBF6F3FFFBF5
          F2FFFBF5F2FFFAF5F2FFFEFDFDFFC39E8EFF0000000700000000000000000000
          000000000000000000000000000000000000000000000000000000000005CFAE
          A1FFFFFFFFFFFCF8F5FFFCF8F5FFFCF7F5FFFCF7F4FFFCF7F4FFFCF7F4FFFBF6
          F4FFFBF6F4FFFBF6F3FFFEFEFDFFC6A093FF0000000600000000000000000000
          000000000000000000000000000000000000000000000000000000000004D1B0
          A3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFFFFFF
          FEFFFFFEFEFFFFFEFEFFFFFEFEFFC8A495FF0000000500000000000000000000
          0000000000000000000000000000000000000000000000000000000000029A82
          77C0CFAFA1FFCFAEA1FFCFAEA1FFCEAEA1FFCEAEA0FFCEAEA0FFCEADA0FFCEAD
          9FFFCEAD9FFFCDAB9EFFCDAA9CFF977E74C00000000300000000000000000000
          0000000000000000000000000000000000000000000000000000000000010000
          0002000000040000000400000004000000040000000400000004000000040000
          0004000000040000000500000004000000030000000100000000000000000000
          0000000000000000000000000000000000000000000000000000}
      end>
  end
end