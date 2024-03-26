program ej2;
const valorAlto = 9999;
type
  alumno = record
    codigo: integer;
    apellido: string;
    nombre: string;
    cursadas: integer;
    finales: integer;
  end;
  det = record  
    codigo: integer;
    materia: string;
    final: boolean;
  end;
  master = file of alumno;
  detail = file of det;

procedure leer(var detalle: detail; var a: det);
begin
  if (not eof(detalle)) then
    read(detalle, a)
  else
    a.codigo := valorAlto;
end;

procedure opcion1(var maestro: master; var detalle: detail);
var
  actual, finales, cursadas: integer;
  a: alumno;
  d: det;
begin
  read(detalle, d);
  while (d.codigo <> valorAlto) do begin
    actual := d.codigo;
    while (codigo = actual) do begin
      if (d.final) then begin
        finales := finales + 1;
        cursadas := cursadas - 1;
      end
      else
        cursadas := cursadas + 1;
      leer(detalle, d);
    end;
    read(maestro, a);
    seek(maestro, filePos(maestro)-1);
    a.cursadas := cursadas;
    a.finales := finales;
    write(maestro, a);
  end;
end;

procedure opcion2(var maestro: master);
var
  archTexto: text;
  a: alumno;
begin
  assign(archTexto, 'alumnos.txt');
  rewrite(archTexto);
  while (not eof(maestro)) do begin
    read(maestro, a);
    if (a.finales > a.cursadas) then
      writeln(archTexto, a.nombre, ' ', a.apellido, ' ', a.codigo, ' ', a.cursadas, ' ', a.finales);
  end;
end;

var
  maestro: master;
  detalle: detail;
begin 
  assign(maestro, 'alumnos.dat');
  assign(detalle, 'materias.dat');
  reset(maestro);
  reset(detalle);

  println('Ingrese una de las siguietes opciones: 1. Actualizar el maestro 2. Exportar a texto alumnos con más finales aprobados');
  readln(opcion);
  case opcion of
    1: opcion1(maestro, detalle);
    2: opcion2(maestro);
  end;

  close(maestro);
  close(detalle);
end.