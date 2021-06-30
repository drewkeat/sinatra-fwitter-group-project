require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, "generate_security"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :'index'
  end

  get '/signup' do
    redirect '/tweets'if session[:user_id]
    erb :signup
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect '/signup'
    end
    @user = User.create(params)
    session[:user_id] = @user.id
    redirect '/tweets'
  end

  get '/login' do
    if session[:user_id]
      redirect '/tweets'
    end
    erb :'login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
    else
      redirect '/login'
    end
    redirect '/tweets'
  end

  get '/logout' do
    if !logged_in?
      redirect '/'
    end
    session.clear
    redirect '/login'
  end

  helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end

  
end
