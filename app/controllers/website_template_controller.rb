class WebsiteTemplateController < ApplicationController
	$selenium_driver = nil

	# To start the password reset process using the email
	def initiate
		begin
			$selenium_driver = Selenium::WebDriver.for :firefox
		
			# YOUR CODE

	    	render :json => {"website": "WEBSITE", "status": "Waiting for temp code..."} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "WEBSITE", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end



	# To handle the temp code input, set new password and finish the password reset process
	def finish
		begin
			
			# YOUR CODE

	    	render :json => {"website": "WEBSITE", "status": "Password reset successful!"} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "WEBSITE", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end


end
