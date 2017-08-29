class HomeController < ApplicationController
	def index
		#If the user is signed in, redirect to the user page
		if user_signed_in?
			redirect_to '/user/index.html'
		end

		
	end
end
