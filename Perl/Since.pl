#!/usr/local/bin/perl 

# Determine the number of days since a certain date 
# or between two dates. 
# It will return a -1 if there is something wrong with 
# your input values. 

# 1.0 11/23/1998 Eric J. Ostrander Created. 
# 1.1 09/19/1999 Eric J. Ostrander Modified to calculate days between any two 
# arbitrary dates. 

# Predefinitions. 
@months = split(/ +/,"Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"); 
@mlength = split(/ +/,"31 28 31 30 31 30 31 31 30 31 30 31 "); 

# Are there the correct number of arguments? 
if ( scalar(@ARGV) != 3 && scalar(@ARGV) != 6 ) { 
print "Usage: since month day year [ month day year ]\n"; 
print " since from-date to-date\n"; 
print " ex: since Apr 15 1962 Sep 30 1963\n"; 
print "If to-date is omitted, today's date is assumed.\n"; 
exit; 
} 

# What is the from-date? 
$req_month = $ARGV[0]; 
$req_day = $ARGV[1]; 
$req_year = $ARGV[2]; 

# What is the to-date? 
if ( scalar(@ARGV) == 6 ) { 
$month = $ARGV[3]; 
$day = $ARGV[4]; 
$year = $ARGV[5]; 
} else { 
($x,$month,$day,$x,$year) = split(/ /,localtime(time)); 
} 

# Is the requested date valid? 
$bad = 1; 
$i = 0; 
foreach $mon (<@months> ) { 
if ( "$req_month" eq "$mon" ) { $req_ind = $i; $bad = 0 } 
if ( "$month" eq "$mon" ) { $mon_ind = $i } 
$i = $i + 1; 
} 
if ( $req_day > $mlength[$req_ind] || $req_year > $year ) { $bad = 1; } 
if ( $req_year == $year && $req_ind >= $mon_ind && $req_day > $day ) { $bad = 1; } 
if ( $bad == 1 ) { print "-1\n"; exit; } 

# Calculate days from Jan. 1, $req_year to today's date. 
CALC_DAYS(); 
$to_days = $days; 

# Calculate days from Jan. 1, $req_year to requested date. 
$month = $req_month; 
$day = $req_day; 
$year = $req_year; 
CALC_DAYS(); 
$from_days = $days; 

# Subtract the two. 
print $to_days - $from_days . "\n"; 

# The iteration subroutine. 
sub CALC_DAYS { 
$yr = $req_year; 
$days = 0; 
ITERATION: while (1) { 
$i = 0; 
$lpyr = 0; 
if ( $yr/4 == int($yr/4) && $yr != 2000 ) { $lpyr = 1; } 
foreach $mon (<@months>) { 
if ( "$mon" eq "$month" && $yr == $year ) { 
$days = $days + $day; 
last ITERATION; 
} else { 
$days = $days + @mlength[$i]; 
if ( "$mon" eq "Feb" ) { $days = $days + $lpyr; } 
} 
$i = $i + 1; 
} 
$yr = $yr + 1; 
} 
} 

exit;