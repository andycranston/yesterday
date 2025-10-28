#!/bin/bash
#
# @(!--#) @(#) yesterday_v2.sh, sversion 0.1.0, fversion 002, 28-october-2025
#
# a script to print out yesterdays date in a year, month and day format
#
# gracefully handles the "oddness" of the year September 1752 run:
#
#    ncal 9 1742
#
# to see the oddness for yourself :-]
#
# Links:
#     https://www.geeksforgeeks.org/linux-unix/how-to-check-if-a-variable-is-a-number-in-bash/
#

set -u

# -----------------------------------------------------------------------------------------------

validnumber()
{
  number="$1"
  description="$2"

  if [ "$number" == "" ]
  then
    echo "$scriptname: $description is the null string" 1>&2
    exit 1
  elif [[ $number =~ ^[0-9]+$ ]]
  then
    true
  else
    echo "$scriptname: $description \"$number\" is not a positive integer" 1>&2
    exit 1
  fi
}

# -----------------------------------------------------------------------------------------------

PATH=/bin:/usr/bin
export PATH

scriptname=`basename $0`

if [ ! -x /usr/bin/ncal ]
then
  echo "$scriptname: the ncal command cannot be found - consider running \"sudo apt install ncal\" or similar" 1>&2
  exit 1
fi

if [ $# -eq 0 ]
then
  year=`date '+%Y'`
  month=`date '+%m'`
  day=`date '+%d'`
elif [ $# -eq 3 ]
then
  validnumber "$1" year
  validnumber "$2" month
  validnumber "$3" day

  year=`expr $1 + 0`
  month=`expr $2 + 0`
  day=`expr $3 + 0`
else
  echo "$scriptname: usage: $scriptname year month day" 1>&2
  exit 1
fi

if [ $year -lt 1 ]
then
  echo "$scriptname: year $year cannot be less than 1" 1>&2
  exit 1
fi

if [ $year -gt 9999 ]
then
  echo "$scriptname: year $year cannot be greater than 9999" 1>&2
  exit 1
fi

if [ $month -lt 1 ]
then
  echo "$scriptname: month $month cannot be less than 1" 1>&2
  exit 1
fi

if [ $month -gt 12 ]
then
  echo "$scriptname: month $month cannot be greater than 12" 1>&2
  exit 1
fi

# produce a space separated list of the days of the month
daylist=" `ncal -h $month $year | fmt -1 | grep '^[0-9]' | sort -n | tr '\n' ' '` "

echo " $daylist " | grep " $day " >/dev/null

if [ $? -eq 1 ]
then
  echo "$scriptname: day $day is not a valid day in the month $month in $year" 1>&2
  exit 1
fi

prev=""

# loop through all the days of the month
for d in `ncal -h $month $year | fmt -1 | grep '^[0-9]' | sort -n`
do
  if [ "$d" = "$day" ]
  then
    break
  fi

  prev=$d
done

if [ "$prev" != "" ]
then
  # if we have a previous day going back one day is easy
  day=$prev
else
  # its the first day of the month - more logic required
  month=`expr $month - 1`

  if [ $month -eq 0 ]
  then
    month=12
    year=`expr $year - 1`

    if [ $year -eq 0 ]
    then
      echo "$scriptname: cannot go from year 1 back to year 0" 1>&2
      exit 1
    fi
  fi

  # get the last day of the month
  day=`ncal -h $month $year | fmt -1 | grep '^[0-9]' | sort -n | tail -n 1`
fi

# output the result and exit success
echo "$year $month $day"

exit 0

# end of file: yesterday_v2.sh
