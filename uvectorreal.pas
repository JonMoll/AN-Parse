unit UVectorREAL;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils;

type CVectorREAL = class
    public
        m_array : array of real;

        procedure Push(elemento : real);
        procedure Pop();
        procedure Clear();
        function Get(posicion : integer) : real;
        function Size() : integer;

        constructor Create();
end;

implementation

constructor CVectorREAL.Create();
begin
    SetLength(m_array, 0);
end;

procedure CVectorREAL.Push(elemento : real);
begin
    SetLength(m_array, Length(m_array) + 1);
    m_array[Length(m_array) - 1] := elemento;
end;

procedure CVectorREAL.Pop();
begin
    SetLength(m_array, Length(m_array) - 1);
end;

procedure CVectorREAL.Clear();
begin
    SetLength(m_array, 0);
end;

function CVectorREAL.Get(posicion : integer) : real;
begin
    Get := m_array[posicion];
end;

function CVectorREAL.Size() : integer;
begin
    Size := Length(m_array);
end;

end.
