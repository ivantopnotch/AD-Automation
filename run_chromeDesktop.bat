
REM delete old logs
del /Q gen\*

REM call tests
call rake chrome > gen\ChromeDesktop.txt

REM email reports
call ruby email_report.rb ChromeDesktop
