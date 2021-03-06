unit UMatrices;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, Math, UVectorREAL;

const k_sumar = 0;
      k_restar = 1;
      k_multiplicar = 2;
      k_potencia = 3;
      k_determinante = 4;
      k_inversa = 5;

type matriz = array of array of real;

CMatrices = class
    private
        function EliminarFila(matriz_a : matriz; fila : integer) : matriz;
        function EliminarColumna(matriz_a : matriz; columna : integer) : matriz;
        function Cofactor(matriz_a : matriz; fila, columna : integer) : real;
    public
        function Verificar_2(matriz_a, matriz_b : matriz; operacion : integer) : string;
        function Verificar_1(matriz_a : matriz; operacion : integer) : string;

        function Transpuesta(matriz_a : matriz) : matriz;
        function Sumar(matriz_a, matriz_b : matriz) : matriz;
        function Restar(matriz_a, matriz_b : matriz) : matriz;
        function Multiplicar(matriz_a, matriz_b : matriz) : matriz;
        function MultiplicarEsc(matriz_a : matriz; escalar : real) : matriz;
        function Potencia(matriz_a : matriz; exponente : integer) : matriz;
        function Determinante(matriz_a : matriz) : real;
        function Inversa(matriz_a : matriz) : matriz;
end;

implementation

function CMatrices.Verificar_2(matriz_a, matriz_b : matriz; operacion : integer) : string;
var filas_a, filas_b, columnas_a, columnas_b : integer;
begin
    filas_a := Length(matriz_a);
    filas_b := Length(matriz_b);

    columnas_a := Length(matriz_a[0]);
    columnas_b := Length(matriz_b[0]);

    if (operacion = k_sumar) or (operacion = k_restar) then begin
        if (filas_a = filas_b) and (columnas_a = columnas_b) then
            Verificar_2 := 'o: Exito.'
        else
            Verificar_2 := '!: Error, las matrices no tienen el mismo tamaño.';
    end;

    if (operacion = k_multiplicar) then begin
        if (columnas_a = filas_b) then
            Verificar_2 := 'o: Exito.'
        else
            Verificar_2 := '!: Error, la cantidad de columnas de la matriz A y la cantidad de filas de la matriz B no son iguales.';
    end;
end;

function CMatrices.Verificar_1(matriz_a : matriz; operacion : integer) : string;
var filas, columnas : integer;
begin
    filas := Length(matriz_a);
    columnas := Length(matriz_a[0]);

    if (operacion = k_determinante) or (operacion = k_potencia) then begin
        if (filas = columnas) then
            Verificar_1 := 'o: Exito.'
        else
            Verificar_1 := '!: Error, la matriz no es cuadrada.';
    end;

    if (operacion = k_inversa) then begin
        if (filas = columnas) then
            Verificar_1 := 'o: Exito.'
        else begin
            Verificar_1 := '!: Error, la matriz no es cuadrada.';
            Exit;
        end;

        if (Determinante(matriz_a) <> 0) then
            Verificar_1 := 'o: Exito.'
	    else
            Verificar_1 := '!: Error, el determinante de la matriz es cero.'
    end;
end;

function CMatrices.Transpuesta(matriz_a : matriz) : matriz;
var matriz_r : matriz;
    filas, columnas, i, j : integer;
begin
    filas := Length(matriz_a[0]);
    columnas := Length(matriz_a);

    SetLength(matriz_r, filas, columnas);

    for i := 0 to filas - 1 do begin
        for j := 0 to columnas - 1 do
            matriz_r[i][j] := matriz_a[j][i];
    end;

    Transpuesta := matriz_r;
end;

function CMatrices.Sumar(matriz_a, matriz_b : matriz) : matriz;
var matriz_r : matriz;
    filas, columnas, i, j : integer;
begin
    filas := Length(matriz_a);
    columnas := Length(matriz_a[0]);

    SetLength(matriz_r, filas, columnas);

    for i := 0 to filas - 1 do begin
        for j := 0 to columnas - 1 do
            matriz_r[i][j] := matriz_a[i][j] + matriz_b[i][j];
    end;

    Sumar := matriz_r;
end;

function CMatrices.Restar(matriz_a, matriz_b : matriz) : matriz;
var matriz_r : matriz;
    filas, columnas, i, j : integer;
begin
    filas := Length(matriz_a);
    columnas := Length(matriz_a[0]);

    SetLength(matriz_r, filas, columnas);

    for i := 0 to filas - 1 do begin
        for j := 0 to columnas - 1 do
            matriz_r[i][j] := matriz_a[i][j] - matriz_b[i][j];
    end;

    Restar := matriz_r;
end;

function CMatrices.Multiplicar(matriz_a, matriz_b : matriz) : matriz;
var matriz_r : matriz;
    filas, columnas, i, j, k : integer;
    elemento : real;
begin
    filas := Length(matriz_a);
    columnas := Length(matriz_b[0]);

    SetLength(matriz_r, filas, columnas);

    for i := 0 to filas - 1 do begin
        for j := 0 to columnas - 1 do begin
            elemento := 0;

            for k := 0 to Length(matriz_a[0]) - 1 do
                elemento := elemento + (matriz_a[i][k] * matriz_b[k][j]);

            matriz_r[i][j] := elemento;
        end;
    end;

    Multiplicar := matriz_r;
