unit UParse;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, Math, ULista, UArbol, UNodo, UConversion, UMatrices;

const

ESTADO_VACIO = 0;
ESTADO_A = 1;
ESTADO_A_OP = 2;
ESTADO_A_OP_B = 3;

type

CParse = Class
public
    m_expresion : string;
    m_MemoriaVar: array of string;
    m_MemoriaVal: array of real;

    function StrToLista(expresion : string) : CLista;
    function ListaToStr(lista : CLista) : string;
    function Operar(nodo : ptr_nodo) : string;
    function EvaluacionLineal(expresion : string) : string;
    function Evaluar() : string;

    procedure RecivirVAriable(variable: string; valor:real);


    constructor Create();
end;

implementation

constructor CParse.Create();
begin
    m_expresion := '';
    SetLength(m_MemoriaVal,0);
    SetLength(m_MemoriaVar,0);
end;

function CParse.StrToLista(expresion : string) : CLista;
var lista : CLista;
    i : integer;
    elemento_actual : string;
    flag_matriz : boolean;
begin
    expresion := expresion + ' ';

    lista := CLista.Create();
    elemento_actual := '';
    flag_matriz := False;

    i := 1;
    while i<=Length(expresion) do begin
        if (flag_matriz = True) and (expresion[i] = '-') then begin
            elemento_actual := elemento_actual + expresion[i];
        end
        else if (flag_matriz = False) and
            (expresion[i] = ' ') or
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
        else if (expresion[i] = ']') then begin
            elemento_actual := elemento_actual + expresion[i];
            flag_matriz := False;
        end
        else if (expresion[i] = '[') or (flag_matriz = True) then begin
            elemento_actual := elemento_actual + expresion[i];
            flag_matriz := True;
        end
        else if ((expresion[i] = 'd') and (expresion[i+1] = 'e') and (expresion[i+2] = 't')) then begin

            lista.Insertar('det');
            lista.Insertar('$');
            i:=i+2;
        end
        else if ((expresion[i] = 'i') and (expresion[i+1] = 'n') and (expresion[i+2] = 'v')) then begin

            lista.Insertar('inv');
            lista.Insertar('$');
            i:=i+2;
        end
        else if ((expresion[i] = 's') and (expresion[i+1] = 'i') and (expresion[i+2] = 'n')) then begin

            lista.Insertar('sin');
            lista.Insertar('$');
            i:=i+2;
        end
        else if ((expresion[i] = 'c') and (expresion[i+1] = 'o') and (expresion[i+2] = 's')) then begin
            lista.Insertar('cos');
            lista.Insertar('$');
            i:=i+2;
        end
        else if ((expresion[i] = 't') and (expresion[i+1] = 'a') and (expresion[i+2] = 'n')) then begin
            lista.Insertar('tan');
            lista.Insertar('$');
            i:=i+2;
        end
        else if ((expresion[i] = 'c') and (expresion[i+1] = 'o') and (expresion[i+2] = 't') and (expresion[i+3] = 'a') and (expresion[i+4] = 'n')) then begin
            lista.Insertar('cotan');
            lista.Insertar('$');
            i:=i+4;
        end
        else if ((expresion[i] = 's') and (expresion[i+1] = 'e') and (expresion[i+2] = 'c')) then begin
            lista.Insertar('sec');
            lista.Insertar('$');
            i:=i+2;
        end
        else if ((expresion[i] = 'c') and (expresion[i+1] = 's') and (expresion[i+2] = 'c')) then begin
            lista.Insertar('csc');
            lista.Insertar('$');
            i:=i+2;
        end
        else if ((expresion[i] = 's') and (expresion[i+1] = 'i') and (expresion[i+2] = 'n') and (expresion[i+3] = 'h')) then begin

            lista.Insertar('sinh');
            lista.Insertar('$');
            i:=i+3;
        end
        else if ((expresion[i] = 'c') and (expresion[i+1] = 'o') and (expresion[i+2] = 's') and (expresion[i+3] = 'h')) then begin
            lista.Insertar('cosh');
            lista.Insertar('$');
            i:=i+3;
        end
        else if ((expresion[i] = 't') and (expresion[i+1] = 'a') and (expresion[i+2] = 'n') and (expresion[i+3] = 'h')) then begin
            lista.Insertar('tanh');
            lista.Insertar('$');
            i:=i+3;
        end
        else if ((expresion[i] = 'e') and (expresion[i+1] = 'x') and (expresion[i+2] = 'p')) then begin
            lista.Insertar('exp');
            lista.Insertar('$');
            i:=i+2;
        end
        else if ((expresion[i] = 'l') and (expresion[i+1] = 'o') and (expresion[i+2] = 'g') ) then begin
            lista.Insertar('cotan');
            lista.Insertar('$');
            i:=i+2;
        end
        else if ((expresion[i] = 'l') and (expresion[i+1] = 'n')) then begin
            lista.Insertar('ln');
            lista.Insertar('$');
            i:=i+1;
        end


        else if (lista.Tipo(expresion[i]) = NUMERO) then begin
            elemento_actual := elemento_actual + expresion[i];
        end;
        i:=i+1;
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
    cast : CConversion;
    ope_m : CMatrices;
    m_a, m_b, m_r : matriz;
