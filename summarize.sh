#!/bin/bash

latexCheck=`which pdflatex`
if [ $? -ne 0 ]; then
	echo "pdflatex cannot be found. Is LaTeX installed?"
	echo "\$PATH="$PATH
	exit 1
fi


function usage {
	echo "usage: summarize.sh -r financialReportsDir [-o output.pdf] [-f financialReportsDir/factors.txt] [-i 123456789,123456790] [-e 123456789,123456790]"
	echo "-r --reports Path to reports directory, where you downloaded the .txt reports for a certain accounting period."
	echo "-o --output Path to which the resulting PDF should be saved. Defaults to 'report.pdf' inside of the directory specified in -r."
	echo "-f --factors Name of the currency exchange factors.txt relative to -r. Defaults to 'factors.txt'"
	echo "-a --adrevenue Name of the adrevenue.txt relative to -r. Defaults to 'adrevenue.txt'"
	echo "-i --include Comma-separated list of App IDs to be included in the bill. All apps included by default."
	echo "-e --exclude Comma-separated list of App IDs to be excluded from the bill. No exclusions by default. Ignored if -i is specified"
}

function summarize {
	# Create tmp working directory
	tmpDir=`mktemp -d appStoreBill.XXX`
	if [ $? -ne 0 ]; then
		echo "Can't create temp directory, exiting..."
		exit 1
	fi

	# Process iTunes Connect files
	echo "Start Date;End Date;ID;App Title;Quantity;Local Currency;Price;Total;Target Currency;Total (Target Currency); Withholding Taxes (Target Currency)" > "$tmpDir/summary.csv";
	reports=`ls -1 $reportsDir | grep .txt`
	for report in $reports; do
		LC_NUMERIC="C" awk -f summarize.awk "$reportsDir/$factorsFile" "$reportsDir/$report" >> "$tmpDir/summary.csv"
	done
	LC_NUMERIC="C" awk -f filter.awk -v include=$include -v exclude=$exclude "$tmpDir/summary.csv" > "$tmpDir/filtered.csv"
	firstStartDate=`sort --numeric-sort --field-separator=';' --key=1 "$tmpDir/filtered.csv" | head -2 | tail -1 | awk -F ';' '{print $1}'`
	lastEndDate=`sort --numeric-sort --field-separator=';' --key=1 "$tmpDir/filtered.csv" | tail -1 | awk -F ';' '{print $2}'`
	if [ -r "$reportsDir/$adrevenueFile" ]; then
		adRevenueUsd=`awk '{print $4}' "$reportsDir/$adrevenueFile"`
		adRevenueWithholdingTaxTargetCurrency=`awk '{print $5 * $9}' "$reportsDir/$adrevenueFile"`
		adRevenueTargetCurrency=`awk '{print $10}' "$reportsDir/$adrevenueFile"`
		LC_NUMERIC="C" awk -f csvToLatex.awk -v periodStart=$firstStartDate -v periodEnd=$lastEndDate -v adRevenueUsd=$adRevenueUsd -v adRevenueTargetCurrency=$adRevenueTargetCurrency -v adRevenueWithholdingTaxTargetCurrency=$adRevenueWithholdingTaxTargetCurrency "$tmpDir/filtered.csv" > "$tmpDir/table.tex"
	else
		LC_NUMERIC="C" awk -f csvToLatex.awk -v periodStart=$firstStartDate -v periodEnd=$lastEndDate "$tmpDir/filtered.csv" > "$tmpDir/table.tex"
	fi

	# LaTeX Power
	cat "head.tex" > "$tmpDir/result.tex"
	cat "$tmpDir/table.tex" >> "$tmpDir/result.tex"
	cat "tail.tex" >> "$tmpDir/result.tex"
	pdflatex -output-directory "$tmpDir" "$tmpDir/result.tex" 2>&1 >/dev/null
	pdflatex -output-directory "$tmpDir" "$tmpDir/result.tex" 2>&1 >/dev/null

	# move result.pdf to target
	if [ -f "$tmpDir/result.pdf" ]; then
	    mv "$tmpDir/result.pdf" "$reportsDir/$outputFile"
	fi

	# comment the following line for easy debugging
	rm -rf $tmpDir
}


while [ "$1" != "" ]; do
    case $1 in
        -r | --reports )        shift
								reportsDir=$1
								;;
        -o | --output )			shift
								outputFile=$1
								;;
        -f | --factors )		shift
								factorsFile=$1
								;;
				-a | --adrevenue )		shift
								adrevenueFile=$1
								;;
        -i | --include )		shift
								include=$1
								;;
        -e | --exclude )		shift
								exclude=$1
								;;
        -h | --help | --rtfm )	usage
								exit
								;;
        * )                     usage
								exit 1
    esac
    shift
done

if [ -z "$factorsFile" ]; then
	factorsFile="factors.txt"
fi

if [ -z "$adrevenueFile" ]; then
	adrevenueFile="adrevenue.txt"
fi

if [ -z "$outputFile" ]; then
	outputFile="report.pdf"
fi

if [ -z "$reportsDir" ]; then
	usage
	exit 1
elif [ -d "$reportsDir" ] && [ -r "$reportsDir/$factorsFile" ]; then
	summarize
elif [ ! -d "$reportsDir" ]; then
	echo "$reportsDir is not a directory"
	exit 1
elif [ ! -r "$reportsDir/$factorsFile" ]; then
	echo "can't read currency conversion factors file '$reportsDir/$factorsFile'"
	exit 1
fi
