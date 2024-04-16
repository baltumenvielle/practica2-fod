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

  crearMaestro(maestro, d, v);
  informarCasosActivos(maestro);

  close(maestro);
  for i:=1 to 10 do
    close(detalle[i]);
end.