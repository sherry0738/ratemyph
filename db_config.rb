require 'pg'
require 'active_record'

options = {
	adapter: 'postgresql',
	database: 'dejtrt7qqtlea5',
	host: 'ec2-54-197-233-123.compute-1.amazonaws.com',
	port: 5432,  
	username:'qrgcvidzgleqjy',   
	password: 'ea8cd2efbdd1f98c9b5c070fb41e3c3f64ca7ce8ec562ff8db72e49b007af43a', 
}

ActiveRecord::Base.establish_connection(options)
