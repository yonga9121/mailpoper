class AweaberAccount
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    field :access_token
    field :refresh_token
    field :expires_in
    field :account_id
    field :list_id

    def self.authorize
        aweaber_client.authorize
    end

    def self.from_code(code)
        oauth_access_token = aweaber_client.token(code)
        if oauth_access_token
            new_acc = new(
                access_token: oauth_access_token.token,
                refresh_token: oauth_access_token.refresh_token,
                expires_in: oauth_access_token.expires_in.to_i
            )
            aux_accounts = new_acc.accounts
            new_acc.account_id = aux_accounts[:entries].last[:id]
            aux_lists = new_acc.lists
            new_acc.list_id = aux_lists[:entries].last[:id]
            new_acc.save!
            new_acc.add_send_information_status_field
        end 
    end

    def expired?
        return false if !self.persisted?
        self.updated_at.utc + self.expires_in.seconds < Time.now.utc
    end 

    def refresh
        oauth_access_token = aweaber_client.refresh!(access_token,refresh_token)
        if oauth_access_token
            self.update!(
                access_token: oauth_access_token.token,
                refresh_token: oauth_access_token.refresh_token,
                expires_in: oauth_access_token.expires_in.to_i
            )
        end 
        self
    end

    def accounts
        self.refresh if self.expired?
        aweaber_client.accounts(self.access_token)
    end 

    def lists
        self.refresh if self.expired?
        aweaber_client.lists(self.account_id,self.access_token)
    end 

    def add_send_information_status_field
        self.refresh if self.expired?
        aweaber_client.add_custom_field(self.account_id,self.list_id, "send-information-status", self.access_token)
    end 

    def add_subscriber(user)
        self.refresh if self.expired?
        custom_fields = { "send-information-status": user.send_info ? 'opted-in' : ''}
        aweaber_client.add_subscriber(
            account_id,
            list_id,
            custom_fields,
            user.email, 
            user.name,
            access_token
        )
    end 

    private

    def self.aweaber_client
        @@aweaber_client ||= Aweaber.new
    end 

    def aweaber_client
        @@aweaber_client ||= Aweaber.new
    end 

end 