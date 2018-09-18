class TwitterController < ApplicationController
	$selenium_driver = nil

	def initiate
		begin
			$selenium_driver = Selenium::WebDriver.for :firefox
			base_url = "https://twitter.com/account/begin_password_reset"
			$selenium_driver.get(base_url)

		    wait = Selenium::WebDriver::Wait.new(:timeout => 5)
			wait.until { $selenium_driver.find_element(:name => "account_identifier").displayed? }
		    $selenium_driver.find_element(:name, "account_identifier").clear
		    $selenium_driver.find_element(:name, "account_identifier").send_keys params[:email]
		    $selenium_driver.find_element(:css, "input.Button").click

		    wait = Selenium::WebDriver::Wait.new(:timeout => 5)
			wait.until { $selenium_driver.find_element(:name => "method").displayed? }
		    $selenium_driver.find_element(:name, "method").click
		    $selenium_driver.find_element(:css, "input.Button").click

		    render :json => {"website": "twitter", "status": "Waiting for temp code..."}
		rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "twitter", "status": "Password reset failed!"}
		end
	end


	def finish
		begin
			$selenium_driver.find_element(:name, "pin").clear
		    $selenium_driver.find_element(:name, "pin").send_keys params[:temp_code]
		    $selenium_driver.find_element(:css, "input.Button").click

		    wait = Selenium::WebDriver::Wait.new(:timeout => 5)
			wait.until { $selenium_driver.find_element(:id => "password").displayed? }
		    $selenium_driver.find_element(:id, "password").clear
		    $selenium_driver.find_element(:id, "password").send_keys params[:password]
		    $selenium_driver.find_element(:name, "password_confirmation").clear
		    $selenium_driver.find_element(:name, "password_confirmation").send_keys params[:password]
		    $selenium_driver.find_element(:css, "input.Button").click

		    render :json => {"website": "twitter", "status": "Password reset successful!"}
	    rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "twitter", "status": "Password reset failed!"}
		end
	end


end
