program Zoologico;

uses
	crt,
	dos;

const
	RutaArchivo = 'C:\tp2\pas\ZOOMUNDO.DAT';
	RutaArchivoSalida = 'C:\tp2\pas\ZOOOUT.DAT';
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
	
function NuevaLinea : string;
begin
	NuevaLinea := CR + LF;
end;
	
procedure alert( mensaje: TD_Alert );
begin
	writeln( mensaje );
	readln;
end;
	
{********************* Comienzo Procedures / Funciones del Vector *********************}
	
procedure InicializarVector( var vector: TVec_CodEspExt );
{pre-condicion: Recibe el vector}
{post-condicion: Devuelve el vector inicializado con un numero muy bajo}
var
	i: integer;
begin
	for i := SubIndInf to SubIndSup do vector[i] := NumeroInicializar;
end;

function ContieneValor( vector: TVec_CodEspExt;
						item: TD_CodEsp;
						cantElem: byte) : boolean;
{pre-condicion: - Vector inicalizado y cargado.
				- Item debe ser un Codigo de Especie Valido}
{post-condicion: Devuelve un valor booleano que indica si el valor que contiene item se encuentra en el vector}				
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

procedure AgregarVector( var vector: TVec_CodEspExt;
						  var item: TD_CodEsp;
						  var cantElem: byte );
{pre-condicion: - Vector inicalizado y cargado.
				- Item debe ser un Codigo de Especie Valido}
{post-condicion: Agrega valores al final del vector, si no puede agregar mas muestra un mensaje de error}						  
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
		alert( 'Vector lleno, no se pueden agregar mas registros' );
end;

{********************* Fin Procedures / Funciones del Vector *********************}

{********************* Comienzo Procedures / Funciones de la lista *********************}

{Lista TL_Zoo}

procedure InicializarListaZoo( var lista: TL_Zoo );
{post-condicion: Devuelve la lista creada y vacia}
begin
	lista := nil;
end;

function PrimeroZoo( lista: TL_Zoo ) : TN_Zoo;
{pre-condicion: Lista inicializada y creada.}
{post-condicion: Devuelve el nodo del primer elemento de la lista.}
begin
	PrimeroZoo := lista;
end;

function SiguienteZoo( nodo: TN_Zoo;
					   var lista: TL_Zoo ) : TN_Zoo;
{pre-condicion: - Lista inicializada y creada.
				- Nodo debe pertenecer a la lista.}
{post-condicion: Devuelve el nodo siguiente al ingresado.}
begin
	SiguienteZoo := nodo^.Siguiente;
end;

procedure CrearNodoZoo( info: TD_CodZoo;
					    var nodo: TN_Zoo );
{pre-condicion: Info debe ser un Codigo de Zoologico valido.}
{post-condicion: Devuelve un nodo nuevo creado con Codigo Zoologico en info y nil en Siguiente}
begin
	new( nodo );
	
	nodo^.CodZoo := info;
	nodo^.Siguiente := nil;
end;

procedure AgregarPrincipioZoo( var lista: TL_Zoo;
							info: TD_CodZoo;
							var nuevoNodo: TN_Zoo);
{pre-condicion: Info debe ser un Codigo de Zoologico valido.}
{post-condicion: Devuelve un nodo nuevo creado con Codigo Zoologico en info y lo agrega al principio de la lista}
begin
	CrearNodoZoo( info, nuevoNodo );

	nuevoNodo^.Siguiente := lista;
	lista := nuevoNodo;
end;

{/Lista TL_Zoo}

{Lista TL_Esp}

procedure InicializarListaEsp( var lista: TL_Esp );
{post-condicion: Devuelve la lista creada y vacia}
begin
	lista := nil;
end;

function ListaVaciaEsp( var lista: TL_Esp ) : boolean;
{pre-condicion: Lista inicializada.}
{post-condicion: Devuelve un booleando indicando si la lista esta vacia.}
begin
	ListaVaciaEsp := lista = nil;
end;

function PrimeroEsp( var lista: TL_Esp ) : TN_Esp;
{pre-condicion: Lista inicializada y creada.}
{post-condicion: Devuelve el nodo del primer elemento de la lista.}
begin
	PrimeroEsp := lista;
