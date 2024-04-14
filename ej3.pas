program ej3;
const valorAlto = 9999;
type
  producto = record
    codigo: integer;
    nombre: string;
    precio: real;
    stock_actual: integer;
    stock_minimo: integer;
  end;
  venta = record  
    codigo: integer;
    unidades: integer;
  end;
  master = file of alumno;
  detail = file of venta;

procedure leer(var detalle: detail; var v: venta);
begin
  if (not eof(detalle)) then
    read(detalle, v)
  else
    v.codigo := valorAlto;
end;
  
procedure opcion1(var maestro: master; var detalle: detail);
var
  v: venta;
  p: producto;
  actual, suma: integer;
begin
  leer(detalle, v);
  while (v.codigo <> valorAlto) do begin
    actual := v.codigo;
    suma := 0;
    while (v.codigo = actual) do begin
      suma := suma + v.unidades;
      leer(detalle, v);
    end;
    read(maestro, p);
    seek(maestro, filePos(maestro)-1);
    p.stock_actual := p.stock_actual - suma;
    write(maestro, p);
  end;
end;

procedure opcion2(var maestro: master);
var
  archTexto: text;
  p: producto;
begin
  assign(archTexto, 'stock_minimo.txt');
  rewrite(archTexto);
  while (not eof(maestro)) do begin
    read(maestro, p);
    if (p.stock_minimo < p.stock_actual) then begin
      writeln(archTexto, p.codigo, ' ', p.precio, ' ', p.stock_actual, ' ', p.stock_minimo);
      write(archTexto, p.nombre);
    end;
  end;
end;

var
  maestro: master;
  detalle: detail;
  opcion: integer;
begin
  assign(maestro, 'maestro.dat');
  reset(maestro);
  assign(detalle, 'detalle.dat');
  reset(detalle);

  writeln('Elija una de las siguientes opciones: 1. Actualizar el maestro 2. Exportar en un texto los productos con stock actual por debajo del minimo');
  readln(opcion);
  case opcion of
    1: opcion1(maestro, detalle);
    2: opcion2(maestro);
  end;

  close(maestro);
  close(detalle);
end.