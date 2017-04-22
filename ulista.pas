unit ULista;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, UNodo;

type

CLista = Class
public
    m_ptr_primero : ptr_nodolista;
    m_ptr_ultimo : ptr_nodolista;
    m_tamano : integer;

    function Tipo(elemento : string) : integer;
    procedure Insertar(contenido : string);
    procedure ImplimirLista();

    constructor Create();
end;

implementation

constructor CLista.Create();
begin
    m_ptr_primero := nil;
    m_ptr_ultimo := nil;
    m_tamano := 0;
end;

function CLista.Tipo(elemento : string) : integer;
begin
    if (elemento = '+') or (elemento = '-') or (elemento = '*') or (elemento = '/') or (elemento = '^') then
        Tipo := OPERADOR
    else if (elemento = '(') then
        Tipo := PARENTESIS_ABIERTO
    else if (elemento = ')') then
        Tipo := PARENTESIS_CERRADO
    else if (elemento = ' ') then
        Tipo := ESPACIO
    else
        Tipo := NUMERO;
end;

procedure CLista.Insertar(contenido : string);
begin
    if (m_ptr_primero = nil) then begin
        new(m_ptr_ultimo);

        m_ptr_ultimo^.m_id := m_tamano;
        m_tamano := m_tamano + 1;

        m_ptr_ultimo^.m_tipo := Tipo(contenido);
        m_ptr_ultimo^.m_contenido := contenido;

        m_ptr_ultimo^.m_ptr_ant := nil;
        m_ptr_ultimo^.m_ptr_sig := nil;

        m_ptr_primero := m_ptr_ultimo;
    end
    else begin
        new(m_ptr_ultimo^.m_ptr_sig);

        m_ptr_ultimo^.m_ptr_sig^.m_id := m_tamano;
        m_tamano := m_tamano + 1;

        m_ptr_ultimo^.m_ptr_sig^.m_tipo := Tipo(contenido);
        m_ptr_ultimo^.m_ptr_sig^.m_contenido := contenido;

        m_ptr_ultimo^.m_ptr_sig^.m_ptr_ant := m_ptr_ultimo;
        m_ptr_ultimo^.m_ptr_sig^.m_ptr_sig := nil;

        m_ptr_ultimo := m_ptr_ultimo^.m_ptr_sig;
    end;
end;

procedure CLista.ImplimirLista();
var i : integer;
    ptr_temp : ptr_nodolista;
    lista : string;
begin
    if (m_ptr_primero <> nil) then begin
        ptr_temp := m_ptr_primero;
        lista := '[ ';

        for i := 0 to m_tamano - 2 do begin
            lista := lista + ptr_temp^.m_contenido;
            lista := lista + ' ][ ';

            ptr_temp := ptr_temp^.m_ptr_sig;
        end;

        lista := lista + ptr_temp^.m_contenido;
        lista := lista + ' ]';

        WriteLn(lista);
    end;
end;

end.

