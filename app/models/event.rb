class Event < ActiveRecord::Base
	has_many :eventusers
	has_many :teamevents
	attr_accessor :userss,:teamss


	def self.search(search)
	  if search
	    where('lower(name) LIKE ? or lower(venue) LIKE ?', "%#{search}%","%#{search}%")
	  else
	    all
	  end
	end


end
