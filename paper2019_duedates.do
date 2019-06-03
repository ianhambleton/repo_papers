** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			        papers2019_duedates.do
    //  project:				        Data Group planning
    //  analysts:				       	Ian HAMBLETON
    // 	date last modified	            16-April-2019
    //  algorithm task			        Paper production timeline

    ** General algorithm set-up
    version 15
    clear all
    macro drop _all
    set more 1
    set linesize 80

    ** Set working directories: this is for DATASET and LOGFILE import and export
    ** DATASETS to encrypted SharePoint folder
    local datapath "X:\The University of the West Indies\DataGroup - DG_Resources\DATAGROUP_outputs"
    ** LOGFILES to unencrypted OneDrive folder (.gitignore set to IGNORE log files on PUSH to GitHub)
    local logpath X:\The University of the West Indies\DataGroup - DG_Resources\DATAGROUP_outputs

    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\papers2019_duedates", replace
** HEADER -----------------------------------------------------

import excel using "`datapath'/papers_duedates.xlsx", sheet("due_dates_2019apr") first
keep if due_date<=d(1jan2020)

** Order by date, 
** then dates equidistant through time period for plotting
** creating artificial but broadly accurate times for each project
gen mind = d(28apr2019)
gen maxd = d(31dec2019) 
gen timeframe = int((maxd - mind)/_N)
sort due_date paper
gen timeframe2 = sum(timeframe) 
gen date2 = mind + timeframe2

** Paper progress
gen progress2 = 1 if progress=="not started"
replace progress2 = 2 if progress == "planned"
replace progress2 = 3 if progress == "analysed"
replace progress2 = 4 if progress == "drafted"
replace progress2 = 5 if progress == "submitted"
replace progress2 = 6 if progress == "accepted"
label define progress2 1 "not started" 2 "planned" 3 "analysed" 4 "drafted" 5 "submitted" 6 "accepted"
label values progress2 progress2

gen date_num = due_date 
order date_num, after(due_date)
sort date2 

** Paper listing in 2019
preserve
	gen x1=1
	** Label the -date2- with the project title
	sort date2
	labmask date2, values(paper)
	#delimit ;
	graph twoway
		(line date2 x1 if date2>=21670 & date2<=21898, lp("l") lc(gs12) lw(2))
        (sc date2 x1 if date2>=21670 & date2<=21898, s(o) msize(5) mc(gs0) yaxis(1 2))
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
		graphregion(margin(50 150 2 2) color(gs16) ic(gs16) ilw(thin) lw(thin))
		ysize(10) xsize(3.5)

		/// X-axis for width
		xlab(none, 
		labs(40) nogrid notick glc(gs14) angle(0) labgap(3))
		xscale(noline fill) 
		xtitle("", margin(t=2) size(10))

		/// Project titles 
		ylab(21674(7)21898,
		valuelabel labs(5) notick nogrid glc(gs14) angle(0) format(%9.0f) axis(1) labgap(10))
		ytitle("", margin(r=3) size(large) axis(1))
		yscale(reverse noline axis(1))

		/// Month indicator
		ylab(21669 "May" 21700 "Jun" 21730 "Jul" 21761 "Aug" 21792 "Sep" 21822 "Oct" 21853 "Nov" 21883 "Dec" 21914 "Jan",
		valuelabel labs(7) notick nogrid glc(gs14) angle(0) format(%9.0f) axis(2) labgap(10) )
		ytitle("", margin(r=3) size(10) axis(2))
		yscale(reverse noline axis(2))

		legend(off size(10) position(12) bm(t=1 b=0 l=0 r=0) colf cols(2)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
		)
		name(DataGroup_2019);
	#delimit cr
restore

** Paper progress in 2019
preserve
	gen x1=1
	** Label the -date2- with the project title
	sort date2
	labmask date2, values(paper)
	#delimit ;
	graph twoway
		(line date2 x1 if date2>=21670 & date2<=21898, lp("l") lc(gs12) lw(2))
        /// Progress
		(sc date2 x1 if date2>=21670 & date2<=21898 & progress2==1, s(o) msize(5) mc("215 48 39") yaxis(1 2))
		(sc date2 x1 if date2>=21670 & date2<=21898 & progress2==2, s(o) msize(5) mc("252 141 89") yaxis(1 2))
		(sc date2 x1 if date2>=21670 & date2<=21898 & progress2==3, s(o) msize(5) mc("254 224 139") yaxis(1 2))
		(sc date2 x1 if date2>=21670 & date2<=21898 & progress2==4, s(o) msize(5) mc("217 239 139") yaxis(1 2))
		(sc date2 x1 if date2>=21670 & date2<=21898 & progress2==5, s(o) msize(5) mc("147 207 96") yaxis(1 2))
		(sc date2 x1 if date2>=21670 & date2<=21898 & progress2==6, s(o) msize(5) mc("26 152 80") yaxis(1 2))
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
		graphregion(margin(50 150 2 2) color(gs16) ic(gs16) ilw(thin) lw(thin))
		ysize(10) xsize(3.5)

		/// X-axis for width
		xlab(none, 
		labs(40) nogrid notick glc(gs14) angle(0) labgap(3))
		xscale(noline fill) 
		xtitle("", margin(t=2) size(10))

		/// Project titles 
		ylab(21674(7)21898,
		valuelabel labs(5) notick nogrid glc(gs14) angle(0) format(%9.0f) axis(1) labgap(10))
		ytitle("", margin(r=3) size(large) axis(1))
		yscale(reverse noline axis(1))

		/// Month indicator
		ylab(21669 "May" 21700 "Jun" 21730 "Jul" 21761 "Aug" 21792 "Sep" 21822 "Oct" 21853 "Nov" 21883 "Dec" 21914 "Jan",
		valuelabel labs(7) notick nogrid glc(gs14) angle(0) format(%9.0f) axis(2) labgap(10))
		ytitle("", margin(r=3) size(10) axis(2))
		yscale(reverse noline axis(2))

		legend(off size(10) position(12) bm(t=1 b=0 l=0 r=0) colf cols(2)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
		)
		name(Progress_2019);
	#delimit cr
