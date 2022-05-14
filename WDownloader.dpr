program WDownloader;

uses
  Vcl.Forms,
  uWDownloader in 'uWDownloader.pas' {frmWDownloader},
  uDM in 'uDM.pas' {DM: TDataModule},
  uClsLogDownload in 'uClsLogDownload.pas',
  uHistoricoDownloads in 'uHistoricoDownloads.pas' {frmHistoricoDownloads},
  util.download in 'util.download.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmWDownloader, frmWDownloader);
  Application.Run;
end.
