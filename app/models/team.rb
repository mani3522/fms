class Team < ActiveRecord::Base
	has_many :events, :through => :teamevents
	has_many :teamusers

	attr_accessor :userss
end
