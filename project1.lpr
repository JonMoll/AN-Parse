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
    fun : string;
    //test: CNodo;
begin
  WriteLn('Parse');
  WriteLn('');

  objeto := CArbol.Create();


  //objeto.Insertar('1', '+', '2', '');
  //objeto.ImprimirUltimo();

  //objeto.Insertar('3', '-', '4', IZQUIERDA);
  //objeto.ImprimirUltimo();

  //objeto.Insertar('5', '*', '6', DERECHA);
  //objeto.ImprimirUltimo();





  fun :='2+1-3/4';

  WriteLn(fun);
  a:=objeto.fCadenaToNodes(fun);
  new(objeto.m_ptr_raiz);


    //objeto.fInsetar(a,@test);   // intente con un nodo comun y pasar su direccion, no funciono :(
  objeto.fInsetar(a,objeto.m_ptr_raiz);//asi deberia ser
  WriteLn('my vallllll'+objeto.m_ptr_raiz^.m_val);//pero no imprime nada...
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

