class OauthController < ApplicationController

    def auth 
        AweaberAccount.from_code(params[:code])
        render json: :ok
    end 

end
