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
    local datapath "X:\OneDrive - The University of the West Indies\repo_ianhambleton\repo_papers"
    ** LOGFILES to unencrypted OneDrive folder (.gitignore set to IGNORE log files on PUSH to GitHub)
    local logpath X:\OneDrive - The University of the West Indies\repo_ianhambleton\repo_papers

    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\papers2020_duedates", replace
** HEADER -----------------------------------------------------

import excel using "`datapath'/papers_duedates.xlsx", sheet("due_dates_2019jun") first
keep if due_date>=d(1jan2020) & due_date<=d(1jan2021)

** Order by date, 
** then dates equidistant through time period for plotting
** creating artificial but broadly accurate times for each project
gen mind = d(01jan2020)
gen maxd = d(31dec2020) 
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

** Paper listing in 2020
preserve
	gen x1=1
	** Label the -date2- with the project title
	#delimit ;
	graph twoway
		(line due_date x1 if due_date>=21915 & due_date<=22280, lp("l") lc(gs12) lw(2))
        (sc due_date x1 if due_date>=21915 & due_date<=22280, s(o) msize(5) mc(gs0) yaxis(1 2) 
					mlabel(paper) mlabs(4) mlabc(gs0))
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
		ylab(21915 "                                                     ",
		valuelabel labs(5) notick nogrid glc(gs14) angle(0) format(%9.0f) axis(1) labgap(10))
		ytitle("", margin(r=3) size(large) axis(1))
		yscale(reverse noline axis(1))

		/// Month indicator
		ylab(21915 "Jan" 21946 "Feb" 21974 "Mar" 22005 "Apr" 22035 "May" 22066 "Jun" 22096 "Jul" 22127 "Aug" 22158 "Sep" 22188 "Oct" 22219 "Nov" 22250 "Dec",
		valuelabel labs(7) notick nogrid glc(gs14) angle(0) format(%9.0f) axis(2) labgap(10) )
		ytitle("", margin(r=3) size(10) axis(2))
		yscale(reverse noline axis(2))

		legend(off size(10) position(12) bm(t=1 b=0 l=0 r=0) colf cols(2)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
		)
		name(DataGroup_2020);
	#delimit cr
restore

** Paper progress in 2020
preserve
	gen x1=1
	#delimit ;
	graph twoway
		(line due_date x1 if due_date>=21915 & due_date<=22280, lp("l") lc(gs12) lw(2))
        /// Progress
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==1, s(o) msize(5) mc("165 0 38") yaxis(1 2) mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==2, s(o) msize(5) mc("244 109 67") yaxis(1 2) mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==3, s(o) msize(5) mc("254 224 139") yaxis(1 2) mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==4, s(o) msize(5) mc("217 239 139") yaxis(1 2) mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==5, s(o) msize(5) mc("102 189 99") yaxis(1 2) mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==6, s(o) msize(5) mc("0 104 55") yaxis(1 2) mlabel(paper) mlabs(4) mlabc(gs0))
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
		ylab(21915 "                                                     ",
		valuelabel labs(5) notick nogrid glc(gs14) angle(0) format(%9.0f) axis(1) labgap(10))
		ytitle("", margin(r=3) size(large) axis(1))
		yscale(reverse noline axis(1))

		/// Month indicator
		ylab(21915 "Jan" 21946 "Feb" 21974 "Mar" 22005 "Apr" 22035 "May" 22066 "Jun" 22096 "Jul" 22127 "Aug" 22158 "Sep" 22188 "Oct" 22219 "Nov" 22250 "Dec",
		valuelabel labs(7) notick nogrid glc(gs14) angle(0) format(%9.0f) axis(2) labgap(10))
		ytitle("", margin(r=3) size(10) axis(2))
		yscale(reverse noline axis(2))

		legend(off size(10) position(12) bm(t=1 b=0 l=0 r=0) colf cols(2)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
		)
		name(Progress_2020);
	#delimit cr
restore

