program PunterosEj4_RES;

uses
    crt;

const
    MAX = 2;  { 1.a Declarar un array de MAX punteros a enteros }

type
   { 1.b Declarar un array de MAX punteros a enteros }
   tparray = array[0..MAX-1] of ^Integer;

var
    { 1.c Declarar un array de MAX punteros a enteros }
    ptrArray: tparray;
    i: Integer; // Variable para recorrer el array de punteros
    option: Char; // Variable para la opción del menú

{ 6.a Implementa una función que calcule el máximo número del array (debes comprobar 
antes, pues puede que alguna posición no tenga un número y esté a NIL)}
function MaxArray(ptrArray: tparray): Integer;
var
    i, m: Integer;

begin
    m := 0;
    for i := 0 to MAX-1 do
        if ptrArray[i] <> nil then
            if ptrArray[i]^ > m then
                m := ptrArray[i]^;
    MaxArray := m;
end;

{ 7.a Implementa una función que compute la suma de todos los enteros (de nuevo 
asegúrate de no intentar sumar los que estén a NIL) }
function SumArray(ptrArray: tparray): Integer;
var
    i, sum: Integer;

begin
    sum := 0;
    for i := 0 to MAX-1 do
        if ptrArray[i] <> nil then
            sum := sum + ptrArray[i]^;
    SumArray := sum;
end;

{ 3.a Implementa un procedimiento que muestre por pantalla el contenido de cada posición }
procedure PrintArray(ptrArray: tparray);
var
    i: Integer;

begin
    for i := 0 to MAX-1 do
        if ptrArray[i] <> nil then
            WriteLn('ptrArray[', i, '] = ', ptrArray[i]^);
end;

{ 4.a Implementa un procedimiento que ponga a cero todos los números }
procedure ZeroArray(var ptrArray: tparray; ptrArray2: tparray); // ptrArray2 no se usa, es para analizar las diferencia entre pasar un array de punteros por valor o por referencia
var
    i: Integer;

begin
    { Dirección de memoria de ptrArray }
    WriteLn('Dirección de memoria de ptrArray: ', PtrUInt(@ptrArray));
    { Dirección de memoria de ptrArray2 }
    WriteLn('Dirección de memoria de ptrArray2: ', PtrUInt(@ptrArray2));
    for i := 0 to MAX-1 do
    begin
        if ptrArray[i] <> nil then
        begin
        ptrArray[i]^ := 0;
        // Comprobamos que las direcciones de memoria son iguales para cada punter del array
        WriteLn('Dirección de memoria de ptrArray: ', PtrUInt(ptrArray[i]));
        WriteLn('Dirección de memoria de ptrArray2: ', PtrUInt(ptrArray2[i]));
        end;
    end;
end;

{ 5. Implementa un subprograma que ponga todos los punteros que no lo estén, a NIL }
procedure NilArray(var ptrArray: tparray);
var
    i: Integer;

begin
    for i := 0 to MAX-1 do
        begin
            if ptrArray[i] <> nil then
                Dispose(ptrArray[i]);
                ptrArray[i] := nil;
        end;
end;

begin
    { 2. Crea un entero en cada una de las posiciones inicializado a un número aleatorio }
    Randomize;
    for i := 0 to MAX-1 do
    begin
        New(ptrArray[i]);
        ptrArray[i]^ := Random(100);
    end;

    repeat
        ClrScr;
        WriteLn('1. Mostrar array'); { 3.b }
        WriteLn('2. Poner a cero array'); { 4.b }
        WriteLn('3. Poner a NIL los punteros'); { 5.b }
        WriteLn('4. Máximo array'); { 6.b }
        WriteLn('5. Suma array'); { 7.b }
        WriteLn('0. Salir');
        Write('Opción: ');
        ReadLn(option);
        case option of
            '1': PrintArray(ptrArray);
            '2': ZeroArray(ptrArray, ptrArray);
            '3': NilArray(ptrArray);
            '4': WriteLn('Máximo del array: ', MaxArray(ptrArray));
            '5': WriteLn('Suma del array: ', SumArray(ptrArray));
        end;
        WriteLn('Pulsa una tecla para continuar...');
        ReadKey;
    until option = '0';

    
    NilArray(ptrArray);



end.