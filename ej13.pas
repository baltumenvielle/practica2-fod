program ej13;
const valorAlto = 9999;
type
  fech = record
    dia: 1..31;
    mes: 1..12;
    anio: integer;
  end;
  vuelo = record
    destino: integer;
    fecha: fech;
    hora: integer;
    asientos_disponibles: integer;
  end;
  det = record
    destino: integer;
    fecha: fech;
    hora: integer;
    asientos_comprados: integer;
  end;
  lista = ^nodo;
  nodo = record
    info: vuelo;
    sig: lista;
  end;

  master = file of vuelo;
  detail = file of det;

procedure leer(var detalle: detail; var d: det);
begin
  if (not eof(detalle)) then
    read(detalle, d)
  else
    d.destino := valorAlto;
end;

procedure minimo(var det1, det2: detail; var r1, r2, min: det);
begin
  if (r1.destino <= r2.destino) then begin
    min := r1;
    leer(det1, r1);
  end
  else begin
    min := r2;
    leer(det2, r2);
  end;
end;

procedure agregarAdelante(var L: lista; v: vuelo);
var
  nuevo: lista;
begin
  new(nuevo);
  nuevo^.info := v;
  nuevo^.sig := nil;
  if (L = nil) then
    L := nuevo
  else begin  
    nuevo^.sig := L;
    L := nuevo;
  end;
end;

procedure actualizarMaestro(var maestro: master; var det1, det2: detail; var L: lista; cant: integer);
var
  v: vuelo;
  r1, r2, min: det;
begin
  reset(maestro);
  reset(det1);
  reset(det2);
  leer(det1, r1);
  leer(det2, r2)
  minimo(det1, det2, r1, r2, min);
  while (min.destino <> valorAlto) do begin
    read(maestro, v);
    while (v.destino <> min.destino) do
      read(maestro, v);
    while (v.destino = min.destino) do begin
      v.asientos_disponibles := v.asientos_disponibles - min.asientos_comprados;
      minimo(det1, det2, r1, r2, min);
    end;
    seek(maestro, filePos(maestro)-1);
    write(maestro, v);
    if (v.asientos_disponibles < cant) then
      agregarAdelante(L, v);
  end;
  close(maestro);
  close(det1);
  close(det2);
end;

var
  maestro: master;
  det1, det2: detail;
  pri: lista;
  cant: integer;
begin
  pri := nil;
  assign(maestro, 'maestro.dat');
  assign(det1, 'detalle1.dat');
  assign(det2, 'detalle2.dat');

  writeln('Ingrese la cantidad de pasajes disponibles que quiera buscar por menor');
  readln(cant);
  actualizarMaestro(maestro, det1, det2, pri, cant);
end.