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
    a : array of ptr_nodo;
    i : integer;
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


  SetLength(a,4);
  for i:=0 to Length(a) do
  begin
         new(a[i]);
  end;
  a[0]^.m_val := '1';
  a[0]^.m_is_op := false;
  a[1]^.m_val := '+';
  a[1]^.m_is_op := true;
  a[2]^.m_val := '2';
  a[2]^.m_is_op := false;
  a[3]^.m_val := '*';
  a[3]^.m_is_op := true;
  a[4]^.m_val := '3';
  a[4]^.m_is_op := false;

  objeto.fInsetar(a);
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

