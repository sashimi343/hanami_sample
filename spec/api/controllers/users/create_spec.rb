RSpec.describe Api::Controllers::Users::Create, type: :action do
  before do
    AccountRepository.new.clear
    UserRepository.new.clear
  end

  let(:action) { described_class.new }
  let(:format) { "application/json" }
  let(:content_type) { "#{format}; charset=utf-8" }
  subject{ action.call(params) }

  context "when parameter is valid" do
    let(:params) { { name: "Alice", email: "alice@example.com", screen_name: "alice", password: "TestP@ssw0rd" } }

    it "is successful" do
      expect(subject[0]).to eq(200)
      expect(subject[1]['Content-Type']).to eq(content_type)
    end

    it "exposes the information about registered user" do
      subject
      expect(action.user).to be_an_instance_of(User)
      expect(action.user.name).to eq(params[:name])
      expect(action.user.email).to eq(params[:email])

      expect(action.account).to be_an_instance_of(Account)
      expect(action.account.screen_name).to eq(params[:screen_name])
    end
  end

  context "when parameter is missing" do
    let(:params) { {} }

    it "fails with HTTP 400 Bad Request" do
      expect(subject[0]).to eq(400)
      expect(subject[1]['Content-Type']).to eq(content_type)
    end
  end
end
