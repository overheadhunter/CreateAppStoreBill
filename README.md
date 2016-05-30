## Generate Bills from Apples Financial Reports
Apple generates financial reports in txt format. The German tax office wants to see the bills. This script helps to generate the bills from the financial reports.

## What you need
You need pdflatex on your machine. And you should be able to edit LaTeX files because you have to add your address in the head.tex file.

## How it works

- Create a directory for each month.
- Save all financial reports from iTunes Connect to the corrsponding directory.
- Download the exchange rate table from "Payments & Financial Reports > Payments" which is a file called `financial_report.csv` in the same directory.
- Adjust your adress in head.tex using your favourite text editor.
- Run `report.sh -r directoryName/financial_report.csv`.

Done.

### Example factors.txt

```
"iTunes Connect - Payments and Financial Reports	(July, 2015)",,,,,,,,,,,,
,,,,,,,,,,,,
Region (Currency),Units Sold,Earned,Pre-Tax Subtotal,Input Tax,Adjustments,Withholding Tax,Total Owed,Exchange Rate,Proceeds,Bank Account Currency,
Australia (AUD),"2","2.40","2.40","0","0","0","2.40","0.63333","1.52","EUR",
Canada (CAD),"1","1.60","1.60","0","0","0","1.60","0.66875","1.07","EUR",
China (CNY),"1","8.40","8.40","0","0","0","8.40","0.13690","1.15","EUR",
Euro-Zone (EUR),"9","9.22","9.22","0","0","0","9.22","1.00000","9.22","EUR",
United Kingdom (GBP),"8","6.55","6.55","0","0","0","6.55","1.36031","8.91","EUR",
Norway (NOK),"1","10.64","10.64","0","0","0","10.64","0.10714","1.14","EUR",
Sweden (SEK),"1","10.64","10.64","0","0","0","10.64","0.10526","1.12","EUR",
Americas (USD),"20","25.20","25.20","0","0","0","25.20","0.88452","22.29","EUR",
,,,,,,,,,,,,
,,,,,,,,,,"46.42" EUR,,
,,,,,,,,,,Paid to FANTASY BANK-****1234,,
,,,,,,,,,,,,
,,,,,,,,,,,,

```

### Further script options
This is the easiest way to use the script. Just point it to the `financial_report.csv`:
``` bash
$ cd ~/Documents/financial_reports
$ bash summarize.sh -r 2015-10/financial_report.csv
```

Specify output file:
``` bash
$ bash summarize.sh -r 2015-10/financial_report.csv -o 2015-10.pdf
```

## Important Note
Use this at your own risk. I am not responsible for any lost data on your machine. The script removes temporary files after it ran. Therefore you should create a directory for your financial reports and run the script in that directory.

To create the bills for the tax office with this script works for me. Before you submit the bills check with your tax consultant! I am not responsible for any problems you have with your tax office because of this script.

## Credits

Thanks to [dasdom](https://github.com/dasdom/CreateAppStoreBill) for the original Perl script.
