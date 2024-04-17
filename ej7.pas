program ej7;
const valorAlto = 9999;
type
  municipio = record
    codigo_localidad: integer;
    codigo_cepa: integer;
    casos_activos: integer;
    casos_nuevos: integer;
    recuperados: integer;
    fallecidos: integer;
  end;
  ministerio = record
    codigo_localidad: integer;
    localidad: string;
    codigo_cepa: integer;
    cepa: string;
    casos_activos: integer;
    casos_nuevos: integer;
    recuperados: integer;
    fallecidos: integer;
  end;
  master = file of ministerio;
  detail = file of municipio;
  vectorDetalles = array [1..10] of detail;
  vectorRegistros = array [1..10] of municipio;

procedure leer(var detalle: detail; var m: municipio);
begin
  if (not eof(detalle)) then
    read(detalle, m)
  else
    m.codigo := valorAlto;
end;

procedure minimo(var v: vectorRegistros; var min: municipio; var d: vectorDetalles);
var
  i, pos, minimo: integer;
begin
  minimo := 9999;
  for i:=1 to 10 do begin
    if (v[i].codigo < minimo) then begin
      minimo := v[i].codigo;
      pos := i;
    end;
  end;
  min := v[pos];
  leer(d[pos], v[pos])
end;

procedure actualizarMaestro(var maestro: master; var d: vectorDetalles: v: vectorRegistros);
var
  min: municipio;
begin
  minimo(v, min, d);
end;

var
  maestro: master;
  d: vectorDetalles;
  v: vectorRegistros;
  i: integer;
begin
  for i := 1 to 10 do begin
    assign(d[i], 'detalle'+ i);
    reset(d[i]);
    leer(d[i], v[i]);
  end;

  assign(maestro, 'maestro.dat');
  reset(maestro);

  actualizarMaestro(maestro, d, v);
  informarCasosActivos(maestro);

  close(maestro);
  for i:=1 to 10 do
    close(detalle[i]);
end.