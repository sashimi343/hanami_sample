require 'hanami/validations'
require_relative '../validatable_interactor.rb'

module MyTasksInteractor
  class Add < HanamiSample::ValidatableInteractor
    class Validation
      include Hanami::Validations

      validations do
        required(:author) { filled? and type?(User) }
        required(:title) { filled? and str? and min_size?(1) }
        optional(:detail).maybe(:str?)
        optional(:deadline).maybe(:time?)
      end
    end

    expose :task

    def initialize(params = {}, user_repository = UserRepository.new)
      @user_repository = user_repository
      super(params)
    end

    def call()
      author = @params[:author]
      error!("user #{@params[:author_id]} does not exist") if author.nil?
      
      @params[:detail] ||= ""
      @params[:closed_at] = nil   # new task should not be closed
      @task = @user_repository.add_task(author, @params)
    end
  end
end
