require 'json'
require 'httparty'

class API
	def initialize(loop = false)
		@loop = loop
		@endpoint = 'http://json-server.devpointlabs.com/api/v1'
	end

	def start
		puts `clear`
		menu
		while(@loop)
			menu
		end
	end

	def menu
		puts 'API Viewer'
		puts '1) view all users'
		puts '2) View a specific user'
		puts '3) create a user'
		puts '4) update a user'
		puts '5) delete a user'
		puts '6) quit'
		print '> '
		handle_input(gets.chomp.to_i)
	end

	def handle_input(input)
		case input
		when 1
			show_all
		when 2
			show_one
		when 3
			create_user
		when 4
			update_user
		when 5
			delete_user
		when 6
			puts 'Bye'
			exit
		else
			puts 'Unknown input'
			menu
		end
	end

	def show_all
		puts HTTParty.get("#{@endpoint}/users")
	end

	def show_one
		user_id = get_user_id
		puts HTTParty.get("#{@endpoint}/users/#{user_id}")
	end

	def create_user
		info = get_user_info

		puts HTTParty.post("#{@endpoint}/users?user[first_name]=#{info[0]}&user[last_name]=#{info[1]}&user[phone_number]=#{info[2]}")
	end

	def update_user
		user_id = get_user_id
		info = get_user_info

		puts HTTParty.put("#{@endpoint}/users/#{user_id}?user[first_name]=#{info[0]}&user[last_name]=#{info[1]}&user[phone_number]=#{info[2]}")
	end

	def delete_user
		user_id = get_user_id
		puts HTTParty.delete("#{@endpoint}/users/#{user_id}").message
	end

	private

		def get_user_id
			puts 'Enter user ID: '
			print '> '
			gets.chomp.to_i
		end

		def get_user_info
			puts 'Enter first name:'
			print '> '
			first_name = gets.chomp
			puts 'Enter last name:'
			print '> '
			last_name = gets.chomp
			puts 'Enter phone number:'
			print '> '
			phone_number = gets.chomp

			[first_name, last_name, phone_number]
		end
end

API.new(true).start
