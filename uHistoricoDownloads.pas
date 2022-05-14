unit uHistoricoDownloads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Buttons, uClsLogDownload;

type
  TfrmHistoricoDownloads = class(TForm)
    grdHistoricoDownload: TDBGrid;
    btnFechar: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    { Private declarations }
    var
      LogSist : TLogDownload;

    procedure CarregaGridHistoricoDownload;

  public
    { Public declarations }
  end;

var
  frmHistoricoDownloads: TfrmHistoricoDownloads;

implementation

{$R *.dfm}

procedure TfrmHistoricoDownloads.FormShow(Sender: TObject);
var
  dsHistoricoDownload : TDataSource;
begin
  dsHistoricoDownload.DataSet     := LogSist.QryPesquisa;
  grdHistoricoDownload.DataSource := dsHistoricoDownload;

  LogSist.Selecionar('');
end;

procedure TfrmHistoricoDownloads.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmHistoricoDownloads.CarregaGridHistoricoDownload;
begin

end;

end.
