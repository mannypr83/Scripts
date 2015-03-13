@rem= 'PERL for Windows NT -- ccperl must be in search path 
@echo off 
ccperl %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 
goto endofperl 
@rem '; 


# 
# Views last accessed since 30 days... 
# 

$days = 30; 

# 
# ---------------------------- 
# 

if ($ENV{TEMP}) 
{ 
$TDIR=$ENV{TEMP}; 
} 
else 
{ 
$TDIR="c:${S}temp"; 
} 

$S = "\\"; 
$JUNK = $TDIR . $S . "junk"; 
$NULL = $TDIR . $S . "null"; 


# Begin of Perl section 

printf("Start of the script...\n"); 


if ($ARGV[0] eq "") 
{ 
printf "\n No user specify, please give one !!! \n"; 
exit 1; 
} 

$search_user = $ARGV[0]; 


printf("Searching for all views that hasn't been accessed since $days days for 
$search_user \n"); 
chomp(@views = `cleartool lsview -s | findstr $search_user`); 



foreach $viewtag (@views) 
{ 
printf("Processing $viewtag: "); 

# Determine the last accessed date and owner for the view. 
chomp(@properties = `cleartool lsview -properties -full $viewtag`); 
foreach $property (@properties) 
{ 
$accessed_line = $property if ( $property =~ /^Last accessed / ); 
$owner_line = $property if ( $property =~ /^Owner: / ); 
} 

$last_accessed = (split(/\./,(split(/ +/,$accessed_line))[2]))[0]; 
($view_day,$view_month,$view_year) = split(/-/,$last_accessed); 
$owner = (split(/\\/,(split(/ +/,$owner_line))[1]))[1]; 

# Build the view's date string for use with the since.pl script. 
if ( $view_year > 80 ) 
{ 
$view_year = "19$view_year"; 
} 
else 
{ 
$view_year = "20$view_year"; 
} 

$view_date = "$view_month $view_day $view_year"; 

# Find out how long ago the view was last accessed. If greater 
# than the specified number of days, print out the data. 
$diff_days = `ccperl .\\since.pl $view_date $now_date`; 
if ( $diff_days > $days ) 
{ 
printf("$owner $last_accessed\n"); 
printf("\t Sending notification for view $viewtag to $owner \n"); 
system("cmd /c del $JUNK 2> $NULL"); 
system("echo . 
> $JUNK"); 
system("echo Hello, $owner... 
>> $JUNK"); 
system("echo . 
>> $JUNK"); 
system("echo Your view $viewtag hasnt been used since $days days !!! 
>> $JUNK"); 
system("echo . 
>> $JUNK"); 
system("echo Please check if you still need this view... >> 
$JUNK"); 
system("echo . 
>> $JUNK"); 
system("echo If not, please delete it ! 
>> $JUNK"); 
system("echo . 
>> $JUNK"); 
system("echo If not done/used in the next 30 days, it will be 
>> $JUNK"); 
system("echo automatically deleted without notice >> 
$JUNK"); 
system("echo . 
>> $JUNK"); 
system("echo S. Aeschbacher and D. Diebolt 
>> $JUNK"); 
system("echo . 
>> $JUNK"); 

system("notify -s \"View $viewtag...\" -f $JUNK $owner\@rational.com"); 
system("notify -s \"View $viewtag...\" -f $JUNK ddiebolt\@rational.com"); 

push(@old_views,"$viewtag"); 
} 
else 
{ 
printf("\n"); 
} 
} 

printf("End of the script...\n"); 


# End of Perl section 

__END__ 
:endofperl