** HAMBLETON Papers in 2020
preserve
	gen x1=0
	keep if lead=="IRH"
	#delimit ;
	graph twoway
		(line due_date x1 if due_date>=21915 & due_date<=22280, lp("l") lc(gs12) lw(2))
        /// Progress
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==1, s(o) msize(5) mc("165 0 38") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==2, s(o) msize(5) mc("244 109 67") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==3, s(o) msize(5) mc("254 224 139") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==4, s(o) msize(5) mc("217 239 139") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==5, s(o) msize(5) mc("102 189 99") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==6, s(o) msize(5) mc("0 104 55") mlabel(paper) mlabs(4) mlabc(gs0))
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
		ylab(21915 "Jan" 21946 "Feb" 21974 "Mar" 22005 "Apr" 22035 "May" 22066 "Jun" 22096 "Jul" 22127 "Aug" 22158 "Sep" 22188 "Oct" 22219 "Nov" 22250 "Dec",
		valuelabel labs(7) notick nogrid glc(gs14) angle(0) format(%9.0f) labgap(5))
		ytitle("", size(10))
		yscale(reverse noline range(21915(10)22280))

		legend(size(4) position(11) bm(t=1 b=0 l=0 r=0) colf cols(3)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(2 3 4 5 6 7)
		lab(2 "not started")
		lab(3 "planned")
		lab(4 "analysed")
		lab(5 "drafted")
		lab(6 "submitted")
		lab(7 "accepted")
		)
		name(IRH_2020);
	#delimit cr
restore



** HOWITT Papers in 2020
preserve
	gen x1=0
	keep if lead=="CH"
	** Label the -date2- with the project title
	#delimit ;
	graph twoway
		(line due_date x1 if due_date>=21915 & due_date<=22280, lp("l") lc(gs12) lw(2))
        /// Progress
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==1, s(o) msize(5) mc("165 0 38") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==2, s(o) msize(5) mc("244 109 67") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==3, s(o) msize(5) mc("254 224 139") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==4, s(o) msize(5) mc("217 239 139") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==5, s(o) msize(5) mc("102 189 99") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==6, s(o) msize(5) mc("0 104 55") mlabel(paper) mlabs(4) mlabc(gs0))
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
		ylab(21915 "Jan" 21946 "Feb" 21974 "Mar" 22005 "Apr" 22035 "May" 22066 "Jun" 22096 "Jul" 22127 "Aug" 22158 "Sep" 22188 "Oct" 22219 "Nov" 22250 "Dec",
		valuelabel labs(7) notick nogrid glc(gs14) angle(0) format(%9.0f) labgap(5))
		ytitle("", size(10))
		yscale(reverse noline range(21915(10)22280))

		legend(size(4) position(11) bm(t=1 b=0 l=0 r=0) colf cols(3)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(2 3 4 5 6 7)
		lab(2 "not started")
		lab(3 "planned")
		lab(4 "analysed")
		lab(5 "drafted")
		lab(6 "submitted")
		lab(7 "accepted")
		)
		name(CH_2020);
	#delimit cr
restore


** BROWN Papers in 2020
preserve
	gen x1=0
	keep if lead=="CB"
	** Label the -date2- with the project title
	#delimit ;
	graph twoway
		(line due_date x1 if due_date>=21915 & due_date<=22280, lp("l") lc(gs12) lw(2))
        /// Progress
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==1, s(o) msize(5) mc("165 0 38") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==2, s(o) msize(5) mc("244 109 67") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==3, s(o) msize(5) mc("254 224 139") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==4, s(o) msize(5) mc("217 239 139") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==5, s(o) msize(5) mc("102 189 99") mlabel(paper) mlabs(4) mlabc(gs0))
		(sc due_date  x1 if due_date>=21915 & due_date<=22280 & progress2==6, s(o) msize(5) mc("0 104 55") mlabel(paper) mlabs(4) mlabc(gs0))
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
		ylab(21915 "Jan" 21946 "Feb" 21974 "Mar" 22005 "Apr" 22035 "May" 22066 "Jun" 22096 "Jul" 22127 "Aug" 22158 "Sep" 22188 "Oct" 22219 "Nov" 22250 "Dec",
		valuelabel labs(7) notick nogrid glc(gs14) angle(0) format(%9.0f) labgap(5))
		ytitle("", size(10))
		yscale(reverse noline range(21915(10)22280))

		legend(size(4) position(11) bm(t=1 b=0 l=0 r=0) colf cols(3)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(2 3 4 5 6 7)
		lab(2 "not started")
		lab(3 "planned")
		lab(4 "analysed")
		lab(5 "drafted")
		lab(6 "submitted")
		lab(7 "accepted")
		)
		name(CB_2020);
	#delimit cr
restore
