program ej4;
const valorAlto = 9999;
type
  provincia = record
    nombre: string;
    alfabetizados: integer;
    encuestados: integer;
  end;
  det = record
    nombre: string;
    codigo: integer;
    alfabetizados: integer;
    encuestados: integer;
  end;
  master = file of provincia;
  detail = file of det;

procedure leer(var detalle: detail; var v: venta);
begin
  if (not eof(detalle)) then
    read(detalle, e)
  else
    e.codigo := valorAlto;
end;

procedure minimo(var det1: detail; var det2: detail; var r1: det; var r2: det; var min: det);
begin
  if (r1.codigo <= r2.codigo) then begin
    min := r1;
    leer(det1, r1);
  end
  else begin
    min := r2;
    leer(det2, r2);
  end;
end;

procedure actualizar(var maestro: master; var det1: detail; var det2: detail);
var
  r1, r2: det;
  p: provincia;
  actual: integer;
begin
  minimo(det1, det2, r1, r2, min);
  while (min.codigo <> valorAlto) do begin
    read(maestro, p);
    while (p.nombre <> min.nombre) do
      read(maestro, p);
    seek(maestro, filePos(maestro)-1);
    p.alfabetizados := p.alfabetizados + min.alfabetizados;
    p.encuestados := p.encuestados + min.encuestados;
    write(maestro, p);
    minimo(det1, det2, r1, r2, min);
  end;
end;

var
  maestro: master;
  det1, det2: detail;
begin
  assign(maestro, 'maestro.dat');
  assign(det1, 'detalle1.dat');
  assign(det2, 'detalle2.dat');
  reset(maestro);
  reset(det1);
  reset(det2);

  actualizar(maestro, det1, det2);

  close(maestro);
  close(det1);
  close(det2);
end.