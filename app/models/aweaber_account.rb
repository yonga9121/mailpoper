class AweaberAccount
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    field :access_token
    field :refresh_token
    field :expires_in


    def self.authorize
        client = Aweaber.new
        client.authorize
    end

    def self.from_code(code)
        client = Aweaber.new
        oauth_access_token = client.token(code)
        if oauth_access_token
            self.create!(
                access_token: oauth_access_token.token,
                refresh_token: oauth_access_token.refresh_token,
                expires_in: oauth_access_token.expires_in.to_i
            )
        end 
    end

    def expired?
        self.updated_at.utc + self.expires_in.seconds > Time.now.utc
    end 

    def refresh
        client = Aweaber.new
        oauth_access_token = client.refresh!(access_token,refresh_token)
        if oauth_access_token
            self.update!(
                access_token: oauth_access_token.token,
                refresh_token: oauth_access_token.refresh_token,
                expires_in: oauth_access_token.expires_in.to_i
            )
        end 
        self
    end

end 