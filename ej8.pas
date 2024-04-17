program ej8;
const valorAlto = 9999;
type
  fech = record
    dia: 1..31;
    mes: 1..12;
    anio: integer;
  end;
  cliente = record
    codigo: integer;
    nombre: string;
    fecha: fech;
    monto: real;
  end;
  master = file of cliente;

procedure leer(var maestro: master; var c: cliente);
begin
  if (not eof(maestro)) then
    read(detalle, c)
  else
    c.codigo := valorAlto;
end;

function informarMontos(var maestro: master): real;
var
  c: cliente;
  actual_cliente, actual_mes, actual_anual: integer;
  total, total_mensual, total_anual: real;
begin
  total := 0;
  read(maestro, c);
  while (c.codigo <> valorAlto) do begin
    actual := c.codigo;
    while (c.codigo = actual) do begin
      actual_anual := c.fecha.anio;
      total_anual := 0;
      while (c.codigo = actual) and (c.fecha.anio = actual_anual) do begin
        actual_mes := c.fecha.mes;
        total_mensual := 0;
        while (c.codigo = actual) and (c.fecha.anio = actual_anual) and (c.fecha.mes = actual_mes) do begin
          total_mensual := total_mensual + c.monto;
          leer(maestro, c);
        end;
        total_anual := total_anual + total_mensual;
      end;
      total := total + total_anual;
    end;
  end;
  informarMontos := total;
end;

var
  maestro: master;
begin
  assign(maestro, 'maestro.dat');
  reset(maestro);

  writeln('El monto total de ventas obtenidos por la empresa es de $', informarMontos(maestro):1:1);

  close(maestro);
end.