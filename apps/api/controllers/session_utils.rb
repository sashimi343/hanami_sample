module Web
  module SessionUtils

    private

    def authenticate!()
      raise HanamiSample::Error::AuthenticationError.new("you are not logged in") unless current_user
    end

    def current_user() 
      @current_user ||= session[:current_user]
    end
  end
end
