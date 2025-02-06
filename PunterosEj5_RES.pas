program PunterosEj5_RES;

uses
    SysUtils;

{ Declaración de constantes }
const
    MAX = 4; { 2. Declaración de constantes }

{ Declaración de tipos }
type
    { 1. Declara un tipo coordenada_3D para puntos con coordenadas x,y,z }
    coordenada_3D = record
        x, y, z: Real;
    end;

    ptCoordenada_3D = ^coordenada_3D;

{ Declaración de variables }
var
    { 2. Declara un array de MAX punteros a coordenadas_3D }
    ptrArray: array[0..MAX-1] of ptCoordenada_3D;
    suma : ptCoordenada_3D;
    posicion : Integer;

{ 3. Crea una coordenada_3D en cada una de las posiciones inicializado 
    todas las coordenadas con números aleatorios }
procedure InicializarArray(var ptrArray: array of ptCoordenada_3D);
var
    i: Integer;
begin
    for i := 0 to MAX-1 do
    begin
        New(ptrArray[i]);
        ptrArray[i]^.x := Random(100);
        ptrArray[i]^.y := Random(100);
        ptrArray[i]^.z := Random(100);
    end;
end;

{ Procedimiento para imprimir una coordenada_3D }
procedure ImprimirPos(coordenada: ptCoordenada_3D);
begin
    if coordenada <> NIL then
    begin
        WriteLn('(', coordenada^.x:0:2, ', ', coordenada^.y:0:2, ', ', coordenada^.z:0:2, ')');
    end;
end;

{ * Implementa un procedimiento que muestre por pantalla el contenido de cada posición }
procedure ImprimirArray(var ptrArray: array of ptCoordenada_3D);
var
    i: Integer;
begin
    for i := 0 to MAX-1 do
    begin
        if ptrArray[i] <> NIL then
        begin
            Write('ptrArray[', i, '] = ');
            ImprimirPos(ptrArray[i]);
        end;
    end;
end;

{ 4. Implementa un subprograma que libere la memoria asignada a una posición }
procedure LiberarPosArray(var ptrArray: array of ptCoordenada_3D; pos: Integer);
begin
    if (pos >= 0) and (pos < MAX) and (ptrArray[pos] <> NIL) then
    begin
        Dispose(ptrArray[pos]);
        ptrArray[pos] := NIL;
    end;
end;

{ 4.' Implementa un subprograma que libere la memoria asignada a todas las posiciones }
procedure LiberarArray(var ptrArray: array of ptCoordenada_3D);
var
    i: Integer;
begin
    for i := 0 to MAX-1 do
    begin
        LiberarPosArray(ptrArray, i);
    end;
end;

{ 5. Implementa una función que sume todas las x de las coordenadas }
function SumarX (ptrArray: array of ptCoordenada_3D): Real;
var
    sum: Real;
    i : Integer;
begin
    sum := 0;
    for i := 0 to MAX-1 do
    begin
        if ptrArray[i] <> NIL then
        begin
            sum := sum + ptrArray[i]^.x;
        end;
    end;
    SumarX := sum;
end;


{ 5.' Implementa una procedimiento que sume las coordenadas de todas las posiciones }
procedure SumarCoordenadas (var ptCoordenada_3D: ptCoordenada_3D; ptrArray: array of ptCoordenada_3D);
var
    i : Integer;
begin
    for i := 0 to MAX-1 do
    begin
        if ptrArray[i] <> NIL then
        begin
            ptCoordenada_3D^.x := ptCoordenada_3D^.x + ptrArray[i]^.x;
            ptCoordenada_3D^.y := ptCoordenada_3D^.y + ptrArray[i]^.y;
            ptCoordenada_3D^.z := ptCoordenada_3D^.z + ptrArray[i]^.z;
        end;
    end;
end;

{ 6. Implementa un procedimiento que permita añadir una coordenada en la primera 
    posición libre del array}
procedure AnadirCoordenadaPrimeraPosicion(var ptrArray: array of ptCoordenada_3D; coordenada: ptCoordenada_3D);
var
    i: Integer;
begin
    i := 0;
    while (i < MAX) and (ptrArray[i] <> NIL) do
    begin
        i := i + 1;
    end;
    if i < MAX then
    begin
        ptrArray[i] := coordenada;
    end;
end;

{ 7. Implementa una función que calcule la máxima coordenada y (debes comprobar  antes,
     pues puede que alguna posición no tenga coordenada y esté a NIL)}
function MaxArrayY(ptrArray: array of ptCoordenada_3D): Real;
var
    i: Integer;
    m: Real;
begin
    m := 0;
    for i := 0 to MAX-1 do
    begin
        if ptrArray[i] <> NIL then
        begin
            if ptrArray[i]^.y > m then
            begin
                m := ptrArray[i]^.y;
            end;
        end;
    end;
    MaxArrayY := m;
end;


begin
    Randomize;
    WriteLn('Inicialización del array de punteros a coordenadas_3D');
    InicializarArray(ptrArray);
    ImprimirArray(ptrArray);
    // WriteLn('Liberación de memoria');
    // LiberarArray(ptrArray);
    // ImprimirArray(ptrArray);
    WriteLn('Suma de las x de todas las posiciones');
    WriteLn(SumarX(ptrArray):0:2);
    WriteLn('Suma de las coordenadas de todas las posiciones');
    New(suma);
    SumarCoordenadas(suma, ptrArray);
    ImprimirPos(suma);

    WriteLn('Liberamos una posición aleatoria');
    posicion := Random(MAX);
    WriteLn('Liberamos la posición ', posicion);
    LiberarPosArray(ptrArray, posicion);
    ImprimirArray(ptrArray);


    WriteLn('Añadimos la suma de las coordenadas en la primera posición libre (',posicion ,')');
    AnadirCoordenadaPrimeraPosicion(ptrArray, suma);
    ImprimirArray(ptrArray);

    WriteLn('Máximo de las componentes y');
    WriteLn(MaxArrayY(ptrArray):0:2);
    
    { Finalización del programa }
    LiberarArray(ptrArray);
    Readln;  { Pausa para ver la salida en la consola }
end.