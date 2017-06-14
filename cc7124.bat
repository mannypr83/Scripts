@echo

if not exist "%ProgramFiles(x86)%" goto not64bit

set ProgramFiles=%ProgramFiles(x86)%

:not64bit

set drive=Z

if exist z:\nul set drive=Y

net use %drive%: /delete

net use %drive%: \\az10cccq.honeywell.com\release\CCCQ7.1.2\InstallationManager1.5.3

%drive%:

rem installc.exe -acceptLicense 

c:

net use %drive%: /delete

cd %ProgramFiles%\IBM\Installation Manager\eclipse

c:

cd tools

rem imcl.exe input \\az10cccq.honeywell.com\release\CCCQ7.1.2\ResponseFiles\cc7124.xml -acceptLicense

rem If you notice any errors: Take a screenshot of this window, go to https://jira.honeywell.com/jira/browse/CCCQ to open a new ticket and attach the screenshot.

pause