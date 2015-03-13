@rem= 'PERL for Windows NT -- ccperl must be in search path 
@echo off 
ccperl %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 
goto endofperl 
@rem '; 

if ($ENV{TEMP}) 
{ 
$TDIR=$ENV{TEMP}; 
} 
else 
{ 
$TDIR="c:${S}temp"; 
} 

$S = "\\"; 
$LIST_VIEW_ONLY = $TDIR . $S . "list_view_only"; 
$LIST_SELECTED = $TDIR . $S . "list_selected"; 



sub do_del_file 
{ 
local($file_to_delete) = @_[0]; 
if (-e $file_to_delete) 
{ 
printf("del \"$file_to_delete\" \n"); 
$return = system("cmd /c del \"$file_to_delete\""); 
} 
} 

sub do_del_directory 
{ 
local($dir_to_delete) = @_[0]; 
printf("rmdir \/q \/s \"$dir_to_delete\" \n"); 
$return = system("cmd /c rmdir \/q \/s \"$dir_to_delete\""); 
} 

# Begin of Perl section 


printf("\n Start of the script \n\n"); 

if ($ARGV[0] eq "") 
{ 
printf("\n No directory specified, will use .\n"); 
$start_dir = "."; 
} 
else 
{ 
$start_dir = $ARGV[0]; 
} 

if (!(-d $start_dir)) 
{ 
printf("\n $start_dir is not a directory !!! \n"); 
exit 1; 
} 


system("cmd /c del $LIST_VIEW_ONLY 2> NUL"); 
printf("\n cleartool ls -recurse -view_only $start_dir \n"); 
chomp(@list_files = `cleartool ls -recurse -view_only $start_dir`); 
foreach $file (@list_files) 
{ 
if ( $file =~ /CHECKEDOUT/ ) 
{ 
$is_checkedout = $file; 
} 
else 
{ 
$is_checkedout = ""; 
} 
# printf("\n Processing $file : $is_checkedout \n"); 
if ("$is_checkedout" eq "") 
{ 
system("cmd /c echo $file, >> $LIST_VIEW_ONLY"); 
} 
} 

if (-e $LIST_VIEW_ONLY) 
{ 
$return = system("clearprompt list -outfile $LIST_SELECTED -dfile 
$LIST_VIEW_ONLY -choices -prompt \"Please choose files \/ directory to delete\""); 
} 
else 
{ 
$return = 512; 
} 

if ("$return" eq "0") 
{ 
open(LIST_ELEMENT,$LIST_SELECTED); 
while ($element=<LIST_ELEMENT>) 
{ 
chop $element; 
if (!("$element" eq "")) 
{ 
if (-d $element) 
{ 
#printf(" $element is a directory\n"); 
do_del_directory($element); 
} 
else 
{ 
#printf(" $element is a file\n"); 
do_del_file($element); 
} 
} 
} 
close(LIST_ELEMENT); 
} 

system("cmd /c del $LIST_VIEW_ONLY 2> NUL"); 
system("cmd /c del $LIST_SELECTED 2> NUL"); 


printf("\n End of the script \n"); 


# End of Perl section 

__END__ 
:endofperl