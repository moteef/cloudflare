# Copyright, 2012, by Marcin Prokop.
# Copyright, 2017, by Samuel G. D. Williams. <http://www.codeotaku.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'json'

module Cloudflare
	class RequestError < StandardError
		def initialize(what, response)
			super("#{what}: #{response.errors.join(', ')}")
			
			@response = response
		end
		
		attr :response
	end
	
	class Response
		def initialize(what, content)
			@what = what
			
			@body = JSON.parse(content, symbolize_names: true)
		end
		
		attr :body

		def result
			unless successful?
				raise RequestError.new(@what, self)
			end
			
			body[:result]
		end

		# Treat result as an array (often it is).
		def results
			Array(result)
		end

		def empty?
			result.empty?
		end

		def successful?
			body[:success]
		end

		def errors
			body[:errors]
		end

		def messages
			body[:messages]
		end
	end
end
