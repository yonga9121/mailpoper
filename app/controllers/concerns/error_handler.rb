module ErrorHandler
    extend  ActiveSupport::Concern

    def self.included(clazz)
        clazz.class_eval do
            rescue_from Errors::GenericError do |e|
                respond(e.status, e.message, e&.data)
            end
        end 
    end

    private 

    def respond(status, message, data)
        aux_response = { mssg: message }
        aux_response.merge!({data: data})
        render json: aux_response, status: status
    end
end 