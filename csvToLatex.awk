BEGIN {
	FS=";";
}

(FNR==1) {
	#Start Date; End Date; ID; App Title; Quantity; Local Currency; Price; Total; Target Currency; Total (Target Currency); Withholding Taxes (Target Currency)
}

(FNR==2) {
	split($1, start, "/");
	split($2, end, "/");
	printf "Rechnungszeitraum: %s-%02s-%02s - %s-%02s-%02s \\\\\n", start[3], start[2], start[1], end[3], end[2], end[1];
	print "\n\\begin{longtable}{|c|r|r|r|r|r|} \\hline";
	printf "Produkt ID & Preis & Stückzahl & Gesamtpreis & Gesamtpreis & Enthaltene Quellensteuer \\\\ \\hline \\hline\n";
}

(FNR>1) {
	printf "%s & %.2f %s & %i & %.2f %s & %.2f %s & %.2f %s \\\\ \\hline \n", $3, $7, $6, $5, $8, $6, $10, $9, $11, $9;
	totalTargetCurrency+=$10;
	totalWithholdingTax+=$11;
}

END {
	printf "\\hline & & & Gesamt & %.2f EUR & %.2f EUR \\\\ \\hline \n", totalTargetCurrency, totalWithholdingTax;
	print "\\end{longtable}\n";
	printf "Zu zahlender Betrag: \\textbf{%.2f EUR}\n\n", totalTargetCurrency-totalWithholdingTax;
}