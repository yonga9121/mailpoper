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

    def self.from_oauth(code)
        client = Aweaber.new
        client.token
    end

end 