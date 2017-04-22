unit UNodo;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils;

const

RAIZ = 'Nodo raiz';
IZQUIERDA = 'Nodo en izquierda';
DERECHA = 'Nodo en derecha';

NUMERO = 1;
OPERADOR = 2;
PARENTESIS_ABIERTO = 3;
PARENTESIS_CERRADO = 4;
ESPACIO = 5;

type

ptr_nodo = ^CNodo;

CNodo = record
    m_id : string;

    m_a : string;
    m_op : string;
    m_b : string;

    m_ptr_ant : ptr_nodo;
    m_ptr_izq : ptr_nodo;
    m_ptr_der : ptr_nodo;
end;

ptr_nodolista = ^CNodoLista;

CNodoLista = record
    m_id : integer;

    m_tipo : integer;
    m_contenido : string;

    m_ptr_ant : ptr_nodolista;
    m_ptr_sig : ptr_nodolista;
end;

implementation

end.

