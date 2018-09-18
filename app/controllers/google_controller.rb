class GoogleController < ApplicationController
	$selenium_driver = nil


	def initiate
		begin
			$selenium_driver = Selenium::WebDriver.for :firefox
			base_url = "https://accounts.google.com?hl=en"
			$selenium_driver.get(base_url)
			wait = Selenium::WebDriver::Wait.new(:timeout => 5)

			begin # Handles Google's A/B testing
				$selenium_driver.find_element(:id, "Email").clear
			    $selenium_driver.find_element(:id, "Email").send_keys params[:email]
			    $selenium_driver.find_element(:id, "next").click

				wait.until { $selenium_driver.find_element(:id => "link-forgot-passwd").displayed? }
				$selenium_driver.find_element(:id, "link-forgot-passwd").click
			rescue Selenium::WebDriver::Error::NoSuchElementError => e
		    	$selenium_driver.find_element(:id, "identifierId").clear
			    $selenium_driver.find_element(:id, "identifierId").send_keys params[:email]
			    $selenium_driver.find_element(:id, "identifierId").send_keys :return

				wait.until { $selenium_driver.find_element(:id, "forgotPassword").displayed? }
				$selenium_driver.find_element(:id, "forgotPassword").send_keys :tab
				$selenium_driver.find_element(:id, "forgotPassword").send_keys :return
		    end

		    begin
		    	$selenium_driver.find_element(:id => "idvPreresteredPhoneSms").displayed?
				
			rescue Selenium::WebDriver::Error::NoSuchElementError => e
				begin
					wait.until { $selenium_driver.find_element(:id => "skipChallenge").displayed? }
					$selenium_driver.find_element(:id, "skipChallenge").click
					sleep 1
					$selenium_driver.find_element(:id => "idvPreresteredPhoneSms").displayed?
				rescue Selenium::WebDriver::Error::NoSuchElementError => e
					wait.until { $selenium_driver.find_element(:id => "skipChallenge").displayed? }
					$selenium_driver.find_element(:id, "skipChallenge").click
					sleep 1
				rescue Selenium::WebDriver::Error::TimeOutError => e # Handles Google's A/B testing
					wait.until { $selenium_driver.find_element(:xpath, "//span[text()='Try another way']").displayed? }
					$selenium_driver.find_element(:xpath, "//span[text()='Try another way']").click
					
					wait.until { $selenium_driver.find_element(:id, "phoneNumberId").displayed? }
					$selenium_driver.find_element(:id, "phoneNumberId").send_keys params[:phone]
					$selenium_driver.find_element(:id, "next").click
				end
			end

			wait.until { $selenium_driver.find_element(:id => "idvPreresteredPhoneSms").displayed? }
			$selenium_driver.find_element(:id, "idvPreresteredPhoneSms").click

			begin
				wait.until { $selenium_driver.find_element(:name => "phoneNumber").displayed? }
		    	$selenium_driver.find_element(:name, "phoneNumber").clear
		    	puts params[:phone]
		    	$selenium_driver.find_element(:name, "phoneNumber").send_keys params[:phone]
		    	puts params[:phone]
		    rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::TimeOutError=> e
				puts "A/B testing related error. All good!"
			end

			render :json => {"website": "google", "status": "Waiting for temp code..."}
		rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "google", "status": "Password reset failed!"}
		end
	end




	def finish
		begin
			wait = Selenium::WebDriver::Wait.new(:timeout => 5)
			begin
				wait.until { $selenium_driver.find_element(:id => "idvPreregisteredPhonePin").displayed? }
				$google_driver.find_element(:id, "idvPreregisteredPhonePin").clear
			    $google_driver.find_element(:id, "idvPreregisteredPhonePin").send_keys params[:temp_code]
				$google_driver.find_element(:id, "submit").click
			rescue Selenium::WebDriver::Error::TimeOutError # Handles Google's A/B testing
				wait.until { $selenium_driver.find_element(:id, "idvPin").displayed? }
				$google_driver.find_element(:id, "idvPin").clear
			    $google_driver.find_element(:id, "idvPin").send_keys params[:temp_code]
				$google_driver.find_element(:id, "idvPin").send_keys :return;
			end

			wait.until { $selenium_driver.find_element(:id => "Password").displayed? }
			$google_driver.find_element(:id, "Password").clear
		    $google_driver.find_element(:id, "Password").send_keys params[:password]
		    $google_driver.find_element(:id, "ConfirmPassword").clear
		    $google_driver.find_element(:id, "ConfirmPassword").send_keys params[:password]
		    $google_driver.find_element(:id, "submit").click

		    begin
		    	wait = Selenium::WebDriver::Wait.new(:timeout => 1)
				wait.until { $google_driver.find_element(:id => "Password").displayed? }
		    	render :status => 500, :json => {"website": "google", "status": "Password reset failed!"}
		    rescue Selenium::WebDriver::Error::TimeOutError => e
		    	render :json => {"website": "google", "status": "Password reset successful!"}
		    end
		rescue Exception => e
			puts e.to_s
			puts e.backtrace
			render :status => 500, :json => {"website": "google", "status": "Password reset failed!"}
		end
	end



end
