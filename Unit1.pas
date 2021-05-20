unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,WinHttp_TLB, Vcl.StdCtrls,Tlhelp32,
    IdHTTP, IdMultiPartFormData,IdFTP,FileCtrl,WinInet,ComCtrls, ExtActns,ShellApi,
  SHDocVw, IdIPWatch, IdBaseComponent, IdComponent, IdTCPConnection,clipbrd,Comobj,
  IdTCPClient, Vcl.OleCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Button1: TButton;
    WebBrowser1: TWebBrowser;
    Button2: TButton;
    Edit1: TEdit;
    Button3: TButton;
    IdHTTP1: TIdHTTP;
    Button4: TButton;
    Edit2: TEdit;
    Button5: TButton;
    Timer2: TTimer;
    Timer3: TTimer;
    crc: TTimer;
    Label1: TLabel;
    procedure REGISTERClick(Sender: TObject);
    procedure LOGIN_BUTTONClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure crcTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
    CRC1,CRC2: Dword;
  MBI: Memory_Basic_Information;

    check:integer;
implementation

{$R *.dfm}

function CRC16(Address, Range: DWORD): DWORD;
asm
 pushad
 @return:
  movzx ebx,byte ptr [Address+Range]
  shl ebx,08
  xor ecx,ebx
  dec edx
  cmp edx,1
  jne @return
 mov result,ecx
 popad
end;

Function DebuggerPresent : boolean;
Type
 TDebugProc = Function : boolean;
   StdCall;
Var
 Kernel32: HMODULE;
 DebugProc: TDebugProc;
Begin
 Result := False;
 Kernel32 := GetModuleHandle('kernel32');
 if Kernel32 <> 0 Then
 Begin
   @DebugProc := GetProcAddress(Kernel32, 'IsDebuggerPresent');
   if Assigned(DebugProc) Then
     Result := DebugProc
 End;
End;

