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
    function ListaToStr(lista : CLista) : string;
    function Operar(nodo : ptr_nodo) : string;
    function EvaluacionLineal(expresion : string) : string;
    function Evaluar() : string;

    constructor Create();
end;

implementation

constructor CParse.Create();
begin
    m_expresion := '';
end;

function CParse.StrToLista(expresion : string) : CLista;
var lista : CLista;
    i : integer;
    elemento_actual : string;
begin
    expresion := expresion + ' ';

    lista := CLista.Create();
    elemento_actual := '';

    for i := 1 to expresion.Length do begin
        if  (expresion[i] = ' ') or
            (expresion[i] = '+') or
            (expresion[i] = '-') or
            (expresion[i] = '*') or
            (expresion[i] = '/') or
            (expresion[i] = '^') or
            (expresion[i] = '(') or
            (expresion[i] = ')') then begin

            if (expresion[i] = ' ') then begin
                if (elemento_actual <> '') then
                    lista.Insertar(elemento_actual);
            end
            else begin
                if (elemento_actual <> '') then
                    lista.Insertar(elemento_actual);

                lista.Insertar(expresion[i]);

                elemento_actual := '';
            end;
        end
        else if (lista.Tipo(expresion[i]) = NUMERO) then begin
            elemento_actual := elemento_actual + expresion[i];
        end;
    end;

    StrToLista := lista;
end;

function CParse.ListaToStr(lista : CLista) : string;
var ptr_i : ptr_nodolista;
    i : integer;
    expresion : string;
begin
    expresion := '';
    ptr_i := lista.m_ptr_primero;

    for i := 0 to lista.m_tamano - 1 do begin
        expresion := expresion + ptr_i^.m_contenido;

        ptr_i := ptr_i^.m_ptr_sig;
    end;

    ListaToStr := expresion;
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

function CParse.EvaluacionLineal(expresion : string) : string;
var lista : CLista;
    arbol : CArbol;
    ptr_i : ptr_nodolista;
    i, nodoactual_estado : integer;
begin
     lista := StrToLista(expresion);
     lista.ImplimirLista();

     arbol := CArbol.Create();

     nodoactual_estado := ESTADO_VACIO;

     ptr_i := lista.m_ptr_primero;
     for i := 0 to lista.m_tamano - 1 do begin
         WriteLn('--------------------------------------------------');
         WriteLn('Elemento actual: ' + ptr_i^.m_contenido);

         if (ptr_i^.m_tipo = PARENTESIS_CERRADO) then begin
             if (arbol.m_ptr_ultimo^.m_id = IZQUIERDA) then begin
                 arbol.m_ptr_ultimo^.m_ptr_ant^.m_a := arbol.m_ptr_ultimo^.m_a;

                 arbol.m_ptr_ultimo := arbol.m_ptr_ultimo^.m_ptr_ant;
                 arbol.m_ptr_ultimo^.m_ptr_izq := nil;

                 arbol.ImprimirUltimo();

                 nodoactual_estado := ESTADO_A;
             end
             else if (arbol.m_ptr_ultimo^.m_id = DERECHA) then begin
                 arbol.m_ptr_ultimo^.m_ptr_ant^.m_b := arbol.m_ptr_ultimo^.m_a;

                 arbol.m_ptr_ultimo := arbol.m_ptr_ultimo^.m_ptr_ant;
                 arbol.m_ptr_ultimo^.m_ptr_der := nil;

                 arbol.ImprimirUltimo();

                 nodoactual_estado := ESTADO_A_OP_B;
             end;
         end
         // --------------------------------------------------
         else if (nodoactual_estado = ESTADO_VACIO) then begin
             if (ptr_i^.m_tipo = NUMERO) then begin
                 if (arbol.m_ptr_raiz = nil) then begin
                    arbol.Insertar(ptr_i^.m_contenido, '', '', '');

                    arbol.ImprimirUltimo();

                    nodoactual_estado := ESTADO_A;
                 end
                 else begin
                    arbol.m_ptr_ultimo^.m_a := ptr_i^.m_contenido;

                    arbol.ImprimirUltimo();

                    nodoactual_estado := ESTADO_A;
                 end;
             end;

             if (ptr_i^.m_tipo = PARENTESIS_ABIERTO) then begin
                 arbol.Insertar(ptr_i^.m_contenido, '', '', '');
                 arbol.Insertar('', '', '', IZQUIERDA);

                 arbol.ImprimirUltimo();
             end;
         end
         // --------------------------------------------------
         else if (nodoactual_estado = ESTADO_A) then begin
             if (ptr_i^.m_tipo = OPERADOR) then begin
                 arbol.m_ptr_ultimo^.m_op := ptr_i^.m_contenido;

                 arbol.ImprimirUltimo();

                 nodoactual_estado := ESTADO_A_OP;
             end;
         end
         // --------------------------------------------------
         else if (nodoactual_estado = ESTADO_A_OP) then begin
             if (ptr_i^.m_tipo = NUMERO) then begin
                 arbol.m_ptr_ultimo^.m_b := ptr_i^.m_contenido;

                 arbol.ImprimirUltimo();

                 nodoactual_estado := ESTADO_A_OP_B;
             end;

             if (ptr_i^.m_tipo = PARENTESIS_ABIERTO) then begin
                 arbol.m_ptr_ultimo^.m_b := '(';

                 arbol.ImprimirUltimo();

                 arbol.Insertar('', '', '', DERECHA);

                 arbol.ImprimirUltimo();

                 nodoactual_estado := ESTADO_VACIO;
             end;
         end;
         // --------------------------------------------------
         if (nodoactual_estado = ESTADO_A_OP_B) then begin
             arbol.m_ptr_ultimo^.m_a := Operar(arbol.m_ptr_ultimo);
             arbol.m_ptr_ultimo^.m_op := '';
             arbol.m_ptr_ultimo^.m_b := '';

             arbol.ImprimirUltimo();

             nodoactual_estado := ESTADO_A;
         end;

         ptr_i := ptr_i^.m_ptr_sig;
     end;

     EvaluacionLineal := arbol.m_ptr_raiz^.m_a;
