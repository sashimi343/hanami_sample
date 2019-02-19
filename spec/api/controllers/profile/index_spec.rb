RSpec.describe Api::Controllers::Profile::Index, type: :action do
  before(:all) do
    @profile = { name: "Alice", email: "alice1234@example.com", screen_name: "alice1234", password: "P@ssw0rd" }
    result = AccountsInteractor::Register.new(@profile).call
    @user = result.user
    @account = result.account
  end

  after(:all) do
    AccountRepository.new.clear
    UserRepository.new.clear
  end

  let(:action) { described_class.new }
  let(:params) { Hash[] }
  let(:format) { "application/json" }
  let(:content_type) { "#{format}; charset=utf-8" }
  let(:profile) { @profile }
  let(:user) { @user }
  let(:account) { @account }

  describe '#call' do
    subject { action.call(params) }

    context "when user has logged in" do
      before { action.instance_variable_set("@current_user", @user) }

      it "is successful" do
        expect(subject[0]).to eq(200)
        expect(subject[1]['Content-Type']).to eq(content_type)
      end

      it "returns user/account information" do
        subject
        expect(action.user).to be_an_instance_of(User)
        expect(action.account).to be_an_instance_of(Account)
        expect(action.user.id).to eq(user.id)
        expect(action.user.name).to eq(user.name)
        expect(action.user.email).to eq(user.email)
        expect(action.account.screen_name).to eq(account.screen_name)
      end
    end

    context "when user has not logged in yet" do
      before { action.instance_variable_set("@current_user", nil) }

      it "fails with HTTP 403 Forbidden" do
        expect(subject[0]).to eq(403)
        expect(subject[1]['Content-Type']).to eq(content_type)
      end

      it "does not return user/account information" do
        subject
        expect(action.user).to be_nil
        expect(action.account).to be_nil
      end
    end
  end
end
