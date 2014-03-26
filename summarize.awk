function abs(value) {
	return (value<0 ? -value : value);
}

function parseNum(input) {
	gsub(",", "", input);
	return input;
}

BEGIN {
	FS="\t";
	wellFormatted=0;
}

# first file
(FNR==NR) {
	exchangeRates[$1]=parseNum($9);
	withholdingTaxes[$1]=abs(parseNum($5)/parseNum($4));
	targetCurrency=$11;
}

# further files
# well formatted financial report file has 22 fields and begins at FNR 2
# skip free downloads ($7==0)
(FNR!=NR && FNR>1 && NF==22 && $7>0) {
	wellFormatted=1;
	
	# we want ISO 8601
	split($1, startDateComps, "/");
	split($2, endDateComps, "/");
	startDate=sprintf("%s-%02s-%02s", startDateComps[3], startDateComps[1], startDateComps[2]);
	endDate=sprintf("%s-%02s-%02s", endDateComps[3], endDateComps[1], endDateComps[2]);
	quantity=parseNum($6);
	subtotal=parseNum($8);
	currency=parseNum($9);
	convertedSubtotal=exchangeRates[$9] * $8;
	
	criteria=$11 "#" $7;
	rowIds[criteria]=criteria;
	appIds[criteria]=$11;
	appTitles[criteria]=$13;
	pricePerUnit[criteria]=parseNum($7);
	sumQuantity[criteria]+=quantity;
	sumTotal[criteria]+=subtotal;
	sumConvertedTotal[criteria]+=convertedSubtotal;
	sumWithholdingTaxes[criteria]=withholdingTaxes[$9] * sumConvertedTotal[criteria];
}

END {
	#Start Date; End Date; ID; App Title; Quantity; Local Currency; Price; Total; Target Currency; Total (Target Currency); Withholding Taxes (Target Currency)
	if (wellFormatted == 1) {
		for (criteria in rowIds) {
			printf "%s;%s;%s;%s;%i;%s;%.7f;%.7f;%s;%.7f;%.7f\n", startDate, endDate, appIds[criteria], appTitles[criteria], sumQuantity[criteria], currency, pricePerUnit[criteria], sumTotal[criteria], targetCurrency, sumConvertedTotal[criteria], sumWithholdingTaxes[criteria];
		}
	}
}