* header.do
* do step1_clean13f.do
****************************
*Setting the path properly
clear all
*global path "/Users/alhu/Dropbox/academic/passive_information/ownership"
*global path "R:/bulk/s34_russell_sue"
*global path "/home/alhu/Dropbox/research/passiveinfo/s34_russell_sue"
global path "/Users/alhu/GitHub/cryptocommon"
*global uppath "/Users/alhu/Dropbox/academic/passive_information"
cd `path'
set more off
global code "$path/code"
global graphs "$path/graphs"
global output "$path/output"
global data "/Users/alhu/GitHub/cryptocommon/data"

** SECTIONS
global data_section "yes"
global econ_data_section "yes"
global pca_section "yes"
global graphs_section "yes"
set matsize 5000
****************************

if "$data_section" == "yes" {

import delimited "$data/ff/ff_factors_daily.csv", clear
rename rf ffrf
save "$code/cryptoprices.dta", replace

import delimited "$data/csv/btc_usd.csv", clear
rename px px_btc
rename vol vol_btc
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace


import delimited "$data/csv/ltc_usd.csv", clear
rename px px_ltc
rename vol vol_ltc
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/csv/ppc_usd.csv", clear
rename px px_ppc
rename vol vol_ppc
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace


import delimited "$data/csv/doge_gap.csv", clear
rename px px_doge
rename vol vol_doge

merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/csv/dash_btc.csv", clear
rename px px_dash
rename vol vol_dash
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/csv/maid_btc.csv", clear
rename px px_maid
rename vol vol_maid
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/csv/xmr_btc.csv", clear
rename px px_xmr
rename vol vol_xmr
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/csv/nxt_btc.csv", clear
rename px px_nxt
rename vol vol_nxt
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/csv/ltc_btc.csv", clear
rename px px_ltcbtc
rename vol vol_ltcbtc
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/csv/crix.csv", clear
rename px px_crix
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/fred/DTWEXM.csv", clear
drop if px == .
gen r_usd = px/px[_n-1]-1
rename px px_usd
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/fred/SP500.csv", clear
drop if px == .
gen r_spy = px/px[_n-1]-1
rename px px_spy
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace


import delimited "$data/fred/DGS10.csv", clear
drop if y_dgs10 == .
gen d_dgs10 = y_dgs10/y_dgs10[_n-1]-1
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/fred/VIXCLS.csv", clear
drop if vix == .
gen r_vix = vix/vix[_n-1]-1
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace

import delimited "$data/fred/DTB3.csv", clear
sort date
gen rf = px/100/90
gen drc = rf - rf[_n-1]
rename px yield
merge 1:1 date using "$code/cryptoprices.dta"
drop _merge
save "$code/cryptoprices.dta", replace
}



if "$econ_data_section" == "yes" {
import delimited "$data/bbg/us_cpi.csv", clear
merge 1:1 date using "$code/cryptoprices.dta"
drop if _merge == 1
drop _merge
gen r_cpi = cpi_actual[_n]/cpi_actual[_n-1] - 1
gen cpi_surp = cpi_actual - cpi_avg
gen cpi = 0
replace cpi = 1 if cpi_actual != .
egen cpi_cat = cut(cpi_surp), group(4) label
save "$code/cryptoprices.dta", replace


import delimited "$data/bbg/us_unemp.csv", clear
merge 1:1 date using "$code/cryptoprices.dta"
drop if _merge == 1
drop _merge
gen r_unemp = unemp_actual[_n]/unemp_actual[_n-1] - 1
gen unemp_surp = unemp_actual - unemp_avg
gen unemp = 0
replace unemp = 1 if unemp_actual != .
egen unemp_cat = cut(unemp_surp), group(4) label
save "$code/cryptoprices.dta", replace

}

if "$data_section" != "yes" {
use "$code/cryptoprices.dta", clear
}

gen px_ltc_btc = px_ltcbtc*1
gen px_ppc_btc = px_ppc*1
gen px_dash_btc = px_dash*1
gen px_doge_btc = px_doge*1
gen px_maid_btc = px_maid*1
gen px_xmr_btc = px_xmr*1
gen px_nxt_btc = px_nxt*1

replace px_ppc = px_ppc*px_btc
replace px_dash = px_dash*px_btc
replace px_doge = px_doge*px_btc
replace px_maid = px_maid*px_btc
replace px_xmr = px_xmr*px_btc
replace px_nxt = px_nxt*px_btc





gen log_px_btc = log(px_btc)
gen log_px_ltc = log(px_ltc)
gen log_px_ppc = log(px_ppc)
gen log_px_doge = log(px_doge)
gen log_px_dash = log(px_dash)
gen log_px_maid = log(px_maid)
gen log_px_xmr = log(px_xmr)
gen log_px_nxt = log(px_nxt)

split date, p("-")  destring
gen daystamp = mdy(date2, date3, date1)
format daystamp %td
drop date1 date2 date3


label var daystamp "Date"

gen dow = dow(daystamp)
sort date
drop if daystamp > mdy(9,9,2016)
gen d = 1
replace d = d[_n-1] + 1 if _n > 1

tsset d

gen unixtime = (daystamp - 3652)*24*60*60
format unixtime %13.0g



** RETURNS
gen r_btc = px_btc[_n]/px_btc[_n-1] - 1
gen r_ltc = px_ltc[_n]/px_ltc[_n-1] - 1
gen r_ppc = px_ppc[_n]/px_ppc[_n-1] - 1
gen r_doge = px_doge[_n]/px_doge[_n-1] - 1
gen r_dash = px_dash[_n]/px_dash[_n-1] - 1
gen r_maid = px_maid[_n]/px_maid[_n-1] - 1
gen r_xmr = px_xmr[_n]/px_xmr[_n-1] - 1
gen r_nxt = px_nxt[_n]/px_nxt[_n-1] - 1
gen r_crix = px_crix[_n]/px_crix[_n-1] - 1

gen r_ltc_btc = px_ltc_btc[_n]/px_ltc_btc[_n-1] - 1
gen r_ppc_btc = px_ppc_btc[_n]/px_ppc_btc[_n-1] - 1
gen r_doge_btc = px_doge_btc[_n]/px_doge_btc[_n-1] - 1
gen r_dash_btc = px_dash_btc[_n]/px_dash_btc[_n-1] - 1
gen r_maid_btc = px_maid_btc[_n]/px_maid_btc[_n-1] - 1
gen r_xmr_btc = px_xmr_btc[_n]/px_xmr_btc[_n-1] - 1
gen r_nxt_btc = px_nxt_btc[_n]/px_nxt_btc[_n-1] - 1


if "$pca_section" == "yes" {
log using "$output/pca_daily", text replace
eststo: pca r_btc r_ltc r_ppc r_doge r_dash r_maid r_xmr r_nxt
log close
*screeplot, yline(1) ci(het)
quietly loadingplot, ylabel(-1(0.2)1) xlabel(-0.5(0.1)0.5)
graph export "$graphs/pca_daily_loading.png", replace
predict pc1 pc2 pc3, score
}


** prices
drop if year(daystamp) < 2010
line log_px_btc log_px_ltc log_px_ppc log_px_doge log_px_dash log_px_maid  log_px_xmr log_px_nxt daystamp,  ytitle(Log Price)
graph export "$graphs/logPrices.png", replace

