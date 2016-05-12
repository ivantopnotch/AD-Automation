require 'spec_helper'

class TestValidation
	#Allows us to use rspect stuff inside a class
	include RSpec::Mocks::ExampleMethods::ExpectHost
  	include RSpec::Matchers 

	def initialize()
		@wait = Selenium::WebDriver::Wait.new(timeout: 3)
	end

	#Test text input validation
	def text_invalid_input(element, input, will_highlight = false, on_blur_element = nil)
		@wait.until { element.displayed? }
		js_scroll_up(element)
		element.clear()
		element.send_keys(input)
		#Click another element to fire on-blur
		if(on_blur_element != nil)
			js_scroll_up(on_blur_element)
			on_blur_element.click
		end

		#Check highlight
		if(will_highlight)
			expect(element.attribute("class").include? "is-error").to eql true
		end
	end

	# Test text input validation NOT firing
	# Opposite of above; provide valid input
	def text_valid_input(element, input, will_highlight = false, on_blur_element = nil)
		@wait.until { element.displayed? }
		js_scroll_up(element)
		element.clear()
		element.send_keys(input)
		#Click another element to fire on-blur
		if(on_blur_element != nil)
			js_scroll_up(on_blur_element)
			on_blur_element.click
		end

		#Check highlight
		if(will_highlight)
			expect(element.attribute("class").include? "is-error").to eql false
		end
	end

	#Check error message existance/non-existance
	#Can optionally check contents
	def error_msg(error_msg, visible = true, error_msg_txt = nil)
		if(visible)
			@wait.until { error_msg.displayed? }
		else
			wait_for_disappear(error_msg, 3)
		end

		#Error message contents
		if(visible && error_msg_txt != nil)
			expect(element.attribute("innerHTML").include? error_msg_txt).to eql true
		end
	end
end