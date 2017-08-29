class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


   def GetCreditTotal
   		@credits = Transaction.where(to_id: self.id)
		@debits = Transaction.where(from_id: self.id)

		#Holds total amount of NET credits
		@amount = 0

		#Calculate NET credit totals
		@credits.each do |c|
			@amount += c.amount
		end
			
		@debits.each do |d|
			@amount -= d.amount
		end

		return @amount
   end
end
