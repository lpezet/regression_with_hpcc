

EXPORT Layouts := MODULE
		
	EXPORT raw_layout := RECORD
	 //STRING id;       // unique record id
	 STRING snum;       // school number
	 STRING dnum;       // district number
	 STRING api00;      // academic school Performan in 2000
	 STRING api99;      // academic school performance in 1999
	 STRING growth;     // growth 1999 to 2000
	 STRING meals;      // percent free meals
	 STRING ell;        // english language learners
	 STRING yr_rnd;     // year round school
	 STRING mobility;   // percent 1st year in school
	 STRING acs_k3;     // average class size k-3
	 STRING acs_46;     // average class size 4-6
	 STRING not_hsg;    // parent not hsg
	 STRING hsg;        // parent hsg
	 STRING some_col;   // parent some college
	 STRING col_grad;   // parent college grad
	 STRING grad_sch;   // parent grad school
	 STRING avg_ed;     // average parent ed
	 STRING full;       // percent full credential
	 STRING emer;       // percent emer credential
	 STRING enroll;     // number of students
	 STRING mealcat;    // percent free means in 3 categories
	 STRING collcat;    // 
	END;

END;