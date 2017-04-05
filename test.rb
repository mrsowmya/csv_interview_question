require 'csv'
require 'uri'

class Test
	attr_accessor :val

	def initialize(val)
		@val = val
	end

	def value
		return array if is_array?
		return number if is_number?
		string
	end

	def is_array?
		return true if array.is_a?(Array) 
	end

	def array
		@array ||= begin
			value = val.split("+")

			first = eval(value.first)
			last  = eval(value.last)

			first + last
		rescue NameError => ex
		end
	end

	def is_number?
		return true if number.is_a?(Integer)
	end

	def number
		@number ||= begin
			value = val.split("+")
			return false if (value.length == 1)
			
			first = value.first.to_i
			last  = value.last.to_i

			value.first.to_i + value.last.to_i
		end
	end

	def string
		uri = URI.parse(val)
		return uri.host if uri.is_a?(URI::HTTPS)
		val
	end
end

data = []

CSV.foreach('/home/theju/csv_interview_question/input.csv') do |row|
	data << row.map {|r| Test.new(r).value }
end

CSV.open("/home/theju/csv_interview_question/output.csv", "wb") do |csv|
	data.map {|d| csv << d }
end
