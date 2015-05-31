class User < ActiveRecord::Base
	attr_accessor :password

	validates_presence_of :email, :password, :full_name
	validates_uniqueness_of :email
end
