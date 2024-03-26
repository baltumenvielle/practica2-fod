program ej1;
const valorAlto = 9999;
type
  empleado = record // se dispone
    codigo: integer;
    nombre: string;
    comision: real;
  end;
  archEmpleados = file of empleado; // se dispone

procedure leer(var detalle: archEmpleados; var e: empleado);
begin
  if (not eof(detalle)) then
    read(detalle, e)
  else
    e.codigo := valorAlto;
end;

procedure resumir(var maestro: archEmpleados; var detalle: archEmpleados);
var
  actual: integer;
  suma: real;
  e: empleado;
begin
  while (e.codigo <> valorAlto) do begin
    actual := e.codigo;
    suma := 0;
    while (codigo = actual) do begin
      suma := suma + e.comision;
      leer(detalle, e);
    end;
    write(maestro, e);
  end;
end;

var 
  maestro, detalle: archEmpleados;
begin
  assign(detalle, 'empleados.dat');
  reset(detalle);
  assign(maestro, 'resumen.dat');
  rewrite(maestro);
  resumir(maestro, detalle);
  close(maestro);
  close(detalle);
end.