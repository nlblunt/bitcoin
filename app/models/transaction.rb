class Transaction < ApplicationRecord

	def NewTransaction(from_id, to_id, amount)
		self.from_id = from_id
		self.to_id = to_id
		self.amount = amount
		self.save
	end
end
