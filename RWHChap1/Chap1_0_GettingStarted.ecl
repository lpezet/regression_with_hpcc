IMPORT RWHChap1.Layouts;
IMPORT RWHUtils.Curl;
IMPORT RWHUtils.BinUtils;
IMPORT RWHUtils.Zip;
IMPORT Std;

DropZoneIP := '192.168.99.101'; //NB: change it to the IP of your Master/ECLAgent

load_data() := FUNCTION
	oFile := DATASET( Std.File.ExternalLogicalFilename( DropZoneIP, '/var/lib/HPCCSystems/mydropzone/elemapi-1.csv' ), Layouts.raw_layout, CSV(HEADING(1), QUOTE('"'), TERMINATOR(['\n','\r\n','\r'])));
	RETURN OUTPUT( oFile,, 'regression::elemapi-1::raw', OVERWRITE);
END;

ETL := SEQUENTIAL(
	// Extract
	OUTPUT( Curl.download( 'https://raw.githubusercontent.com/lpezet/regression_with_hpcc/master/elemapi-1.zip', '/var/lib/HPCCSystems/mydropzone/elemapi-1.zip' ), NAMED('Download') ),
	// Unzip
	OUTPUT( Zip.unzip( '/var/lib/HPCCSystems/mydropzone/elemapi-1.zip', '/var/lib/HPCCSystems/mydropzone/', TRUE ), NAMED('Unzip') ),
	// Load
	load_data()
);

ETL;
