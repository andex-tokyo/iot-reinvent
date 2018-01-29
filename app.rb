require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models'

enable :sessions

get '/' do
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

get '/post' do
    erb :post
end

post '/post' do
        author = Author.find_by(name: params[:author])
        if author != nil
            Post.create(userid: session[:user],authorid: author.id,url: params[:url],comment: params[:comment])
        else
            author = Author.create(name: params[:author])
            Post.create(userid: session[:user],authorid: author.id,url: params[:url],comment: params[:comment])
        end
            
end

