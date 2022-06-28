interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.StdCtrls, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, FireDAC.Comp.UI, FMX.Objects, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdFTP,  System.IOUtils,

  {$IF DEFINED(ANDROID)}
  System.Permissions,
  Androidapi.Helpers,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Telephony,
  Androidapi.JNI.App,
  Androidapi.JNI.OS,
  {$ENDIF}

  FMX.Layouts;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    rectCabecalho: TRectangle;
    Rectangle1: TRectangle;
    Rectangle3: TRectangle;
    Edit1: TEdit;
    Rectangle4: TRectangle;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    rectAcessar: TRectangle;
    Label3: TLabel;
    IdFTP: TIdFTP;
    procedure Rectangle1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
{$IFDEF ANDROID}
    PermissaoReadStorage,
    PermissaoWriteStorage: String;
    procedure DisplayMessageLibrary(Sender: TObject;
    const APermissions: TArray<string>;
    const APostProc: TProc);
    procedure LibraryPermissionRequestResult(Sender: TObject;
    const APermissions: TArray<string>;
    const AGrantResults: TArray<TPermissionStatus>);
    procedure Baixar_ViaIdFTP_WINDOWS;
    procedure Baixar_ViaIdFTP_ANDROID;
    {$ENDIF}
    procedure btVendedorSincrofiltro;
    { Private declarations }
  public
    { Public declarations }
    {$IFDEF ANDROID}
    f_Atribuida_PermissaoReadStorage,
    f_Atribuida_PermissaoWriteStorage: Boolean;
    {$ENDIF}
    LControl : boolean;
    FControl : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.SmXhdpiPh.fmx ANDROID}


uses
   dmbanco, UnitTelaInicial;

{$IFDEF ANDROID}

procedure TForm1.DisplayMessageLibrary(Sender: TObject;
  const APermissions: TArray<string>;
  const APostProc: TProc);
begin
  ShowMessage('O app precisa acessar seu dispositivo');
end;

procedure TForm1.LibraryPermissionRequestResult(
  Sender: TObject; const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  // 2 Permissoes: READ_EXTERNAL_STORAGE e WRITE_EXTERNAL_STORAGE
  if (Length(AGrantResults) = 2)
  and (AGrantResults[0] = TPermissionStatus.Granted)
  and (AGrantResults[1] = TPermissionStatus.Granted) then
  begin
    f_Atribuida_PermissaoReadWriteStorage := True;
  end
  else
    ShowMessage('Você não tem permissão para acessar');
end;

{$ENDIF}

procedure TForm1.Baixar_ViaIdFTP_WINDOWS;
begin
  {$IF Defined(MSWINDOWS)}
  IdFTP1.Get('/ftp/vdf.rem', 'C:\temp\vdf.rem', true, false);
  if not DirectoryExists(ExtractFilePath (Application.ExeName)) then
    ForceDirectories(ExtractFilePath (Application.ExeName));
  {$ENDIF}
end;
DisplayMessageLibrary);

procedure TForm1.Baixar_ViaIdFTP_ANDROID;
begin
  {$IF DEFINED(ANDROID)}
  if f_Atribuida_PermissaoReadWriteStorage then
    IdFTP1.Get('/ftp/vdf.rem', TPath.Combine(TPath.GetTempPath, 'vdf.rem'), true, false);
  {$ENDIF}
end;

//botão para acessar
{$IFDEF ANDROID}

