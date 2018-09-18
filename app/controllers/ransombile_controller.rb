require 'net/imap'

class RansombileController < ApplicationController

  $email = ""
  $password = ""

  def checkMail
  	begin
		imap = Net::IMAP.new("imap.googlemail.com", 993, true, nil, false)
		imap.login($email, $password)
		imap.examine("Inbox")
		emailIds = imap.search(["UNSEEN"])
		emailData = imap.fetch(emailIds.last, "BODY[HEADER.FIELDS (FROM)]").first[1]["BODY[HEADER.FIELDS (FROM)]"].to_s
		regexResult = /<(.*)>/.match(emailData)
		emailFrom = regexResult[1]
		render :json => {"email": emailFrom}
	rescue Exception => e
		render :json => {"email": ""}
	ensure
  		imap.logout
  	end
  end

end
