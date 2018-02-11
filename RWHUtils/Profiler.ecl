
EXPORT Profiler := MODULE

	EXPORT profile_field_values( pOutDS, pInDS, pFieldName, pField ) := MACRO
		pOutDS :=
			TABLE( pInDS, { STRING field := pFieldName; STRING value := pField; UNSIGNED occ := COUNT(GROUP); }, pField );
	ENDMACRO;
	
	EXPORT profile_select_fields_values( pOutDS, pInDS, pFields ) := MACRO
		LOADXML( pFields );
		pOutDS := MERGE(
			//#EXPORTXML(FileStruct, pInDS)
			#FOR (Field)
				TABLE( pInDS, { STRING field := %'{@label}'%; STRING value := %{@label}%; UNSIGNED occ := COUNT(GROUP); }, %{@label}% , UNSORTED, MERGE),
				//TABLE( pDS, { STRING100 field := %'{@label}'%; STRING100 min_value := MIN(GROUP, %{@label}%); STRING100 max_value := MAX(GROUP, %{@label}%); UNSIGNED min_value_length := MIN(GROUP, LENGTH(%{@label}%)); UNSIGNED max_value_length := MAX(GROUP, LENGTH(%{@label}%)); UNSIGNED filled_in := SUM(GROUP, IF(%{@label}% = '',0,1)); UNSIGNED total_records := COUNT(GROUP); } ),
			#END
				SORTED(field)
		);
	ENDMACRO;

	
	EXPORT profile_fields_values( pOutDS, pInDS ) := MACRO
		pOutDS := MERGE(
			#EXPORTXML(FileStruct, pInDS)
			#FOR (FileStruct)
				#FOR (ThorTable)
					#FOR (Field)
						TABLE( pInDS, { STRING field := %'{@label}'%; STRING value := %{@label}%; UNSIGNED occ := COUNT(GROUP); }, %{@label}%, UNSORTED, MERGE),
					#END
				#END
			#END
				SORTED(field)
		);
	ENDMACRO;

	EXPORT profile_fields( pOutDS, pInDS ) := MACRO
		pOutDS := MERGE(
			#EXPORTXML(FileStruct, pInDS)
			#FOR (FileStruct)
				#FOR (ThorTable)
					#FOR (Field)
						TABLE( pInDS, { STRING100 field := %'{@label}'%; STRING100 min_value := MIN(GROUP, %{@label}%); STRING100 max_value := MAX(GROUP, %{@label}%); UNSIGNED min_value_length := MIN(GROUP, LENGTH(%{@label}%)); UNSIGNED max_value_length := MAX(GROUP, LENGTH(%{@label}%)); } ),
					#END
				#END
			#END
				SORTED(field)
		);
	ENDMACRO;
	
	EXPORT profile_select_fields( pOutDS, pInDS, pFields ) := MACRO
		LOADXML( pFields );
		pOutDS := MERGE(
			//#EXPORTXML(FileStruct, pInDS)
			#FOR (Field)
					TABLE( pInDS, { STRING100 field := %'{@label}'%; STRING100 min_value := MIN(GROUP, %{@label}%); STRING100 max_value := MAX(GROUP, %{@label}%); UNSIGNED min_value_length := MIN(GROUP, LENGTH(%{@label}%)); UNSIGNED max_value_length := MAX(GROUP, LENGTH(%{@label}%)); UNSIGNED filled_in := SUM(GROUP, IF(%{@label}% = '',0,1)); UNSIGNED total_records := COUNT(GROUP); } ),
			#END
				SORTED(field)
		);
	ENDMACRO;
	
	EXPORT freq( pOutDS, pInDS, pFields = '' ) := MACRO
		LOADXML('<xml/>');
		//pOutDS := TABLE( pInDS; { #EXPAND(pFields); UNSIGNED frequency := COUNT(GROUP); DECIMAL4_2 percent := 0.0; UNSIGNED cumul_frequency := 0; DECIMAL4_2 cumul_percent := 0.0 }, #EXPAND(pFields) ) 
		#DECLARE(tablefieldslist) #SET(tablefieldslist,'')
		#DECLARE(tablefieldsgroup) #SET(tablefieldsgroup,'')
		#EXPORTXML(fields,RECORDOF(pInDS))
		#FOR(fields)
			#FOR(Field)
				#IF(REGEXFIND('\\s*,\\s*'+%'{@label}'%+',',','+pFields+',',NOCASE))
					#APPEND(tablefieldslist, %'{@label}'%)
					#APPEND(tablefieldslist, ';')
					#IF(%'tablefieldsgroup'%!='')
						#APPEND(tablefieldsgroup, ',')
					#END
					#APPEND(tablefieldsgroup, %'{@label}'%)
				#END
			#END
		#END
		//OUTPUT( %'tablefieldslist'% );
		//OUTPUT( %'tablefieldsgroup'% );
		#UNIQUENAME(Summary)
		%Summary% := TABLE( pInDS, { #EXPAND(%'tablefieldslist'%) UNSIGNED frequency := COUNT(GROUP); DECIMAL4_2 percent := COUNT(GROUP) / COUNT(pInDS); UNSIGNED cumul_frequency := 0; DECIMAL4_2 cumul_percent := 0.0; }, #EXPAND(%'tablefieldsgroup'%) );
		pOutDS := ITERATE( %Summary%, TRANSFORM( RECORDOF( %Summary% ),
			SELF.cumul_frequency := LEFT.cumul_frequency + RIGHT.frequency;
			SELF.cumul_percent := LEFT.cumul_percent + RIGHT.percent;
			SELF := RIGHT;
		));
	ENDMACRO;

END;