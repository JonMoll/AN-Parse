unit UParse;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, Math, ULista, UArbol, UNodo;

const

ESTADO_VACIO = 0;
ESTADO_A = 1;
ESTADO_A_OP = 2;
ESTADO_A_OP_B = 3;

type

CParse = Class
public
    m_expresion : string;

    function StrToLista(expresion : string) : CLista;
    function Operar(nodo : ptr_nodo) : string;
    function EvaluacionLineal() : string;

    constructor Create();
end;

implementation

constructor CParse.Create();
begin
    m_expresion := '';
end;

function CParse.StrToLista(expresion : string) : CLista;
var lista : CLista;
    i, tipo_actual : integer;
    elemento_actual : string;
begin
    expresion := expresion + ' ';

    lista := CLista.Create();
    tipo_actual := lista.Tipo(expresion[1]);
    elemento_actual := '';

    for i := 1 to expresion.Length do begin
        if (lista.Tipo(expresion[i]) <> tipo_actual) then begin
            lista.Insertar(elemento_actual);
            elemento_actual := expresion[i];
            tipo_actual := lista.Tipo(expresion[i]);
        end
        else
            elemento_actual := elemento_actual + expresion[i];
    end;

    StrToLista := lista;
end;

function CParse.Operar(nodo : ptr_nodo) : string;
var a, b : real;
    op : string;
begin
    a := StrToFloat(nodo^.m_a);
    b := StrToFloat(nodo^.m_b);
    op := nodo^.m_op;

    if (op = '+') then
        Operar := FloatToStr(a + b)
    else if (op = '-') then
        Operar := FloatToStr(a - b)
    else if (op = '*') then
        Operar := FloatToStr(a * b)
    else if (op = '/') then
        Operar := FloatToStr(a / b)
    else if (op = '^') then
        Operar := FloatToStr( power(a,b) );
end;

function CParse.EvaluacionLineal() : string;
var lista : CLista;
    arbol : CArbol;
    ptr_i : ptr_nodolista;
    i, nodoactual_estado : integer;
    a, b : real;
begin
     lista := StrToLista(m_expresion);
     lista.ImplimirLista();

     arbol := CArbol.Create();

     nodoactual_estado := ESTADO_VACIO;

     ptr_i := lista.m_ptr_primero;
     for i := 0 to lista.m_tamano - 1 do begin
         // --------------------------------------------------
         if (nodoactual_estado = ESTADO_VACIO) then begin
             if (ptr_i^.m_tipo = NUMERO) then begin
                arbol.Insertar(ptr_i^.m_contenido, '', '', '');
                nodoactual_estado := ESTADO_A;
             end;
         end
         // --------------------------------------------------
         else if (nodoactual_estado = ESTADO_A) then begin
             if (ptr_i^.m_tipo = OPERADOR) then begin
                arbol.m_ptr_ultimo^.m_op := ptr_i^.m_contenido;
                nodoactual_estado := ESTADO_A_OP;
             end;
         end
         // --------------------------------------------------
         else if (nodoactual_estado = ESTADO_A_OP) then begin
             if (ptr_i^.m_tipo = NUMERO) then begin
                arbol.m_ptr_ultimo^.m_b := ptr_i^.m_contenido;
                nodoactual_estado := ESTADO_A_OP_B;
             end;
         end;
         // --------------------------------------------------
         if (nodoactual_estado = ESTADO_A_OP_B) then begin
             arbol.m_ptr_ultimo^.m_a := Operar(arbol.m_ptr_ultimo);
             arbol.m_ptr_ultimo^.m_op := '';
             arbol.m_ptr_ultimo^.m_b := '';

             nodoactual_estado := ESTADO_A;
         end;

         ptr_i := ptr_i^.m_ptr_sig;
     end;

     EvaluacionLineal := arbol.m_ptr_raiz^.m_a;
end;

end.

