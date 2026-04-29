program OrdenarPilaTest;

uses
  uPilaChar, uBinaryCharSearchTree;

var
  pila: tPilaChars;
  elemento: char;

{ Ejercicio 3 }
procedure mostrar_pila_en_orden(var p: tPilaChars);
var
  arbol: tBinarySearchTree;
  aux: tPilaChars;
  i: integer;

begin
  // Inicializar el árbol
  initialize(arbol);
  // Inicializar la pila auxiliar
  uPilaChar.initialize(aux);

  // Agregar elementos de la pila al árbol y a la pila auxiliar
  while not isEmpty(p) do
  begin
    elemento := peek(p);
    add(arbol, elemento);
    push(aux, elemento);
    pop(p);
  end;

  // Mostrar los elementos en orden
  writeln('Elementos en orden: ');
  inorder(arbol);

  // Limpiar el árbol
  clear(arbol);

  // Volver a agregar los elementos a la pila original
  while not isEmpty(aux) do
  begin
    elemento := peek(aux);
    push(p, elemento);
    pop(aux);
  end;

  writeln('Pila original restaurada: ', toString(p));
end;


begin
  // Inicializar la pila
  uPilaChar.initialize(pila);

  // Agregar elementos desordenados a la pila
  push(pila, 'd');
  push(pila, 'a');
  push(pila, 'c');
  push(pila, 'b');

  // Mostrar pila antes de ordenar
  writeln('Pila antes de ordenar: ', toString(pila));

  mostrar_pila_en_orden(pila);

  // Mostrar pila después de ordenar
  writeln('Pila después de ordenar: ', toString(pila));
end.