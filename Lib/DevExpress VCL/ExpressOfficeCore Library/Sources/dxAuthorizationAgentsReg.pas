{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressOfficeCore Library classes                        }
{                                                                    }
{           Copyright (c) 2000-2018 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSOFFICECORE LIBRARY AND ALL     }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
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

unit dxAuthorizationAgentsReg;

{$I cxVer.inc}

interface

uses
  Classes, SysUtils, Menus, TypInfo, Windows, Graphics, Controls, DesignIntf;

procedure Register;

implementation

uses
  cxLibraryReg, dxCoreReg,
  dxAuthorizationAgents;

const
  dxExpressOfficeCoreProductName = 'ExpressOfficeCore Library';

type
  { TdxAuthorizationAgentEditor }

  TdxAuthorizationAgentEditor = class(TdxComponentEditor)
  protected
    function GetProductName: string; override;
  end;

{ TdxAuthorizationAgentEditor }

function TdxAuthorizationAgentEditor.GetProductName: string;
begin
  Result := dxExpressOfficeCoreProductName;
end;

procedure Register;
begin
  RegisterComponents(dxLibraryProductPage, [TdxGoogleAPIOAuth2AuthorizationAgent, TdxMicrosoftGraphAPIOAuth2AuthorizationAgent]);
  RegisterComponentEditor(TdxCustomAuthorizationAgent, TdxAuthorizationAgentEditor);
end;

end.
