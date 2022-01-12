module Errors

    class GenericError < StandardError
        attr_accessor :error, :status, :message, :data
        def initialize(error: nil, status: nil, message: nil, data: [])
            @error = error || 422
            @status = status || :unprocessable_entity
            @message = message || "Oops something went wrong"
            @data = data || []
        end
    end
    
    module User
        class EmailOrPhoneAlreadyTaken < GenericError

            def initialize
                super(
                    error: 422,
                    status: :unprocessable_entity,
                    message: "Email or phone already taken. Please try a different one"
                )
            end 

        end 

        class EmailNotValid < GenericError
            def initialize
                super(
                    error: 422,
                    status: :unprocessable_entity,
                    message: "Email is invalid. Should match the format something@valid.com"
                )
            end 
        end 

        class PhoneNotValid < GenericError
            def initialize
                super(
                        error: 422,
                        status: :unprocessable_entity,
                        message: "Phone is invalid. Min length is 10. Only valid numeric characters are allowed"
                )
            end 
        end 
    end 
end 