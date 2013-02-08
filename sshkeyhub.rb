require 'rubygems'
require 'sinatra'
require 'oauth2' # ~> 0.5.0
require 'json'

def client
  OAuth2::Client.new(ENV['SSHKEYHUB_ID'], ENV['SSHKEYHUB_SECRET'],
                     :ssl => {:ca_file => '/etc/ssl/ca-bundle.pem'},
                     :site => 'https://api.github.com',
                     :authorize_url => 'https://github.com/login/oauth/authorize',
                     :token_url => 'https://github.com/login/oauth/access_token')
end

get "/" do
  erb :index
end

get '/auth/github' do
  url = client.auth_code.authorize_url(:redirect_uri => redirect_uri, :scope => 'user')
  redirect url
end

get '/auth/github/callback' do
  puts params[:code]
  begin
    access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
    @user = JSON.parse(access_token.get('/user').body)
    @login = @user['login']
    @keys = JSON.parse(access_token.get("/users/#{@login}/keys").body)
    erb :success
  rescue OAuth2::Error => e
    @error = "Oops - please try again."
    erb :index
  end
end

def redirect_uri(path = '/auth/github/callback', query = nil)
  uri = URI.parse(request.url)
  uri.path  = path
  uri.query = query
  uri.to_s
end