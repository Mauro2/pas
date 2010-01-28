program Zoologico;

uses
	crt,
	dos;
	
const
	RutaArchivo = 'ZOOMUNDO.DAT';
	RutaArchivoSalida = 'ZOOOUT.DAT';
	ZooBSAS = 'AARGCBA';

	NumeroInicializar = -999999999;
	
	SubIndInf = 1;
	SubIndSup = 50;
	
	CR = #13;
	LF = #10;
type
	TD_CodZoo = string[7]; { 8 bytes }
	TD_CodEsp = longint;
	TD_Alert = string[100];
	TD_TipoContinente = string[10];
	
	TVec_CodEspExt = array[SubIndInf..SubIndSup] of TD_CodEsp;
	
	TN_Zoo = ^TR_Zoo;
	TN_Esp = ^TR_Esp;
	
	TR_Zoomundo = record
					CodZoo: TD_CodZoo;
					CodEsp: TD_CodEsp;
				  end;
	
	TA_Zoomundo = file of TR_Zoomundo;
	TA_ZooOut = text;
	{Declaracion de Lista Zoologico}
	TL_Zoo = TN_Zoo;
	
	TR_Zoo = record
				CodZoo: TD_CodZoo;
				Siguiente: TN_Zoo;
			 end;
				
	{Declaracion de Lista Especie}
	TL_Esp = TN_Esp;
	
	TR_Esp = record
				CodEsp: TD_CodEsp;
				ListaZoo: TL_Zoo;
				Siguiente: TN_Esp;
			 end;
	
function NuevaLinea( ) : string;
begin
	NuevaLinea := CR + LF;
end;
	
procedure alert( mensaje: TD_Alert );
begin
	writeln( mensaje );
	readln();
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

{********************* Fin Procedures / Funciones del Vector *********************}




{********************* Comienzo Procedures / Funciones de la lista *********************}

{Lista TL_Zoo}

procedure CrearLista( var lista: TL_Zoo );
begin
	lista := nil;
end;

function ListaVacia( var lista: TL_Zoo ) : boolean;
begin
	ListaVacia := lista = nil;
end;

function Primero( lista: TL_Zoo ) : TN_Zoo;
begin
	Primero := lista;
end;

function Siguiente( nodo: TN_Zoo;
					var lista: TL_Zoo ) : TN_Zoo;
begin
	Siguiente := nodo^.Siguiente;
end;

procedure CrearNodo( info: TD_CodZoo;
					 var nodo: TN_Zoo );
begin
	new( nodo );
	
	nodo^.CodZoo := info;
	nodo^.Siguiente := nil;
end;

procedure AgregarPrincipio( var lista: TL_Zoo;
							info: TD_CodZoo;
							var nuevoNodo: TN_Zoo);
begin
	CrearNodo( info, nuevoNodo );

	nuevoNodo^.Siguiente := lista;
	lista := nuevoNodo;
end;

{/Lista TL_Zoo}

{Lista TL_Esp}

procedure CrearLista( var lista: TL_Esp );
begin
	lista := nil;
end;

function ListaVacia( var lista: TL_Esp ) : boolean;
begin
	ListaVacia := lista = nil;
end;

function Primero( var lista: TL_Esp ) : TN_Esp;
begin
	Primero := lista;
end;

function Siguiente( nodo: TN_Esp;
					var lista: TL_Esp ) : TN_Esp;
begin
	Siguiente := nodo^.Siguiente;
end;

procedure CrearNodo( info: TD_CodEsp;
					 var nodo: TN_Esp );
begin
	new( nodo );
	
	nodo^.CodEsp  := info;
	nodo^.ListaZoo := nil;
	nodo^.Siguiente := nil;
end;

procedure AgregarPrincipio( item: TD_CodEsp;
							var lista: TL_Esp;
							var nodo: TN_Esp );
begin
	CrearNodo( item, nodo );
	
	if nodo <> nil then
	begin
		nodo^.Siguiente := lista;
		lista := nodo;
	end;
end;

procedure LocalizarDato( item: TD_CodEsp;
						 lista: TL_Esp;
						 var nodo: TN_Esp);

begin
	nodo := Primero( lista );
	
	while (nodo <> nil) and (item <> nodo^.CodEsp) do
	begin
		nodo := Siguiente( nodo, lista );
	end;
