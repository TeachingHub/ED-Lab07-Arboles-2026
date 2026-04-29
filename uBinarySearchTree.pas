unit uBinarySearchTree;

interface

{ Ejercicio 2.4: modificar los nodos para que contengan la multiplicidad de la clave. }
type
  tBinarySearchTree = ^tnode;
  tnode = record
    info: integer;
    multiplicidad: integer; // Number of times the key appears
    hi, hd: tBinarySearchTree;
  end;

  // Basic methods
  procedure initialize(var a: tBinarySearchTree);
  function is_empty(a: tBinarySearchTree): boolean;
  procedure add(var a: tBinarySearchTree; clave: integer);
  function in_tree(a: tBinarySearchTree; clave: integer): boolean;
  procedure remove(var a: tBinarySearchTree; x: integer);

  // Traversal algorithms
  procedure preorder(a: tBinarySearchTree);
  procedure inorder(a: tBinarySearchTree);
  procedure postorder(a: tBinarySearchTree);

  // Other methods
  procedure get_hi(a: tBinarySearchTree; var b: tBinarySearchTree);
  procedure get_hd(a: tBinarySearchTree; var b: tBinarySearchTree);


  // Ejercicio 2.1
  function mismos_nodos_izq_y_der(a: tBinarySearchTree): boolean;
  // Ejercicio 2.2
  function niveles_completos(a: tBinarySearchTree): boolean;
  // Ejercicio 2.3
  procedure add_tree(var a: tBinarySearchTree; b: tBinarySearchTree);
  // Ejercicio 2.4
  function get_multiplicidad(a: tBinarySearchTree; clave: integer): integer;

implementation

uses
  Math;

procedure initialize(var a: tBinarySearchTree);
begin
  a := NIL;
end;

function is_empty(a: tBinarySearchTree): boolean;
begin
  is_empty := a = NIL;
end;

function in_tree(a: tBinarySearchTree; clave: integer): boolean;
begin
  if a = NIL then
    in_tree := FALSE
  else if a^.info < clave then
    in_tree := in_tree(a^.hd, clave)
  else if a^.info > clave then
    in_tree := in_tree(a^.hi, clave)
  else
    in_tree := TRUE;
end;

{ Ejercicio 2.4: modificar el procedimiento add para que si la clave ya existe, se incremente su multiplicidad. }
procedure add(var a: tBinarySearchTree; clave: integer);
var
  aux: tBinarySearchTree;
begin
  if a = NIL then
  begin
    new(a);
    a^.info := clave;
    a^.multiplicidad := 1; // Initialize multiplicity to 1
    a^.hi := NIL;
    a^.hd := NIL;
  end
  else if a^.info < clave then
    add(a^.hd, clave)
  else if a^.info > clave then
    add(a^.hi, clave)
  else
    Inc(a^.multiplicidad); // Increase multiplicity if the key already exists
end;


{ Ejercicio 2.4: modificar el procedimiento remove para que si la clave tiene multiplicidad mayor a 1, se decremente su multiplicidad. }
procedure remove(var a: tBinarySearchTree; x: integer);
var
  aux, ant: tBinarySearchTree;
begin
  if a <> NIL then
    if a^.info < x then
      remove(a^.hd, x)
    else if a^.info > x then
      remove(a^.hi, x)
    else
    begin
      if a^.multiplicidad > 1 then
        Dec(a^.multiplicidad) // Decrease multiplicity if greater than 1
      else
      begin
        aux := a;
        if a^.hi = NIL then
          a := a^.hd
        else if a^.hd = NIL then
          a := a^.hi
        else
        begin
          aux := a^.hi;
          ant := NIL;
          while aux^.hd <> NIL do
          begin
            ant := aux;
            aux := aux^.hd;
          end;
          if a^.hi = aux then
            a^.hi := aux^.hi
          else
            ant^.hd := aux^.hi;
          a^.info := aux^.info;
          a^.multiplicidad := aux^.multiplicidad;
        end;
        dispose(aux);
      end;
    end;
