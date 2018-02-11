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

The data file contains academic performance, average class sizes, percent of student eligible for free meals, parents education, percent of teachers with full and emergency credentials, number of enrollees, etc. per school.

Let's see what the data looks like:

```ecl
OUTPUT( DATASET('regression::elemapi-1', raw_layout, THOR), NAMED('DataSample'));
```

This will print the first 100 records from the data.

| snum | dnum | api00 | api99 | growth | meals | ell | yr_rnd | mobility | acs_k3 | acs_46 | not_hsg | hsg | some_col | col_grad | grad_sch | avg_ed | full | emer | enroll | mealcat | collcat |
| ---- | ----- | ----- | ---- | ---- | --- | --- | ---- | ---- | ---- | --- | --- | --- | --- | --- | --- | ---- | ---- | ----- | --- | --- | --- |
| 906 | 41 | 693 | 600 | 93 | 67 | 9 | 0 | 11 | 16 | 22 | 0 | 0 | 0 | 0 | 0 |  | 76 | 24 | 247 | 2 | |
| 889 | 41 | 570 | 501 | 69 | 92 | 21 | 0 | 33 | 15 | 32 | 0 | 0 | 0 | 0 | 0 |  | 79 | 19 | 463 | 3 | | 
| 887 | 41 | 546 | 472 | 74 | 97 | 29 | 0 | 36 | 17 | 25 | 0 | 0 | 0 | 0 | 0 |  | 68 | 29 | 395 | 3 | |
| 876 | 41 | 571 | 487 | 84 | 90 | 27 | 0 | 27 | 20 | 30 | 36 | 45 | 9 | 9 | 0 | 1.909999966621399 | 87 | 11 | 418 | 3 | |
| 888 | 41 | 478 | 425 | 53 | 89 | 30 | 0 | 44 | 18 | 31 | 50 | 50 | 0 | 0 | 0 | 1.5 | 87 | 13 | 520 | 3 | |
| 4284 | 98 | 858 | 844 | 14 |  | 3 | 0 | 10 | 20 | 33 | 1 | 8 | 24 | 36 | 31 | 3.890000104904175 | 100 | 0 | 343 | 1 | |
| 4271 | 98 | 918 | 864 | 54 |  | 2 | 0 | 16 | 19 | 28 | 1 | 4 | 18 | 34 | 43 | 4.130000114440918 | 100 | 0 | 303 | 1 | |
| 2910 | 108 | 831 | 791 | 40 |  | 3 | 0 | 44 | 20 | 31 | 0 | 4 | 16 | 50 | 30 | 4.059999942779541 | 96 | 2 | 1513 | 1 | |
| 2899 | 108 | 860 | 838 | 22 |  | 6 | 0 | 10 | 20 | 30 | 2 | 9 | 15 | 42 | 33 | 3.9600000381469727 | 100 | 0 | 660 | 1 | |
| 2887 | 108 | 737 | 703 | 34 | 29 | 15 | 0 | 17 | 21 | 29 | 8 | 25 | 34 | 27 | 7 | 2.9800000190734863 | 96 | 7 | 362 | 1 | |
| ... | ..... | ..... | .... | .... | ... | ... | .... | .... | .... | ... | ... | ... | ... | ... | ... | .... | .... | ..... | ... | ... | ... | 

Listing data can be helpful to eyeball problems within it. In this output, we can clearly see that some values are missing for *meals*., as well as fr *avg_ed*. Thing is, it's possible we might be missing values for other fields that we can't see here because we're looking at only 100 records.

 A useful way to learn about the data at hand is to get basic statistics on the fields we're interested in, like the minimum value, the maximum value, the average, etc.
 
 This can be easily done using the free Machine Learning library provided by HPCC Systems.
 
 
 The output is as follows:
 
| field_name | number | minval | maxval | sumval | countval | mean | var | sd |
| ----- | -- | ---- | ---- | ------- | ----- | ----------------- | --------------- | ---------------- |
| acs_k3 | 10 | 0.0 | 50.0 | 11399.0 | 386.0 | 29.53108808290155 | 21.518463582915 | 4.63879979983131 |
| full | 18 | 0.0 | 59.0 | 4984.0 | 386.0 | 12.9119170984456 | 142.1269564283605 | 11.92170107108715 |
| api00 | 3 | 333.0 | 917.0 | 236741.0 | 386.0 | 613.3186528497409 | 21605.42954844422 | 146.9878551052576 |
| meals | 6 | 0.0 | 91.0 | 12307.0 | 386.0 | 31.88341968911917 | 632.1962535907005 | 25.14351315132196 |

WARNING: Again here, because of SAS Viewer export, some observations made from UCLA is off here, since we don't see like -21 for min val of acs_k3.


TODO: freq for yr_rnd
TODO: univariate acs_k3
TODO: tables acs_k3
TODO: troubleshoot negatie values for acs_k3
TODO: troubleshoot full <= 1
TODO: scatter plots!!!
TODO; regression!!!!



