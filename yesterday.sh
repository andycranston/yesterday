#!/bin/bash
#
# @(#) yesterday.sh, sversion 0.1.0, fversion 002, 02-may-2025
#
# a script to print out yesterdays date in a year, month and day format
#

set -u

# --------------------------------------------------------------------------------------------------------------------------------

daysinmonth()
{
  year=$1
  month=$2

  # run the ncal command for a given year and month and display the last number output which will be the no. of days in that month
  echo `ncal -h -b $month $year | grep '[0-9]' | tail -n 1 | awk '{ print $NF }'`
}

# --------------------------------------------------------------------------------------------------------------------------------

#
# Main
#

PATH=/bin:/usr/bin
export PATH

scriptname=`basename $0`

if [ ! -x /usr/bin/ncal ]
then
  echo "$scriptname: the ncal command cannot be found - consider running \"sudo apt install ncal\" or similar" 1>&2
  exit 1
fi

if [ $# -eq 3 ]
then
  year=$1             ; month=$2             ; day=$3
else
  year=`date '+%Y'`   ; month=`date '+%m'`   ; day=`date '+%d'`
fi

if [ $day -gt 1 ]
then
  day=`expr $day - 1`
else
  if [ $month -gt 1 ]
  then
    month=`expr $month - 1`
  else
    month=12
    year=`expr $year - 1`
  fi

  day=`daysinmonth $year $month`
fi

# using expr gets rid of any leaving zeros in the output
echo `expr $year - 0` `expr $month - 0` `expr $day - 0`

exit 0

# end of file: yesterday.sh
