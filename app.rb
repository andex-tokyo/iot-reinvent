require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models'

enable :sessions

get '/' do
    @records = Record.all
    erb :index
end

get '/signin' do
    erb :sign_in
end

get '/signup' do
    erb :sign_up
end

post '/signin' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/'
end

post '/signup' do
    @user = User.create(name: params[:name],password: params[:password],password_confirmation: params[:password_confirmation])
    if @user.persisted?
        session[:user] = @user.id
    end
    redirect '/'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end

get '/send' do
    record = Record.find_by(name: params[:name])
    if record
        if record.status == true
            record.status = false
            record.save
            elsif record.status == false
            record.status = true
            record.save
        end
        
    else
        Record.create(name:params[:name],status:false)
    end
end
