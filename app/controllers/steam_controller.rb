class SteamController < ApplicationController
	$selenium_driver = nil

	# To start the password reset process using the email
	def initiate
		begin
			$selenium_driver = Selenium::WebDriver.for :firefox
		    base_url = "https://help.steampowered.com/en/wizard/HelpWithLoginInfo"
		    $selenium_driver.get(base_url)

			wait = Selenium::WebDriver::Wait.new(:timeout => 5)
		    wait.until { $selenium_driver.find_element(:id, "forgot_login_search").displayed? }
		    $selenium_driver.find_element(:id, "forgot_login_search").send_keys params[:email]
		    $selenium_driver.find_element(:id, "forgot_login_search").send_keys :return

		    # Needs testing from here on
		    wait.until { $selenium_driver.find_element(:xpath, "//span[text()='Text an account verification']").displayed? }
		    $selenium_driver.find_element(:xpath, "//span[text().='Text an account verification']").click

	    	render :json => {"website": "steam", "status": "Waiting for temp code..."} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "steam", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end



	# To handle the temp code input, set new password and finish the password reset process
	def finish
		begin
			wait.until { $selenium_driver.find_element(:id => "forgot_login_code").displayed? }
			$selenium_driver.find_element(:id => "forgot_login_code").send_keys params[:temp_code]
			$selenium_driver.find_element(:id => "forgot_login_code").send_keys :return

	    	render :json => {"website": "steam", "status": "Password reset successful!"} # Replace WEBSITE with appropiate website name
	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "steam", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end
end
