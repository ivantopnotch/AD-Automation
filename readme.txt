This is the script for automating AD testing

HOW TO RUN:
1. Install ruby, make sure to add to $PATH on windows; make sure rake is installed
2. In commandline/terminal, navigate to AD-automation directory and run: bundle update; this should install all required gemfiles
3. Make sure to specify environment in spec_helper.rb
4. Make sure to set up email in email_report.rb
5. Run .bat file for desired browser(s)

INTERNET EXPLORER:
You must download the IE driver and put it in a location that has been added to $PATH
Using the x64 version is not recommended as it enters keys really slowly

FIREFOX:
By default, the script is set to run with a profile named "adblock" to get around foresee, sine adding the foresee cookies doens't seem to work in firefox for some reason.