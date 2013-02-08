require 'rubygems'
require 'sinatra'
require 'oauth2' # ~> 0.5.0
require 'json'
require 'sshkey'

def client
  OAuth2::Client.new(ENV['SSHKEYHUB_ID'], ENV['SSHKEYHUB_SECRET'],
                     :ssl => {:ca_file => '/etc/ssl/ca-bundle.pem'},
                     :site => 'https://api.github.com',
                     :authorize_url => 'https://github.com/login/oauth/authorize',
                     :token_url => 'https://github.com/login/oauth/access_token')
end

get "/" do
  @page_title = "Click to link your Github SSH keys to an email address."
  erb :index
end

get '/auth/github' do
  url = client.auth_code.authorize_url(:redirect_uri => redirect_uri, :scope => 'user')
  redirect url
end

# Search for the public key - render text only.
get '/:email' do
  # Clean up email params.
  # Search for name via email.
  # Display keys with fingerprint.
  # Else - display nothing.
end

get '/auth/github/callback' do
  puts params[:code]
  begin
    access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
    @user = JSON.parse(access_token.get('/user').body)
    @login = @user['login']
    keys_hash = JSON.parse(access_token.get("/users/#{@login}/keys").body)
    @keys = keys_to_fingerprint(keys_hash)
    @page_title = "Linked!"
    erb :success
  rescue OAuth2::Error => e
    @error = "Oops - please try again."
    @page_title = "Oops."
    erb :index
  end
end

def link_email_to_user(email, user)
  
end

def keys_to_fingerprint(keys_hash)
  keys = Hash.new
  keys_hash.each do |key|
    fingerprint = SSHKey.md5_fingerprint(key['key'])
    keys["#{fingerprint}"] = key['key']
  end
  keys
end

def redirect_uri(path = '/auth/github/callback', query = nil)
  uri = URI.parse(request.url)
  uri.path  = path
  uri.query = query
  uri.to_s
end