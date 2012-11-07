#!/usr/mogreet_distro/bin/ruby

require 'cgi'
require 'net/http'
require 'net/smtp'
require 'json'


API_KEY   = "R_be7c9912a376e73ed510bd2809d838b9"
API_LOGIN = "mogreetmoshare"
API_URL   = "api.bitly.com"

def read_the_file filename, moShare_links
    lines = File.open(filename, 'r') do |file|
        file.readlines
    end

    # Drops the 2 first lines which contains the headers and a return
    lines.each do |line|
        split = line.split(',')
        moShare_links << MoShare_link.new(date=split[0], 
                                          source=split[1].strip!, 
                                          url=split[2].strip!, 
                                          type=split[3].strip!, 
                                          channel=split[4].strip!, 
                                          sends=split[5].strip!, 
                                          cid=split[6][0, split[6].length-1].strip!, 
                                          clicks="")
    end
end

def bitly_request diff_in_days, moShare_links
    # Get the number of clicks for 15 links max
    i = 0
    data = {}
    while i < moShare_links.length do
        j = 0
        bunch_of_links = Array.new
        until (j == moShare_links.length || j == 15 || i == moShare_links.length) do 
            if moShare_links[i].url =~ /http:\/\/(.*)/
                moShare_links[i].url = CGI.escape(moShare_links[i].url)
                bunch_of_links << moShare_links[i].url
            end
            i += 1
            j += 1
        end

        # Let's construct the request
        request = "http://#{API_URL}/v3/clicks_by_day?&login=#{API_LOGIN}&apiKey=#{API_KEY}&days=#{diff_in_days+1}"
        
        bunch_of_links.each do |link|
            request += "&shortUrl="+link
        end

        res = Net::HTTP.get_response(URI(request))

        data = JSON.parse(res.body)

        bunch_of_links.each_with_index do |temp_link, k|
            moShare_links.each do |link|
                link.url = CGI.unescape(link.url)
                # Test if the current link have data to retrieve (it's possible that bit.ly throws an error if we try to call the API with a non-bit.ly link)
                if (link.url == data["data"]["clicks_by_day"][k]["short_url"] && data["data"]["clicks_by_day"][k]["error"].nil?)
                    #puts "#{Time.at(data["data"]["clicks_by_day"][k]["clicks"][diff_in_days]["day_start"])}"
                    link.clicks = data["data"]["clicks_by_day"][k]["clicks"][diff_in_days]["clicks"]
                end
            end
        end
    end

    return data
end

def write_file filedate, data, diff_in_days, moShare_links
    # Try to retrieve the day corresponding to the clicks
    # We need to do that because if the original CSV file doesn't contain any bit.ly links
    # the script will fail.
    notFound = true, k = 0, day = "Day not found"
    while (notFound && k < moShare_links.length) do 
        if (data["data"]["clicks_by_day"][k]["error"].nil?)
            day = "clicks on #{Time.at(data["data"]["clicks_by_day"][k]["clicks"][diff_in_days]["day_start"]).getutc.strftime("%d %b %Y")}"
            notFound = false
        else
            k = k + 1
        end
    end

    # Write the local file (not needed, this is just for testing and having a local copy)
    local_file = File.new("logs/sends/sends_#{filedate}_modified.csv", 'w')
    local_file.puts "date, source, url, type, channel, sends, cid, " + day

    moShare_links.each do |link|
        local_file.puts "#{link.date}, #{link.source}, #{link.url}, #{link.type}, #{link.channel}, " +
                        "#{link.sends}, #{link.cid}, #{link.clicks}"
    end

    # Build the string which is gonna be send in a csv format
    email_file = "date, source, url, type, channel, sends, cid, " + day + "\n\n"
    moShare_links.each do |link|
        email_file += "#{link.date}, #{link.source}, #{link.url}, #{link.type}, #{link.channel}, #{link.sends}, " + 
                      "#{link.cid}, #{link.clicks}\n"
    end

    return email_file
end

def send_by_mail filedate, email_file, recipient
    encodedcontent = [email_file].pack("m")   # base64

    marker = "AUNIQUEMARKER"

body =<<EOF
Here's the moShare sends report for yesterday...
EOF

# Define the main headers.
part1 =<<EOF
From: Moshare <monet@mogreet.com>
To: #{recipient}
Subject: Daily Moshare Report
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{marker}
--#{marker}
EOF

# Define the message action
part2 =<<EOF
Content-Type: text/plain
Content-Transfer-Encoding:8bit

#{body}
--#{marker}
EOF

# Define the attachment section
part3 =<<EOF
Content-Type: text/csv; name=\"sends_#{filedate}.csv\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename="sends_#{filedate}.csv"

#{encodedcontent}
--#{marker}--
EOF

    mailtext = part1 + part2 + part3

     
    Net::SMTP.start('mail-relay.mogreet.com', 25) { |smtp|
         smtp.sendmail(mailtext, 'monet@mogreet.com', recipient)
    }
end

begin
    MoShare_link = Struct.new(:date,:source,:url,:type, :channel,:sends,:cid,:clicks)
    moShare_links = Array.new

    today     = Time.now
    yesterday = today - (60*60*24)
    filedate  = "#{yesterday.month}-#{yesterday.day}-#{yesterday.year}"
    recipient = 'benjamin.guillet@mogreet.com'
    filedate  = '5-22-2012'
    filename  = File.expand_path(File.join(File.dirname(__FILE__), "logs/sends/sends_#{filedate}.csv"))
    errorlog  = File.expand_path(File.join(File.dirname(__FILE__), 'logs/error.txt'))

    current_filedate_splitted = filedate.split("-")
    filetime = Time.local(current_filedate_splitted[2], current_filedate_splitted[0], current_filedate_splitted[1])
    diff_in_days = ((today - filetime) / (3660*24)).floor

    # We wanna access the numbers of clicks for the diff_in_days+1 day (the day of the filedate)
    # bit.ly API only authorize a 29 days ago data request, so... not need to continue if the diff_in_days exceeds 29 days
    if diff_in_days > 29
        abort("The difference between now and the filedate is too important in the past, it cannnot exceeds 29 days")
    end

    read_the_file filename, moShare_links
    
    data = bitly_request diff_in_days, moShare_links
    
    email_file = write_file filedate, data, diff_in_days, moShare_links
    
    send_by_mail filedate, email_file, recipient
    

    File.open(errorlog, 'a') { |f| f.write("\n\nSuccessfully emailed #{filename}\n\n\n\n") }
rescue Exception => e  
    File.open(errorlog, 'a') { |f| f.write("\n\nError emailing: #{e.message}\n#{e.backtrace}\n\n\n\n") }
end
