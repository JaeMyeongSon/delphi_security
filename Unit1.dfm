object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Crack_Me '#50504#45397#52828#44396#46308
  ClientHeight = 38
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 334
    Height = 13
    Caption = #51656#47928#51060#45208' '#44417#44552#54620#44144#51080#51004#47732' '#51060#51901#51004#47196' '#50672#46973#54616#46972#44396' '#46356#49828#53076#46300' : '#47637'?#2461'
  end
  object Button1: TButton
    Left = 257
    Top = 253
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object WebBrowser1: TWebBrowser
    Left = 641
    Top = 440
    Width = 300
    Height = 150
    TabOrder = 1
    ControlData = {
      4C000000021F0000810F00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Button2: TButton
    Left = 361
    Top = 253
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 745
    Top = 255
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
  object Button3: TButton
    Left = 457
    Top = 253
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 538
    Top = 253
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Edit2: TEdit
    Left = 745
    Top = 282
    Width = 121
    Height = 21
    TabOrder = 6
    Text = 'Edit2'
  end
  object Button5: TButton
    Left = 641
    Top = 253
    Width = 75
    Height = 25
    Caption = 'Button5'
    TabOrder = 7
    OnClick = Button5Click
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 553
    Top = 293
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 601
    Top = 221
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 433
    Top = 349
  end
  object Timer3: TTimer
    OnTimer = Timer3Timer
    Left = 232
    Top = 368
  end
  object crc: TTimer
    OnTimer = crcTimer
    Left = 664
    Top = 408
  end
end
