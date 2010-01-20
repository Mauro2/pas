program Zoologico;

uses
	crt,
	dos;
	
const
	RutaArchivo = 'ZOOMUNDO.DAT';
	ZooBSAS = 'AARGCBA';
	
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
	
	
	
procedure MostrarError( mensaje: TD_MensajeError )
begin
	writeln( mensaje );
end;
	
{ Procedures Vector }
	
procedure InicializarVector( var vector: TVec_CodEspExt )
var
	i: integer;
begin
	for i := SubIndInf to SubIndSup do vector[i] = -999999999;
end;


procedure DesplazarElementos( var vector: TVec_CodEspExt;
							  corriente: integer;
							  var cantElem: integer )
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
{TODO: post-condicion: }
procedure InsertarVector( var vector: TVec_CodEspExt;
						  var item: TD_CodEsp;
						  var cantElem: integer )
var
	i: integer;
	corriente: integer;
begin
	if( cantElem <= SubIndSup )
	begin
		while item > vector[corriente] and corriente < cantElem do
		begin
			inc(corriente);
		end
	end
	else
	begin
		MostrarError( 'Vector lleno, no se pueden insertar mas registros' );
	end;
	

end;


	
var
	ListaEsp: TL_Esp;
	Archivo: TA_Zoomundo;
	
begin
	assign(Archivo, RutaArchivo);
	
	
	
	writeln('*** Fin del Programa ***');
end.