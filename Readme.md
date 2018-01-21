# 1.0 Introduction

This walkthrough on regression and modeling follows the SAS version that inspired it, written by the brilliant people from UCLA Idrea. It can be found here: [REGRESSION WITH SAS CHAPTER 1 – SIMPLE AND MULTIPLE REGRESSION](https://stats.idre.ucla.edu/sas/webbooks/reg/chapter1/regressionwith-saschapter-1-simple-and-multiple-regression/)
This article will try to follow each step taken in the original web book, try to replicate it in HPCC ECL, and present results and hopefully explain differences and where to go from there.

The emphasize will be on understanding data by running some simple analysis to find more actionable and useful means to come up with predictive models.

I assume that you already have a basic understanding of HPCC ECL, and that you have basic environment running (e.g. VirtualBox VM is fine for this exercise).

The data used here was created by randomly sampling 400 elementary schools from the California Department of Education’s API 2000 dataset. This data file contains a measure of school academic performance as well as other attributes of the elementary schools, such as, class size, enrollment, poverty, etc.
There are two versions of the data as we will see shortly, one which is *raw* (i.e. dirty) and one that has been cleaned up and used later.

The SAS *raw* file is [elemapi.sas7bdat](https://stats.idre.ucla.edu/wp-content/uploads/2016/02/elemapi-1.sas7bdat). This is the file we will be using from now on until mentioned otherwise.

## 1.0.1 Setting things up

Best is to simply clone this repository and add the containing folder to your **ECL Folders** in your ECL IDE.


## 1.0.2 Loading data

Best is to simply to use ECL Watch to upload the data file to the dropzone and spray it as CSV.
To make things faster, this ECL code will basically do the same.

```ecl
TODO
```

# 1.1 Examining data

Before getting to the nitty gritty, it's best to understand what kind of data we are dealing with.
As far as I know, there's today no HPCC data file format that would store both the data and its description.
The following **RECORD** will have to suffice for now:

```ecl
raw_layout := RECORD
 UNSIGNED id;       // unique record id
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
```

So basically, the data file contains academic performance, average class sizes, percent of student eligible for free meals, parents education, percent of teachers with full and emergency credentials, number of enrollees, etc. per school.

Let's see what the data looks like:

```ecl
OUTPUT( DATASET('regression::elemapi-1', raw_layout, THOR), NAMED('DataSample'));
```

This will print the first 100 records from the data.

