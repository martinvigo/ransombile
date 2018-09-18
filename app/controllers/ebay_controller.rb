class EbayController < ApplicationController
	$selenium_driver = nil

	# To start the password reset process using the email
	def initiate
		begin
			$selenium_driver = Selenium::WebDriver.for :firefox
		    base_url = "https://fyp.ebay.com/"
		    $selenium_driver.get(base_url)
		    
		    wait = Selenium::WebDriver::Wait.new(:timeout => 5)
		    wait.until { $selenium_driver.find_element(:id, "userInfo").displayed? }
		    $selenium_driver.find_element(:id, "userInfo").send_keys params[:email]
			$selenium_driver.find_element(:id, "userInfo").send_keys :return

			wait.until { $selenium_driver.find_element(:id, "defaulttext").displayed? }
		    $selenium_driver.find_element(:id, "defaulttext").click

	    	render :json => {"website": "ebay", "status": "Waiting for temp code..."} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "ebay", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end



	# To handle the temp code input, set new password and finish the password reset process
	def finish
		begin
			wait = Selenium::WebDriver::Wait.new(:timeout => 5)
		    wait.until { $selenium_driver.find_element(:id, "pinTxtBx").displayed? }
		    $selenium_driver.find_element(:id, "pinTxtBx").send_keys params[:temp_code]
		    $selenium_driver.find_element(:id, "pinTxtBx").send_keys :return

		    wait.until { $selenium_driver.find_element(:id, "password").displayed? }
		    $selenium_driver.find_element(:id, "password").send_keys params[:password]
		    $selenium_driver.find_element(:id, "password").send_keys :return

	    	render :json => {"website": "ebay", "status": "Password reset successful!"} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "ebay", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end

end