end;

function SiguienteEsp( nodo: TN_Esp;
					   var lista: TL_Esp ) : TN_Esp;
{pre-condicion: - Lista inicializada y creada.
				- Nodo debe pertenecer a la lista.}
{post-condicion: Devuelve el nodo siguiente al ingresado.}
begin
	SiguienteEsp := nodo^.Siguiente;
end;

procedure CrearNodoEsp( info: TD_CodEsp;
						var nodo: TN_Esp );
{pre-condicion: Info debe ser un Codigo de Especie valido.}
{post-condicion: Devuelve un nodo nuevo creado con Codigo Especie en info y nil en Siguiente.}
begin
	new( nodo );
	
	nodo^.CodEsp  := info;
	InicializarListaZoo( nodo^.ListaZoo );
	nodo^.Siguiente := nil;
end;

procedure AgregarPrincipioEsp( item: TD_CodEsp;
							   var lista: TL_Esp;
							   var nodo: TN_Esp );
{pre-condicion: Info debe ser un Codigo de Zoologico valido.}
{post-condicion: Devuelve un nodo nuevo creado con Codigo Zoologico en info y lo agrega al principio de la lista.}
begin
	CrearNodoEsp( item, nodo );
	
	if nodo <> nil then
	begin
		nodo^.Siguiente := lista;
		lista := nodo;
	end;
end;

procedure LocalizarDatoEsp( item: TD_CodEsp;
							lista: TL_Esp;
							var nodo: TN_Esp);
{pre-condicion: Info debe ser un Codigo de Zoologico valido.}
{post-condicion: Devuelve un nodo nuevo creado con Codigo Zoologico en info y lo agrega al principio de la lista.}
begin
	nodo := PrimeroEsp( lista );
	
	while (nodo <> nil) and (item <> nodo^.CodEsp) do
	begin
		nodo := SiguienteEsp( nodo, lista );
	end;
end;

procedure InsertarEsp( info: TD_CodEsp;
					   var lista: TL_Esp;
					   var nodo: TN_Esp );
{pre-condicion: - Lista debe ser inicializada
				- Info debe ser un Codigo de Especie valido.}
{post-condicion: Devuelve un nodo nuevo creado con Codigo Especie en info y lo inserta en la lista.}
var
	nodoPrevio, nodoCursor: TN_Esp;

begin
	CrearNodoEsp( info, nodo );
	
	if ( ListaVaciaEsp( lista ) )
		or ( ( not ListaVaciaEsp( lista ) ) and ( info < PrimeroEsp( lista )^.CodEsp ) ) then
	begin
		AgregarPrincipioEsp( info, lista, nodo );
	end
	else if nodo <> nil then
	begin
		nodoPrevio := PrimeroEsp( lista );
		nodoCursor := nodoPrevio^.Siguiente;

		while( nodoCursor <> nil ) and ( nodoCursor^.CodEsp < info ) do
		begin
			nodoPrevio := nodoCursor;
			nodoCursor := SiguienteEsp( nodoCursor, lista );
		end;
		
		nodo^.Siguiente := nodoPrevio^.Siguiente;
		nodoPrevio^.Siguiente := nodo;
	end;
end;

procedure AgregarLista( info: TR_Zoomundo;
						   var listaEsp: TL_Esp );
{pre-condicion: - Lista debe ser inicializada.
				- Info debe ser un registro del archivo valido.}
{post-condicion: Si encuentra un nodo con el codigo de especie del registro, agrega el codigo de Zoologico a la ListaZoo,
				 de no existir, lo inserta en la lista.}
var
	nodoEsp: TN_Esp;
	nodoZoo: TN_Zoo;
begin
	LocalizarDatoEsp( info.CodEsp, listaEsp, nodoEsp );
	
	if nodoEsp = nil then
	begin
		InsertarEsp( info.CodEsp, listaEsp, nodoEsp );
	end;
	
	AgregarPrincipioZoo( nodoEsp^.ListaZoo, info.CodZoo, nodoZoo );
end;

{/Lista TL_Esp}

{********************* Fin Procedures / Funciones de la lista *********************}

