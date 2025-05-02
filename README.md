# A shell script to display yesterdays date

The `yesterday.sh` shell script is a small bash script which, by default, determines todays date and then moves it back
one day to get yesterdays date.

Most of the logic is quite obvious but the edge case of todays date being 1st March needs to be handled gracefully as yesterdays date will be
29th February on a leap year and 28th February on "normal" years. The function `daysinmonth` uses the `ncal` command to work out how may days are
in a given month in a given year.

## Pre-requisites

The `ncal` command must be installed.

If running:

```
which ncal
```

does not output the full pathname of the ncal command (e.g. `/bin/ncal` or `/usr/bin/ncal`) then install the ncal package.

For Ubuntu/Debian style systems this will be:

```
sudo apt install ncal
```

Other Linux variants will have a different package (such as `yum` or `dnf`) - refer to your Linux distribution documentation.

## Example run

Running:

```
./yesterday.sh
```

on the 2nd of May 2025 will result in the following line of output:

```
2025 5 1
```

## Command line arguments

If three command line arguments are given they are used as the year, month and day of the month so running:

```
./yesterday.sh 2025 3 1
```

which is the 1st March 2025 will result in this output:

```
2025 2 28
```

Changing the year to 2024 and running:


```
./yesterday.sh 2024 3 1
```

gives:

```
2024 2 29
```

as 2024 was a leap year and so there were 29 days in February that year.

## Bugs

The main bug is that if the year 1752 is involved then incorrect results are likely - especially around dates in September 1752.

If you run:

```
ncal 9 1752
```

The output will be:

```
    September 1752
Mo    18 25
Tu  1 19 26
We  2 20 27
Th 14 21 28
Fr 15 22 29
Sa 16 23 30
Su 17 24
```

The days 3rd September to 13th September 1752 inclusive are missing. The script logic in `yesterday.sh` does not handle this "strangeness". I welcome suggestions on
how to make the script handle this date range correctly :-]



## Nice example of a shell script in general

This shell script is, in my humble opinion, a nice example containing content and formatting I think are good things to see in shell scripts in general.

They are:

First line using the "hash-pling" notation to explicity set which shell command to use to interpret/run the script.

A comment line with versioning information including the filename and date the file was last modified.

A comment or two at the top of the script giving a brief summary of what the script is for/what the script does.

Using the set -u option so the script will fail if an undefined shell variable is referenced.

A horizontal ruler style of comment to separate individual functions and the main body of the script.

Comments to explain the less obvious lines of code - for example the ncal pipeline in the daysinmonth function.

A comment indicating where the main body of the script begins.

Fix a static PATH. In this case just the /bin and /usr/bin directories are searched for commands.

Set a variable name such as scriptname to hold the name of the script so it can be used in error messages.

Send error messages to standard error using echo and the 1>&2 syntax - include the script name in the error message.

Exit with a non-zero return code when an error has occurred.

Exit with a return code of zero if/when the script completes successfully.

Make the last line of the script a comment of the form "end of file" with the filename of the script - this shows the script has not been partially copied.


----------------
End of README.md
