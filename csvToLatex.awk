BEGIN {
	FS=";";
}

(FNR==1) {
	#Start Date; End Date; ID; App Title; Quantity; Local Currency; Price; Total; Target Currency; Total (Target Currency)
}

(FNR==2) {
	split($1, start, "/");
	split($2, end, "/");
	printf "Rechnungszeitraum: %s-%02s-%02s - %s-%02s-%02s \\\\\n", start[3], start[2], start[1], end[3], end[2], end[1];
	print "\n\\begin{longtable}{|c|r|r|c|r|} \\hline";
	printf "Produkt ID & Preis & Stückzahl & Gesamtpreis & Gesamtpreis (%s) \\\\ \\hline \\hline\n", $9;
}

(FNR>1) {
	printf "%s & %.2f %s & %i & %.2f %s & %.2f %s \\\\ \\hline \n", $3, $7, $6, $5, $8, $6, $10, $9;
	totalTargetCurrency+=$10;
}

END {
	printf "\\hline & & & Gesamt & %.2f EUR \\\\ \\hline \n", totalTargetCurrency;
	print "\\end{longtable}"
}