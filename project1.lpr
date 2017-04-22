program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, UArbol, UNodo;

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
  end;

{ TMyApplication }

procedure TMyApplication.DoRun;
var objeto : CArbol;
begin
  WriteLn('Parse');
  WriteLn('');

  objeto := CArbol.Create();

  objeto.Insertar('1', '+', '2', '');
  objeto.ImprimirUltimo();

  objeto.Insertar('3', '-', '4', IZQUIERDA);
  objeto.ImprimirUltimo();

  objeto.Insertar('5', '*', '6', DERECHA);
  objeto.ImprimirUltimo();

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

