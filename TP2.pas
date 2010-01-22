program Zoologico;

uses
	crt,
	dos;
	
const
	RutaArchivo = 'C:\src-git\pas\ZOOMUNDO.DAT';
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
	
{********************* Comienzo Procedures / Funciones del Vector *********************}
	
procedure InicializarVector( var vector: TVec_CodEspExt );
var
	i: integer;
begin
	for i := SubIndInf to SubIndSup do vector[i] := NumeroInicializar;
end;

function ContieneValor( vector: TVec_CodEspExt;
						item: TD_CodEsp;
						cantElem: byte) : boolean;
var 
i: integer;
encontrado: boolean;

begin
	i := 1;
	encontrado := false;
	
	while ( i <= cantElem )
	  and ( encontrado = false ) do
	begin
		if vector[i] = item then encontrado := true;
		
		inc( i );
	end;
	
	ContieneValor := encontrado;
end;						

{pre-condicion: Vector inicializado con InicializarVector}
{post-condicion: Agrega valores al final del vector, 
				 si no puede agregar mas muestra un mensaje de error}
procedure AgregarVector( var vector: TVec_CodEspExt;
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
		alert( 'Vector lleno, no se pueden agregar mas registros' );
	end;
end;

{TODO: Hacer Procedimiento}
procedure InicializarVariables( var cantElem: byte );
begin
	cantElem := 0;
end;

{********************* Fin Procedures / Funciones del Vector *********************}




{********************* Comienzo Procedures / Funciones de la lista *********************}









{********************* Fin Procedures / Funciones de la lista *********************}


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
			AgregarVector( vector, item.CodEsp, cantElem );
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
	writeln( 'function Proceso - Not Implemented' );
end;

var
	VectorEsp: TVec_CodEspExt;
	ListaEsp: TL_Esp;
	
	Archivo: TA_Zoomundo;
	
	CantElem: byte;
	i: integer;
	
begin
	assign( Archivo, RutaArchivo );
	
	InicializarVariables( CantElem );
	CrearIndices( Archivo, VectorEsp, ListaEsp, CantElem );
	
	for i := 1 to cantElem do
	begin
		writeln( VectorEsp[i] );
	end;
	
	Proceso( );
	
	writeln( '*** Fin del Programa ***' );
end.
