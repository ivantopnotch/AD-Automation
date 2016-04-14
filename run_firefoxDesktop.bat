
REM delete old logs
del /Q gen\*

REM call tests
call rake firefox > gen\FirefoxDesktop.txt

REM email reports
call ruby email_report.rb FirefoxDesktop
