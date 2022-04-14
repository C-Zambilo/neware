# neware
//BOTÃO PARA SINCRONIZAÇÃO
procedure TForm3.btSincrofiltro;

    var   gravar :TStringList;
    var   myFile : TextFile;
    var    n1 : String ;
    var   myFile2:TextFile;
begin
  gravar:=Tstringlist.Create;
  showmessage('iniciando a sincronização');
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
     //    ELSE
          begin
            ShowMessage('Não foi possível realizar a sincronização');
          end;
  end;

  begin
       if IdFTP.Connected then
       begin
           IdFTP.ChangeDir('/ftp');
           IdFTP.Get('vdf.rem','vdf.rem',true,false)
       end;

     AssignFile(myFile , 'vdf.rem');
     Reset(myFile);
         gravar.Delimiter := '|';
         gravar.StrictDelimiter := true;
           DataModule2.qrydeletesSincro.Active:=false;
           DataModule2.qrydeletesSincro.SQL.Clear;
           DataModule2.qrydeletesSincro.SQL.ADD('DELETE FROM TAB_LOGIN;'+
           'DELETE FROM TAB_EMPRESA;'+
           'DELETE FROM TAB_FORMA;'+
           'DELETE FROM TAB_ESTOQUE;'+
           'DELETE FROM TAB_CLIENTE;'+
           'DELETE FROM TAB_CONDICAO');
           DataModule2.qrydeletesSincro.ExecSQL;

     while not Eof(myFile)  do
     begin
         ReadLn(myFile,n1);
         gravar.DelimitedText := n1;

         if gravar[0] = ('EEMPRESA') then
         with DataModule2 do
         begin
           qryempresa.Active:=false;
           qryempresa.SQL.Clear;
           qryempresa.SQL.ADD('Insert Into TAB_EMPRESA (emp_codigo, emp_razao)');
           qryempresa.SQL.ADD('values (:id , :razao )');
           qryempresa.ParamByName ('id').AsString:=gravar[1];
           qryempresa.ParamByName ('razao').AsString:=gravar[2];
           qryempresa.ExecSql
         end;

          if gravar[0] = ('EFORMA_PG') then
         with DataModule2 do
         begin
           qryforma.Active:=false;
           qryforma.SQL.Clear;
           qryforma.SQL.ADD('Insert Into TAB_FORMA (fpg_codigo, fpg_forma)');
           qryforma.SQL.ADD('values (:fpg_codigo, :fpg_forma )');
           qryforma.ParamByName ('fpg_codigo').AsString:=gravar[1];
           qryforma.ParamByName ('fpg_forma').AsString:=gravar[2];
           qryforma.ExecSql
         end;

         if gravar[0] = ('ECOBRANCA') then
         with DataModule2 do
         begin
           qrycondicao.Active:=false;
           qrycondicao.Active:=false;
           qrycondicao.SQL.Clear;
           qrycondicao.SQL.ADD('Insert Into TAB_CONDICAO (cpg_id, cpg_condicao,cpg_parcelas, cpg_minimo,cpg_parc01, cpg_parc02, cpg_parc03, cpg_parc04, cpg_parc05, cpg_parc06, cpg_parc07, cpg_parc08, cpg_parc09, cpg_parc10, cpg_parc11, cpg_parc12, cpg_cobrancafiltro)');
           qrycondicao.SQL.ADD('values (:cpg_id, :cpg_condicao, :cpg_parcelas, :cpg_minimo, :cpg_parc01, :cpg_parc02, :cpg_parc03, :cpg_parc04, :cpg_parc05, :cpg_parc06, :cpg_parc07, :cpg_parc08, :cpg_parc09, :cpg_parc10, :cpg_parc11, :cpg_parc12, :cpg_cobrancafiltro )');
           qrycondicao.ParamByName ('cpg_id').AsString:=gravar[1];
           qrycondicao.ParamByName ('cpg_condicao').AsString:=gravar[2];
           qrycondicao.ParamByName ('cpg_parcelas').AsString:=gravar[3];
           qrycondicao.ParamByName ('cpg_minimo').AsString:=gravar[4];
           qrycondicao.ParamByName ('cpg_parc01').AsString:=gravar[5];
           qrycondicao.ParamByName ('cpg_parc02').AsString:=gravar[6];
           qrycondicao.ParamByName ('cpg_parc03').AsString:=gravar[7];
           qrycondicao.ParamByName ('cpg_parc04').AsString:=gravar[8];
           qrycondicao.ParamByName ('cpg_parc05').AsString:=gravar[9];
           qrycondicao.ParamByName ('cpg_parc06').AsString:=gravar[10];
           qrycondicao.ParamByName ('cpg_parc07').AsString:=gravar[11];
           qrycondicao.ParamByName ('cpg_parc08').AsString:=gravar[12];
           qrycondicao.ParamByName ('cpg_parc09').AsString:=gravar[13];
           qrycondicao.ParamByName ('cpg_parc10').AsString:=gravar[14];
           qrycondicao.ParamByName ('cpg_parc11').AsString:=gravar[15];
           qrycondicao.ParamByName ('cpg_parc12').AsString:=gravar[16];
           qrycondicao.ParamByName ('cpg_cobrancafiltro').AsString:=gravar[17];
           qrycondicao.ExecSql
         end;

         if gravar[0] = ('EESTOQUE') then
         with DataModule2 do
         begin

           qryestoque.Active:=false;
           qryestoque.SQL.Clear;
           qryestoque.sql.Add('Insert Into TAB_ESTOQUE (est_codigo, est_produto, est_fornecedor, est_linha, est_marca, est_saldo, est_custo, est_preco, est_unidade, est_situacao, est_barras, est_peso,'+
           ' est_valor1, est_valor2, est_valor3, est_valor4, est_valor5, est_valor6, est_valor7, est_valor8, est_valor9)');
           qryestoque.sql.Add('values (:est_codigo, :est_produto, :est_fornecedor, :est_linha, :est_marca, :est_saldo, :est_custo, :est_preco, :est_unidade, :est_situacao, :est_barras, :est_peso,'+
           ' :est_valor1, :est_valor2, :est_valor3, :est_valor4, :est_valor5, :est_valor6, :est_valor7, :est_valor8, :est_valor9 )');
           qryestoque.ParamByName ('est_codigo').AsString:=gravar[1];
           qryestoque.ParamByName ('est_produto').AsString:=gravar[2];
           qryestoque.ParamByName ('est_fornecedor').AsString:=gravar[3];
           qryestoque.ParamByName ('est_linha').AsString:=gravar[4];
           qryestoque.ParamByName ('est_marca').AsString:=gravar[5];
           qryestoque.ParamByName ('est_saldo').AsString:=gravar[6];
           qryestoque.ParamByName ('est_custo').AsString:=gravar[7];
           qryestoque.ParamByName ('est_preco').AsString:=gravar[8];
           qryestoque.ParamByName('est_unidade').AsString:=gravar[9];
           qryestoque.ParamByName ('est_barras').AsString:=gravar[10];
           qryestoque.ParamByName ('est_situacao').AsString:=gravar[11];
           qryestoque.ParamByName ('est_peso').AsString:=gravar[12];
           qryestoque.ParamByName ('est_valor1').AsString:=gravar[22];
           qryestoque.ParamByName ('est_valor2').AsString:=gravar[23];
           qryestoque.ParamByName ('est_valor3').AsString:=gravar[24];
           qryestoque.ParamByName ('est_valor4').AsString:=gravar[25];
           qryestoque.ParamByName ('est_valor5').AsString:=gravar[26];
           qryestoque.ParamByName ('est_valor6').AsString:=gravar[27];
           qryestoque.ParamByName ('est_valor7').AsString:=gravar[28];
           qryestoque.ParamByName ('est_valor8').AsString:=gravar[29];
           qryestoque.ParamByName ('est_valor9').AsString:=gravar[30];
           qryestoque.ExecSql
         end;

         if gravar[0] = ('ECLIENTES') then
         with DataModule2 do
         begin

           qrycliente.Active:=false;
           qrycliente.SQL.Clear;
           qrycliente.sql.Add('Insert Into TAB_CLIENTE (cli_codigo, cli_razao, cli_fantasia, cli_tipo, cli_cgc, cli_inscricao, cli_cep, cli_logradouro, cli_bairro, cli_estado, cli_municipio, cli_ibge,'+
           'cli_contato, cli_telefone, cli_celular, cli_email, cli_vendedor, cli_cadastro, cli_vendedor2, cli_ativo, cli_vendedor3, cli_vendedor4, cli_complemento, cli_credito)');
           qrycliente.sql.Add('values (:cli_codigo, :cli_razao, :cli_fantasia, :cli_tipo, :cli_cgc, :cli_inscricao, :cli_cep, :cli_logradouro, :cli_bairro, :cli_estado, :cli_municipio, :cli_ibge,'+
           ':cli_contato, :cli_telefone, :cli_celular, :cli_email, :cli_vendedor, :cli_cadastro, :cli_vendedor2, :cli_ativo, :cli_vendedor3, :cli_vendedor4, :cli_complemento, :cli_credito)');
           qrycliente.ParamByName ('cli_codigo').AsString:=gravar[1];
           qrycliente.ParamByName ('cli_razao').AsString:=gravar[2];
           qrycliente.ParamByName ('cli_fantasia').AsString:=gravar[3];
           qrycliente.ParamByName ('cli_tipo').AsString:=gravar[4];
           qrycliente.ParamByName ('cli_cgc').AsString:=gravar[5];
           qrycliente.ParamByName ('cli_inscricao').AsString:=gravar[6];
           qrycliente.ParamByName ('cli_cep').AsString:=gravar[7];
           qrycliente.ParamByName ('cli_logradouro').AsString:=gravar[8];
           qrycliente.ParamByName('cli_bairro').AsString:=gravar[9];
           qrycliente.ParamByName ('cli_estado').AsString:=gravar[10];
           qrycliente.ParamByName ('cli_municipio').AsString:=gravar[11];
           qrycliente.ParamByName ('cli_ibge').AsString:=gravar[12];
           qrycliente.ParamByName ('cli_telefone').AsString:=gravar[13];
           qrycliente.ParamByName ('cli_celular').AsString:=gravar[14];
           qrycliente.ParamByName ('cli_email').AsString:=gravar[15];
           qrycliente.ParamByName ('cli_contato').AsString:=gravar[16];
           qrycliente.ParamByName ('cli_cadastro').AsString:=gravar[17];
           qrycliente.ParamByName ('cli_vendedor').AsString:=gravar[18];
           qrycliente.ParamByName ('cli_vendedor2').AsString:=gravar[19];
           qrycliente.ParamByName ('cli_ativo').AsString:=gravar[20];
           qrycliente.ParamByName ('cli_vendedor3').AsString:=gravar[21];
           qrycliente.ParamByName ('cli_vendedor4').AsString:=gravar[22];
           qrycliente.ParamByName ('cli_complemento').AsString:=gravar[23];
           qrycliente.ParamByName ('cli_credito').AsString:=gravar[24];
           qrycliente.ExecSql
         end;
     end;

    DataModule2.qrysincro.Active:=false;
    DataModule2.qrysincro.SQL.Clear;
    DataModule2.qrysincro.SQL.ADD('SELECT * FROM  TAB_SINCRO');
    DataModule2.qrysincro.Active:=true;

     circleSinc.opacity:= 1;
     RectSincro.Visible:= true;
     LblSincro2.Visible:= false;

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
  end;
 //verificar banco e gerar .rem

end;