program ej12;
const valorAlto = 9999;
type
  usuario = record
    numero: integer;
    nick: string;
    nombre: string;
    cantidad_mails: integer;
  end;
  mail = record
    numero_envio: integer;
    numero_destino: integer;
    mensaje: string;
  end;

  master = file of usuario;
  detail = file of mail;

procedure leer(var detalle: detail; var m: mail);
begin
  if (not eof(detalle)) then
    read(detalle, m)
  else
    m.numero_envio := valorAlto;
end;

procedure actualizarMaestro(var maestro: master; var detalle: detail);
var
  u: usuario;
  m: mail;
begin
  reset(maestro); 
  reset(detalle);
  leer(detalle, m);
  while (m.numero_envio <> valorAlto) do begin
    read(maestro, u);
    while (u.numero <> m.numero_envio) do
      read(maestro, u);
    while (u.numero = m.numero_envio) do
      u.cantidad_mails := u.cantidad_mails + 1;
    seek(maestro, filePos(maestro)-1);
    write(maestro, u);
  end;
  close(maestro);
  close(detalle);
end;

function generarTexto(var maestro: master; var texto: text)
var
  u: usuario;
begin
  reset(maestro);
  rewrite(texto);
  while (not eof(maestro)) do begin
    read(maestro, u);
    writeln(texto, u.numero, ' ', u.cantidad_mails);
  end;
  close(maestro);
  close(texto);
end;

var
  maestro: master;
  detalle: detail;
  texto: text;
begin
  assign(maestro, '/var/log/logmail.dat');
  assign(detalle, 'detalle.dat');
  assign(texto, 'texto.txt');

  actualizarMaestro(maestro, detalle);
  generarTexto(maestro, texto);
end.