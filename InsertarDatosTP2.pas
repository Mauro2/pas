program Zoologico;

uses
	crt,
	dos;
	
const
	RutaArchivo = 'ZOOMUNDO.DAT';

type
	TD_CodZoo = string[7]; { 8 bytes }
	TD_CodEsp = longint;
	
	TR_Zoomundo = record
					CodZoo: TD_CodZoo;
					CodEsp: TD_CodEsp;
				  end;

	TA_Zoomundo = file of TR_Zoomundo;
	
var
	Archivo: TA_Zoomundo;
	
procedure InsertarRegistros( var arch: TA_Zoomundo );
var
	auxRec: TR_Zoomundo;
begin
	rewrite( arch );

	write( 'Codigo Zoologico (string[7]): ' );
	readln( auxRec.CodZoo );
	
	write( 'Codigo Especie (longint): ' );
	readln( auxRec.CodEsp );
	
	while auxRec.CodEsp > 0 do
	begin
		write( arch, auxRec );
	
		write( 'Codigo Zoologico (string[7]): ' );
		readln( auxRec.CodZoo );
		
		write( 'Codigo Especie (longint): ' );
		readln( auxRec.CodEsp );	
	end;
	
	close( arch );
end;
	
begin
	assign(Archivo, RutaArchivo);
	
	InsertarRegistros( Archivo );

	writeln('*** Fin del Programa ***');
end.