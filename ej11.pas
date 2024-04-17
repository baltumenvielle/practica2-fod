program ej11;
type
  fech = record
    dia: 1..31;
    mes: 1..12;
    anio: integer;
  end;
  acceso = record
    fecha: fech;
    codigo: integer;
    acceso: real;
  end;

  master = file of acceso;

procedure buscarAccesos(var maestro: master; anio: integer);
var
  a: acceso;
  actual_mes, actual_dia, actual_usuario: integer;
  accesos_dia, accesos_mes, accesos_anio, accesos_usuario: real;
begin
  while (not eof(maestro)) do begin
    read(maestro, a);
    if (a.fecha.anio = anio) then
      break;
  end;
  
  if (a.fecha.anio = anio) then begin
    writeln('Año: ', anio);
    accesos_anio := 0;
    while (a.fecha.anio = anio) do begin
      actual_mes := a.fecha.mes;
      writeln('Mes: ', actual_mes);
      accesos_mes := 0;
      while (a.fecha.anio = anio) and (a.fecha.mes = actual_mes) do begin
        actual_dia := a.fecha.dia;
        writeln('Día: ', actual_dia);
        accesos_dia := 0;
        while (a.fecha.anio = anio) and (a.fecha.mes = actual_mes) and (a.fecha.dia = actual_dia) do begin
          actual_usuario := a.codigo;
          accesos_usuario := 0;
          while (a.fecha.anio = anio) and (a.fecha.mes = actual_mes) and (a.fecha.dia = actual_dia) and (a.codigo = actual_usuario) do begin
            accesos_usuario := accesos_usuario + a.acceso;
            read(maestro, a);
          end;
          accesos_dia := accesos_dia + accesos_usuario;
          writeln('Usuario: ', a.codigo, ' Tiempo total de acceso en el dia ', actual_dia, ' mes ', actual_mes, ': ', accesos_usuario:1:1);
        end;
        accesos_mes := accesos_mes + accesos_dia;
        writeln('Tiempo total de accesos en el dia ', actual_dia, ' ', accesos_dia);
      end;
      accesos_anio := accesos_anio + accesos_mes;
      writeln('Tiempo total de accesos en el mes ', actual_mes, ' ', accesos_mes);
    end;
    writeln('Tiempo total de accesos en el año ', anio, ' ', accesos_anio);
  end;
  else
    writeln('No se encontró el año ingresado.');
end;

var
  maestro: master;
  anio: integer;
begin
  assign(maestro, 'maestro.dat');

  writeln('Ingrese el año en el que desea buscar los accesos');
  readln(anio);

  buscarAccesos(maestro, anio);
end.