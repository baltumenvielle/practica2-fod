program ej5;
const valorAlto = 9999;
type
  producto = record
    codigo: integer;
    nombre: string;
    descripcion: string;
    stock_actual: integer;
    stock_minimo: integer;
    precio: real;
  end;
  det = record
    codigo: integer;
    ventas: integer;
  end;
  master = file of producto;
  detail = file of det;
  vectorDetalles = array [1..30] of detail;
  vectorRegistros = array [1..30] of det;

procedure leer(var detalle: detail; var d: det);
begin
  if (not eof(detalle)) then
    read(detalle, d)
  else
    d.codigo := valorAlto;
end;

procedure minimo(var v: vectorRegistros; var min: det; var d: vectorDetalles);
var
  i, pos, minimo: integer;
begin
  minimo := 9999;
  for i:=1 to 30 do begin
    if (v[i].codigo < minimo) then begin
      minimo := v[i].codigo;
      pos := i;
    end;
  end;
  min := v[pos];
  leer(d[pos], v[pos])
end;

procedure crearMaestro(var maestro: master; var d: vectorDetalles; v: vectorRegistros);
var
  min: det;
  p: producto;
begin
  minimo(v, min, d);
  while (min.codigo <> valorAlto) do begin
    read(maestro, p);
    while (p.codigo <> min.codigo) do
      read(maestro, p);
    while (p.codigo = min.codigo) do begin
      p.stock_disponible := p.stock_disponible - min.ventas;
      minimo(v, min, d);
    end;
    seek(maestro, filePos(maestro)-1);
    write(maestro, p);
  end;
end;

procedure informarTexto(var maestro: master);
var
  p: producto;
  archTexto: text;
begin
  assign(archTexto, 'productos.txt');
  rewrite(archTexto);
  while (not eof(maestro)) do begin
    read(maestro, p);
    writeln(archTexto, p.nombre);
    writeln(archTexto, p.descripcion);
    write(archTexto, p.stock_disponible, ' ', p.stock_minimo);
  end;
  close(archTexto);
end;

var
  maestro: master;
  d: vectorDetalles;
  v: vectorRegistros;
  i: integer;
begin
  for i := 1 to 30 do begin
    assign(d[i], 'detalle'+ i);
    reset(d[i]);
    leer(d[i], v[i]);
  end;

  assign(maestro, 'maestro.dat');
  reset(maestro);

  crearMaestro(maestro, d, v);
  informarTexto(maestro);

  close(maestro);
  for i:=1 to 30 do
    close(detalle[i]);
end.