procedure InicializarVariables( var cantElem: byte );
{post-condicion: Devuelve las variables inicializadas.}
begin
	cantElem := 0;
end;

function EsEspecieEnExtincion( codEsp: TD_CodEsp ) : boolean;
{pre-condicion: Codigo de Especie valido.}
{post-condicion: Devuelve un booleano indicando si es una especie en extincion.}
begin
	EsEspecieEnExtincion := codEsp mod 10 = 0;
end;

procedure ProcesarRegistro( item: TR_Zoomundo;
							var vector: TVec_CodEspExt;
							var lista: TL_Esp;
							var cantElem: byte );
{pre-condicion: Codigo de Especie valido.}
{post-condicion: Devuelve un booleano indicando si es una especie en extincion.}
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

procedure ProcesarArchivo( var arch: TA_Zoomundo;
						var vector: TVec_CodEspExt;
						var	lista: TL_Esp;
						var	cantElem: byte );
{pre-condicion: - Archivo asignado.
				- Vector y Lista inicializados.}
{post-condicion: Recorre el archivo secuencialmente y genera un vector de especies en extincion
				 ya existentes en el zoologico de BsAs y una lista de listas con todas las especies en extincion
				 y los zoologicos en donde se encuentran (excepto en Buenos Aires)}
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
{pre-condicion: - Archivo Inicializado.
				- Codigo de especie valido.}
{post-condicion: Devuelve el encabezado por cada codigo de Especie.}
begin
	writeln( arch, NuevaLinea, ' ':5, 'Codigo de especie en extincion: ', codEsp );
	writeln( arch, ' ':10, 'Codigo de zoologico con especie existente', ' ':10, 'Continente' );
end;

function NombreContinente( cadena: TD_CodZoo ) : TD_TipoContinente;
{NOTA: Funcion desarrollada solo para hacer pruebas}
var
	aux: char;
begin
	aux := upcase(cadena[1]);

	case aux of
		'A':
			NombreContinente := 'America';

		'F':
			NombreContinente := 'Africa';

		'E':
			NombreContinente := 'Europa';

		'S':
			NombreContinente := 'Asia';

		'O':
			NombreContinente := 'Oceania';

		else
			NombreContinente := 'NoCont';
	end;
end;

procedure CrearReporte( var arch: TA_ZooOut;
				   var vector: TVec_CodEspExt;
				   var lista: TL_Esp;
				   var cantElem: byte );
{pre-condicion: Lista y vector inicializados y cargados.}
{post-condicion: Busca en las listas que contienen todas las especies en extincion
				 los animales que no estan en el Zoologico de Buenos Aires}				   
var
	ptrCursorEsp: TN_Esp;
	ptrCursorZoo: TN_Zoo;
	
begin
	rewrite( arch );
	ptrCursorEsp := PrimeroEsp( lista );
	
	writeln( arch, ' ':15, 'Faltantes de especies en EXTINCION del Zoologico de la Ciudad de Bs. As.', NuevaLinea );
	
	while ptrCursorEsp <> nil do
	begin
		if not ContieneValor( vector, ptrCursorEsp^.CodEsp, cantElem ) then
		begin
			ImprimirEncabezado( ptrCursorEsp^.CodEsp, arch );
			
			ptrCursorZoo := PrimeroZoo( ptrCursorEsp^.ListaZoo );
			
			while ptrCursorZoo <> nil do
			begin
				writeln( arch, ' ': 15, ptrCursorZoo^.CodZoo, ' ': 40, NombreContinente(  ptrCursorZoo^.CodZoo ) );				
				
				ptrCursorZoo := SiguienteZoo( ptrCursorZoo, ptrCursorEsp^.ListaZoo );
			end;
			
		end;
		
		ptrCursorEsp := ptrCursorEsp^.Siguiente;		
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

	InicializarVariables( CantElem );
	InicializarListaEsp( ListaEsp );

	ProcesarArchivo( Archivo, VectorEsp, ListaEsp, CantElem );

	CrearReporte( ArchivoSalida, VectorEsp, ListaEsp, CantElem );

	writeln( '*** Fin del Programa ***' );
end.


