program PunterosEj6_RES;

uses SysUtils;



{
    Vamos a hacer un simulador de "Isla de la Tentación" en Pascal. Para ello, sigue los siguientes pasos:
}

const
    NUM_PAREJAS = 2; // Número de participantes = 2 * parejas + parejas/2
    NUM_PARTICIPANTES = 2 * NUM_PAREJAS + NUM_PAREJAS div 2;

{
    1. Genera un registro de tipo  "Participante" con los campos: 
        nombre (texto), edad (entero), rol (tentador, pareja) y otroParticipante (puntero a Participante)
}

type
    Rol = (tentador, pareja);
    Participante = record
        nombre: String[20];
        edad: Integer;
        rol: Rol;
        otroParticipante: ^Participante;
    end;


var
    {
        2. Crea un array de MAX punteros a Participante
    }
    participantes: array[1..NUM_PARTICIPANTES] of ^Participante;
    numParticipantes: Integer;
    numTentadores: Integer;


{
    3. Crea un procedimiento que cree un participante con nombre, edad y rol. Otro participante será nil.
}
procedure crearParticipante(var p: Participante; nombre: String; edad: Integer; rol: Rol);
begin
    p.nombre := nombre;
    p.edad := edad;
    p.rol := rol;
    p.otroParticipante := nil;
end;


{
    4. Crea un procedimiento que asigne una pareja a un participante, recibirá dos parámetros, los dos participantes
}
procedure asignarPareja(var p1: Participante; var p2: Participante);
begin
    p1.otroParticipante := @p2;
    p2.otroParticipante := @p1;
end;


{
    5. Crea un procedimiento aud inicialice la isla de las tentaciones. Por cada 2 parejas, habrá un tentador. 
}
procedure inicializarIsla();
var
    i: Integer;
begin
{ 
        Para simplificarnos un poco el trabajo, por el inicio del array vamos a meter las parejas y por detrás los tentadores:
        [ persona1, persona2, persona3, persona4, persona5]
        [ pareja1, pareja1, pareja2, pareja2, tentador1]
}
    numParticipantes := 0;
    numTentadores := 0;
    for i := 1 to NUM_PAREJAS do
    begin
        New(participantes[i * 2 - 1]);
        New(participantes[i * 2]);
        crearParticipante(participantes[i * 2 - 1]^, 'Persona' + IntToStr(i * 2 - 1), 20 + i, pareja);
        crearParticipante(participantes[i * 2]^, 'Persona' + IntToStr(i * 2), 20 + i, pareja);
        asignarPareja(participantes[i * 2 - 1]^, participantes[i * 2]^);
        numParticipantes := numParticipantes + 2;
    end;

    for i := 1 to NUM_PAREJAS div 2 do
    begin
        New(participantes[NUM_PAREJAS * 2 + i]);
        crearParticipante(participantes[NUM_PAREJAS * 2 + i]^, 'Tentador' + IntToStr(i), 25 + i, tentador);
        numTentadores := numTentadores + 1;
    end;
end;


{
    6. Crea un procedimiento que muestre por pantalla la isla de las tentaciones de la siguiente manera:
            - Nombre: XXXX
            - Edad: XX
            - Rol: Pareja/Tentador
            - Pareja: XXXX --> si tuviera pareja
            - Infiel --> si su rol fuese pareja, pero no la tiene
            - Tentó a: XXXX --> si fuese tentador y ahora tiene pareja
}
procedure mostrarIsla();
var
    i: Integer;
