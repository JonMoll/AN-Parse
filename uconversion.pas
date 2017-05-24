unit UConversion;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils;

type matriz = array of array of real;

CConversion = class
public
    function StrToMatrix(entrada : string) : matriz;
    function MatrixToStr(entrada : matriz) : string;
end;

implementation

function CConversion.StrToMatrix(entrada : string) : matriz;
var matriz_r : matriz;
    i, x, y, filas, columnas : integer;
    columnas_completas : boolean;
    elemento : string;
begin
    filas := 0;
    columnas := 1;
    columnas_completas := False;

    // CONTANDO FILAS Y COLUMNAS
    for i := 2 to Length(entrada) do begin
        if (entrada[i] = ';') or (entrada[i] = ']') then begin
            filas := filas + 1;
            columnas_completas := True;
        end;

        if (entrada[i] = ' ') and (columnas_completas = False) then
            columnas := columnas + 1;
    end;

    // RELLENANDO LA MATRIZ
    SetLength(matriz_r, filas, columnas);
    elemento := '';
    x := 0;
    y := 0;

    for i := 2 to Length(entrada) do begin
        if (entrada[i] = ' ') then begin
            matriz_r[x][y] := StrToFloat(elemento);
            elemento := '';
            y := y + 1;
        end
        else if (entrada[i] = ';') or (entrada[i] = ']') then begin
            matriz_r[x][y] := StrToFloat(elemento);
            elemento := '';
            x := x + 1;
            y := 0;
        end
        else if (entrada[i] <> '[') then
            elemento := elemento + entrada[i];
    end;

    StrToMatrix := matriz_r;
end;

function CConversion.MatrixToStr(entrada : matriz) : string;
var i, j : integer;
    salida : string;
begin
    salida := '[';
    for i := 0 to Length(entrada) - 1 do begin
        for j := 0 to Length(entrada[0]) - 1 do begin
            if (j <> Length(entrada[0]) - 1) then
                salida := salida + FloatToStr(entrada[i][j]) + ' '
            else if (i <> Length(entrada) - 1) then
                salida := salida + FloatToStr(entrada[i][j]) + ';'
            else
                salida := salida + FloatToStr(entrada[i][j]) + ']';
        end;
    end;

    MatrixToStr := salida;
end;

end.

