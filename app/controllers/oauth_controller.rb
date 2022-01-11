class OauthController < ApplicationController

    def auth 
        AweaberAccount.from_code(params[:code])
    end 

end