restore

** HAMBLETON Papers in 2019
preserve
	gen x1=0
	keep if lead=="IRH"
	** Label the -date2- with the project title
	sort date2
	labmask date2, values(paper)
	#delimit ;
	graph twoway
		(line date2 x1 if date2>=21674 & date2<=21914, lp("l") lc(gs12) lw(2))
        /// Progress
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==1, s(o) msize(5) mc("215 48 39") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==2, s(o) msize(5) mc("252 141 89") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==3, s(o) msize(5) mc("254 224 139") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==4, s(o) msize(5) mc("217 239 139") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==5, s(o) msize(5) mc("147 207 96") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==6, s(o) msize(5) mc("26 152 80") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
		ysize(10) xsize(3.5)

		/// X-axis for width
		xlab(none, 
		labs(4) nogrid notick glc(gs14) angle(0))
		xscale(noline range(0(1)10) ) 
		xtitle("", size(10))

		/// Month indicator
		ylab(21669 "May" 21700 "Jun" 21730 "Jul" 21761 "Aug" 21792 "Sep" 21822 "Oct" 21853 "Nov" 21883 "Dec" 21914 "Jan",
		valuelabel labs(7) notick nogrid glc(gs14) angle(0) format(%9.0f) labgap(5))
		ytitle("", size(10))
		yscale(reverse noline)

		legend(size(4) position(11) bm(t=1 b=0 l=0 r=0) colf cols(3)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(2 3 4 5 6)
		lab(1 "not started")
		lab(2 "planned")
		lab(3 "analysed")
		lab(4 "drafted")
		lab(5 "submitted")
		lab(6 "accepted")
		)
		name(IRH_2019);
	#delimit cr
restore

** HOWITT Papers in 2019
preserve
	gen x1=0
	keep if lead=="CH"
	** Label the -date2- with the project title
	sort date2
	labmask date2, values(paper)
	#delimit ;
	graph twoway
		(line date2 x1 if date2>=21660 & date2<=21914, lp("l") lc(gs12) lw(2))
        /// Progress
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==1, s(o) msize(5) mc("215 48 39") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==2, s(o) msize(5) mc("252 141 89") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==3, s(o) msize(5) mc("254 224 139") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==4, s(o) msize(5) mc("217 239 139") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==5, s(o) msize(5) mc("147 207 96") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==6, s(o) msize(5) mc("26 152 80") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
		ysize(10) xsize(3.5)

		/// X-axis for width
		xlab(none, 
		labs(4) nogrid notick glc(gs14) angle(0))
		xscale(noline range(0(1)10) ) 
		xtitle("", size(10))

		/// Month indicator
		ylab(21669 "May" 21700 "Jun" 21730 "Jul" 21761 "Aug" 21792 "Sep" 21822 "Oct" 21853 "Nov" 21883 "Dec" 21914 "Jan",
		valuelabel labs(7) notick nogrid glc(gs14) angle(0) format(%9.0f) labgap(5))
		ytitle("", size(10))
		yscale(reverse noline)

		legend(size(4) position(11) bm(t=1 b=0 l=0 r=0) colf cols(3)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(2 3 4 5 6)
		lab(1 "not started")
		lab(2 "planned")
		lab(3 "analysed")
		lab(4 "drafted")
		lab(5 "submitted")
		lab(6 "accepted")
		)
		name(CH_2019);
	#delimit cr
restore


** BROWN Papers in 2019
preserve
	gen x1=0
	keep if lead=="CB"
	** Label the -date2- with the project title
	sort date2
	labmask date2, values(paper)
	#delimit ;
	graph twoway
		(line date2 x1 if date2>=21660 & date2<=21914, lp("l") lc(gs12) lw(2))
        /// Progress
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==1, s(o) msize(5) mc("215 48 39") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==2, s(o) msize(5) mc("252 141 89") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==3, s(o) msize(5) mc("254 224 139") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==4, s(o) msize(5) mc("217 239 139") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==5, s(o) msize(5) mc("147 207 96") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		(sc date2 x1 if date2>=21660 & date2<=21914 & progress2==6, s(o) msize(5) mc("26 152 80") mlabel(paper) mlabsize(5) mlabc(gs0) mlabg(5) )
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
		ysize(10) xsize(3.5)

		/// X-axis for width
		xlab(none, 
		labs(4) nogrid notick glc(gs14) angle(0))
		xscale(noline range(0(1)10) ) 
		xtitle("", size(10))

		/// Month indicator
		ylab(21669 "May" 21700 "Jun" 21730 "Jul" 21761 "Aug" 21792 "Sep" 21822 "Oct" 21853 "Nov" 21883 "Dec" 21914 "Jan",
		valuelabel labs(7) notick nogrid glc(gs14) angle(0) format(%9.0f) labgap(5))
		ytitle("", size(10))
		yscale(reverse noline)

		legend(size(4) position(11) bm(t=1 b=0 l=0 r=0) colf cols(3)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(2 3 4 5 6)
		lab(1 "not started")
		lab(2 "planned")
		lab(3 "analysed")
		lab(4 "drafted")
		lab(5 "submitted")
		lab(6 "accepted")
		)
		name(CB_2019);
	#delimit cr
restore
