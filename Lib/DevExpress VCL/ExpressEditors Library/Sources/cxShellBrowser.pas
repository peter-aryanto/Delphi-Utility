{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressEditors                                           }
{                                                                    }
{           Copyright (c) 1998-2018 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSEDITORS AND ALL                }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
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

unit cxShellBrowser;

{$I cxVer.inc}

{$WARN UNIT_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShlObj, ComObj, ActiveX, FileCtrl,
  dxCore, cxControls, cxContainer, cxShellTreeView,
  cxShellCommon, cxSHellControls, cxShellDlgs,
  cxEdit, cxTextEdit, dxForms,
  ComCtrls, cxLookAndFeels, cxLookAndFeelPainters,
  cxLabel, cxButtons, Menus, cxGraphics, cxGeometry, cxTreeView, cxGroupBox;

type
  { TcxShellBrowserDlg }

  TcxShellBrowserDlg = class(TdxForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    pnlBottomBar: TcxGroupBox;
    cxStv: TcxShellTreeView;
    cxTeFolder: TcxTextEdit;
    lblFolder: TcxLabel;

    procedure cxStvChange(Sender: TObject; Node: TTreeNode);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FLookAndFeel: TcxLookAndFeel;
    FSizeGripRect: TRect;
    function GetFAbsolutePIDL: PItemIDList;
    function GetFolder: string;
    procedure SetFolder(const Value: string);
    function GetCaption: string;
    procedure SetCaption(const Value: string);
    function GetFolderCaption: string;
    procedure SetFolderCaption(const Value: string);
    function GetShellOptions: TcxShellTreeViewOptions;
    procedure SetShellOptions(Value: TcxShellTreeViewOptions);
    function GetRoot: TcxShellTreeRoot;
    procedure SetRoot(const Value: TcxShellTreeRoot);
    function GetShButtons: boolean;
    function GetShInfoTips: boolean;
    function GetShShowLines: boolean;
    function GetShShowRoot: boolean;
    procedure SetSfShowRoot(const Value: boolean);
    procedure SetShButtons(const Value: boolean);
    procedure SetShInfoTips(const Value: boolean);
    procedure SetShShowLines(const Value: boolean);
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;

    procedure LFChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
    procedure SetLookAndFeel(Value: TcxLookAndFeel);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property AbsolutePIDL: PItemIDList read GetFAbsolutePIDL;
    property DlgCaption: string read GetCaption write SetCaption;
    property DlgFolderLabelCaption: string read GetFolderCaption write SetFolderCaption;
    property DlgOptions: TcxShellTreeViewOptions read GetShellOptions
      write SetShellOptions;
    property DlgShowButtons: boolean read GetShButtons write SetShButtons;
    property DlgShowInfoTips: boolean read GetShInfoTips write SetShInfoTips;
    property DlgShowLines: boolean read GetShShowLines write SetShShowLines;
    property DlgShowRoot: boolean read GetShShowRoot write SetSfShowRoot;
    property DlgRoot: TcxShellTreeRoot read GetRoot write SetRoot;
    property DlgFolder: string read GetFolder write SetFolder;
    property LookAndFeel: TcxLookAndFeel read FLookAndFeel write SetLookAndFeel;
  end;

implementation

{$R *.dfm}

uses
  Types, cxClasses, cxEditConsts, dxThemeConsts, dxThemeManager, dxUxTheme;

{ TcxShellBrowserDlg }

constructor TcxShellBrowserDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLookAndFeel := TcxLookAndFeel.Create(Self);
  FLookAndFeel.OnChanged := LFChanged;
  cxStv.Style.LookAndFeel.MasterLookAndFeel := FLookAndFeel;
  cxTeFolder.Style.LookAndFeel.MasterLookAndFeel := FLookAndFeel;
  cxButton1.LookAndFeel.MasterLookAndFeel := FLookAndFeel;
  cxButton2.LookAndFeel.MasterLookAndFeel := FLookAndFeel;
  cxButton1.Caption := cxGetResourceString(@cxSEditButtonOK);
  cxButton2.Caption := cxGetResourceString(@cxSEditButtonCancel);
  Caption := cxGetResourceString(@scxShellBrowserDlgCaption);
  lblFolder.Caption := cxGetResourceString(@scxShellBrowserDlgCurrentFolderCaption);
  DoubleBuffered := True;
end;

destructor TcxShellBrowserDlg.Destroy;
begin
  FreeAndNil(FLookAndFeel);
  inherited Destroy;
end;

procedure TcxShellBrowserDlg.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
end;

procedure TcxShellBrowserDlg.CreateWnd;
begin
  inherited CreateWnd;
  SendMessage(Handle, WM_SETICON, 1, 0);
end;

function TcxShellBrowserDlg.GetCaption: string;
begin
  Result := Caption;
end;

function TcxShellBrowserDlg.GetFAbsolutePIDL: PItemIDList;
begin
  Result := cxStv.AbsolutePIDL;
end;

function TcxShellBrowserDlg.GetFolder: string;
begin
  Result := cxStv.Path;
end;

function TcxShellBrowserDlg.GetFolderCaption: string;
begin
  Result := lblFolder.Caption;
end;

procedure TcxShellBrowserDlg.SetCaption(const Value: string);
begin
  Caption := Value;
end;

procedure TcxShellBrowserDlg.SetFolder(const Value: string);
begin
  cxStv.Path := Value;
end;

procedure TcxShellBrowserDlg.SetFolderCaption(const Value: string);
begin
  lblFolder.Caption := Value;
end;

procedure TcxShellBrowserDlg.FormResize(Sender: TObject);
var
  ASizeGripSize: TSize;
begin
  cxTeFolder.Text := MinimizeName(cxStv.Path, Canvas, cxTeFolder.Width);
  FSizeGripRect := ClientRect;
  ASizeGripSize := FLookAndFeel.Painter.ScaledSizeGripSize(ScaleFactor);
  FSizeGripRect.Left := FSizeGripRect.Right - ASizeGripSize.cx;
  FSizeGripRect.Top := FSizeGripRect.Bottom - ASizeGripSize.cy;
  Refresh;
end;

procedure TcxShellBrowserDlg.cxStvChange(Sender: TObject; Node: TTreeNode);
begin
  with cxTeFolder do
    Text := MinimizeName(cxStv.Path, Self.Canvas, Width);
  //  cxStv.InnerTreeView.Selected.MakeVisible;  
end;

procedure TcxShellBrowserDlg.SetShellOptions(Value: TcxShellTreeViewOptions);
begin
  cxStv.Options := Value;
end;

function TcxShellBrowserDlg.GetRoot: TcxShellTreeRoot;
begin
  Result := cxStv.Root;
end;

procedure TcxShellBrowserDlg.SetRoot(const Value: TcxShellTreeRoot);
begin
  cxStv.Root := Value;
end;

function TcxShellBrowserDlg.GetShButtons: boolean;
begin
  Result := cxStv.ShowButtons;
end;

function TcxShellBrowserDlg.GetShellOptions: TcxShellTreeViewOptions;
begin
  Result := cxStv.Options;
end;

function TcxShellBrowserDlg.GetShInfoTips: boolean;
begin
  Result := cxStv.ShowInfoTips;
end;

function TcxShellBrowserDlg.GetShShowLines: boolean;
begin
  Result := cxStv.ShowLines;
end;

function TcxShellBrowserDlg.GetShShowRoot: boolean;
begin
  Result := cxStv.ShowRoot;
end;

procedure TcxShellBrowserDlg.SetSfShowRoot(const Value: boolean);
begin
  cxStv.ShowRoot := Value;
end;

procedure TcxShellBrowserDlg.SetShButtons(const Value: boolean);
begin
  cxStv.ShowButtons := Value;
end;

procedure TcxShellBrowserDlg.SetShInfoTips(const Value: boolean);
begin
  cxStv.ShowInfoTips := Value;
end;

procedure TcxShellBrowserDlg.SetShShowLines(const Value: boolean);
begin
  cxStv.ShowLines := Value;
end;

procedure TcxShellBrowserDlg.FormPaint(Sender: TObject);
begin
  cxPaintCanvas.BeginPaint(Canvas);
  try
    FLookAndFeel.Painter.DrawSizeGrip(cxPaintCanvas, FSizeGripRect, clNone);
  finally
    cxPaintCanvas.EndPaint;
  end;
end;

procedure TcxShellBrowserDlg.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  if PtInRect(FSizeGripRect,
    ScreenToClient(SmallPointToPoint(Message.Pos))) then
    Message.Result := HTBOTTOMRIGHT;
end;

procedure TcxShellBrowserDlg.LFChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
end;

procedure TcxShellBrowserDlg.SetLookAndFeel(Value: TcxLookAndFeel);
begin
  FLookAndFeel.Assign(Value);
end;

end.
