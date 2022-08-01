
* Stata Syntax example for merging vertical biographic data file with horizontal CATI individual data file
* "Hypothetical" Problem: do men and women have a different number of learned professions ?

cd D:\SHP\Biography	/* Directory, where data file is located; working directory */
use shp0_bvlp_user, clear	/* load working file; here lp="learned professions" */
keep idpers bvlp_idx	/* since we are only interested in the number, we only need to keep the index variable (+idpers)*/
bysort idpers: keep if _n==_N	/* we keep the last index per person */

merge idpers using shp_mp	/* we assume that shp_mp is already sorted by idpers */
keep if _merge==3		/* we only keep individuals who are in the biographic data file */

* Now we have created the target working file :-)
tab bvlp_idx sex, chi2

************************************************************************************************
* 2nd problem: mean number of years a Swiss person lived outside of Switzerland

use shp0_bvsa_user, clear	/* load working file; here sa="outside of Switzerland" */
gen stay=bvsa002-bvsa001	/* compute duration of stay, but take care of ... */
replace stay=0 if bvsa001==-3 | bvsa002==-3	/* ... the inapplicable values from those who were never abroad */

bysort idpers: egen cumstay=sum(stay)	/* compute aggregated value per person */
bysort idpers: keep if _n==1		/* keep value once per person */

summ cumstay, det	/* summary statistics */

merge idpers using shp_mp	/* we assume that shp_mp is already sorted by idpers */
keep if _merge==3		/* we only keep individuals who are in the biographic data file */

* Now we have created the target working file :-)
tab bvlp_idx sex, chi2
