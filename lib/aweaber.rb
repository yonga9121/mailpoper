require 'oauth2'
require 'httparty'

class Aweaber
    include HTTParty
    SITE_URL = "https://auth.aweber.com".freeze
    AUTH_URL = '/oauth2/authorize'.freeze
    TOKEN_URL = '/oauth2/token'.freeze
    REDIRECT_URI = 'https://mailpoper.herokuapp.com/oauth/auth'.freeze
    CLIENT_ID = ENV["AWEABER_CLIENT_ID"].freeze
    CLIENT_SECRET = ENV["AWEABER_CLIENT_SECRET"].freeze
    BASE_URL = 'https://api.aweber.com/1.0'.freeze

    base_uri BASE_URL
    ACCOUNTS_URL = "/accounts"
    LISTS_URL = "/accounts/:account_id/lists"
    ADD_CUSTOM_FIELD_URL = "https://api.aweber.com/1.0/accounts/:account_id/lists/:list_id/custom_fields"
    ADD_SUBSCRIBER_URL = "https://api.aweber.com/1.0/accounts/:account_id/lists/:list_id/subscribers"
    
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
        str = @oauth_client.auth_code.authorize_url(redirect_uri: REDIRECT_URI, scope: SCOPE)
    end 

    def token(code)
        @oauth_client.auth_code.get_token(code, redirect_uri: REDIRECT_URI)
    end 

    def refresh!(access_token, refresh_token)
        oauth_token = OAuth2::AccessToken.new(
            @oauth_client,
            access_token,
            {
                refresh_token: refresh_token,
                scope: SCOPE
            }
        )
        oauth_token.refresh!(scopes: SCOPE)
    end 

    def accounts(access_token)
        response = parse_response(
            get_request(
                ACCOUNTS_URL,
                {},
                {
                    "Authorization": "Bearer #{access_token}"
                }
            )
        )
        response
    end 

    def lists(account_id, access_token)
        response = parse_response(
            get_request(
                LISTS_URL.gsub(/\:account_id/, account_id.to_s),
                {},
                {
                    "Authorization": "Bearer #{access_token}"
                }
            )
        )
        response
    end

    def add_custom_field(account_id, list_id, custom_field_name, access_token)
        response = parse_response(
            post_request(
                ADD_CUSTOM_FIELD_URL.gsub(/\:account_id/, account_id.to_s).gsub(/\:list_id/,list_id.to_s),
                {
                    "name": "#{custom_field_name}",
                    "ws.op": "create"
                },
                {
                    "Authorization": "Bearer #{access_token}"
                }
            )
        )
        response
    end 

    def add_subscriber(account_id, list_id, custom_fields, email, name, access_token)
        response = parse_response(
            post_request(
                ADD_SUBSCRIBER_URL.gsub(/\:account_id/, account_id.to_s).gsub(/\:list_id/,list_id.to_s),
                {
                    "email": email.to_s,
                    "name": name.to_s,
                    "custom_fields": custom_fields
                },
                {
                    "Authorization": "Bearer #{access_token}"
                }
            )
        )
        response
    end 

    def get_request(service_url, query = {}, headers = {})
        headers['Content-Type'] = 'application/json'
        self.class.get(
            URI.escape(service_url),
            body: query.to_json,
            headers: headers
        )
    end 
    
    def post_request(service_url, params = {}, headers = {})
        headers['Content-Type'] = 'application/json'
        response = self.class.post(
            service_url,
            body: params.to_json,
            headers: headers
        )
    end 

    def parse_response(httparty_response)
        if !["200", "201", "204"].include? httparty_response.response.code.to_s
          return {}
        end
        httparty_response&.try(:deep_symbolize_keys)
    end

end 