class ApplicationController < ActionController::API
    include ErrorHandler

    private 


    def current_account
        @current_account ||= AweaberAccount.last
        check_account
    end 

    def check_account
        if @current_account
            if @current_account.expired?
                return @current_account.refresh
            else 
                return @current_account
            end 
        else
            url = AweaberAccount.authorize
            render json: JSON.generate( { 
                mssg: "Please login into Aweaber",
                url: url
            })
        end 
    end 
end
