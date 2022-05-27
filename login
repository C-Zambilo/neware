# neware
uses
   dmbanco,
   TelaInicial;

//botão para acessar
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

  //Verifica o banco de dados de cliente
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
    Form3 := TForm3.Create(Self);
    Form3.circlePedidos.Visible  := False;
    Form3.circleClientes.Visible := False;
    Form3.circleSinc.Visible     := False;
    Form3.Label2.Visible         := False;
    LControl                     := True;
    Application.MainForm := Form3;
    FControl := 'S';
    Form3.btVendedorSincrofiltro;
    Form3.ShowModal;
  end;
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
      if Form3 = nil then
        form3 := TForm3.Create(Self);
      Form3.Show;
      Application.MainForm := Form3;
      //Form3.btSincrofiltro;
    end
    else  //Não encontra nenhum dado e deleta os registros da tabela vendedor
    begin
      DataModule2.qrydeletesSincro.close;
      DataModule2.qrydeletesSincro.SQL.Clear;
      DataModule2.qrydeletesSincro.SQL.ADD('DELETE FROM TAB_VENDEDOR');
      DataModule2.qrydeletesSincro.ExecSQL;
      showmessage('login ou senha incorretos');
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
  end
  else
  begin
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
      DataModule2.qrylogin.ParamByName('log_codigo').AsString:=edit1.text;
      DataModule2.qrylogin.ParamByName('log_logou').AsString:='S';
      DataModule2.qrylogin.ExecSQL;

      if Form3 = nil then
      form3 := TForm3.Create(Self);
      Form3.Show;
      Application.MainForm := Form3;
      //Form3.btSincrofiltro;
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
           IdFTP.ChangeDir('/ftp');
           IdFTP.Get('login.rem','login.rem',true,false)
      end;
     AssignFile(myFile , 'login.rem');
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
      DataModule2.qrylogin.ParamByName('log_codigo').AsString:=edit1.text;
      DataModule2.qrylogin.ParamByName('log_logou').AsString:='S';
      DataModule2.qrylogin.ExecSQL;

      Idftp.Disconnect;

      if Form3 = nil then
        Form3 := TForm3.Create(Self);

      Form3.Show;
      Application.MainForm := Form3;
      Close;
    end;
  end;
end;
end.
