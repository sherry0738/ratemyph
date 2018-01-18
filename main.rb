require 'sinatra'
require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'models/photographer'
require_relative 'models/comment'
require_relative 'models/user'

enable :sessions

helpers do 

	def current_user
		User.find_by(id: session[:user_id])
	end

	def loggen_in?
		!!current_user		
	end
end

get '/' do
	@photographers = Photographer.all 
	erb :index
end

get '/about' do
	erb :about
end

get '/search' do
	@photographers = Photographer.where(name: params[:photographer_name])
		
  	# conn = PG.connect(dbname: 'ratemyphotographer')
 	# resp = conn.excu()
	# conn.close

	# @photographers.each do |photographer|
	# 	photographer = Photographer.New 
		
	# 	Photographer.where(name: @photographer_title)
	# end	

	erb :search_result
end

get '/photographers/new' do
	erb :new
end

# add a new photographer to photographers table
post '/photographers' do
	photographer = Photographer.new
	photographer.name = params[:name]
	photographer.image_url = params[:image_url]
	photographer.save
	redirect '/'
end


get '/photographers/:id' do

	@photographer = Photographer.find(params[:id])
	
	# ?????   photographer.created_by = params[:]
	
	@comments = Comment.where(photographer_id: params[:id])
	erb :show
end

get '/photographers/:id/edit' do
	@photographer = Photographer.find(params[:id])
	erb :edit
end

put '/photographers/:id' do
	photographer = Photographer.find(params[:id]) #is this because missing @ front?
	photographer.name = params[:name]
	photographer.image_url = params[:image_url]
	photographer.phone = params[:phone]
	photographer.address = params[:address]
	photographer.website = params[:website]
	photographer.save
	redirect '/photographers/'+ photographer.id.to_s
end

post '/comments' do
	comment = Comment.new
	comment.content = params[:content]
	comment.photographer_id = params[:photographer_id]
	comment.created_by = session[:user_id]
	comment.created_at = params[:created_at]
	comment.save
	@comments = Comment.where(photographer_id: params[:id])
	# @comment_by = Comment.where(created_by: params[:id])
	redirect "/photographers/#{comment.photographer_id}" 
end

post '/rate' do
	
	redirect "/photographers/#{comment.photographer_id}"
end

delete '/photographers/:id' do	
	photographer = Photographer.find(params[:id])
	comments = Comment.where(photographer_id: params[:id])
	
	comments.each do |comment|
	comment.destroy
	end

	photographer.destroy
	redirect '/'
end

get '/signup' do
	erb :signup
end

post '/signup' do
	user = User.new
	user.name = params[:name]
	user.email = params[:email]
	user.password = params[:password]
	user.save
	session[:user_id] = user.id
	redirect '/'
end

get '/session' do
	redirect '/'
	end

post '/session' do
	user = User.find_by(email:params[:email])

	if user && user.authenticate(params[:password])
		session[:user_id] = user.id 
		redirect '/' 
	else
		redirect '/' 
	end
end

delete '/session' do
	session[:user_id] = nil
	redirect '/'
end