function DelDir(dir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));

  with fos do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom  := PChar(dir + #0);
  end;

  Result := (0 = ShFileOperation(fos));
end;

function GetHDSerialNumber : Integer;
var
 PDW : Integer;
 MC, FL : DWord;

begin
 GetVolumeInformation( nil, nil, 0, @pdw, mc, fl, nil, 0 );
 Result := pdw;
end;

function CheckProcess(sFindFile : string): Boolean;
var
   peList : TProcessEntry32;
   hL : THandle;
begin
   Result := False;
   peList.dwSize := SizeOf(TProcessEntry32);
   hL             := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
   if Process32First(hL, peList) then begin
      repeat
         if CompareText(peList.szExeFile, sFindFile) = 0 then begin
            Result := True;
            break;
         end;
      until not Process32Next(hL, peList);
   end;
   CloseHandle(hL);
end;

Procedure Wait2(milliseconds: integer);
var dTime: DWORD;
begin
  dTime:= GetTickCount;
  while GetTickCount <= (dTime + milliseconds) do
  begin
    Application.ProcessMessages;
  end;
end;

Procedure SmoothComponent(Target: AnsiString; Speed: Byte);
var MyComponent: TComponent;
    save, val, ScaleWidth: integer;
    squareroot: single;
    rc: TRect;
begin
  with Form1 do
  begin
    MyComponent:= FindComponent(Target);
    if MyComponent is TControl then
    begin
      save:= TControl(MyComponent).Left;
      Rc:= GetClientRect;
      ScaleWidth:= rc.Right - rc.Left;
      TControl(MyComponent).Left:= ScaleWidth;
      while(true) do
      begin
        squareroot:= Sqrt(TControl(MyComponent).Left);
        val:= TControl(MyComponent).Left div Speed;
        TControl(MyComponent).Left:= (TControl(MyComponent).Left - val) - round(squareroot);
        if TControl(MyComponent).Left <= save then
        begin
          TControl(MyComponent).Left:= save;
          break;
        end;
        Wait2(15);
      end;
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 sLogName,sLogNameC : String; //로그 화일명
 tLog : TEXTFILE;
begin
WebBrowser1.Navigate('http://crcserver.dothome.co.kr/autoipban/Ban.php');
   sLogName := copy(Application.ExeName,1,length(Application.ExeName)-4) + '.log';  //실행화일명.log ,실행화일과 동일디렉토리
   //sLogNameC := 'C:\Galaxy.log';
 AssignFile(tLog, sLogName);
 if FileExists( sLogName ) then
 BEGIN
   Append( tLog );
   Button2.Click;
END else
BEGIN
   Rewrite( tLog); // 파일을 새로 생성하고 연다.

 WriteLn( tLog, Format('%s %s', [FormatDateTime('YYYY-MM-DD :hhmmss',Now) , '메모리 변조' ] ));  // 로그 내용 쓰기

 closeFile(tLog);
 Button2.Click;
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   Serial : Integer;
   HWID : String; //로그 화일명
    tLog : TEXTFILE;
begin
   Serial := GetHDSerialNumber;
    Edit1.Text :=  Format ('%4X-%4X', [LongRec(Serial).hi, LongRec(Serial).lo]) + '.log';;
   HWID := Format ('%4X-%4X', [LongRec(Serial).hi, LongRec(Serial).lo]) + '.log';;  //실행화일명.log ,실행화일과 동일디렉토리
     AssignFile(tLog, HWID);
      if FileExists( HWID ) then
      BEGIN
   Append( tLog ); // 파일이 존재하면 Append   한다.
    Button3.Click;
 END else
 BEGIN
   Rewrite( tLog); // 파일을 새로 생성하고 연다.

 WriteLn( tLog, Format('%s %s', [FormatDateTime('YYYY-MM-DD :hhmmss',Now) , '메모리 변조' ] ));  // 로그 내용 쓰기

 closeFile(tLog);
     Button3.Click;
end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  AUrl       : String;
  DataPath   : String;
  sLogName    : String;
  DataStream : TIdMultiPartFormDataStream;
  ResStream  : TMemoryStream;
begin
  //업로드 파일
  sLogName := Edit1.text;
   //sLogName := copy(Application.ExeName,1,length(Application.ExeName)-4) + '.log';  //실행화일명.log ,실행화일과 동일디렉토리
  DataPath   := sLogName;
  //업로드 한 파일을 처리하는 PHP의 절대 경로
  AUrl       := 'http://crcserver.dothome.co.kr/upload/up.php';
  DataStream := TIdMultiPartFormDataStream.Create;
  ResStream  := TMemoryStream.Create;
  try
    //업로드 할 파일 지정
    DataStream.AddFile('upfile', sLogName, '');

    //업로드
    IdHTTP1.Post(AUrl, DataStream, ResStream);

    ResStream.Position := 0;
  finally
    FreeAndNil(DataStream);
    FreeAndNil(ResStream);
    if DelDir(sLogName) = True then
    BEGIN
    //ShellExecute( handle , 'open', 'http://crcserver.dothome.co.kr/ban/ban2.php', nil, nil, SW_SHOWNORMAL );
   Application.Terminate;
  end;
end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var Pt :TPoint; // 캡쳐할 화면의 Left, Top 좌표
  DC :HDC;
  Bmp : TBitmap;
  Scr : TScreen;

    begin // 폼전체를 하기 위해 (0, 0) 으로 설정하였다.
      Pt.x := 0; // x => 폼에서의 Left 값
      Pt.y := 0; // y => 폼에서의 Top 값 // 폼의 좌표를 스크린 좌표로 변환한다.
      // Pt := ClientToScreen(Pt); // 캡쳐할 비트맵 생성
      Bmp := TBitMap.Create;
      Edit2.Text := formatdatetime('YYYYMMDDhhnnss',now);
        try /// 비트맵 크기 지정 => 폼전체를 하기위해 폼의 크기를 지정하였다.
          Scr := TScreen.Create(Self);
          Bmp.Width := Scr.Width; // Width+100;
          Bmp.Height := Scr.Height; // Height+100;
          DC := GetDC(0);
          BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, DC, Pt.x , Pt.y, SRCCOPY);
          ReleaseDC(0,DC);
          Bmp.SaveToFile(Edit2.Text + '.bmp');
        finally
          Bmp.Free;
          Scr.Free;
         // WebBrowser1.Navigate('http://crcserver.dothome.co.kr/autoipban/Ban.php');
          Button5.Click;
          //Button16.Click;
        end;
    end;

procedure TForm1.Button5Click(Sender: TObject);
var
  AUrl       : String;
  DataPath   : String;
  sLogName1    : String;
  DataStream : TIdMultiPartFormDataStream;
  ResStream  : TMemoryStream;
