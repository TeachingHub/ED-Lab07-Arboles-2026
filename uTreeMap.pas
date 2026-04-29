unit uTreeMap;

interface

uses
  uListaEnlazadaSimple;

type
  tTreeMap = ^tnode;
  tnode = record
    key: integer;
    value: tListaSimple;
    hi, hd: tTreeMap;
  end;

  // Métodos básicos
  procedure initialize(var a: tTreeMap);
  procedure add(var a: tTreeMap; value: string);
  procedure get(a: tTreeMap; key: integer; var value: tListaSimple);
  function contains(a: tTreeMap; key: integer): boolean;
  procedure remove(var a: tTreeMap; key: integer);
  procedure remove_value(var a: tTreeMap; value: string);
  function is_empty(a: tTreeMap): boolean;
  // Métodos de recorrido
  procedure inorder(a: tTreeMap);
  procedure preorder(a: tTreeMap);
  procedure postorder(a: tTreeMap);

implementation

uses
  Math;

procedure initialize(var a: tTreeMap);
begin
  a := NIL;
end;

function is_empty(a: tTreeMap): boolean;
begin
  is_empty := a = NIL;
end;

function contains(a: tTreeMap; key: integer): boolean;
begin
  if a = NIL then
    contains := FALSE
  else if a^.key < key then
    contains := contains(a^.hd, key)
  else if a^.key > key then
    contains := contains(a^.hi, key)
  else
    contains := TRUE;
end;

procedure add(var a: tTreeMap; value: string);
var
  key: integer;
begin
  key := Length(value); // La clave es el número de caracteres de la palabra
  if a = NIL then
  begin
    new(a);
    a^.key := key;
    a^.hi := NIL;
    a^.hd := NIL;
    uListaEnlazadaSimple.initialize(a^.value);
    uListaEnlazadaSimple.insert_at_end(a^.value, value);
  end
  else if a^.key < key then
    add(a^.hd, value)
  else if a^.key > key then
    add(a^.hi, value)
  else
  begin
    uListaEnlazadaSimple.insert_at_end(a^.value, value);
  end;
end;

procedure get(a: tTreeMap; key: integer; var value: tListaSimple);
begin
  if a = NIL then
    uListaEnlazadaSimple.initialize(value) // Si no se encuentra, lista vacía
  else if a^.key < key then
    get(a^.hd, key, value)
  else if a^.key > key then
    get(a^.hi, key, value)
  else
    uListaEnlazadaSimple.copy(a^.value, value); // Copiar la lista si se encuentra
end;

procedure remove(var a: tTreeMap; key: integer);
var
  aux, ant: tTreeMap;
begin
  if a <> NIL then
    if a^.key < key then
      remove(a^.hd, key)
    else if a^.key > key then
      remove(a^.hi, key)
    else
    begin
      aux := a;
      uListaEnlazadaSimple.clear(a^.value); // Limpiar la lista antes de eliminar el nodo
      if a^.hi = NIL then
        a := a^.hd
      else if a^.hd = NIL then
        a := a^.hi
      else
      begin
        aux := a^.hi;
        while aux^.hd <> NIL do
        begin
          ant := aux;
          aux := aux^.hd;
        end;
        if a^.hi = aux then
          a^.hi := aux^.hi
        else
          ant^.hd := aux^.hi;
        a^.key := aux^.key;
        a^.value := aux^.value; // Transferir la lista al nodo actual
      end;
      dispose(aux);
    end;
end;

procedure remove_value(var a: tTreeMap; value: string);
var
  key: integer;
begin
  key := Length(value); // La clave es el número de caracteres de la palabra
  if a <> NIL then
  begin
    if a^.key < key then
      remove_value(a^.hd, value)
    else if a^.key > key then
      remove_value(a^.hi, value)
    else
    begin
      uListaEnlazadaSimple.delete(a^.value, value); // Eliminar el valor de la lista
      if uListaEnlazadaSimple.num_elems(a^.value) = 0 then // Si la lista queda vacía, eliminar el nodo
        remove(a, key);
    end;
  end;
end;

procedure visit(x: integer);
begin
  writeln(x);
end;

procedure preorder(a: tTreeMap);
begin
  if (a <> NIL) then
  begin
    visit(a^.key);
    preorder(a^.hi);
    preorder(a^.hd);
  end;
end;

procedure inorder(a: tTreeMap);
begin
  if (a <> NIL) then
  begin
    inorder(a^.hi);
    visit(a^.key);
    inorder(a^.hd);
  end;
end;

procedure postorder(a: tTreeMap);
begin
  if (a <> NIL) then
  begin
    postorder(a^.hi);
    postorder(a^.hd);
    visit(a^.key);
  end;
end;

// Other methods

procedure get_hi(a: tTreeMap; var b: tTreeMap);
var
  hi: tTreeMap;
begin
  if a = nil then
    b := nil
  else
  begin
    hi := a^.hi;
    new(b);
    b^.key := hi^.key;
    b^.hi := hi^.hi;
    b^.hd := hi^.hd;
  end;
end;

procedure get_hd(a: tTreeMap; var b: tTreeMap);
var
  hd: tTreeMap;
begin
  if a = nil then
    b := nil
  else
  begin
    hd := a^.hd;
    new(b);
    b^.key := hd^.key;
    b^.hi := hd^.hi;
    b^.hd := hd^.hd;
  end;
end;

end.