end;

// Traversal algorithms

procedure visit(x: integer);
begin
  writeln(x);
end;

procedure preorder(a: tBinarySearchTree);
begin
  if (a <> NIL) then
  begin
    visit(a^.info);
    preorder(a^.hi);
    preorder(a^.hd);
  end;
end;

procedure inorder(a: tBinarySearchTree);
begin
  if (a <> NIL) then
  begin
    inorder(a^.hi);
    visit(a^.info);
    inorder(a^.hd);
  end;
end;

procedure postorder(a: tBinarySearchTree);
begin
  if (a <> NIL) then
  begin
    postorder(a^.hi);
    postorder(a^.hd);
    visit(a^.info);
  end;
end;

// Other methods

function get_info(a: tBinarySearchTree): integer;
begin
  get_info := a^.info;
end;

procedure get_hi(a: tBinarySearchTree; var b: tBinarySearchTree);
var
  hi: tBinarySearchTree;
begin
  if a = nil then
    b := nil
  else
  begin
    hi := a^.hi;
    new(b);
    b^.info := hi^.info;
    b^.hi := hi^.hi;
    b^.hd := hi^.hd;
  end;
end;

procedure get_hd(a: tBinarySearchTree; var b: tBinarySearchTree);
var
  hd: tBinarySearchTree;
begin
  if a = nil then
    b := nil
  else
  begin
    hd := a^.hd;
    new(b);
    b^.info := hd^.info;
    b^.hi := hd^.hi;
    b^.hd := hd^.hd;
  end;
end;


{ Método auxiliar para contar los nodos de un árbol binario de búsqueda. }
function node_count(a: tBinarySearchTree): integer;
var
  izq, der: integer;
begin
  if a = nil then
    node_count := 0
  else
  begin
    izq := node_count(a^.hi);
    der := node_count(a^.hd);
    node_count := izq + der + 1;
  end;
end;

{ Ejercicio 2.1 
  
   Determina si un árbol binario de búsqueda tiene la misma cantidad de nodos en su subárbol izquierdo y derecho.

}
function mismos_nodos_izq_y_der(a: tBinarySearchTree): boolean;
var
  izq, der: integer;
begin
  if a = nil then
    mismos_nodos_izq_y_der := true
  else
  begin
    izq := node_count(a^.hi);
    der := node_count(a^.hd);
    if izq = der then
      mismos_nodos_izq_y_der := true
    else
      mismos_nodos_izq_y_der := false;
  end;
end;

  
  { Ejercicio 2.2 
    
    Determina si un árbol binario de búsqueda tiene todos sus niveles completos.
  }
function niveles_completos(a: tBinarySearchTree): boolean;
begin
  if a = nil then
    niveles_completos := true
  else if (a^.hi = nil) and (a^.hd = nil) then
    niveles_completos := true
  else if (a^.hi <> nil) and (a^.hd <> nil) then
    niveles_completos := niveles_completos(a^.hi) and niveles_completos(a^.hd)
  else
    niveles_completos := false;
end;


{ Ejercicio 2.3 
  Añade arbol b a a arbol a. Se empiezan a añadir los nodos de b en a siguiendo un orden preorden.
}
procedure add_tree(var a: tBinarySearchTree; b: tBinarySearchTree);
begin
  if (b <> NIL) then
  begin
    add(a, b^.info);
    add_tree(a, b^.hi);
    add_tree(a, b^.hd);
  end;
end;

{ Ejercicio 2.4: obtener la multiplicidad de un nodo. }
function get_multiplicidad(a: tBinarySearchTree; clave: integer): integer;
begin
  if a = NIL then
    get_multiplicidad := 0
  else if a^.info < clave then
    get_multiplicidad := get_multiplicidad(a^.hd, clave)
  else if a^.info > clave then
    get_multiplicidad := get_multiplicidad(a^.hi, clave)
  else
    get_multiplicidad := a^.multiplicidad; // Return multiplicity of the key
end;


end.