begin
    if (nodo^.m_a[1] = '[') or (nodo^.m_b[1] = '[') then begin
        cast := CConversion.Create();
        ope_m := CMatrices.Create();

        if (nodo^.m_op = '+') then begin
            m_a := cast.StrToMatrix(nodo^.m_a);
            m_b := cast.StrToMatrix(nodo^.m_b);
            m_r := ope_m.Sumar(m_a, m_b);

            Operar := cast.MatrixToStr(m_r);
        end
        else if (nodo^.m_op = '-') then begin
            m_a := cast.StrToMatrix(nodo^.m_a);
            m_b := cast.StrToMatrix(nodo^.m_b);
            m_r := ope_m.Restar(m_a, m_b);

            Operar := cast.MatrixToStr(m_r);
        end
        else if (nodo^.m_op = '*') then begin
            m_a := cast.StrToMatrix(nodo^.m_a);
            m_b := cast.StrToMatrix(nodo^.m_b);
            m_r := ope_m.Multiplicar(m_a, m_b);

            Operar := cast.MatrixToStr(m_r);
        end
        else if (nodo^.m_op = '$') and (nodo^.m_a = 'det') then begin
            m_b := cast.StrToMatrix(nodo^.m_b);
            Operar := FloatToStr(ope_m.Determinante(m_b));
        end
        else if (nodo^.m_op = '$') and (nodo^.m_a = 'inv') then begin
            m_b := cast.StrToMatrix(nodo^.m_b);
            m_r := ope_m.Inversa(m_b);
            Operar := cast.MatrixToStr(m_r);
        end;

        ope_m.Destroy();
        cast.Destroy();
        Exit;
    end;

    //***primero vemos si es una funcion
    op := nodo^.m_op;
    b := StrToFloat(nodo^.m_b);
    if (op = '$') and (nodo^.m_a='sin') then begin
        Operar:=FloatToStr(sin(b));
        Exit;
    end;
    if (op = '$') and (nodo^.m_a='cos') then begin
        Operar:=FloatToStr(cos(b));
        Exit;
    end;
    if (op = '$') and (nodo^.m_a='tan') then begin
        Operar:=FloatToStr(tan(b));
        Exit;
    end;
    if (op = '$') and (nodo^.m_a='cotan') then begin
        Operar:=FloatToStr(cotan(b));
        Exit;
    end;
    if (op = '$') and (nodo^.m_a='sec') then begin
        Operar:=FloatToStr(sec(b));
        Exit;
    end;
    if (op = '$') and (nodo^.m_a='csc') then begin
        Operar:=FloatToStr(csc(b));
        Exit;
    end;
    //----------------hiperbolicos--------------
    if (op = '$') and (nodo^.m_a='cosh') then begin
        Operar:=FloatToStr(cosh(b));
        Exit;
    end;
    if (op = '$') and (nodo^.m_a='sinh') then begin
        Operar:=FloatToStr(sinh(b));
        Exit;
    end;
    if (op = '$') and (nodo^.m_a='tanh') then begin
        Operar:=FloatToStr(tanh(b));
        Exit;
    end;
    //----------------otros--------------
    if (op = '$') and (nodo^.m_a='exp') then begin
        Operar:=FloatToStr(exp(b));
        Exit;
    end;
    if (op = '$') and (nodo^.m_a='log') then begin
        Operar:=FloatToStr(log10(b));
        Exit;
    end;
    if (op = '$') and (nodo^.m_a='ln') then begin
        Operar:=FloatToStr(ln(b));
        Exit;
    end;


    a := StrToFloat(nodo^.m_a);

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

     WriteLn('*****Ver lista****');
     lista.ImplimirLista();

     arbol := CArbol.Create();

     nodoactual_estado := ESTADO_VACIO;

     try
     ptr_i := lista.m_ptr_primero;
     for i := 0 to lista.m_tamano - 1 do begin
         //WriteLn('--------------------------------------------------');
         //WriteLn('Elemento actual: ' + ptr_i^.m_contenido + '   [ estado: ' + IntToStr(nodoactual_estado) + ' ]');

         if (ptr_i^.m_tipo = PARENTESIS_CERRADO) then begin
             if (arbol.m_ptr_ultimo^.m_id = IZQUIERDA) then begin
                 arbol.m_ptr_ultimo^.m_ptr_ant^.m_a := arbol.m_ptr_ultimo^.m_a;

                 arbol.m_ptr_ultimo := arbol.m_ptr_ultimo^.m_ptr_ant;
                 arbol.m_ptr_ultimo^.m_ptr_izq := nil;

                 //arbol.ImprimirUltimo();

                 nodoactual_estado := ESTADO_A;
             end
             else if (arbol.m_ptr_ultimo^.m_id = DERECHA) then begin
                 arbol.m_ptr_ultimo^.m_ptr_ant^.m_b := arbol.m_ptr_ultimo^.m_a;

                 arbol.m_ptr_ultimo := arbol.m_ptr_ultimo^.m_ptr_ant;
                 arbol.m_ptr_ultimo^.m_ptr_der := nil;

                 //arbol.ImprimirUltimo();

                 nodoactual_estado := ESTADO_A_OP_B;
             end;
         end
         // --------------------------------------------------
         else if (nodoactual_estado = ESTADO_VACIO) then begin
             if (ptr_i^.m_tipo = NUMERO) or (ptr_i^.m_tipo = T_MATRIZ) then begin
                 if (arbol.m_ptr_raiz = nil) then begin
                    arbol.Insertar(ptr_i^.m_contenido, '', '', '');

                    //arbol.ImprimirUltimo();

                    nodoactual_estado := ESTADO_A;
                 end
                 else begin
                    arbol.m_ptr_ultimo^.m_a := ptr_i^.m_contenido;

                    //arbol.ImprimirUltimo();

                    nodoactual_estado := ESTADO_A;
                 end;
             end;

             if (ptr_i^.m_tipo = PARENTESIS_ABIERTO) then begin

                 if (arbol.m_ptr_raiz = nil) then begin
                    arbol.Insertar(ptr_i^.m_contenido, '', '', '');

                    //arbol.ImprimirUltimo();

                    arbol.Insertar('', '', '', IZQUIERDA);

                    //arbol.ImprimirUltimo();
                 end
                 else begin
                    arbol.m_ptr_ultimo^.m_a := ptr_i^.m_contenido;

                    //arbol.ImprimirUltimo();
                    arbol.Insertar('', '', '', IZQUIERDA);

                    //arbol.ImprimirUltimo();
                 end;
             end;


         end
         // --------------------------------------------------
         else if (nodoactual_estado = ESTADO_A) then begin

             if (ptr_i^.m_tipo = OPERADOR) then begin
                 arbol.m_ptr_ultimo^.m_op := ptr_i^.m_contenido;

                 //arbol.ImprimirUltimo();

                 nodoactual_estado := ESTADO_A_OP;
             end;
         end
         // --------------------------------------------------
         else if (nodoactual_estado = ESTADO_A_OP) then begin
             if (ptr_i^.m_tipo = NUMERO) or (ptr_i^.m_tipo = T_MATRIZ) then begin
                 arbol.m_ptr_ultimo^.m_b := ptr_i^.m_contenido;

                 //arbol.ImprimirUltimo();

                 nodoactual_estado := ESTADO_A_OP_B;
             end;
             if (ptr_i^.m_tipo = PARENTESIS_ABIERTO) then begin
                 arbol.m_ptr_ultimo^.m_b := '(';

                 //arbol.ImprimirUltimo();

                 arbol.Insertar('', '', '', DERECHA);

                 //arbol.ImprimirUltimo();

                 nodoactual_estado := ESTADO_VACIO;
             end;
         end;
         // --------------------------------------------------
         if (nodoactual_estado = ESTADO_A_OP_B) then begin

             arbol.m_ptr_ultimo^.m_a := Operar(arbol.m_ptr_ultimo);

             //WriteLn(arbol.m_ptr_ultimo^.m_a);

             arbol.m_ptr_ultimo^.m_op := '';
             arbol.m_ptr_ultimo^.m_b := '';

             //arbol.ImprimirUltimo();

             nodoactual_estado := ESTADO_A;
         end;

         ptr_i := ptr_i^.m_ptr_sig;
     end;

     except
        WriteLn('Error');

        Exit();
     end;

     EvaluacionLineal := arbol.m_ptr_raiz^.m_a;
