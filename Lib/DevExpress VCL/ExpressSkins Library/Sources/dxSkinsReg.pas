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

unit dxSkinsReg;

{$I cxVer.inc}

interface

uses
  Windows, Classes, cxClasses, Forms, Types, DesignIntf, DesignEditors,  VCLEditors,
  SysUtils, TypInfo, dxCoreReg, cxLibraryReg, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsCore, dxSkinsLookAndFeelPainter, dxSkinsDefaultPainters, dxSkinsForm;

const
  dxSkinsProductName = 'ExpressSkins';

type
  TdxSkinModifyProjectOptionsProc = procedure;

  { TdxSkinNameProperty }

  TdxSkinNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  { TdxSkinPaletteNameProperty }

  TdxSkinPaletteNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

var
  FdxSkinModifyProjectOptionsProc: TdxSkinModifyProjectOptionsProc;

procedure Register;

implementation

uses
  cxControls, dxSkinsStrs, dxSkinInfo;

type

  { TdxSkinControllerEditor }

  TdxSkinControllerEditor = class(TdxComponentEditor)
  protected
    function GetProductName: string; override;
    function InternalGetVerb(AIndex: Integer): string; override;
    function InternalGetVerbCount: Integer; override;
    procedure InternalExecuteVerb(AIndex: Integer); override;
  public
    procedure Edit; override;
    procedure ResetControllerState;
  end;

{ TdxSkinNameProperty }

function TdxSkinNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes - [paReadOnly] + [paValueList];
end;

procedure TdxSkinNameProperty.GetValues(Proc: TGetStrProc);
var
  AName: string;
  I: Integer;
begin
  for I := 0 to cxLookAndFeelPaintersManager.Count - 1 do
  begin
    AName := cxLookAndFeelPaintersManager[I].LookAndFeelName;
    if dxSkinListCanUseSkin(AName) then
      Proc(AName);
  end;
end;

{ TdxSkinPaletteNameProperty }

function TdxSkinPaletteNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes - [paReadOnly] + [paValueList];
end;

procedure TdxSkinPaletteNameProperty.GetValues(Proc: TGetStrProc);
var
  AData: TdxSkinInfo;
  APalettes: TStringList;
  I: Integer;
begin
  if TdxSkinController.GetPainterData(AData) and (AData.Skin.ColorPalettes.Count > 0) then
  begin
    APalettes := TStringList.Create;
    try
      TdxSkinController.PopulateSkinColorPalettes(APalettes);
      for I := 0 to APalettes.Count - 1 do
        Proc(APalettes[I]);
    finally
      APalettes.Free;
    end;
  end
  else
    Proc(sdxDefaultColorPaletteName);
end;

{ TdxSkinControllerEditor }

procedure TdxSkinControllerEditor.Edit;
begin
  if Assigned(FdxSkinModifyProjectOptionsProc) then
    FdxSkinModifyProjectOptionsProc;
end;

function TdxSkinControllerEditor.InternalGetVerb(AIndex: Integer): string;
begin
  if Assigned(FdxSkinModifyProjectOptionsProc) and (AIndex = 0) then
    Result := 'Modify Project Skin Options'
  else
    Result := 'Reset';
end;

function TdxSkinControllerEditor.InternalGetVerbCount: Integer;
const
  VerbsCountMap: array[Boolean] of Integer = (1, 2);
begin
  Result := VerbsCountMap[Assigned(FdxSkinModifyProjectOptionsProc)];
end;

procedure TdxSkinControllerEditor.InternalExecuteVerb(AIndex: Integer);
begin
  if Assigned(FdxSkinModifyProjectOptionsProc) and (AIndex = 0) then
    FdxSkinModifyProjectOptionsProc
  else
    ResetControllerState;
end;

procedure TdxSkinControllerEditor.ResetControllerState;
begin
  TdxSkinController(Component).Reset;
  Designer.Modified;
end;

function TdxSkinControllerEditor.GetProductName: string;
begin
  Result := dxSkinsProductName;
end;

procedure Register;
begin
  ForceDemandLoadState(dlDisable);
  RegisterComponents(dxCoreLibraryProductPage, [TdxSkinController]);
  RegisterClasses([TdxSkinController]);
  RegisterPropertyEditor(TypeInfo(TdxSkinName), nil, 'SkinName', TdxSkinNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TdxSkinController, 'SkinPaletteName', TdxSkinPaletteNameProperty);
  RegisterComponentEditor(TdxSkinController, TdxSkinControllerEditor);
end;

end.
