require 'mail'
require 'zip'

# extract export
report = ''
if File.exist?("gen\\#{ARGV[0]}.txt",)
    File.open("gen\\#{ARGV[0]}.txt", "r") do |f|
        f.each_line do |line|
            report << line
        end
    end
else
    puts "could not find file gen\\#{ARGV[0]}.txt"
end

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :user_name            => 'topnotchtester@gmail.com',
            :password             => 'TopNotch123!',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }

Mail.defaults do
    delivery_method :smtp, options
end

Mail.deliver do
    from    'topnotchtester@gmail.com'
    to      ['danny@topnotchltd.com', 'jake@topnotchltd.com']
    cc      'billy@topnotchltd.com'
    subject "#{ARGV[0]} test results #{Time.now.strftime("%m/%d/%Y %H:%M")}"
    #body    report
    body    "1. Download attached zip file\n2. Extract allure-results to allure-commandline\\bin\n3. Double click generate.bat' (Windows)\n4. Double click 'open.bat' (Windows)\nMore detailed results follow:\n\n\n" + report
    #Attach all screenshots
    # Dir.glob("gen/*.png") do |file_name|
    #     path = File.expand_path(file_name)
    #     puts "Attached file " + path
    #     add_file(path)
    # end

    #Zip and attach allure report
    sys_dir = "gen/allure-results/" #Directory on system
    zip_dir = "allure-results/" #Directory inside zip
    zipfile_name = sys_dir + "allure-results.zip"

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        Dir.glob(sys_dir + "*.png") do |file_name|
            path = File.expand_path(file_name)
            zipfile.add(zip_dir + file_name.split("/").last, path)
            puts "Inserted file " + file_name
        end
        Dir.glob(sys_dir + "*.xml") do |file_name|
            path = File.expand_path(file_name)
            zipfile.add(zip_dir + file_name.split("/").last, path)
            puts "Inserted file " + file_name
        end
    end

    path = File.expand_path(zipfile_name)
    puts "Attached file " + path
    add_file(path)
end

puts "==Email sent=="