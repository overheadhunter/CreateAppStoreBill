function unquote(input) {
	gsub("\"", "", input);
	return input;
}

BEGIN {
	FS=",";
  sum = 0;
}

# first line
(NR == 1) {
  strContainingPeriod = unquote($0);
  periodParanthesisOpen = index(strContainingPeriod, "(");
  periodParanthesisClose = index(strContainingPeriod, ")");
  period = substr(strContainingPeriod, periodParanthesisOpen + 1, periodParanthesisClose - periodParanthesisOpen - 1);
  printf "Rechnungszeitraum: %s \\\\\n", period;
  print "\n\\begin{longtable}{|l|r|r|r|r|} \\hline";
  printf "Region oder Typ & Stückzahl & Gesamtpreis & Quellensteuern und Abgaben & Gesamtpreis \\\\ \\hline \\hline\n";
}

# column labels
(NR == 3) {
	for (i = 1; i <= NF; i++) {
		col[$i] = i;
	}
}

(NR > 3) {
	unitsSold = unquote($col["Units Sold"]);
	if (length(unitsSold) > 0) {
	  regionOrType = unquote($col["Region (Currency)"]);
	  localCurrency = substr(regionOrType, index(regionOrType, "(") + 1, 3);
		earned = unquote($col["Earned"]);
		inputTax = unquote($col["Input Tax"]);
		adjustments = unquote($col["Adjustments"]);
		withholdingTax = unquote($col["Withholding Tax"]);
		taxTotal = inputTax + adjustments + withholdingTax;
		proceeds = unquote($col["Proceeds"]);
		targetCurrency = unquote($col["Bank Account Currency"]);
	  printf "%s & %s & %.2f %s & %.2f %s & %.2f %s \\\\ \\hline \n", regionOrType, unitsSold, earned, localCurrency, taxTotal, localCurrency, proceeds, targetCurrency;
	  sum += proceeds;
	}
}

END {
	print "\\end{longtable}";
	print "\n\n";
  printf "\\begin{flushright} \\textbf{Zu zahlender Betrag %.2f %s} \\end{flushright} \n\n", sum, targetCurrency;
}
