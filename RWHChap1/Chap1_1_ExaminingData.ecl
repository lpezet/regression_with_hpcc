﻿IMPORT RWHChap1.Layouts;
IMPORT RWHUtils.Profiler;


oDS := DATASET( 'regression::elemapi-1::raw', Layouts.raw_layout, THOR );
// Peek at the data
OUTPUT( oDS, NAMED('SampleRaw') );

// Peek at the fields
Profiler.profile_fields( oProfileAllFields, oDS );
OUTPUT( oProfileAllFields, NAMED('AllFields') );
Profiler.profile_select_fields_values( oProfileSelectFields, oDS, '<Fields><Field label="full"/><Field label="meals"/><Field label="acs_k3"/><Field label="api00"/></Fields>' );
OUTPUT( oProfileSelectFields, NAMED('SelectFields') );
Profiler.freq( oFreqMeals, oDS, 'meals' );
OUTPUT(oFreqMeals, NAMED('MealsFrequency') );
Profiler.freq( oFreqACSK3, oDS, 'acs_k3' );
OUTPUT(oFreqACSK3, NAMED('ACSK3Frequency') );
