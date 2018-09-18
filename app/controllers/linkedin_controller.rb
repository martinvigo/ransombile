class LinkedinController < ApplicationController
	$selenium_driver = nil

	# To start the password reset process using the email
	def initiate
		begin
			$selenium_driver = Selenium::WebDriver.for :firefox
			base_url = "https://www.linkedin.com/uas/request-password-reset"
			$selenium_driver.get(base_url)
			wait = Selenium::WebDriver::Wait.new(:timeout => 5)
  			
  			begin # Handles A/B testing
				wait.until { $selenium_driver.find_element(:id => "username").displayed? }
			    $selenium_driver.find_element(:id, "username").clear
			    $selenium_driver.find_element(:id, "username").send_keys params[:email]
			    $selenium_driver.find_element(:id, "reset-password-submit-button").click

				wait.until { $selenium_driver.find_element(:id => "sms").displayed? }
			    $selenium_driver.find_element(:xpath, "//label[contains(@for,'sms')]").click
			    $selenium_driver.find_element(:id, "reset-password-submit-button").click
			rescue Selenium::WebDriver::Error::TimeOutError => e
				wait.until { $selenium_driver.find_element(:id => "userName-requestPasswordReset").displayed? }
			    $selenium_driver.find_element(:id, "userName-requestPasswordReset").clear
			    $selenium_driver.find_element(:id, "userName-requestPasswordReset").send_keys params[:email]
			    $selenium_driver.find_element(:id, "btnSubmitResetRequest").click

				wait.until { $selenium_driver.find_element(:id => "SMS-passwordResetOption-passwordResetOption").displayed? }
			    $selenium_driver.find_element(:id, "SMS-passwordResetOption-passwordResetOption").click
			    $selenium_driver.find_element(:id, "btn-submit").click
			end

	    	render :json => {"website": "linkedin", "status": "Waiting for temp code..."} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "linkedin", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end



	# To handle the temp code input, set new password and finish the password reset process
	def finish
		begin
			wait = Selenium::WebDriver::Wait.new(:timeout => 5)
			begin # Handles A/B testing
			    wait.until { $selenium_driver.find_element(:id => "newPassword").displayed? }
			    $selenium_driver.find_element(:id, "newPassword").clear
			    $selenium_driver.find_element(:id, "newPassword").send_keys params[:password]
			    $selenium_driver.find_element(:id, "confirmPassword").clear
			    $selenium_driver.find_element(:id, "confirmPassword").send_keys params[:password]
			    $selenium_driver.find_element(:id, "reset-password-submit-button").click
			rescue Selenium::WebDriver::Error::TimeOutError => e
				wait.until { $selenium_driver.find_element(:id => "challenge-input").displayed? }
			    $selenium_driver.find_element(:id, "challenge-input").clear
			    $selenium_driver.find_element(:id, "challenge-input").send_keys params[:temp_code]

			    wait = Selenium::WebDriver::Wait.new(:timeout => 5)
				wait.until { $selenium_driver.find_element(:css, "div.cp-challenge-actions.form-actions > input.btn-submit").displayed? }
			    $selenium_driver.find_element(:css, "div.cp-challenge-actions.form-actions > input.btn-submit").click
			    
			    wait = Selenium::WebDriver::Wait.new(:timeout => 5)
				wait.until { $selenium_driver.find_element(:id => "new_password-newPassword-passwordReset").displayed? }
				$selenium_driver.find_element(:id, "new_password-newPassword-passwordReset").clear
			    $selenium_driver.find_element(:id, "new_password-newPassword-passwordReset").send_keys params[:password]
			    $selenium_driver.find_element(:id, "new_password_again-newPassword-passwordReset").clear
			    $selenium_driver.find_element(:id, "new_password_again-newPassword-passwordReset").send_keys params[:password]
			    $selenium_driver.find_element(:id, "reset").click
			end

	    	render :json => {"website": "linkedin", "status": "Password reset successful!"} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "linkedin", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end


end