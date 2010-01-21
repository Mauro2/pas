program Zoologico;

uses
	crt,
	dos;
	
const
	RutaArchivo = 'ZOOMUNDO.DAT';
	ZooBSAS = 'AARGCBA';

	NumeroInicializar = -999999999;
	
	SubIndInf = 1;
	SubIndSup = 50;

type
	TD_CodZoo = string[7]; { 8 bytes }
	TD_CodEsp = longint;
	TD_Alert = string[100];
	
	TVec_CodEspExt = array[SubIndInf..SubIndSup] of TD_CodEsp;
	
	TN_Zoo = ^TR_Zoo;
	TN_Esp = ^TR_Esp;
	
	TR_Zoomundo = record
					CodZoo: TD_CodZoo;
					CodEsp: TD_CodEsp;
				  end;
	
	TA_Zoomundo = file of TR_Zoomundo;
	
	{Declaracion de Lista Zoologico}
	TL_Zoo = TN_Zoo;
	
	TR_Zoo = record
				CodZoologico: TD_CodZoo;
				Siguiente: TN_Zoo;
			 end;
				
	{Declaracion de Lista Especie}
	TL_Esp = TN_Esp;
	
	TR_Esp = record
				CodEspecie: TD_CodEsp;
				ListaZoo: TL_Zoo;
				Siguiente: TN_Esp;
			 end;
	
	
	
procedure alert( mensaje: TD_Alert );
begin
	writeln( mensaje );
end;
	
{ Procedures Vector }
	
procedure InicializarVector( var vector: TVec_CodEspExt );
var
	i: integer;
begin
	for i := SubIndInf to SubIndSup do vector[i] := NumeroInicializar;
end;


procedure DesplazarElementos( var vector: TVec_CodEspExt;
							  corriente: integer;
							  var cantElem: byte );
var
	i: integer;
	aux: TD_CodEsp;
begin
	
	{TODO: Revisar}
	aux := vector[ corriente ];
	writeln( aux );
	
	
	for i := (corriente + 1) to cantElem do
	begin
		vector[i] := aux;
		aux := vector[i + 1];
	end;
	
	for i := 1 to cantElem do
	begin
		write( vector[i], ' - ' );
	end;
	
	inc(cantElem);
end;

{TODO: DEPRECATE, no es necesario que esten en orden en el vector.}
{pre-condicion: Vector inicializado con InicializarVector}
{post-condicion: Inserta en el vector}
procedure InsertarVector( var vector: TVec_CodEspExt;
						  var item: TD_CodEsp;
						  var cantElem: byte );
var
	i: integer;
	corriente: integer;
begin
	if cantElem < SubIndSup  then
	begin
		inc(cantElem);
		vector[cantElem] := item;
	end
	else
	begin
		alert( 'Vector lleno, no se pueden insertar mas registros' );
	end;
end;

{TODO: Hacer Procedimiento}
procedure InicializarVariables( var cantElem: byte );
begin
	cantElem := 0;
end;

function EsEspecieEnExtincion( codEsp: TD_CodEsp ) : boolean;
begin
	EsEspecieEnExtincion := codEsp mod 10 = 0;
end;

procedure ProcesarRegistro( item: TR_Zoomundo;
							var vector: TVec_CodEspExt;
							var lista: TL_Esp;
							var cantElem: byte );
begin
    if EsEspecieEnExtincion( item.CodEsp ) then
	begin
		if item.CodZoo = ZooBSAS then
		begin
			InsertarVector( vector, item.CodEsp, cantElem );
		end
		else
		begin
			{InsertarLista( lista, item );}
		end;
	end;
end;

{TODO: pre-condicion:}
{post-condicion: Recorre el archivo secuencialmente y genera un vector de especies en extincion 
				 ya existentes en el zoologico de BsAs y una lista de listas con todas las especies en extincion
				 y los zoologicos en donde se encuentran (excepto en Buenos Aires)}
procedure CrearIndices( var arch: TA_Zoomundo;
						var vector: TVec_CodEspExt;
						var	lista: TL_Esp;
						var	cantElem: byte );
var
	auxRec: TR_Zoomundo;
	
begin
	reset( arch );
	read( arch, auxRec );
	
	while not eof( arch ) do
	begin		
		ProcesarRegistro( auxRec, vector, lista, cantElem );
		
		read( arch, auxRec );
	end;
	
	ProcesarRegistro( auxRec, vector, lista, cantElem );

	close( arch );
end;

{pre-condicion: Tener las listas con datos de CrearIndices}
{post-condicion: Busca en las listas que contienen todas las especies en extincion
				 los animales que no estan en el Zoologico de Buenos Aires}
procedure Proceso( );
begin
	writeln( 'Not Implemented' );
end;

var
	VectorEsp: TVec_CodEspExt;
	ListaEsp: TL_Esp;
	
	Archivo: TA_Zoomundo;
	
	CantElem: byte;
	
begin
	assign( Archivo, RutaArchivo );
	
	InicializarVariables( CantElem );
	CrearIndices( Archivo, VectorEsp, ListaEsp, CantElem );
	Proceso( );
	
	writeln( '*** Fin del Programa ***' );
end.
