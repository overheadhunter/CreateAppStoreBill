#!/bin/bash

latexCheck=`which pdflatex`
if [ $? -ne 0 ]; then
	echo "pdflatex cannot be found. Is LaTeX installed?"
	echo "\$PATH="$PATH
	exit 1
fi


function usage {
	echo "usage: report.sh -r financialReport.csv [-o output.pdf]"
	echo "-r --reports Path to reports file obtained from Apple."
	echo "-o --output Path to which the resulting PDF should be saved. Defaults to 'report.pdf' inside of the directory specified in -r."
}

function report {
	# Create tmp working directory
	tmpDir=`mktemp -d appStoreBill.XXX`
	if [ $? -ne 0 ]; then
		echo "Can't create temp directory, exiting..."
		exit 1
	fi

	# Process iTunes Connect files
	LC_NUMERIC="C" awk -f report.awk $reportsFile > "$tmpDir/table.tex"

	# LaTeX Power
	cat "head.tex" > "$tmpDir/result.tex"
	cat "$tmpDir/table.tex" >> "$tmpDir/result.tex"
	cat "tail.tex" >> "$tmpDir/result.tex"
	pdflatex -output-directory "$tmpDir" "$tmpDir/result.tex" 2>&1 >/dev/null
	pdflatex -output-directory "$tmpDir" "$tmpDir/result.tex" 2>&1 >/dev/null

	# move result.pdf to target
	if [ -f "$tmpDir/result.pdf" ]; then
    reportsDir=`dirname $reportsFile`
    mv "$tmpDir/result.pdf" "$reportsDir/$outputFile"
	fi

	# comment the following line for easy debugging
	rm -rf $tmpDir
}


while [ "$1" != "" ]; do
    case $1 in
        -r | --reports )        shift
								reportsFile=$1
								;;
        -o | --output )			shift
								outputFile=$1
								;;
        * )                     usage
								exit 1
    esac
    shift
done

if [ -z "$outputFile" ]; then
	outputFile="report.pdf"
fi

if [ -z "$reportsFile" ]; then
	usage
	exit 1
else
  report
fi