begin
  sLogName1 := Edit2.text;
  DataPath   := sLogName1;

  AUrl       := 'http://crcserver.dothome.co.kr/upload/bmp.php';
  DataStream := TIdMultiPartFormDataStream.Create;
  ResStream  := TMemoryStream.Create;
    try
      DataStream.AddFile('upfile', sLogName1+'.bmp', '');

      IdHTTP1.Post(AUrl, DataStream, ResStream);

      ResStream.Position := 0;
    finally
      FreeAndNil(DataStream);
      FreeAndNil(ResStream);
        if DelDir(sLogName1) = True then
        Application.Terminate;
    end;
  end;

procedure TForm1.crcTimer(Sender: TObject);
var
  F : TextFile;
  FH : Integer;
    begin
      VirtualQuery(Ptr($00401000), MBI, SizeOf(MBI));
      CRC2:=CRC16(Dword(MBI.BaseAddress),MBI.RegionSize) ;
    if CRC1 <> CRC2 then
      begin
          if check = 0 then
            begin
              check:=1;
                  Button1.Click;
                    Button4.Click;
              SmoothComponent('CRC',200);
              CRC.Enabled :=false
           end;
        end;
    end;


procedure TForm1.FormCreate(Sender: TObject);
var
Winhttp : IWinHttpRequest;
  sTmp: String;
  sLogName : String;
  voice:OLEVariant;
begin
VirtualQuery(Ptr($00401000), MBI, SizeOf(MBI));
CRC1:=CRC16(Dword(MBI.BaseAddress),MBI.RegionSize);

BorderStyle:= bsSingle;
////////////////////////
///////////////////////////////////////////////////////////////////////////////   해당 프로그램 실행 하위 폴더에 로그 파일이 있는지 검사
 sLogName := copy(Application.ExeName,1,length(Application.ExeName)-4) + '.log';  //실행화일명.log ,실행화일과 동일디렉토리
 if FileExists( sLogName ) then           //로그파일이 존재하면 프로그램종료
 Application.Terminate
  else
end;


procedure TForm1.FormShow(Sender: TObject);
var
Ban : String;
voice:OLEVariant;
 Winhttp:IWinHttpRequest;
begin
Winhttp := coWinHttpRequest.Create;
try
Winhttp.Open('GET','http://crcserver.dothome.co.kr/autoipban/IP.php', false);
WinHttp.Send(EmptyParam);
Ban := (Winhttp.ResponseText);
Winhttp.Open('GET','http://crcserver.dothome.co.kr/IPBan.txt', false);
WinHttp.Send(EmptyParam);
if(AnsiPos((Ban), Winhttp.ResponseText) <> 0)then
begin
application.Terminate;
end
finally
end;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
if CheckProcess('cheatengine-x86_64.exe') then
begin
    Button1.Click;
    Button4.Click;
    Application.Terminate;
end;

if CheckProcess('Cheat Engine.exe') then
begin
    Button1.Click;
    Button4.Click;
    Application.Terminate;
end;

if CheckProcess('cheatengine-i386.exe') then
begin
    Button1.Click;
    Button4.Click;
    Application.Terminate;
end;

if CheckProcess('Kernelmoduleunloader.exe') then
begin
    Button1.Click;
    Button4.Click;
    Application.Terminate;
end;

if CheckProcess ('Fiddler.exe') then
begin
    Button1.Click;
    Button4.Click;
    Application.Terminate;
end;

if CheckProcess('x32dbg.exe') then
begin
    Button1.Click;
    Button4.Click;
    Application.Terminate;
end;

if CheckProcess('x64dbg.exe') then
begin
    Button1.Click;
    Button4.Click;
    Application.Terminate;
end;

if CheckProcess('x96dbg.exe') then
begin
    Button1.Click;
    Button4.Click;
    Application.Terminate;
end;

if CheckProcess('ollydbg.exe') then
begin
    Button1.Click;
    Button4.Click;
    Application.Terminate;
end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
If DebuggerPresent = True Then
Begin
    Button1.Click;
    Button4.Click;
Application.Terminate;
End;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
  var
 Winhttp:IWinHttpRequest;
 Serial : Integer;
 AA: String;
  begin
    Serial := GetHDSerialNumber;
    AA := Format ('%4X-%4X', [LongRec(Serial).hi, LongRec(Serial).lo]);
  begin
    try
    Winhttp := coWinHttpRequest.Create;
    Winhttp.Open('GET','http://crcserver.dothome.co.kr/ban.txt', false);
    Winhttp.send('');

      if not(AnsiPos((AA), Winhttp.ResponseText) <> 0)then
      begin
        SmoothComponent('HWIDBAN',200);
        timer3.Enabled :=false;
      end else
        begin
          Application.Terminate;
        end;

          except
    end;
  end;
end;


end.
