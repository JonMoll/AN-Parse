unit UParse;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, ULista;

type

CParse = Class
public
    m_expresion : string;

    function StrToLista(expresion : string) : CLista;
    function Evaluar() : real;

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

function CParse.Evaluar() : real;
var lista : CLista;
begin
     lista := StrToLista(m_expresion);
     lista.ImplimirLista();

     Evaluar := 0;
end;

end.

