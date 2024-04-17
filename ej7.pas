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
    m.codigo_localidad := valorAlto;
end;

procedure minimo(var v: vectorRegistros; var min: municipio; var d: vectorDetalles);
var
  i, pos, min1, min2: integer;
begin
  min1 := 9999;
  min2 := 9999;
  for i:=1 to 10 do begin
    if (v[pos].codigo_localidad <= min1) then begin
      min2 := 9999;
      min1 := v[i].codigo_localidad;
    end;
    if (v[i].codigo_localidad < min2) then begin
      min2 := v[i].codigo_cepa;
      pos := i;
    end;
  end;
  min := v[pos];
  leer(d[pos], v[pos])
end;

procedure actualizarMaestro(var maestro: master; var d: vectorDetalles: v: vectorRegistros);
var
  m: ministerio;
  min: municipio;
  actual_cod, actual_cepa: integer;
begin
  minimo(v, min, d);
  while (min.codigo <> valorAlto) do begin
    read(maestro, m);
    while (m.codigo_localidad <> min.codigo_localidad) and (m.codigo_cepa <> min.codigo_cepa) do
      read(maestro, m);
    while (m.codigo_localidad = min.codigo_localidad) and (m.codigo_cepa = min.codigo_cepa) do begin
      m.fallecidos := m.fallecidos + min.fallecidos;
      m.recuperados := m.recuperados + min.recuperados;
      m.casos_activos := min.casos_activos;
      m.casos_nuevos := m.casos_nuevos;

      minimo(v, min, d);
    end;
  end;
end;

procedure informarCasosActivos(var maestro: master);
var
  m: municipio;
begin
  while (not eof(maestro)) do begin
    read(maestro, m);
    if (m.casos_activos > 50) then
      writeln('La localidad ', m.localidad, ' tiene mas de 50 casos activos');
  end;
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