end;

function CParse.Evaluar() : string;
var i, i_temp, estado_operacion, parentesis_pendientes, parentesis_izq, parentesis_der, j, encontro, k : integer;
    ptr_i, ptr_j, ptr_temp : ptr_nodolista;
    subexpresion, operador_actual, new_exp : string;
    Arr : array of Char;
    lista : CLista;
begin
    //AQUI SE CAMBIA LAS VARIABLES A NUMEROS ANTES DE PASAR A LA EXPRESION
    //WriteLn('Cambio ');
    if Length(m_MemoriaVal)>0 then
    begin
        SetLength(Arr,Length(m_expresion));
        for i:= 1 to Length(m_expresion) do
          Arr[i - 1] := m_expresion[i];

        for i := 0 to Length(Arr)-1 do
        begin
            encontro:=0;
            for j := 0 to Length(m_MemoriaVar)-1 do
            begin
                if Arr[i]=m_MemoriaVar[j] then
                  begin
                    new_exp:=new_exp+FloatToStr(m_MemoriaVal[j]);
                    encontro:=1;
                  end;
            end;
            if encontro=0 then
               new_exp:=new_exp+Arr[i];
        end;
    end
    else
      begin
          new_exp:=m_expresion;
      end;
    //WriteLn('Cambio de variable a su valor');
    //WriteLn(new_exp);

    m_expresion:=new_exp;
    //WriteLn('Lissta antes del parentesis');
    lista := StrToLista(m_expresion);


    // RESOLVIENDO LAS PRIORIDADES DE POTENCIA AGREGANDO PARENTESIS
    for k := 0 to 5 do begin
        ptr_i := lista.m_ptr_primero;
        i := 0;
        if (k = 0) then operador_actual := '$';
        if (k = 1) then operador_actual := '^';
        if (k = 2) then operador_actual := '/';
        if (k = 3) then operador_actual := '*';
        if (k = 4) then operador_actual := '-';
        if (k = 5) then operador_actual := '+';


        while (i < lista.m_tamano - 1) do begin
            if (ptr_i^.m_contenido = operador_actual) then begin
                if ( ptr_i^.m_ptr_ant^.m_contenido <> ')' ) and ( ptr_i^.m_ptr_sig^.m_contenido <> '(' ) then begin
                    i_temp := i;

                    lista.InsertarSigAnt(ptr_i^.m_ptr_sig, SIGUIENTE, ')');
                    lista.InsertarSigAnt(ptr_i^.m_ptr_ant, ANTERIOR, '(');

                    ptr_i := ptr_i^.m_ptr_sig;
                    i := i_temp + 2;
                end
                else if ( ptr_i^.m_ptr_ant^.m_contenido <> ')' ) and ( ptr_i^.m_ptr_sig^.m_contenido = '(' ) then begin
                    ptr_temp := ptr_i;
                    i_temp := i;

                    estado_operacion := 0;
                    parentesis_pendientes := 0;

                    ptr_i := ptr_i^.m_ptr_ant;
                    lista.InsertarSigAnt(ptr_i, ANTERIOR, '(');

                    ptr_i := ptr_i^.m_ptr_ant;
                    while (estado_operacion <> 3) or (parentesis_pendientes <> 0) do begin
                        ptr_i := ptr_i^.m_ptr_sig;

                        if (ptr_i^.m_tipo = PARENTESIS_ABIERTO) then
                            parentesis_pendientes := parentesis_pendientes + 1
                        else if (ptr_i^.m_tipo = PARENTESIS_CERRADO) then
                            parentesis_pendientes := parentesis_pendientes - 1
                        else begin
                            if (estado_operacion < 3) then
                                estado_operacion := estado_operacion + 1;
                        end;
                    end;

                    lista.InsertarSigAnt(ptr_i, SIGUIENTE, ')');

                    ptr_i := ptr_temp^.m_ptr_sig;
                    i := i_temp + 2;
                end
                else if ( ptr_i^.m_ptr_ant^.m_contenido = ')' ) and ( ptr_i^.m_ptr_sig^.m_contenido <> '(' ) then begin
                    ptr_temp := ptr_i;
                    i_temp := i;

                    estado_operacion := 0;
                    parentesis_pendientes := 0;

                    ptr_i := ptr_i^.m_ptr_sig;
                    lista.InsertarSigAnt(ptr_i, SIGUIENTE, ')');

                    ptr_i := ptr_i^.m_ptr_sig;
                    while (estado_operacion <> 3) or (parentesis_pendientes <> 0) do begin
                        ptr_i := ptr_i^.m_ptr_ant;

                        if (ptr_i^.m_tipo = PARENTESIS_CERRADO) then
                            parentesis_pendientes := parentesis_pendientes + 1
                        else if (ptr_i^.m_tipo = PARENTESIS_ABIERTO) then
                            parentesis_pendientes := parentesis_pendientes - 1
                        else begin
                            if (estado_operacion < 3) then
                                estado_operacion := estado_operacion + 1;
                        end;
                    end;

                    lista.InsertarSigAnt(ptr_i, ANTERIOR, '(');

                    ptr_i := ptr_temp^.m_ptr_sig;
                    i := i_temp + 2;
                end
                else if ( ptr_i^.m_ptr_ant^.m_contenido = ')' ) and ( ptr_i^.m_ptr_sig^.m_contenido = '(' ) then begin
                    ptr_temp := ptr_i;
                    i_temp := i;

                    parentesis_izq := 1;
                    parentesis_der := 1;

                    ptr_i := ptr_i^.m_ptr_ant;
                    ptr_j := ptr_i^.m_ptr_sig^.m_ptr_sig;

                    while (parentesis_izq <> 0) and (ptr_i <> nil) do begin
                        ptr_i := ptr_i^.m_ptr_ant;

                        if (ptr_i^.m_tipo = PARENTESIS_CERRADO) then
                            parentesis_izq := parentesis_izq + 1
                        else if (ptr_i^.m_tipo = PARENTESIS_ABIERTO) then
                            parentesis_izq := parentesis_izq - 1;
                    end;
                    while (parentesis_der <> 0) and (ptr_j <> nil) do begin
                        ptr_j := ptr_j^.m_ptr_sig;

                        if (ptr_j^.m_tipo = PARENTESIS_CERRADO) then
                            parentesis_der := parentesis_der - 1
                        else if (ptr_j^.m_tipo = PARENTESIS_ABIERTO) then
                            parentesis_der := parentesis_der + 1;
                    end;

                    lista.InsertarSigAnt(ptr_i, ANTERIOR, '(');
                    lista.InsertarSigAnt(ptr_j, SIGUIENTE, ')');

                    ptr_i := ptr_temp^.m_ptr_sig;
                    i := i_temp + 2;
                end;
            end;

            i := i + 1;
            ptr_i := ptr_i^.m_ptr_sig;
        end;
    end;

    Evaluar := EvaluacionLineal(ListaToStr(lista));
end;

procedure CParse.RecivirVAriable(variable: string; valor:real);
var
    i: integer;
    len: integer;
begin
    i:=0;
    len:=Length(m_MemoriaVar);
    while (i < len) do// ver duplicados
    begin
        if (variable=m_MemoriaVar[i]) then
        begin
             m_MemoriaVal[i]:=valor;
             exit;
        end;
        i:=i+1;
    end;

    SetLength(m_MemoriaVar,len+1);
    SetLength(m_MemoriaVal,len+1);
    m_MemoriaVar[len]:=variable;
    m_MemoriaVal[len]:=valor;
end;

end.