procedure TForm1.LibraryPermissionRequestResult(
  Sender: TObject; const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  // 2 Permissoes: READ_EXTERNAL_STORAGE e WRITE_EXTERNAL_STORAGE
  if (Length(AGrantResults) = 2)
  and (AGrantResults[0] = TPermissionStatus.Granted)
  and (AGrantResults[1] = TPermissionStatus.Granted) then
  begin
    f_Atribuida_PermissaoReadStorage   := True;
    f_Atribuida_PermissaoWriteStorage  := True;
  end
  else
    ShowMessage('Você não tem permissão para acessar');
end;

{$ENDIF}

procedure TForm1.Button1Click(Sender: TObject);
var
  I: Integer;
  Lista: String;
begin
  //  TESTE
  Lista := '';
  if not IdFTP.Connected then
  begin
      IdFTP.Host := 'newarettt.ddns.net';
      IdFTP.Username := 'neware';
      IdFTP.Password := 'V8.';
      IdFTP.Port :=21;
      IdFTP.Connect;
  end;
  if IdFTP.Connected then
  begin
    {$IF Defined(MSWINDOWS)}

      if not DirectoryExists('C:\temp\') then
        ForceDirectories('C:\temp\');

      IdFTP.Get('/ftp/vdf.rem', 'C:\temp\vdf.rem', true, false);
    {$ENDIF}

    {$IF DEFINED(ANDROID)}
      try
        PermissionsService.RequestPermissions([PermissaoReadStorage, PermissaoWriteStorage], nil, nil);
      except
        ShowMessage('Não foi possível estabelecer permissão para sua Câmera');
      end;

      if f_Atribuida_PermissaoReadStorage and f_Atribuida_PermissaoWriteStorage then
      begin
        IdFTP.Get('/ftp/vdf.rem', TPath.Combine(TPath.GetTempPath, 'vdf.rem'), true, false);
      end;
   {$ENDIF}
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  {$IFDEF ANDROID}
  PermissaoReadStorage   := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  PermissaoWriteStorage  := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
  {$ENDIF}
end;

procedure TForm1.Rectangle1Click(Sender: TObject);
    var   gravar :TStringList;
    var   myFile : TextFile;
    var    n1 : String ;
begin
  //valida os campos de login
  if edit1.Text='' then
  begin
    ShowMessage('Preencha o campo Login');
    exit;
  end;
  if edit2.Text='' then
  begin
    ShowMessage('Preencha o campo senha');
    exit;
  end;

  //Verifica o banco de dados de vendedor
  DataModule2.qrylogin.Close;
  DataModule2.qrylogin.SQL.Clear;
  DataModule2.qrylogin.SQL.ADD('SELECT * FROM tab_vendedor');
  DataModule2.qrylogin.open;
  //se não encontrar nenhum registro, faz a sincronização da tabela vendedor.
  if DataModule2.qrylogin.EOF then
  begin
    ShowMessage('Nenhum registro encontrado no banco de dados, a sincronização sera iniciada!');
  //verifica os dados inseridos
    DataModule2.qrylogin.Close;
    DataModule2.qrylogin.SQL.Clear;
    DataModule2.qrylogin.SQL.ADD('SELECT * FROM tab_vendedor WHERE ven_cod =:User and ven_senha =:Pass' );
    DataModule2.qrylogin.ParamByName('User').AsString := edit1.Text;
    DataModule2.qrylogin.ParamByName('Pass').AsString := edit2.Text;
    DataModule2.qrylogin.open;
    //Faz a sincronização
    application.CreateForm(TForm2, Form2);
    Form2.circlePedidos.Visible  := False;
    Form2.circleClientes.Visible := False;
    Form2.circleSinc.Visible     := False;
    Form2.Label2.Visible         := False;
    LControl                     := True;
    Application.MainForm := Form2;
    FControl := 'S';
    Form2.btVendedorSincrofiltro;
    Form2.Show;

    //SE O LOGIN COLOCADO EXISTIR FAZ O LOGIN, SENÃO DELETA OS DADOS DE VENDEDOR POR SEGURANÇA
    DataModule2.qrylogin.Close;
    DataModule2.qrylogin.SQL.Clear;
    DataModule2.qrylogin.SQL.ADD('SELECT * FROM tab_vendedor WHERE ven_cod =:User and ven_senha =:Pass' );
    DataModule2.qrylogin.ParamByName('User').AsString := edit1.Text;
    DataModule2.qrylogin.ParamByName('Pass').AsString := edit2.Text;
    DataModule2.qrylogin.open;
    //encontra o login e sincroniza tudo
    if  DataModule2.qrylogin.recordcount >= 1 then
    begin
      //ativa o login
      DataModule2.qrylogin.Close;
      DataModule2.qrylogin.SQL.Clear;
      DataModule2.qrylogin.SQL.ADD('SELECT * FROM  TAB_LOGIN WHERE log_ativo LIKE :REM');
      DataModule2.qrylogin.ParamByName('REM').Value := 'S';
      DataModule2.qrylogin.Open;
      if Form2 = nil then
      application.CreateForm(TForm2, Form2);
      Form2.Show;
      Application.MainForm := Form2;
      Form2.btSincrofiltro;
      form1.close;
      //apaga os demais vendedores
      DataModule2.qryvendedor.Close;
      DataModule2.qryvendedor.SQL.Clear;
      DataModule2.qryvendedor.SQL.ADD('DELETE FROM tab_vendedor WHERE ven_cod <> :User');
      DataModule2.qryvendedor.ParamByName('User').AsString := edit1.Text;
      DataModule2.qryvendedor.EXECSQL;

    end
    else  //Não encontra nenhum dado e deleta os registros da tabela vendedor
    begin
      DataModule2.qrydeletesSincro.close;
      DataModule2.qrydeletesSincro.SQL.Clear;
      DataModule2.qrydeletesSincro.SQL.ADD('DELETE FROM TAB_VENDEDOR');
      DataModule2.qrydeletesSincro.ExecSQL;
      showmessage('login ou senha incorretos');
    end;
  end;

  DataModule2.qrylogin.Close;
  DataModule2.qrylogin.SQL.Clear;
  DataModule2.qrylogin.SQL.ADD('SELECT * FROM tab_vendedor WHERE ven_cod =:User and ven_senha =:Pass' );
  DataModule2.qrylogin.ParamByName('User').AsString := edit1.Text;
  DataModule2.qrylogin.ParamByName('Pass').AsString := edit2.Text;
  DataModule2.qrylogin.open;

  if DataModule2.qrylogin.RecordCount > 0 then
  begin
    //ativa o login
    DataModule2.qrylogin.Close;
    DataModule2.qrylogin.SQL.Clear;
    DataModule2.qrylogin.SQL.ADD('SELECT * FROM  TAB_LOGIN WHERE log_ativo LIKE :REM');
    DataModule2.qrylogin.ParamByName('REM').Value := 'S';
    DataModule2.qrylogin.Open;
    ///////////////////////////////////////////////////////////////////////////////////
    if Form2 = nil then
    application.CreateForm(TForm2, Form2);
    Form2.Show;
    Application.MainForm := Form2;
    //Form2.btSincrofiltro;
    form1.close;
    //apaga os demais vendedores
    DataModule2.qryvendedor.Close;
    DataModule2.qryvendedor.SQL.Clear;
    DataModule2.qryvendedor.SQL.ADD('DELETE FROM tab_vendedor WHERE ven_cod <> :User');
    DataModule2.qryvendedor.ParamByName('User').AsString := edit1.Text;
    DataModule2.qryvendedor.EXECSQL;
  end
  else
  begin
    showmessage('login ou senha incorretos');
    Exit;
  end;
     if DataModule2.qrylogin.Locate('log_codigo', edit1.Text, [loCaseInsensitive ]) and
        DataModule2.qrylogin.Locate('log_senha' , edit2.Text, [loCaseInsensitive ]) then
      begin
      DataModule2.qrylogin.Close;
      DataModule2.qrylogin.SQL.Clear;
      DataModule2.qrylogin.SQL.ADD('SELECT * FROM  TAB_LOGIN');
      DataModule2.qrylogin.Open;
      DataModule2.qrylogin.Close;
      DataModule2.qrylogin.SQL.Clear;
      DataModule2.qrylogin.SQL.ADD('UPDATE TAB_LOGIN SET log_logou=:log_logou WHERE log_codigo=:log_codigo;');
       DataModule2.qrylogin.SQL.ADD('DELETE FROM TAB_LOGIN WHERE log_logou is Null');
      DataModule2.qrylogin.ParamByName('log_codigo').AsString:=edit1.text;
      DataModule2.qrylogin.ParamByName('log_logou').AsString:='S';
      DataModule2.qrylogin.ExecSQL;
     end
   ELSE
    gravar:=Tstringlist.Create;
       try
          if not IdFTP.Connected then
          begin
              IdFTP.Host := 'newarettt.ddns.net';
              IdFTP.Username := 'neware';
              IdFTP.Password := 'V8.';
              IdFTP.Port :=21;
              IdFTP.Connect;
          end;
      except
            on E:Exception do
            begin
              ShowMessage('Não foi possível realizar o acesso');
               exit;
            end;
      end;
  begin
    if IdFTP.Connected then
    begin
      {$IF Defined(MSWINDOWS)}

        if not DirectoryExists('C:\temp\') then
          ForceDirectories('C:\temp\');

        IdFTP.Get('/ftp/vdf.rem', 'C:\temp\vdf.rem', true, false);
      {$ENDIF}

      {$IF DEFINED(ANDROID)}
        try
          PermissionsService.RequestPermissions([PermissaoReadStorage, PermissaoWriteStorage], nil, nil);
        except
          ShowMessage('Não foi possível estabelecer permissão para sua Câmera');
        end;

        if f_Atribuida_PermissaoReadStorage and f_Atribuida_PermissaoWriteStorage then
        begin
          IdFTP.Get('/ftp/vdf.rem', TPath.Combine(TPath.GetTempPath, 'vdf.rem'), true, false);
        end;
     {$ENDIF}
    end;

    try
       AssignFile(myFile , 'vdf.rem');
       Reset(myFile);
       gravar.Delimiter := '|';
       gravar.StrictDelimiter := true;
       DataModule2.qrylogin.Close;
       DataModule2.qrylogin.SQL.Clear;
       DataModule2.qrylogin.SQL.ADD('DELETE FROM TAB_LOGIN');
       DataModule2.qrylogin.ExecSQL;
       while not Eof(myFile)  do
       begin
         ReadLn(myFile,n1);
         gravar.DelimitedText := n1;

        if gravar[0] = ('EVENDEDOR') then
           with DataModule2 do
           begin
             qrylogin.Close;
             qrylogin.SQL.Clear;
             qrylogin.SQL.ADD('Insert Into TAB_LOGIN (log_codigo, log_nome, log_ativo, log_senha)');
             qrylogin.SQL.ADD('values (:log_codigo, :log_nome, :log_ativo, :log_senha)');
             qrylogin.ParamByName ('log_codigo').AsString:=gravar[1];
             qrylogin.ParamByName ('log_nome').AsString:=gravar[2];
             qrylogin.ParamByName ('log_senha').AsString:=gravar[6];
             qrylogin.ParamByName ('log_ativo').AsString:=gravar[7];
             qrylogin.ExecSql
          end;
       end;

      DataModule2.qrylogin.Close;
      DataModule2.qrylogin.SQL.Clear;
      DataModule2.qrylogin.SQL.ADD('SELECT * FROM  TAB_LOGIN WHERE log_ativo LIKE :REM');
      DataModule2.qrylogin.ParamByName('REM').Value := 'S';
      DataModule2.qrylogin.Open;

     if DataModule2.qrylogin.Locate('log_codigo', edit1.Text, [loCaseInsensitive ]) and
     DataModule2.qrylogin.Locate('log_senha', edit2.Text, [loCaseInsensitive ]) then
      begin
       DataModule2.qrylogin.Close;
        DataModule2.qrylogin.SQL.Clear;
        DataModule2.qrylogin.SQL.ADD('SELECT * FROM  TAB_LOGIN');
        DataModule2.qrylogin.Open;
        DataModule2.qrylogin.Close;
        DataModule2.qrylogin.SQL.Clear;
        DataModule2.qrylogin.SQL.ADD('UPDATE TAB_LOGIN SET log_logou=:log_logou WHERE log_codigo=:log_codigo;');
        DataModule2.qrylogin.SQL.ADD('DELETE FROM TAB_LOGIN WHERE log_logou <> log_logou');
        DataModule2.qrylogin.ParamByName('log_codigo').AsString:=edit1.text;
        DataModule2.qrylogin.ParamByName('log_logou').AsString:='S';
        DataModule2.qrylogin.ExecSQL;
      Idftp.Disconnect;
        if Form2 = nil then
           Form2 := TForm2.Create(Self);
        Form2.Show;
        Application.MainForm := Form2;
        Close;
      end;
    finally
    Closefile(myfile);
    end;
  end;
end;

procedure TForm1.btVendedorSincrofiltro;
    var   gravar :TStringList;
    var   myFile : TextFile;
    var    n1 : String ;
    var   myFile2:TextFile;
begin
  begin

    gravar:=Tstringlist.Create;
    if not IdFTP.Connected then
    begin
      IdFTP.Host := 'newarettt.ddns.net';
      IdFTP.Username := 'neware';
      IdFTP.Password := 'V8.';
      IdFTP.Port :=21;
      IdFTP.Connect;
    end
    ELSE
    begin
      ShowMessage('Não foi possível realizar a sincronização');
    end;

  if IdFTP.Connected then
  begin
    {$IF Defined(MSWINDOWS)}

      if not DirectoryExists('C:\temp\') then
        ForceDirectories('C:\temp\');

      IdFTP.Get('/ftp/vdf.rem', 'C:\temp\vdf.rem', true, false);
    {$ENDIF}

    {$IF DEFINED(ANDROID)}
      try
        PermissionsService.RequestPermissions([PermissaoReadStorage, PermissaoWriteStorage], nil, nil);
      except
        ShowMessage('Não foi possível estabelecer permissão para sua Câmera');
      end;

      if f_Atribuida_PermissaoReadStorage and f_Atribuida_PermissaoWriteStorage then
      begin
        IdFTP.Get('/ftp/vdf.rem', TPath.Combine(TPath.GetTempPath, 'vdf.rem'), true, false);
      end;
   {$ENDIF}
  end;

   try
    // AssignFile(myFile , '/vdf.rem');
     AssignFile(myFile , 'vdf.rem');
     Reset(myFile);
     gravar.Delimiter := '|';
     gravar.StrictDelimiter := true;
     DataModule2.qrydeletesSincro.Active:=false;
     DataModule2.qrydeletesSincro.SQL.Clear;
     DataModule2.qrydeletesSincro.SQL.ADD('DELETE FROM TAB_VENDEDOR');
     DataModule2.qrydeletesSincro.ExecSQL;

     while not Eof(myFile)  do
     begin
           ReadLn(myFile,n1);
           gravar.DelimitedText := n1;

           if gravar[0] = ('EVENDEDOR') then
           with DataModule2 do
           begin
             qryvendedor.close;
             qryvendedor.SQL.Clear;
             qryvendedor.sql.Add('Insert Into TAB_VENDEDOR (ven_cod, ven_nome, ven_telefone, ven_ativo, ven_celular, ven_senha, ven_ativoapp)');
             qryvendedor.sql.Add('values (:ven_cod, :ven_nome, :ven_telefone, :ven_ativo, :ven_celular, :ven_senha, :ven_ativoapp)');
             qryvendedor.ParamByName ('ven_cod').AsString:=gravar[1];
             qryvendedor.ParamByName ('ven_nome').AsString:=gravar[2];
             qryvendedor.ParamByName ('ven_telefone').AsString:=gravar[3];
             qryvendedor.ParamByName ('ven_ativo').AsString:=gravar[4];
             qryvendedor.ParamByName ('ven_celular').AsString:=gravar[5];
             qryvendedor.ParamByName ('ven_senha').AsString:=gravar[6];
             qryvendedor.ParamByName ('ven_ativoapp').AsString:=gravar[7];
             qryvendedor.ExecSql
           end;
      end;
      DataModule2.qrysincro.close;
      DataModule2.qrysincro.SQL.Clear;
      DataModule2.qrysincro.SQL.ADD('SELECT * FROM  TAB_SINCRO');
      DataModule2.qrysincro.open;

      if not DataModule2.qrysincro.Locate('sn_sincro','S', [loCaseInsensitive ])  then
      begin
       var currentdate:TDateTime;
       currentdate:= now;
       DataModule2.qrysincro.Active:=false;
       DataModule2.qrysincro.SQL.Clear;
       DataModule2.qrysincro.sql.Add('Insert Into TAB_SINCRO (sn_sincro, sn_data) VALUES (:sn_sincro, :sn_data)');
       DataModule2.qrysincro.ParamByName ('sn_sincro').AsString:='S';
       DataModule2.qrysincro.ParamByName ('sn_data').AsString:=datetostr(currentdate);
       DataModule2.qrysincro.ExecSql;
     end;
    //verificar banco e gerar .rem
    finally
    Closefile(myfile);
    end;
end;
end;
end.
