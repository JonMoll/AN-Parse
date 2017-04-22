program project1;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX}{$IFDEF UseCThreads}
     cthreads,
     {$ENDIF}{$ENDIF}
     Classes, SysUtils, CustApp, UArbol, UNodo, ULista;

type

    { TMyApplication }

    TMyApplication = class(TCustomApplication)
    protected
        procedure DoRun; override;
    public
    end;

{ TMyApplication }

procedure TMyApplication.DoRun;
var objeto : CLista;
begin
    objeto := CLista.Create();

    objeto.Insertar('1');
    objeto.Insertar('+');
    objeto.Insertar('3');
    objeto.Insertar('/');
    objeto.Insertar('5');

    objeto.ImplimirLista();

    objeto.Destroy();

    ReadLn;
end;

var Application : TMyApplication;
begin
    Application := TMyApplication.Create(nil);
    Application.Title := 'My Application';
    Application.Run;
    Application.Free;
end.