begin
    for i := 1 to NUM_PARTICIPANTES do
    begin
        WriteLn('Nombre: ', participantes[i]^.nombre);
        WriteLn('Edad: ', participantes[i]^.edad);
        WriteLn('Rol: ', participantes[i]^.rol);
        if participantes[i]^.rol = pareja then
        begin
            if participantes[i]^.otroParticipante <> nil then
            begin
            // miramos is la otra pareja le tiene como pareja, si le tiene, siguen siendo pareja, si no, ponemos "Le han sido infiel"
                if participantes[i]^.otroParticipante^.otroParticipante = participantes[i] then
                begin
                    WriteLn('Pareja: ', participantes[i]^.otroParticipante^.nombre);
                end
                else
                begin
                    WriteLn(participantes[i]^.otroParticipante^.nombre, ' le ha sido infiel');
                end;
            end
            else
            begin
                WriteLn('Infiel');
            end;
        end
        else
        begin
            if participantes[i]^.otroParticipante <> nil then
            begin
                WriteLn('Tentó a: ', participantes[i]^.otroParticipante^.nombre);
            end;
        end;
        WriteLn();
    end;
end;

{
     7. Crea un procedimiento que simule una ronda de tentación. En cada ronda, se seleccionará una pareja y un tentador: 
    - Se seleccionará al azar (50/50) quién de los dos será tentado. 
    - Se determinará si la pareja es infiel o no (25/75). 
    - Se actualizarán los datos. Si ha sido infiel, perderán su pareja. El tentador, tendrá una nueva pareja.
}
procedure rondaTentacion();
var
    pareja: Integer;
    tentador: Integer;
    infiel: Boolean;
    esTentado: Boolean;
begin
    pareja := Random(NUM_PAREJAS) + 1;
    tentador := Random(NUM_PAREJAS div 2) + 1;
    infiel := Random(100) < 25;
    esTentado := Random(100) < 50;

    if infiel then
    begin
        // Vamos a ver quién de los dos de la pareja ha sido infiel, si es esTentado, será el primero, si no, el segundo
        if esTentado then
        begin
            WriteLn(participantes[(pareja - 1) * 2 + 1]^.nombre, ' ha sido infiel con ', participantes[NUM_PAREJAS * 2 + tentador]^.nombre);
            WriteLn('Le han puesto los cuernos a ', participantes[(pareja - 1) * 2 + 2]^.nombre);
            // Actualizamos la pareja  
            participantes[(pareja - 1) * 2 + 1]^.otroParticipante := nil;
            // Actualizamos el tentador
            participantes[NUM_PAREJAS * 2 + tentador]^.otroParticipante := participantes[(pareja - 1) * 2 + 1];
        end
        else
        begin
            WriteLn(participantes[(pareja - 1) * 2 + 2]^.nombre, ' ha sido infiel con ', participantes[NUM_PAREJAS * 2 + tentador]^.nombre);
            WriteLn('Le han puesto los cuernos a ', participantes[(pareja - 1) * 2 + 1]^.nombre);
            // Actualizamos la pareja  
            participantes[(pareja - 1) * 2 + 2]^.otroParticipante := nil;
            // Actualizamos el tentador
            participantes[NUM_PAREJAS * 2 + tentador]^.otroParticipante := participantes[(pareja - 1) * 2 + 2];
        end;
    end
    else
    begin
        // Simplemente vamos a escribir quién ha intentado tentar a quién
        if esTentado then
        begin
            WriteLn(participantes[NUM_PAREJAS * 2 + tentador]^.nombre, ' ha intentado tentar a ', participantes[(pareja - 1) * 2 + 1]^.nombre, ' pero no ha podido');
        end
        else
        begin
            WriteLn(participantes[NUM_PAREJAS * 2 + tentador]^.nombre, ' ha intentado tentar a ', participantes[(pareja - 1) * 2 + 2]^.nombre, ' pero no ha podido');
        end;
    end;


end;


{
    8. Genera un programa que le pregunte al usuario si quiere jugar una ronda más o no. 
    Si el usuario decide que sí, se realizará una ronda más. Si decide que no, se mostrará el estado final de la isla de las tentaciones.
}
var
    jugar: Char;
begin
    Randomize;
    inicializarIsla();
    mostrarIsla();
    repeat
        rondaTentacion();
        mostrarIsla();
        WriteLn('¿Quieres jugar una ronda más? (S/N)');
        ReadLn(jugar);
    until (jugar = 'N') or (jugar = 'n');

    mostrarIsla();
end.