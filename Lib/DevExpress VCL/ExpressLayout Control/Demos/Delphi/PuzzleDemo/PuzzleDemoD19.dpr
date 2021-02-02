program PuzzleDemoD19;

uses
  Forms,
  Puzzle in 'Puzzle.pas' {frmPuzzle};

  {$R *.res}
  {$R WindowsXP.res}


begin
  Application.Initialize;
  Application.Title := 'PuzzleDemoD19';
  Application.CreateForm(TfrmPuzzle, frmPuzzle);
  Application.Run;
end.
