## Generate Bills from Apples Financial Reports
Apple generates financial reports in txt format. The German tax office wants to see the bills. This script helps to generate the bills from the financial reports.

## What you need
You need pdflatex on your machine. And you should be able to edit LaTeX files because you have to add your address in the head.tex file.

## How it works

- Create a directory for each month.
- Save all financial reports from iTunes Connect to the corrsponding directory.
- Copy/Paste the exchange rates from "Payments & Financial Reports > Payments" to a file called `factors.txt` in the same directory.
- Adjust your adress in head.tex using your favourite text editor.
- Run `summarize.sh -r directoryName`.

Done.

### Example factors.txt

```
AUD      0.00    13.97   13.97   0.00    0.00    0.00    13.97   0.77022         10.76  EUR
CHF      0.00    33.15   33.15   0.00    0.00    0.00    33.15   0.80030         26.53  EUR
DKK      0.00    23.73   23.73   0.00    0.00    0.00    23.73   0.13359         3.17   EUR
EUR      0.00    247.84  247.84  0.00    0.00    0.00    247.84  1.00000         247.84 EUR
GBP      0.00    4.55    4.55    0.00    0.00    0.00    4.55    1.16484         5.30   EUR
INR      0.00    77.00   77.00   0.00    0.00    0.00    77.00   0.01351         1.04   EUR
JPY      0       179     179     -37     0       0       142     0.00817         1.16   EUR
MXN      0.00    18.20   18.20   0.00    0.00    0.00    18.20   0.05824         1.06   EUR
NOK      0.00    7.84    7.84    0.00    0.00    0.00    7.84    0.13393         1.05   EUR
NZD      0.00    1.81    1.81    0.00    0.00    0.00    1.81    0.61326         1.11   EUR
RUB      0.00    138.60  138.60  0.00    0.00    0.00    138.60  0.02395         3.32   EUR
SEK      0.00    4.26    4.26    0.00    0.00    0.00    4.26    0.11502         0.49   EUR
SGD      0.00    1.81    1.81    0.00    0.00    0.00    1.81    0.60221         1.09   EUR
USD      0.00    58.10   58.10   0.00    0.00    0.00    58.10   0.74200         43.11  EUR
ZAR      0.00    11.19   11.19   0.00    0.00    0.00    11.19   0.08311         0.93   EUR
```

### Further script options
This is the easiest way to use the script. Just specify the financial reports folder:
``` bash
$ cd ~/Documents/financial_reports
$ bash summarize.sh -r 1212
```

Specify output file:
``` bash
$ bash summarize.sh -r 1212 -o 2012-12.pdf
```

Specify the name of your exchange rates file (relative to your reports directory specified by -r):
``` bash
$ bash summarize.sh -r 1212 -f imfRates.txt
```

Filter the apps, you want to appear on the bill:
``` bash
$ bash summarize.sh -r 1212 --include 123456789,123456790
$ bash summarize.sh -r 1212 --exclude 123456791,123456792
```

## Important Note
Use this at your own risk. I am not responsible for any lost data on your machine. The script removes temporary files after it ran. Therefore you should create a directory for your financial reports and run the script in that directory.

To create the bills for the tax office with this script works for me. Before you submit the bills check with your tax consultant! I am not responsible for any problems you have with your tax office because of this script.

## Credits
Thanks to [dasdom](dasdom/CreateAppStoreBill) for the original Perl script.