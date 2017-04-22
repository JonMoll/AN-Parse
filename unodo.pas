unit UNodo;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils;

const

RAIZ = 'Nodo raiz';
IZQUIERDA = 'Nodo en izquierda';
DERECHA = 'Nodo en derecha';

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

implementation

end.

