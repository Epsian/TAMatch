@echo off
title TA Matching Process

echo:
echo This code will calculate the best match between
echo TA course rankings and instructor TA rankings.
echo:
echo You need to first download the ranking files
echo from the google forms that were sent out to the
echo department. Make sure you download these files
echo in a '.csv' format. Others will not work.
echo:
echo Created by Jared Joseph (jnjoseph@ucdavis.edu)
echo:

SET ROPTS=--no-save --no-environ --no-init-file --no-restore --no-Rconsole
SET R_Script=.\R-Portable\App\R-Portable\bin\RScript.exe %ROPTS%

echo What is the name of the TA ranking file? (This must include the file extension!)
SET /p ta_file=
echo TA ranking file is %ta_file%
echo:

echo What is the name of the instructor ranking file? (This must include the file extension!)
SET /p i_file=
echo Instructor ranking file is %i_file%
echo:

%R_Script% R-Portable/ta_match_command.r %ta_file% %i_file%

echo:
echo Matching done!
pause