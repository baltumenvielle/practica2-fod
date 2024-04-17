program ej9;
const valorAlto = 9999;
type
  mesa = record
    provincia: integer;
    localidad: integer;
    mesa: integer;
    votos: integer;
  end;
  master = file of mesa;

procedure leer(var maestro: master; var m: mesa);
begin
  if (not eof(maestro)) then
    read(maestro, m)
  else
    m.provincia := valorAlto;
end;

procedure informarVotos(var maestro: master);
var
  m: mesa;
  total, total_provincia, total_localidad, actual_provincia, actual_localidad: integer;
begin
  total := 0;
  leer(maestro, m);
  while (m.provincia <> valorAlto) do begin
    actual_provincia := m.provincia;
    writeln(actual_provincia);
    total_provincia := 0;
    while (m.provincia = actual_provincia) do begin
      actual_localidad := m.localidad;
      total_localidad := 0;
      while (m.provincia = actual_provincia) and (m.localidad = actual_localidad) do begin
        total_localidad := total_localidad + m.votos;
        leer(maestro, m);
      end;
      total_provincia := total_provincia + total_localidad;
      writeln('Localidad: 'actual_localidad, ' votos: ', total_localidad);
    end;
    total := total + total_provincia;
    writeln('Provincia: ', actual_provincia, ' votos: ', total_provincia);
  end;  
  writeln('Total de votos: ', total);
end;

var
  maestro: master;
begin
  assign(maestro, 'maestro.dat');
  reset(maestro);

  informarVotos(maestro);

  close(maestro);
end.