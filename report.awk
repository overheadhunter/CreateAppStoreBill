function unquote(input) {
	gsub("\"", "", input);
	return input;
}

BEGIN {
	FS=",";
  sum = 0;
  targetCurrency = "";
}

# first line
match($0, /iTunes Connect - Payments and Financial Reports/){

  strContainingPeriod = unquote($0);
  periodParanthesisOpen = index(strContainingPeriod, "(");
  periodParanthesisClose = index(strContainingPeriod, ")");
  period = substr(strContainingPeriod, periodParanthesisOpen + 1, periodParanthesisClose - periodParanthesisOpen - 1);
  printf "Rechnungszeitraum: %s \\\\\n", period;
  print "\n\\begin{longtable}{|l|r|r|r|r|} \\hline";
  printf "Region oder Typ & Stückzahl & Gesamtpreis & Quellensteuern und Abgaben & Gesamtpreis \\\\ \\hline \\hline\n";
}

match($3, /\"[0-9]*\.[0-9]+\"/) {
  regionOrType = unquote($1);
  localCurrency = substr(regionOrType, index(regionOrType, "(") + 1, 3);
  targetCurrency = unquote($11);
  printf "%s & %i & %.2f %s & %.2f %s & %.2f %s \\\\ \\hline \n", regionOrType, unquote($2), unquote($4), localCurrency, unquote($5) + unquote($6) + unquote($7), localCurrency, unquote($10), targetCurrency;
  sum += unquote($10);
}

END {
	print "\\end{longtable}";
	print "\n\n";
  printf "\\begin{flushright} \\textbf{Zu zahlender Betrag %.2f %s} \\end{flushright} \n\n", sum, targetCurrency;
}
