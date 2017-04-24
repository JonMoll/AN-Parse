unit UArbol;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, UNodo;

type

CArbol = Class
public
    m_ptr_raiz : ptr_nodo;
    m_ptr_ultimo : ptr_nodo;

    procedure Insertar(a, op, b, id : string);
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
