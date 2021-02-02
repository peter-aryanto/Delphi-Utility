{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSkins Library                                     }
{                                                                    }
{           Copyright (c) 2006-2018 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSSKINS AND ALL ACCOMPANYING     }
{   VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY.              }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxSkinSummer2008;

interface

uses
  Classes, dxCore, dxGDIPlusApi, cxLookAndFeelPainters, dxSkinsCore, dxSkinsLookAndFeelPainter;

type

  { TdxSkinSummer2008Painter }

  TdxSkinSummer2008Painter = class(TdxSkinLookAndFeelPainter)
  public
    function LookAndFeelName: string; override;
  end;

implementation

{$R dxSkinSummer2008.res}

const
  SkinsCount = 1;
  SkinNames: array[0..SkinsCount - 1] of string = (
    'Summer2008'
  );
  SkinPainters: array[0..SkinsCount - 1] of TdxSkinLookAndFeelPainterClass = (
    TdxSkinSummer2008Painter
  );


{ TdxSkinSummer2008Painter }

function TdxSkinSummer2008Painter.LookAndFeelName: string;
begin
  Result := 'Summer2008';
end;

//

procedure RegisterPainters;
var
  I: Integer;
begin
  if CheckGdiPlus then
  begin
    for I := 0 to SkinsCount - 1 do
      cxLookAndFeelPaintersManager.Register(SkinPainters[I].Create(SkinNames[I], HInstance));
  end;
end;

procedure UnregisterPainters;
var
  I: Integer;
begin
  if cxLookAndFeelPaintersManager <> nil then
  begin
    for I := 0 to SkinsCount - 1 do
      cxLookAndFeelPaintersManager.Unregister(SkinNames[I]);
  end;
end;

{$IFNDEF DXSKINDYNAMICLOADING}
initialization
  dxUnitsLoader.AddUnit(@RegisterPainters, @UnregisterPainters);
finalization
  dxUnitsLoader.RemoveUnit(@UnregisterPainters);
{$ENDIF}
end.