end;

procedure Insertar( info: TD_CodEsp;
					var lista: TL_Esp;
					var nodo: TN_Esp );
var
	nodoPrevio, nodoCursor: TN_Esp;

begin
	CrearNodo( info, nodo );
	
	if ( ListaVacia( lista ) )
		or ( ( not ListaVacia( lista ) ) and ( info < Primero( lista )^.CodEsp ) ) then
	begin
		AgregarPrincipio( info, lista, nodo );
	end
	else if nodo <> nil then
	begin
		nodoPrevio := Primero( lista );
		nodoCursor := nodoPrevio^.Siguiente;
		
		while( nodoCursor <> nil ) and ( nodoCursor^.CodEsp < info ) do
		begin
			nodoPrevio := nodoCursor;
			nodoCursor := Siguiente( nodoCursor, lista );
		end;
		
		nodo^.Siguiente := nodoPrevio^.Siguiente;
		nodoPrevio^.Siguiente := nodo;
	end;
end;

procedure AgregarLista( info: TR_Zoomundo;
						var listaEsp: TL_Esp );
var
	nodoEsp: TN_Esp;
	nodoZoo: TN_Zoo;
begin
	LocalizarDato( info.CodEsp, listaEsp, nodoEsp );
	
	if nodoEsp = nil then
	begin
		Insertar( info.CodEsp, listaEsp, nodoEsp );
	end;
	
	AgregarPrincipio( nodoEsp^.ListaZoo, info.CodZoo, nodoZoo );
end;

{/Lista TL_Esp}

{********************* Fin Procedures / Funciones de la lista *********************}

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
			AgregarVector( vector, item.CodEsp, cantElem );
		end
		else
		begin
			AgregarLista( item, lista );
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
	cursor: TN_Esp;
	i: integer;
	
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

procedure ImprimirEncabezado( codEsp: TD_CodEsp;
							  var arch: TA_ZooOut );
begin
	writeln( arch, ' ':5, 'Codigo de especie en extincion: ', codEsp );
	writeln( arch, ' ':10, 'Codigo de zoologico con especie existente', ' ':10, 'Continente' );
end;

function NombreContinente( cadena: TD_CodZoo ) : TD_TipoContinente;
var
	aux: char;
begin
	aux := upcase(cadena)[1];
	
	case aux of
		'A':
			NombreContinente := 'America';
		
		'F':
			NombreContinente := 'Africa';
		
		'E':
			NombreContinente := 'Europa';
			
		'S':
			NombreContinete := 'Asia';
		
		'O':
			NombreContinente := 'Oceania';
			
		otherwise
			NombreContinente := 'NoCont';
	end;
end;

{pre-condicion: Tener las listas con datos de CrearIndices}
{post-condicion: Busca en las listas que contienen todas las especies en extincion
				 los animales que no estan en el Zoologico de Buenos Aires}
procedure Proceso( var arch: TA_ZooOut;
				   var vector: TVec_CodEspExt;
				   var lista: TL_Esp;
				   var cantElem: byte );
				   
var
	ptrCursorEsp: TN_Esp;
	
begin
	rewrite( arch );
	ptrCursorEsp := Primero( lista );
	
	writeln( arch, ' ':15, 'Faltantes de especies en EXTINCION del Zoologico de la Ciudad de Bs. As.', NuevaLinea() );
	
	ImprimirEncabezado( 2222, arch );
	
	while ptrCursorEsp <> nil do
	begin
		
	end;
	
	close( arch );
end;

var
	VectorEsp: TVec_CodEspExt;
	ListaEsp: TL_Esp;
	
	Archivo: TA_Zoomundo;
	ArchivoSalida: TA_ZooOut;
	
	CantElem: byte;
	i: integer;
	
begin
	assign( Archivo, RutaArchivo );
	assign( ArchivoSalida, RutaArchivoSalida );
	
	alert( NombreContinente( 'AAAA' ) );
	
	alert( NombreContinente( 'FAAA' ) );
	
	alert( NombreContinente( '4AAA' ) );
	
	InicializarVariables( CantElem );
	{CrearIndices( Archivo, VectorEsp, ListaEsp, CantElem );}
		
	Proceso( ArchivoSalida, VectorEsp, ListaEsp, CantElem );
	
	writeln( '*** Fin del Programa ***' );
end.
