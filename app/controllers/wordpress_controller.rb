class WordpressController < ApplicationController
	$selenium_driver = nil

	# To start the password reset process using the email
	def initiate
		begin
			$selenium_driver = Selenium::WebDriver.for :firefox
		    base_url = "https://wordpress.com/wp-login.php?action=lostpassword"
		    $selenium_driver.get(base_url)

		    wait = Selenium::WebDriver::Wait.new(:timeout => 5)
		    wait.until { $selenium_driver.find_element(:id => "lostpasswordform").displayed? }
		    wait.until { $selenium_driver.find_element(:id => "user_login").enabled? }
		    $selenium_driver.find_element(:id, "user_login").clear
		    $selenium_driver.find_element(:id, "user_login").send_keys params[:email]
		    $selenium_driver.find_element(:id, "wp-submit").click

	    	render :json => {"website": "wordpress", "status": "Waiting for temp code..."} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "wordpress", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end



	# To handle the temp code input, set new password and finish the password reset process
	def finish
		begin
			wait = Selenium::WebDriver::Wait.new(:timeout => 5)
		    wait.until { $selenium_driver.find_element(:name => "recovery-sms").displayed? }
		    $selenium_driver.find_element(:name, "recovery-sms").clear
		    $selenium_driver.find_element(:name, "recovery-sms").send_keys params[:temp_code]
		    $selenium_driver.find_element(:id, "wp-submit").click

		    wait.until { $selenium_driver.find_element(:id => "pass1").displayed? }
		    $selenium_driver.find_element(:id, "pass1").clear
		    $selenium_driver.find_element(:id, "pass1").send_keys params[:password]
		    wait.until { $selenium_driver.find_element(:name => "wp-submit").enabled? }
		    $selenium_driver.find_element(:id, "wp-submit").click

		    begin
		    	wait = Selenium::WebDriver::Wait.new(:timeout => 1)
				wait.until { $selenium_driver.find_element(:id => "login_error").displayed? }
		    	render :status => 500, :json => {"website": "wordpress", "status": "Password reset failed!"}
		    rescue Selenium::WebDriver::Error::TimeOutError => e
		    	render :json => {"website": "wordpress", "status": "Password reset successful!"}
		    end

	    	render :json => {"website": "wordpress", "status": "Password reset successful!"} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "wordpress", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end

end
