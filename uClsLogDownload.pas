unit uClsLogDownload; 

interface 

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.Param, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Dialogs,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, SysUtils;

type
TLogDownload = class
	private
		FCodigo: integer;
		FURL: string;
		FDataInicio: TDateTime;
		FDataFim: TDateTime;
		FQry: TFDQuery;
		FDs: TDataSource;
		Conexao : TFDConnection;
    FTrans : TFDTransaction;
		FDsPesquisa: TDataSource;
		FQryPesquisa: TFDQuery;

		procedure SetCodigo(const Value: integer);
		procedure SetURL(const Value: string);
		procedure SetDataInicio(const Value: TDateTime);
		procedure SetDataFim(const Value: TDateTime);
		procedure SetDs(const Value: TDataSource);
		procedure SetQry(const Value: TFDQuery);
		procedure SetDsPesquisa(const Value: tDataSource);
		procedure SetQryPesquisa(const Value: TFDQuery);
		procedure SeTrans(const Value: TFDTransaction);

  published

	public
		constructor Create(Conn: TFDConnection);

  	property Codigo : integer read FCodigo write SetCodigo;
    property URL : string read FURL write SetURL;
    property DataInicio : TDateTime read FDataInicio write SetDataInicio;
    property DataFim : TDateTime read FDataFim write SetDataFim;

    property Qry : TFDQuery read FQry write SetQry;
    property QryPesquisa : TFDQuery read FQryPesquisa write SetQryPesquisa;
    property Ds : TDataSource read FDs write SetDs;
    property DsPesquisa : TDataSource read FDsPesquisa write SetDsPesquisa;
    property Trans : TFDTransaction read FTrans write SeTrans;

    function Selecionar(Ordem: String):Boolean;
    function Inserir : boolean;
    function Alterar : boolean;
    function MaxCodigo: Integer;
end;

implementation { TClientes }

constructor TLogDownload.Create(Conn: TFDConnection);
var
  DB :String;

begin
  DB := ExtractFilePath(ParamStr(0)) + 'LogSistema.db';

	Conexao                   := TFDConnection.Create(nil);;
	Qry                       := TFDQuery.Create(nil);
	Ds                        := TDataSource.Create(nil);
	QryPesquisa               := TFDQuery.Create(nil);
	DsPesquisa                := TDataSource.Create(nil);
  Trans                     := TFDTransaction.Create(nil);

  with Conexao do
  begin
    Connected  :=  false;
    Params.Clear;
    Params.Values['DriverID']  := 'SQLite';
    Params.Values['Database']  := DB;
    Transaction := Trans;
    Connected  :=  true;
  end;

	Qry.Connection            := Conexao;
	QryPesquisa.Connection    := Conexao;
	Ds.DataSet                := Qry;
	DsPesquisa.DataSet        := QryPesquisa;
end;

function TLogDownload.Alterar: boolean;
begin
	with Qry do
	begin
    Close;
    SQL.Text := ' Update LogDownload Set '+
                ' DataFim = :DataFim,'+
                ' Where '+
                ' Codigo = :Codigo';

    ParamByName('Codigo').Value     := FCodigo;
    ParamByName('DataFim').Value    := FDataFim;

		try
			ExecSQL;
			Result := true;
		except
			Result := False;
	   end;
	end;
end;

function TLogDownload.Inserir: boolean;
begin
  with Qry  do
  begin
    Close;
    Sql.text := ' Insert into LogDownload'+
                ' (URL, DataInicio)'+
                ' Values '+
                ' (:URL, :DataInicio)';

    ParamByName('URL').Value         := FURL;
    ParamByName('DataInicio').Value  := FDataInicio;

    try
      ExecSQL;
      result := true;
    except
      result := false;
    end;
  end;
end;

function TLogDownload.MaxCodigo: Integer;
begin
  with Qry  do
  begin
    Close;
    Sql.text := ' Select Max(Codigo) as Codigo from LogDownload';

    try
      Open;
      result := Qry.FieldByName('Codigo').AsInteger;
    except
      result := 0;
    end;
  end;
end;


function TLogDownload.Selecionar(Ordem: String):Boolean;
begin
  with QryPesquisa do
  begin
    Close;
    Sql.Text := ' Select * from LogDownload where 1 = 1 ';

    if Ordem <> '' then
      sql.add(' Order by ' + Ordem);

    try
      Open;

      if not eof then
        Result := true
      else
        Result := false;
    except
      Result := false;
    end;
  end;
end;

procedure TLogDownload.SetDs(const Value: TDataSource);
begin
	FDs := Value;
end;

procedure TLogDownload.SetDsPesquisa(const Value: tDataSource);
begin
	FDsPesquisa := Value;
end;

procedure TLogDownload.SetCodigo(const Value: integer);
begin
	FCodigo := Value;
end;

procedure TLogDownload.SetURL(const Value: string);
begin
	FURL := Value;
end;

procedure TLogDownload.SetDataInicio(const Value: TDateTime);
begin
	FDataInicio := Value;
end;

procedure TLogDownload.SetDataFIm(const Value: TDateTime);
begin
	FDataFim := Value;
end;

procedure TLogDownload.SetQry(const Value: TFDQuery);
begin
	FQry := Value; 
end;

procedure TLogDownload.SetQryPesquisa(const Value: TFDQuery);
begin
	FQryPesquisa := Value; 
end;

procedure TLogDownload.SeTrans(const Value: TFDTransaction);
begin
	FTrans := Value;
end;

end.