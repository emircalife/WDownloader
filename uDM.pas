unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.Param, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Dialogs,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite;

type
  TDM = class(TDataModule)
    Trans: TFDTransaction;
    Conn: TFDConnection;
    SchAdapter: TFDSchemaAdapter;
    qryListaDownloads: TFDQuery;
    qryManutDownloads: TFDQuery;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
var
  DB :String;

begin
  DB := ExtractFilePath(ParamStr(0)) + 'LogSistema.db';

  if not FileExists(DB) then
  begin
    try
      with Conn do
      begin
        Connected  :=  false;
        Params.Clear;
        Params.Values['DriverID']  := 'SQLite';
        Params.Values['Database']  := DB;
        Transaction := Trans;
        Connected  :=  true;
      end;

     qryManutDownloads.SQL.Clear();
     qryManutDownloads.SQL.Add('create table if not exists LogDownload '+
                                ' (Codigo INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '+
                                ' URL Varchar(600) NOT NULL, '+
                                ' DataInicio Date NOT NULL, '+
                                ' DataFim Date)');
      qryManutDownloads.ExecSQL;
      Conn.Close;
    except
      ShowMessage('Não foi possível criar: ' + DB);
    end;

  end;
end;

end.
