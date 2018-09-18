class PaypalController < ApplicationController
	$selenium_driver = nil

	# To start the password reset process using the email
	def initiate
		begin
			$selenium_driver = Selenium::WebDriver.for :firefox
			base_url = "https://www.paypal.com/authflow/password-recovery/"
			$selenium_driver.get(base_url)
			
			wait = Selenium::WebDriver::Wait.new(:timeout => 5)    
			wait.until { $selenium_driver.find_element(:name => "email").displayed? }
			wait.until { $selenium_driver.find_element(:name => "email").enabled? }
			$selenium_driver.find_element(:name, "email").click
			$selenium_driver.find_element(:name, "email").clear
		    $selenium_driver.find_element(:name, "email").send_keys params[:email]

		    $selenium_driver.find_element(:name, "submitForgotPasswordForm").click
			wait.until { $selenium_driver.find_element(:name => "submit").displayed? }
			wait.until { $selenium_driver.find_element(:id, "sms-challenge-option").displayed? }
			wait.until { $selenium_driver.find_element(:id, "sms-challenge-option").enabled? }
		    $selenium_driver.find_element(:id, "sms-challenge-option").click
		    $selenium_driver.find_element(:name, "submit").click

	    	render :json => {"website": "paypal", "status": "Waiting for temp code..."} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "paypal", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end



	# To handle the temp code input, set new password and finish the password reset process
	def finish
		begin
			wait = Selenium::WebDriver::Wait.new(:timeout => 5)
			wait.until { $paypal_driver.find_element(:id => "smsAnswer").displayed? }
		    $paypal_driver.find_element(:id, "smsAnswer").send_keys params[:temp_code]
		    $paypal_driver.find_element(:name, "smsPin").click

			wait.until { $paypal_driver.find_element(:name => "password").displayed? }
		    $paypal_driver.find_element(:name, "password").send_keys params[:password]
		    $paypal_driver.find_element(:name, "confirmPassword").send_keys params[:password]

			wait.until { $paypal_driver.find_element(:name => "submitPassword").displayed? }
			wait.until { $paypal_driver.find_element(:name => "submitPassword").enabled? }
		    $paypal_driver.find_element(:name, "submitPassword").click

	    	render :json => {"website": "paypal", "status": "Password reset successful!"} # Replace WEBSITE with appropiate website name

	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "paypal", "status": "Password reset failed!"} # Replace WEBSITE with appropiate website name
		end
	end


end
