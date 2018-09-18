class FacebookController < ApplicationController
	$selenium_driver = nil

	# To start the password reset process using the email
	def initiate
		begin
			$selenium_driver = Selenium::WebDriver.for :firefox
			base_url = "https://www.facebook.com/recover/initiate"
			$selenium_driver.get(base_url)

			wait = Selenium::WebDriver::Wait.new(:timeout => 5)
			wait.until { $selenium_driver.find_element(:id => "identify_email").displayed? }
		    $selenium_driver.find_element(:id, "identify_email").clear
		    $selenium_driver.find_element(:id, "identify_email").send_keys params[:email]
		    $selenium_driver.find_element(:xpath, "//input[contains(@value,'Search')]").click

			wait.until { $selenium_driver.find_element(:xpath, "//input[contains(@id,'send_sms')]").displayed? }
		    $selenium_driver.find_element(:xpath, "//input[contains(@id,'send_sms')]").click
		    if not $selenium_driver.find_element(:xpath, "//input[contains(@id,'send_sms')]").selected? # double check
		    	$selenium_driver.find_element(:xpath, "//input[contains(@id,'send_sms')]").click
		    end
		    $selenium_driver.find_element(:xpath, "//button[@type='submit']").click

			render :json => {"website": "facebook", "status": "Waiting for temp code..."}

	    rescue Exception => e
	    	puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "facebook", "status": "Password reset failed!"}
		end
	end



	# To handle the temp code input, set new password and finish the password reset process
	def finish
		begin
			wait = Selenium::WebDriver::Wait.new(:timeout => 5)
			wait.until { $selenium_driver.find_element(:name => "n").displayed? }
		    $selenium_driver.find_element(:name, "n").clear
		    $selenium_driver.find_element(:name, "n").send_keys params[:temp_code]
		    $selenium_driver.find_element(:xpath, "//button[@type='submit']").click

			wait.until { $selenium_driver.find_element(:id => "password_new").displayed? }
		    $selenium_driver.find_element(:id, "password_new").clear
		    $selenium_driver.find_element(:id, "password_new").send_keys params[:password]
		    $selenium_driver.find_element(:id, "btn_continue").click

	    	render :json => {"website": "facebook", "status": "Password reset successful!"} 

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "facebook", "status": "Password reset failed!"}
		end
	end

end
