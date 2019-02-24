RSpec.describe Api::Controllers::Tasks::Create, type: :action do
  before(:all) do
    profile = { name: "Alice", email: "alice1234@example.com", screen_name: "alice1234", password: "P@ssw0rd" }
    result = AccountsInteractor::Register.new(profile).call
    @author = result.user
  end

  after(:all) do
    TaskRepository.new.clear
    AccountRepository.new.clear
    UserRepository.new.clear
  end

  let(:action) { described_class.new }
  let(:format) { "application/json" }
  let(:content_type) { "#{format}; charset=utf-8" }
  let(:author) { @author }
  let(:tomorrow) { Time.now + 1 * 24 * 60 * 60 }

  describe '#call' do
    subject { action.call(params) }

    context "when user has logged in" do
      before { action.instance_variable_set("@current_user", @author) }
      let(:params) { { title: "Run a test", detail: "bundle exec rake", deadline: tomorrow.to_s } }

      it "is successful" do
        expect(subject[0]).to eq(200)
        expect(subject[1]['Content-Type']).to eq(content_type)
      end
      it "returns created task" do
        subject
        task = action.task
        expect(task).to be_an_instance_of(Task)
        expect(task.title).to eq(params[:title])
        expect(task.detail).to eq(params[:detail])
        expect(task.deadline).to be_within(1).of(tomorrow)
      end
    end
  end
end
