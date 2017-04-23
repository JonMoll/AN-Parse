unit UArbol;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, UNodo;

type
node_array = array of ptr_nodo;

CArbol = Class
public
    m_ptr_raiz : ptr_nodo;
    m_ptr_ultimo : ptr_nodo;//innecesario

    procedure Insertar(a, op, b, id : string);
    procedure fInsetar(cadena : node_array ; nodo : ptr_nodo) ;
    function fCadenaToNodes(cadena :string) : node_array;
    procedure EliminarUltimo();
    procedure ImprimirUltimo();

    constructor Create();
end;

implementation

constructor CArbol.Create();
begin
    m_ptr_raiz := nil;
end;

procedure CArbol.Insertar(a, op, b, id : string);
var ptr_temp : ptr_nodo;
begin
    if (m_ptr_raiz = nil) then begin
        new(m_ptr_raiz);

        m_ptr_raiz^.m_id := RAIZ;

        m_ptr_raiz^.m_a := a;
        m_ptr_raiz^.m_b := b;
        m_ptr_raiz^.m_op := op;

        m_ptr_raiz^.m_ptr_ant := nil;
        m_ptr_raiz^.m_ptr_izq := nil;
        m_ptr_raiz^.m_ptr_der := nil;

        m_ptr_ultimo := m_ptr_raiz;
    end
    else begin
        if (id = IZQUIERDA) then begin
            new(m_ptr_ultimo^.m_ptr_izq);

            ptr_temp := m_ptr_ultimo^.m_ptr_izq;
            ptr_temp^.m_ptr_ant := m_ptr_ultimo;
        end;

        if (id = DERECHA) then begin
            new(m_ptr_ultimo^.m_ptr_der);

            ptr_temp := m_ptr_ultimo^.m_ptr_der;
            ptr_temp^.m_ptr_ant := m_ptr_ultimo;
        end;

        ptr_temp^.m_id := id;

        ptr_temp^.m_a := a;
        ptr_temp^.m_op := op;
        ptr_temp^.m_b := b;

        ptr_temp^.m_ptr_izq := nil;
        ptr_temp^.m_ptr_der := nil;

        m_ptr_ultimo := ptr_temp;
    end;
end;

function CArbol.fCadenaToNodes(cadena : string) : node_array;//string a vector de nodos
var
  Arr: array of Char;
  nodes: node_array;
  i: integer;
begin
  SetLength(Arr,Length(cadena));
  SetLength(nodes,Length(cadena));
  for i := 1 to Length(cadena) do
      Arr[i - 1] := cadena[i];

  //Ahora tenemos un buen vector con chars
  //porque los string son medios raros (1-n)

  //aqui coloco todos los posibles operadores
  for i:=0 to Length(nodes) do
  begin
         new(nodes[i]);
  end;
  for i := 0 to Length(Arr)-1 do
  begin
       if arr[i]='+' then
       begin
          nodes[i]^.m_val := Arr[i];
          nodes[i]^.m_is_op := true;
       end
       else if arr[i]='-' then
       begin
          nodes[i]^.m_val := Arr[i];
          nodes[i]^.m_is_op := true;
       end
       else if arr[i]='*' then
       begin
          nodes[i]^.m_val := Arr[i];
          nodes[i]^.m_is_op := true;
       end
       else if arr[i]='/' then
       begin
          nodes[i]^.m_val := Arr[i];
          nodes[i]^.m_is_op := true;
       end
       else if arr[i]='^' then
       begin
          nodes[i]^.m_val := Arr[i];
          nodes[i]^.m_is_op := true;
       end
       else
       begin
          nodes[i]^.m_val := Arr[i];
          nodes[i]^.m_is_op := false;
       end;
  end;


  fCadenaToNodes:=nodes;
end;

procedure CArbol.fInsetar(cadena : node_array; nodo : ptr_nodo);//insertaa un vector de nodos
var
  i,particion : integer ;
  a_left,a_right : node_array;

begin
    if Length(cadena) = 0 then
       Exit;

    if Length(cadena) = 1 then
    begin
         nodo:=cadena[0];
         WriteLn('num'+nodo^.m_val);
         Exit;
    end;

    for i:=0 to Length(cadena) do
    begin

         if(cadena[i]^.m_is_op) then
         begin
             particion:=i;
             nodo:=cadena[i];
             WriteLn('operador'+nodo^.m_val);
             Break;
         end;
    end;
    a_left := Copy(cadena,0,particion);
    a_right:= Copy(cadena,particion+1,Length(cadena)+1);
    new(nodo^.m_ptr_izq);
    new(nodo^.m_ptr_der);
    fInsetar(a_right,nodo^.m_ptr_der);
    fInsetar(a_left,nodo^.m_ptr_izq);



end;

procedure CArbol.EliminarUltimo();
begin
    if (m_ptr_raiz <> nil) and (m_ptr_ultimo <> nil) then begin
        if (m_ptr_ultimo^.m_id = RAIZ) then begin
            m_ptr_raiz := nil;
            m_ptr_ultimo := nil;
        end;

        if (m_ptr_ultimo^.m_id = IZQUIERDA) then begin
            m_ptr_ultimo := m_ptr_ultimo^.m_ptr_ant;
            m_ptr_ultimo^.m_ptr_izq := nil;
        end;

        if (m_ptr_ultimo^.m_id = DERECHA) then begin
            m_ptr_ultimo := m_ptr_ultimo^.m_ptr_ant;
            m_ptr_ultimo^.m_ptr_der := nil;
        end;
    end;
end;

procedure CArbol.ImprimirUltimo();
begin
    if (m_ptr_raiz <> nil) and (m_ptr_ultimo <> nil) then begin
        WriteLn('ID: ' + m_ptr_ultimo^.m_id);
        WriteLn('    A:  [' + m_ptr_ultimo^.m_a + ']');
        WriteLn('    OP: [' + m_ptr_ultimo^.m_op + ']');
        WriteLn('    B:  [' + m_ptr_ultimo^.m_b + ']');
        WriteLn('');
    end;
end;

end.
