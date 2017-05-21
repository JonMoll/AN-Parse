program project1;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX}{$IFDEF UseCThreads}
     cthreads,
     {$ENDIF}{$ENDIF}
     Classes, SysUtils, CustApp, UArbol, UNodo, ULista, UParse;

type

    { TMyApplication }

    TMyApplication = class(TCustomApplication)
    protected
        procedure DoRun; override;
    public
    end;

{ TMyApplication }

procedure TMyApplication.DoRun;
var objeto : CParse;
    lista : CLista;
    x, y : real;
    expresion : string;
begin
    objeto := CParse.Create();
    //objeto.m_expresion := '2+3*(5-4/2)';
    //objeto.m_expresion := '((2+3^2)^2-(5*2)^2)/((1+2)^2-(3-1)^2)-0.2';
    {
    WriteLn( 'Variables: ');
    WriteLn( '    * Si no va ha usar variables puede escribir cualquier valor en ellas');
    WriteLn( '    x = ');
    ReadLn(x);
    WriteLn( '    y = ');
    ReadLn(y);

    objeto.RecivirVAriable('y', x);
    objeto.RecivirVAriable('x', y);

    WriteLn( 'Expresion: ');
    ReadLn(expresion);
    objeto.m_expresion := expresion;

    try
        WriteLn( '--------------------------------------------------');
        WriteLn( 'RESPUESTA: ' + objeto.Evaluar() );
        WriteLn( '--------------------------------------------------');
    except;
        WriteLn( '--------------------------------------------------');
        WriteLn( 'HA OCURRIDO UN ERROR');
        WriteLn( '--------------------------------------------------');
        objeto.Destroy();
        ReadLn();
    end; }

    lista := objeto.StrToLista('[1 1 1;1 1 1]+[1 1 1;1 1 1]');
    //lista := objeto.StrToLista('2+152');
    lista.ImplimirLista();
    lista.Destroy;

    objeto.Destroy();
    ReadLn();
end;

var Application : TMyApplication;
begin
    Application := TMyApplication.Create(nil);
    Application.Title := 'My Application';
    Application.Run;
    Application.Free;
end.

