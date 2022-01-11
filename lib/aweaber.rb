require 'oauth2'
require 'net/http'


class Aweaber
    SITE_URL = "https://auth.aweber.com".freeze
    AUTH_URL = '/oauth2/authorize'.freeze
    TOKEN_URL = '/oauth2/token'.freeze
    REDIRECT_URI = 'https://mailpoper.herokuapp.com/auth'.freeze
    CLIENT_ID = ENV["AWEABER_CLIENT_ID"].freeze
    CLIENT_SECRET = ENV["AWEABER_CLIENT_SECRET"].freeze
    
    SCOPE = [
        'account.read',
        'list.read',
        'list.write',
        'subscriber.read',
        'subscriber.write',
        'email.read',
        'email.write',
        'subscriber.read-extended',
        'landing-page.read'
    ].join(" ").freeze

    def initialize
        @oauth_client = OAuth2::Client.new(
            CLIENT_ID, 
            CLIENT_SECRET, 
            :site => SITE_URL,
            :authorize_url => AUTH_URL,
            :token_url => TOKEN_URL,
            :scope => SCOPE
        )
    end

    def authorize
        str = @oauth_client.auth_code.authorize_url(redirect_uri: REDIRECT_URI, SCOPE: SCOPE)
    end 

    def token
        puts @oauth_client.auth_code.get_token(code, redirect_uri: REDIRECT_URI)
    end 

    def refresh
    end 

end 