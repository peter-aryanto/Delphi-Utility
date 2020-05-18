unit CryptographyTest.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TCryptographyTestView = class(TForm)
    MainPanel: TPanel;
    BottomPanel: TPanel;
    CloseButton: TButton;
    ResultRichEdit: TRichEdit;
    procedure FormShow(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

implementation

{$R *.dfm}

uses
  Cryptography
  ;

procedure TCryptographyTestView.FormShow(Sender: TObject);
const
  CExtraDetails_DateTime = '10/05/2020 12:00:00 AM';
var
  LHashGenerator: IHashGenerator;
  LHashResult: string;
begin
  LHashGenerator := TPbkdf2Sha1.Create;
  LHashResult := LHashGenerator.GenerateHash(
    'HPIO=12412412' + 'DBID=112441' + CExtraDetails_DateTime + 'NONCE=SomeRandomString'
  );
//  ShowMessage(LHashResult);
  ResultRichEdit.Lines.Text := LHashResult;

  // Setting ActiveControl does not work properly within FromShow.
//  ActiveControl := nil;
end;

procedure TCryptographyTestView.FormActivate(Sender: TObject);
begin
  ActiveControl := nil;
end;

procedure TCryptographyTestView.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

end.
