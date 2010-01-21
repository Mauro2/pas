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
	TD_MensajeError = string[100];
	
	TVec_CodEspExt = array[SubIndInf..SubIndSup] of TD_CodEsp;
	
	TN_Zoo = ^TR_Zoo;
	TN_Esp = ^TR_Esp;
	
	TR_Zoomundo = record
					CodZoo: TD_CodZoo;
					CodEsp: TD_CodEsp;
				  end;
	
	TA_Zoomundo = file of TR_Zoomundo;
	
	{Declaración de Lista Zoologico}
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
	
	
	
procedure MostrarError( mensaje: TD_MensajeError );
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
							  var cantElem: integer );
var
	i: integer;
	aux: TD_CodEsp;
begin
	
	for i := corriente to cantElem do
	begin
		aux := vector[i + 1];
		vector[i + 1] := vector[i];
	end;
	
	inc(cantElem);
	
end;

{pre-condicion: Vector inicializado con InicializarVector}
{post-condicion: Inserta en el vector}
procedure InsertarVector( var vector: TVec_CodEspExt;
						  var item: TD_CodEsp;
						  var cantElem: byte );
var
	i: integer;
	corriente: integer;
begin
	if cantElem <= SubIndSup  then
	begin
		while ( item > vector[corriente]) and (corriente < cantElem ) do
		begin
			inc(corriente);
		end
	end
	else
	begin
		MostrarError( 'Vector lleno, no se pueden insertar mas registros' );
	end;
end;

{TODO: Hacer Procedimiento}
procedure InicializarVariables( );
begin
	writeln( 'NotImplemented' );
end;

procedure ProcesarRegistro( item: TR_Zoomundo;
							var vector: TVec_CodEspExt;
							var lista: TL_Esp;
							var cantElem: byte );
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

{TODO: pre-condicion:}
{post-condicion: Recorre el archivo secuencialmente y genera los indices de especies en extincion en 
		 		 el zoologico de BsAs y los zoologicos en donde se encuentran}
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

	
var
	VectorEsp: TVec_CodEspExt;
	ListaEsp: TL_Esp;
	
	Archivo: TA_Zoomundo;
	
	CantElem: byte;
	
begin
	assign( Archivo, RutaArchivo );
	
	InicializarVariables( );
	CrearIndices( Archivo, VectorEsp, ListaEsp, CantElem );
	
	writeln( '*** Fin del Programa ***' );
end.