end;

function CMatrices.MultiplicarEsc(matriz_a : matriz; escalar : real) : matriz;
var matriz_r : matriz;
    filas, columnas, i, j : integer;
begin
    filas := Length(matriz_a);
    columnas := Length(matriz_a[0]);

    SetLength(matriz_r, filas, columnas);

    for i := 0 to filas - 1 do begin
        for j := 0 to columnas - 1 do
            matriz_r[i][j] := matriz_a[i][j] * escalar;
    end;

    MultiplicarEsc := matriz_r;
end;

function CMatrices.Potencia(matriz_a : matriz; exponente : integer) : matriz;
var matriz_r : matriz;
    i : integer;
begin
    matriz_r := matriz_a;

    for i := 1 to (exponente - 1) do
        matriz_r := Multiplicar(matriz_r, matriz_a);

    Potencia := matriz_r;
end;

function CMatrices.Determinante(matriz_a : matriz) : real;
var acumulado : real;
    n, i : integer;
begin
    n := Length(matriz_a);

    if (n = 1) then
        Determinante := matriz_a[0][0]
    else begin
        acumulado := 0;

        for i := 0 to n - 1 do
            acumulado := acumulado + matriz_a[0][i] * Cofactor(matriz_a, 0, i);

        Determinante := acumulado;
    end;
end;

function CMatrices.EliminarFila(matriz_a : matriz; fila : integer) : matriz;
var matriz_t : matriz;
    i, j, fila_pos : integer;
begin
    SetLength(matriz_t, Length(matriz_a) - 1, Length(matriz_a[0]));
    fila_pos := 0;

    for i := 0 to Length(matriz_a) - 1 do begin
        for j := 0 to Length(matriz_a[0]) - 1 do begin
            if (i <> fila) then
                matriz_t[fila_pos][j] := matriz_a[i][j];
        end;

        if (i <> fila) then
            fila_pos := fila_pos + 1;
    end;

    EliminarFila := matriz_t;
end;

function CMatrices.EliminarColumna(matriz_a : matriz; columna : integer) : matriz;
var matriz_t : matriz;
    i, j, columna_pos : integer;
begin
    SetLength(matriz_t, Length(matriz_a), Length(matriz_a[0]) - 1);

    columna_pos := 0;
    for i := 0 to Length(matriz_a) - 1 do begin
        for j := 0 to Length(matriz_a[0]) - 1 do begin
            if (j <> columna) then begin
                matriz_t[i][columna_pos] := matriz_a[i][j];
                columna_pos := columna_pos + 1;
            end;
        end;

        columna_pos := 0;
    end;

    EliminarColumna := matriz_t;
end;

function CMatrices.Cofactor(matriz_a : matriz; fila, columna : integer) : real;
var matriz_1, matriz_2 : matriz;
begin
    matriz_1 := EliminarFila(matriz_a, fila);
    matriz_2 := EliminarColumna(matriz_1, columna);

    Cofactor := power(-1, fila + columna) * Determinante(matriz_2);
end;

function CMatrices.Inversa(matriz_a : matriz) : matriz;
var matriz_r : matriz;
    n, i, j, k, columnas : integer;
    diagonal, espejo : real;
    fila_temporal : CVectorReal;
begin
    n := Length(matriz_a);
    columnas := 2 * n;

    SetLength(matriz_a, n, n * 2);

    //AGREGANDO LA MATRIZ IDENTIDAD
    for i := 0 to n - 1 do begin
        for j := n to Length(matriz_a[0]) - 1 do begin
            if (i = j - n) then
                matriz_a[i][j] := 1
            else
                matriz_a[i][j] := 0;
        end;
    end;

    //METODO DE GAUSS
    fila_temporal := CVectorREAL.Create();

    for i := 0 to n - 1 do begin //RECORRIENDO LA MATRIZ ORIGINAL
        diagonal := matriz_a[i][i];

        for j := 0 to Length(matriz_a[0]) - 1 do //IGUALANDO LA DIAGONAL A 1
            matriz_a[i][j] := matriz_a[i][j] / diagonal;

        for j := 0 to n - 1 do begin
            if (i <> j) then begin //IGUALANDO LOS ELEMENTOS A 0
                espejo := matriz_a[j][i];

                for k := 0 to columnas - 1 do
                    fila_temporal.Push(matriz_a[i][k] * -espejo);

                    for k := 0 to columnas - 1 do
                         matriz_a[j][k] := matriz_a[j][k] + fila_temporal.Get(k);

                    fila_temporal.Clear();
            end;
        end;
    end;

    fila_temporal.Destroy();

    //COPIANDO LA MATRIZ INVERSA
    SetLength(matriz_r, n, n);

    for i := 0 to n - 1 do begin
        for j := n to Length(matriz_a[0]) - 1 do
            matriz_r[i][j-n] := matriz_a[i][j];
    end;

    Inversa := matriz_r;
end;

end.

