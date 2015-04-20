BEGIN {
	FS=";";
}

(FNR==1) {
	#Start Date; End Date; ID; App Title; Quantity; Local Currency; Price; Total; Target Currency; Total (Target Currency); Withholding Taxes (Target Currency)
}

(FNR==2) {
	printf "Rechnungszeitraum: %s - %s \\\\\n", periodStart, periodEnd;
	print "\n\\begin{longtable}{|c|r|r|r|r|r|} \\hline";
	printf "Produkt ID & Preis & Stückzahl & Gesamtpreis & Gesamtpreis & Enthaltene Quellensteuer \\\\ \\hline \\hline\n";
}

(FNR>1) {
	printf "%s & %.2f %s & %i & %.2f %s & %.2f %s & %.2f %s \\\\ \\hline \n", $3, $7, $6, $5, $8, $6, $10, $9, $11, $9;
	totalTargetCurrency+=$10;
	totalWithholdingTax+=$11;
}

END {
	if (length(adRevenueTargetCurrency) != 0) {
		printf "Ad Revenue & & & %.2f USD & %.2f EUR & %.2f EUR \\\\ \\hline \n", adRevenueUsd, adRevenueTargetCurrency, adRevenueWithholdingTaxTargetCurrency;
		totalTargetCurrency += adRevenueTargetCurrency;
		totalWithholdingTax += adRevenueWithholdingTaxTargetCurrency;
	}
	roundedTotal=sprintf("%.2f", totalTargetCurrency);
	roundedTax=sprintf("%.2f", totalWithholdingTax);
	printf "\\hline & & & Gesamt & %.2f EUR & %.2f EUR \\\\ \\hline \n", totalTargetCurrency, totalWithholdingTax;
	print "\\end{longtable}";
	print "\n\n";
	printf "\\raggedleft \\textbf{Zu zahlender Betrag %.2f EUR}\n\n", roundedTotal-roundedTax;
}
