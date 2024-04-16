program ej6;
const valorAlto = 9999;
type
  fech = record
    dia: 1..31;
    mes: 1..12;
    anio: integer;
  end;
  servidor = record
    codigo: integer;
    fecha: fech;
    tiempo_total: real;
  end;
  usuario = record
    codigo: integer;
    fecha: fech;
    tiempo_sesion: real;
  end;
  master = file of servidor;
  detail = file of usuario;
  vectorDetalles = array [1..5] of detail;
  vectorRegistros = array [1..5] of usuario;

procedure leer(var detalle: detail; var u: usuario);
begin
  if (not eof(detalle)) then
    read(detalle, u)
  else
    u.codigo := valorAlto;
end;

procedure minimo(var v: vectorRegistros; var min: usuario; var d: vectorDetalles);
var
  i, pos, minimo: integer;
begin
  minimo := 9999;
  for i:=1 to 5 do begin
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
  min: usuario;
  s: servidor;
  actual: integer;
begin
  minimo(v, min, d);
  while (min.codigo <> valorAlto) do begin
    actual := min.codigo;
    s.tiempo_total := 0;
    while (min.codigo = actual) do begin
      s.tiempo_total := s.tiempo_total + min.tiempo_sesion;
      minimo(v, min, d);
    end;
    s.codigo := actual;
    write(maestro, s);
  end;
end;

var
  maestro: master;
  d: vectorDetalles;
  v: vectorRegistros;
  i: integer;
begin
  for i := 1 to 5 do begin
    assign(d[i], 'detalle'+ i);
    reset(d[i]);
    leer(d[i], v[i]);
  end;

  assign(maestro, '/var/log/maestro.dat');
  reset(maestro);

  crearMaestro(maestro, d, v);

  close(maestro);
  for i:=1 to 5 do
    close(detalle[i]);
end.