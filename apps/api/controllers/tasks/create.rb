module Api
  module Controllers
    module Tasks
      class Create
        include Api::Action

        before :authenticate!
        expose :task

        params do
          required(:title).filled
          optional(:detail).maybe(:str?)
          optional(:deadline).maybe(:time?)
        end

        def call(params)
          interactor = MyTasksInteractor::Add.new(interactor_params(params))
          result = interactor.call

          raise HanamiSample::Error::ParameterInvalidError.new(result.errors) if interactor.validation_failed?
          if result.success?
            @task = result.task
          else
            raise HanamiSample::Error::UnprosessableEntityError.new("task", result.errors)
          end
        end

        def interactor_params(params)
          params.to_h.merge({ author: @current_user })
        end
      end
    end
  end
end
