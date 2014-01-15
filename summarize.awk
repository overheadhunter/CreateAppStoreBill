BEGIN {
	FS="\t";
	wellFormatted=0;
}

# first file
(FNR==NR) {
	exchangeRates[$1]=$9;
	targetCurrency=$11;
}

# further files
# well formatted financial report file has 22 fields and begins at FNR 2
# skip free downloads ($7==0)
(FNR!=NR && FNR>1 && NF==22 && $7>0) {
	wellFormatted=1;
	
	startDate=$1;
	endDate=$2;
	quantity=$6;
	subtotal=$8;
	currency=$9;
	convertedSubtotal=exchangeRates[$9] * $8;
	
	criteria=$11 "#" $7;
	rowIds[criteria]=criteria;
	appIds[criteria]=$11;
	appTitles[criteria]=$13;
	pricePerUnit[criteria]=$7;
	sumQuantity[criteria]+=quantity;
	sumTotal[criteria]+=subtotal;
	sumConvertedTotal[criteria]+=convertedSubtotal;
}

END {
	#Start Date; End Date; ID; App Title; Quantity; Local Currency; Price; Total; Target Currency; Total (Target Currency)
	if (wellFormatted == 1) {
		for (criteria in rowIds) {
			printf "%s;%s;%s;%s;%i;%s;%.2f;%.2f;%s;%.2f\n", startDate, endDate, appIds[criteria], appTitles[criteria], sumQuantity[criteria], currency, pricePerUnit[criteria], sumTotal[criteria], targetCurrency, sumConvertedTotal[criteria];
		}
	}
}