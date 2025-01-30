program ej1; 

type
tPtrInt = ^integer;

var
x: integer;
PtrInt: tPtrInt;

begin
	x:= 100;

	new(PtrInt);

	PtrInt^:= x;

	writeln(PtrInt^);

	new(PtrInt);

	PtrInt:= @x;

	PtrInt^:= PtrInt^ + 100;

	writeln(x);
	writeln(PtrInt^);

	PtrInt:= nil;

	dispose(PtrInt);

	PtrInt:= @x;
	PtrInt^:= PtrInt^ + 100;

	writeln('PtrInt^ = x :', PtrInt^ = x);

	dispose(PtrInt);

	PtrInt:= nil;
end.
