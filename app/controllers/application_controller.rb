class ApplicationController < ActionController::API

    def current_account
        @current_account ||= AweaberAccount.last
        check_account
    end 

    def check_account
        if @current_account
            if @current_account.created_at + @current_account.expires_in.seconds > Time.now
                return @current_account.refresh!
            else 
                return @current_account
            end 
        else
            url = AweaberAccount.authorize
            render json: { 
                mssg: "Please login into Aweaber",
                url: url
            }
        end 
    end 
end
