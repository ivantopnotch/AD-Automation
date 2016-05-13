require 'spec_helper'

class TestValidation
	#Allows us to use rspect stuff inside a class
	include RSpec::Mocks::ExampleMethods::ExpectHost
  	include RSpec::Matchers 

	def initialize()
		@wait = Selenium::WebDriver::Wait.new(timeout: 3)
		@wait_long = Selenium::WebDriver::Wait.new(timeout: 20)
	end

	#Test text input validation
	#Enter invalid input and set will_highlight to true
	#OR enter valid input and set will_highlight to false
	def text_input(element, input, will_highlight = false, on_blur_element = nil, long_wait = false)
		if long_wait
			@wait_long.until { element.displayed? }
		else
			@wait.until { element.displayed? }
		end
		js_scroll_up(element,true)
		element.clear()
		element.send_keys(input)
		#Click another element to fire on-blur
		num_retry = 0
		begin
			if(on_blur_element != nil)
				js_scroll_up(on_blur_element,true)
				on_blur_element.click
			end

			#Check highlight
			@wait.until { (element.attribute("class").include? "is-error") == will_highlight }
		rescue Selenium::WebDriver::Error::TimeOutError
			retry if (num_retry += 1) == 1
		end
	end

	#Check error message existance/non-existance
	#Can optionally check contents, can set flag to check if it's NOT equal
	def error_msg(error_msg, visible = true, error_msg_txt = nil, msg_not_equal = false, long_wait = false)
		if(visible && !long_wait)
			@wait.until { error_msg.displayed? }
		elsif(visible && long_wait)
			@wait_long.until { error_msg.displayed? }
		else
			wait_for_disappear(error_msg, 3)
		end

		#Error message contents
		if(visible && error_msg_txt != nil)
			expect(error_msg.attribute("innerHTML").include? error_msg_txt).to eql !msg_not_equal
		end
	end

	#Check if elements are/are not highlighted
	#Must be passed an array of elements
	def batch_check_highlights(elements, are_highlighted = true)
		elements.each do |element|
			expect(element.attribute("class").include? "is-error").to eql are_highlighted
		end
	end
end