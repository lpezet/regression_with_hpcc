
EXPORT Profiler := MODULE

	EXPORT profile_field_values( pDS, pFieldName, pField ) := FUNCTIONMACRO
		RETURN
			TABLE( pDS, { STRING field := pFieldName; STRING value := pField; UNSIGNED occ := COUNT(GROUP); }, pField );
	ENDMACRO;
	
	EXPORT profile_select_fields_values( pDS, pFields ) := FUNCTIONMACRO
		LOADXML( pFields );
		RETURN MERGE(
			//#EXPORTXML(FileStruct, pDS)
			#FOR (Field)
				TABLE( pDS, { STRING field := %'{@label}'%; STRING value := %{@label}%; UNSIGNED occ := COUNT(GROUP); }, %{@label}% , UNSORTED, MERGE),
				//TABLE( pDS, { STRING100 field := %'{@label}'%; STRING100 min_value := MIN(GROUP, %{@label}%); STRING100 max_value := MAX(GROUP, %{@label}%); UNSIGNED min_value_length := MIN(GROUP, LENGTH(%{@label}%)); UNSIGNED max_value_length := MAX(GROUP, LENGTH(%{@label}%)); UNSIGNED filled_in := SUM(GROUP, IF(%{@label}% = '',0,1)); UNSIGNED total_records := COUNT(GROUP); } ),
			#END
				SORTED(field)
		);
	ENDMACRO;

	
	EXPORT profile_fields_values( pDS ) := FUNCTIONMACRO
		RETURN MERGE(
			#EXPORTXML(FileStruct, pDS)
			#FOR (FileStruct)
				#FOR (ThorTable)
					#FOR (Field)
						TABLE( pDS, { STRING field := %'{@label}'%; STRING value := %{@label}%; UNSIGNED occ := COUNT(GROUP); }, %{@label}%, UNSORTED, MERGE),
					#END
				#END
			#END
				SORTED(field)
		);
	ENDMACRO;

	EXPORT profile_fields( pDS ) := FUNCTIONMACRO
		RETURN MERGE(
			#EXPORTXML(FileStruct, pDS)
			#FOR (FileStruct)
				#FOR (ThorTable)
					#FOR (Field)
						TABLE( pDS, { STRING100 field := %'{@label}'%; STRING100 min_value := MIN(GROUP, %{@label}%); STRING100 max_value := MAX(GROUP, %{@label}%); UNSIGNED min_value_length := MIN(GROUP, LENGTH(%{@label}%)); UNSIGNED max_value_length := MAX(GROUP, LENGTH(%{@label}%)); } ),
					#END
				#END
			#END
				SORTED(field)
		);
	ENDMACRO;
	
	EXPORT profile_select_fields( pDS, pFields ) := FUNCTIONMACRO
		LOADXML( pFields );
		RETURN MERGE(
			//#EXPORTXML(FileStruct, pDS)
			#FOR (Field)
					TABLE( pDS, { STRING100 field := %'{@label}'%; STRING100 min_value := MIN(GROUP, %{@label}%); STRING100 max_value := MAX(GROUP, %{@label}%); UNSIGNED min_value_length := MIN(GROUP, LENGTH(%{@label}%)); UNSIGNED max_value_length := MAX(GROUP, LENGTH(%{@label}%)); UNSIGNED filled_in := SUM(GROUP, IF(%{@label}% = '',0,1)); UNSIGNED total_records := COUNT(GROUP); } ),
			#END
				SORTED(field)
		);
	ENDMACRO;

END;