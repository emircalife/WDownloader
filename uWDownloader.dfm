object frmWDownloader: TfrmWDownloader
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'WDownloader'
  ClientHeight = 135
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  DesignSize = (
    554
    135)
  TextHeight = 15
  object lblURL: TLabel
    Left = 8
    Top = 25
    Width = 21
    Height = 15
    Anchors = []
    Caption = 'URL'
  end
  object lblStatus: TLabel
    Left = 8
    Top = 50
    Width = 58
    Height = 15
    Caption = 'Baixando...'
  end
  object edtURL: TEdit
    Left = 35
    Top = 21
    Width = 399
    Height = 23
    Anchors = []
    TabOrder = 0
    Text = 
      'https://ubuntu.com/download/desktop/thank-you?version=22.04&arch' +
      'itecture=amd64'
  end
  object btnIniciarDownload: TBitBtn
    Left = 440
    Top = 20
    Width = 106
    Height = 25
    Anchors = []
    Caption = 'Iniciar &Download'
    TabOrder = 1
    OnClick = btnIniciarDownloadClick
  end
  object btnFechar: TBitBtn
    Left = 471
    Top = 102
    Width = 75
    Height = 25
    Anchors = []
    Caption = 'Fecha&r'
    TabOrder = 6
    OnClick = btnFecharClick
  end
  object pbprogress: TProgressBar
    Left = 35
    Top = 66
    Width = 511
    Height = 17
    Anchors = []
    TabOrder = 2
    TabStop = True
  end
  object btnExibirMensagem: TBitBtn
    Left = 247
    Top = 102
    Width = 106
    Height = 25
    Anchors = []
    Caption = '&Exibir mensagem'
    TabOrder = 4
    OnClick = btnExibirMensagemClick
  end
  object btnPararDownload: TBitBtn
    Left = 359
    Top = 102
    Width = 106
    Height = 25
    Anchors = []
    Caption = '&Parar Download'
    TabOrder = 5
    OnClick = btnPararDownloadClick
  end
  object btnExibirHistoricoDownloads: TBitBtn
    Left = 35
    Top = 102
    Width = 169
    Height = 25
    Anchors = []
    Caption = '&Exibir hist'#243'rico de downloads'
    TabOrder = 3
    OnClick = btnExibirHistoricoDownloadsClick
  end
  object dlgSalvar: TSaveDialog
    Left = 192
    Top = 48
  end
  object IdHTTP: TIdHTTP
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
    Left = 384
    Top = 48
  end
  object IdAntiFreeze: TIdAntiFreeze
    Left = 304
    Top = 48
  end
end
