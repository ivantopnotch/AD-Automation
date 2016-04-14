
REM delete old logs
del /Q gen\*

REM call tests
call rake edge > gen\EdgeDesktop.txt

REM email reports
call ruby email_report.rb EdgeDesktop
