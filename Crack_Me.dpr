program Crack_Me;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  WinHttp_TLB in 'D:\2018 06 15\HACKING\WinHttp_TLB.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
