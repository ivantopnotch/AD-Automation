
REM delete old logs
del /Q gen\*

REM call tests
call rake ie > gen\IEDesktop.txt

REM email reports
call ruby email_report.rb IEDesktop
