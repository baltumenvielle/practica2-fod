program ej10;
const valorAlto = 9999;
type
  empleado = record
    departamento: integer;
    division: integer;
    numero: integer;
    categoria: 1..15;
    horas_extras: integer;
  end;
  vector = array [1..15] of real;
  master = file of empleado;

procedure leer(var maestro: master; var e: empleado);
begin
  if (not eof(maestro)) then
    read(maestro, e)
  else
    e.departamento := valorAlto;
end;

procedure cargarVector(var v: vector; var precios: text);
var
  codigo: integer;
  valor: real;
begin
  reset(precios);
  while (not eof(precios)) do begin
    read(precios, codigo, valor);
    v[codigo] := valor;
  end;
  close(precios);
end;

procedure informarHorasExtras(var maestro: master; v: vector);
var
  e: empleado;
  total_precio_departamento, total_precio_division: real;
  actual_division, actual_departamento, total_horas_division, total_horas_departamento: integer;
begin
  reset(maestro);

  leer(maestro, m);
  while (m.departamento <> valorAlto) do begin
    total_precio_departamento := 0;
    total_horas_departamento := 0;
    actual_departamento := m.departamento;
    writeln(actual_departamento);
    while (m.departamento = actual_departamento) do begin
      total_precio_division := 0;
      total_horas_division := 0;
      actual_division := m.division;
      writeln(actual_division);
      while (m.departamento = actual_departamento) and (m.division = actual_division) do begin
        writeln(m.numero, 'Total de horas: ', m.horas_extras, ' Importe a cobrar: $', (v[m.categoria] * m.horas_extras):1:1);
        total_horas_division := total_horas_division + m.horas_extras;
        total_precio_division := total_precio_division + v[m.categoria] * m.horas_extras;
        leer(maestro, m);
      end;
      writeln('Total de horas de la division: ', total_horas_division);
      writeln('Monto total de la division: ', total_precio_division);
      total_precio_departamento := total_precio_departamento + total_precio_division;
      total_horas_departamento := total_horas_departamento + total_horas_division;
    end;
    writeln('Total de horas del departamento: ', total_horas_departamento);
    writeln('Monto total del departamento: ', total_precio_departamento);
  end;
  close(maestro);
end;

var
  maestro: master;
  v: vector;
  precios: text;
begin
  assign(maestro, 'maestro.dat');
  assign(precios, 'precios.txt');

  cargarVector(v, precios);
  informarHorasExtras(maestro);
end.