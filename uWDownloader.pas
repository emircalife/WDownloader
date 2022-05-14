unit uWDownloader;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMan, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Stan.Param, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent, IdAntiFreezeBase,
  IdAntiFreeze, uClsLogDownload, uDM, Vcl.ComCtrls,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdAuthentication, uHistoricoDownloads, util.download;

type
  TfrmWDownloader = class(TForm)
    dlgSalvar: TSaveDialog;
    lblURL: TLabel;
    edtURL: TEdit;
    btnIniciarDownload: TBitBtn;
    btnFechar: TBitBtn;
    pbprogress: TProgressBar;
    lblStatus: TLabel;
    btnExibirMensagem: TBitBtn;
    btnPararDownload: TBitBtn;
    btnExibirHistoricoDownloads: TBitBtn;
    IdHTTP: TIdHTTP;
    IdAntiFreeze: TIdAntiFreeze;
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnIniciarDownloadClick(Sender: TObject);
    procedure btnPararDownloadClick(Sender: TObject);
    procedure btnExibirMensagemClick(Sender: TObject);
    procedure btnExibirHistoricoDownloadsClick(Sender: TObject);
    procedure WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure IdHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
  private
    { Private declarations }
    var
      QtdeDownloadsAtivos : integer;
      LogSist : TLogDownload;
      Conn : TFDConnection;
      IdHTTPProgress : TIdHTTPProgress;

    function ValidarLink(link:String):String;
    function RetornaPorcentagem(ValorMaximo, ValorAtual: real): string;
    function RetornaKiloBytes(ValorAtual: real): string;
  public
    { Public declarations }
  end;

  DownloadThread = class (TThread)
    private
      URL, fileName : String;
    public constructor Create(URL, fileName : String);
      procedure Execute; override;
    end;
var
  frmWDownloader: TfrmWDownloader;

implementation

{$R *.dfm}

procedure TfrmWDownloader.btnIniciarDownloadClick(Sender: TObject);
var
  cLink : String;
begin
  if Trim(edtURL.Text) = '' then
  begin
    Application.MessageBox('Digite uma URL para baixar o arquivo desejado!', 'Atenção', MB_OK);
  end
  else
  begin
    cLink := ValidarLink(edtURL.Text);

    LogSist.URL         := cLink;
    LogSist.DataInicio  := now;

    if not LogSist.Inserir then
    begin
      Application.MessageBox('Falha na inclusão da URL na fila de download!', 'Atenção', MB_OK);
    end
    else
    begin
      try
        pbprogress.Visible          := True;
        lblStatus.Visible           := True;

        DownloadThread.Create(edtUrl.Text, dlgSalvar.FileName + ExtractFileExt(edtUrl.Text));
      except
        ShowMessage('Erro no download do arquivo');
      end;
    end;
  end;
end;

procedure TfrmWDownloader.btnPararDownloadClick(Sender: TObject);
begin
  IdHTTPProgress.Disconnect;
end;

procedure TfrmWDownloader.btnExibirHistoricoDownloadsClick(Sender: TObject);
begin
  frmHistoricoDownloads := TfrmHistoricoDownloads.Create(Self);
  frmHistoricoDownloads.ShowModal;
  FreeAndNil(frmHistoricoDownloads);
end;

procedure TfrmWDownloader.btnExibirMensagemClick(Sender: TObject);
begin
  Application.MessageBox(PChar('Download atual em ' + Trim(IntToStr(pbprogress.Position)) + '%'), 'Atenção', MB_OK);
end;

procedure TfrmWDownloader.btnFecharClick(Sender: TObject);
begin
  if QtdeDownloadsAtivos > 0 then
  begin
    if MessageDlg('Existe um download em andamento, deseja interrompe-lo?', mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      IdHTTPProgress.Disconnect;
      Application.Terminate;
    end;
  end
  else
    Application.Terminate;
end;

procedure TfrmWDownloader.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if QtdeDownloadsAtivos > 0 then
  begin
    if MessageDlg('Existe um download em andamento, deseja interrompe-lo?', mtWarning, [mbYes, mbNo], 0) = mrYes then
      Application.Terminate
    else
      CanClose := False;
  end
  else
    Application.Terminate;
end;

procedure TfrmWDownloader.FormCreate(Sender: TObject);
begin
  QtdeDownloadsAtivos := 0;
  Conn                := TFDConnection.Create(Self);
  LogSist             := TLogDownload.Create(Conn);
  IdHTTPProgress      := TIdHTTPProgress.Create(Self);
end;

procedure TfrmWDownloader.IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  pbprogress.Position     := AWorkCount;

  lblStatus.Caption       := 'Baixando ... ' + RetornaKiloBytes(AWorkCount);
  frmWDownloader.Caption  := 'Download em ... ' + RetornaPorcentagem(pbprogress.Max, AWorkCount);
end;

procedure TfrmWDownloader.IdHTTPWorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  pbprogress.Max := AWorkCountMax;
end;

procedure TfrmWDownloader.IdHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  LogSist.DataFim := now;
  LogSist.Codigo  := LogSist.MaxCodigo();

  if LogSist.Alterar then
  begin
    pbprogress.Position         := 0;

    frmWDownloader.Caption      := 'Finalizado ...';
    lblStatus.Caption           := 'Download Finalizado ...';

    pbprogress.Visible          := false;
  end;
end;

function TfrmWDownloader.ValidarLink(link:String):String;
var
  cLink : String;
begin
  cLink :=  Trim(link);

  if not (copy(link, 0, 7) = 'http://') and not (Copy(link, 0, 8) = 'https://') then
    cLink := 'http://' + link;

  result := cLink;
end;

function TfrmWDownloader.RetornaPorcentagem(ValorMaximo, ValorAtual: real): string;
var
  resultado: Real;
begin
  resultado := ((ValorAtual * 100) / ValorMaximo);
  Result    := FormatFloat('0%', resultado);
end;

function TfrmWDownloader.RetornaKiloBytes(ValorAtual: real): string;
var
  resultado : real;
begin
  resultado := ((ValorAtual / 1024) / 1024);
  Result    := FormatFloat('0.000 KBs', resultado);
end;

procedure TfrmWDownloader.WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  LogSist.DataFim := now;
  LogSist.Codigo  := LogSist.MaxCodigo();

  if LogSist.Alterar then
  begin
    pbprogress.Position         := 0;

    frmWDownloader.Caption      := 'Finalizado ...';
    lblStatus.Caption           := 'Download Finalizado ...';

    pbprogress.Visible          := false;
  end;
end;

constructor DownloadThread.Create (URL, fileName : string);
begin
  inherited Create(false);
  self.URL := URL;
  self.fileName := fileName;
end;

procedure DownloadThread.Execute;
var
  downFile: TFileStream;
begin
  downFile := TFileStream.Create(self.fileName, fmCreate);
  try
    frmWDownloader.IdHTTP.Get(self.URL, downFile);
   except
    ShowMessage('Erro no Download do Arquivo!');
   end;
   downFile.Free;
end;

end.
