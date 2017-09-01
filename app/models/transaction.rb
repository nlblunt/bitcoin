class Transaction < ApplicationRecord
	#Validate the transaction to ensure the user still has enough credits
	#If another transaction comes through to create a negative balance,
	#cancel this transaction
	def NewTransaction(from_id, to_id, amount)
		self.from_id = from_id
		self.to_id = to_id
		self.amount = amount
		self.save

		#Check to see if this transaction puts user credit balance negative.
		#If so, another transaction cleared prior to this.
		#Delete this transaction from the database
		user = User.find_by(id: from_id)
		if user.GetCreditTotal < 0
			self.delete
			return :error
		else
			return :success
		end
	end
end
