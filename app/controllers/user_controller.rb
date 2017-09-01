class UserController < ApplicationController
	before_action :authenticate_user!

	def index
		#Get the current user
		@user = current_user

		#Get a list of all the users
		@users = User.all
		
		#Get a list of all CREDIT and DEBIT transactions
		@credits = Transaction.where(to_id: @user.id)
		@debits = Transaction.where(from_id: @user.id)

		#Holds total amount of NET credits
		@amount = 0

		#Calculate NET credit totals
		@credits.each do |c|
			@amount += c.amount
		end
			
		@debits.each do |d|
			@amount -= d.amount
		end

		#If using external API call, return current user
		#respond {email: @user.email, credits: @amount}
	end

	#POST /user/send_credits
	def send_credits
		#Creates a new Transaction

		#Lock current user so another transactions can't
		#access this user
		current_user.with_lock do
			
			#If Send To and Send From are the same => error
			#Can't send to self
			to_user = User.find_by(email: params[:email])
			if to_user.id == current_user.id
				flash[:notice] = "Can't send credits to self"
				redirect_to '/user/index'
				#End current user lock
				current_user.save!
				return
			end

			#Does user have enough credits to send?
			total_credits = current_user.GetCreditTotal
			if total_credits < params[:credits].to_f
				#Not enough credits
				flash[:notice] = "Not enough credits to send"
				redirect_to '/user/index'

				#End current user lock
				current_user.save!
				return
			end

			#Create the new transaction & save the result
			result = current_user.CreateTransaction(to_user.id, params[:credits])
			
			#t = Transaction.new
			#result = t.NewTransaction(current_user.id, to_user.id, params[:credits])
			
			#Display result message
			if result == :success
				flash[:notice] = "Sent " + params[:credits] + " credits to " + to_user.email
			else result == :error
				flash[:notice] = "Not enough credits to send"
			end

			#Reload user index page
			redirect_to '/user/index'

			#End current user lock
			current_user.save!
		end
	end

	#GET /api/v1/users/current
	def current
		#Returns the current user email and credit balance as JSON
		#User must already be logged in

		render json: {email: current_user.email, num_credits: current_user.GetCreditTotal}
	end
end