end;

function CParse.Evaluar() : string;
var i : integer;
    ptr_i : ptr_nodolista;
    lista : CLista;
    subexpresion : string;
begin
    lista := StrToLista(m_expresion);

    // RESOLVIENDO LAS PRIORIDADES DE POTENCIA
    ptr_i := lista.m_ptr_primero;
    i := 0;

    while (i <= lista.m_tamano - 1) do begin
        if (ptr_i^.m_contenido = '^') then begin
            if ( ptr_i^.m_ptr_ant^.m_contenido <> ')' ) and ( ptr_i^.m_ptr_sig^.m_contenido <> '(' ) then begin
                subexpresion := ptr_i^.m_ptr_ant^.m_contenido + ptr_i^.m_contenido + ptr_i^.m_ptr_sig^.m_contenido;
                lista.Eliminar3(ptr_i^.m_ptr_ant, EvaluacionLineal(subexpresion));

                i := 0;
                ptr_i := lista.m_ptr_primero;
            end;
        end;

        ptr_i := ptr_i^.m_ptr_sig;
        i := i + 1;
    end;

    // RESOLVIENDO LAS PRIORIDADES DE MULTIPLICACION Y DIVISION
    ptr_i := lista.m_ptr_primero;
    i := 0;

    while (i <= lista.m_tamano - 1) do begin
        if (ptr_i^.m_contenido = '*') or (ptr_i^.m_contenido = '/') then begin
            if ( ptr_i^.m_ptr_ant^.m_contenido <> ')' ) and ( ptr_i^.m_ptr_sig^.m_contenido <> '(' ) then begin
                subexpresion := ptr_i^.m_ptr_ant^.m_contenido + ptr_i^.m_contenido + ptr_i^.m_ptr_sig^.m_contenido;
                lista.Eliminar3(ptr_i^.m_ptr_ant, EvaluacionLineal(subexpresion));

                i := 0;
                ptr_i := lista.m_ptr_primero;
            end;
        end;

        ptr_i := ptr_i^.m_ptr_sig;
        i := i + 1;
    end;

    Evaluar := EvaluacionLineal(ListaToStr(lista));
end;

end.

