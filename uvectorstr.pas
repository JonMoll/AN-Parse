unit UVectorSTR;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils;

type CVectorSTR = class
    public
        m_array : array of string;

        procedure Push(elemento : string);
        procedure Pop();
        procedure Clear();
        function Get(posicion : integer) : string;
        function Size() : integer;

        constructor Create();
end;

implementation

constructor CVectorSTR.Create();
begin
    SetLength(m_array, 0);
end;

procedure CVectorSTR.Push(elemento : string);
begin
    SetLength(m_array, Length(m_array) + 1);
    m_array[Length(m_array) - 1] := elemento;
end;

procedure CVectorSTR.Pop();
begin
    SetLength(m_array, Length(m_array) - 1);
end;

procedure CVectorSTR.Clear();
begin
    SetLength(m_array, 0);
end;

function CVectorSTR.Get(posicion : integer) : string;
begin
    Get := m_array[posicion];
end;

function CVectorSTR.Size() : integer;
begin
    Size := Length(m_array);
end;

end.
