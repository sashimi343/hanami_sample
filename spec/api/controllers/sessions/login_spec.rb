RSpec.describe Api::Controllers::Sessions::Login, type: :action do
  before(:all) do
    AccountsInteractor::Register.new(name: "Bob", email: "bob@example.com", screen_name: "bob1234", password: "P@ssw0rd").call
  end

  after(:all) do
    UserRepository.new.clear
    AccountRepository.new.clear
  end

  let(:action) { described_class.new }
  let(:format) { "application/json" }
  let(:content_type) { "#{format}; charset=utf-8" }

  describe '#call' do
    subject { action.call(params) }

    context "when screen_name and password are both correct" do
      let(:params) { { screen_name: "bob1234", password: "P@ssw0rd" } }

      it "is successful" do
        expect(subject[0]).to eq(200)
        expect(subject[1]['Content-Type']).to eq(content_type)
      end

      it "exposes the authenticated user" do
        subject
        authenticated_user = action.authenticated_user
        expect(authenticated_user).to be_an_instance_of(User)
        expect(authenticated_user.name).to eq("Bob") 
        expect(authenticated_user.email).to eq("bob@example.com")
      end
    end

    context "when screen_name is incorrect" do
      let(:params) { { screen_name: "booboo", password: "P@ssw0rd" } }

      it "fails with HTTP 403 Forbidden" do
        expect(subject[0]).to eq(403)
        expect(subject[1]['Content-Type']).to eq(content_type)
      end

      it "does not return authenticated user" do
        subject
        expect(action.authenticated_user).to be_nil
      end
    end

    context "when password is incorrect" do
      let(:params) { { screen_name: "bob1234", password: "booboo" } }

      it "fails with HTTP 403 Forbidden" do
        expect(subject[0]).to eq(403)
        expect(subject[1]['Content-Type']).to eq(content_type)
      end

      it "does not return authenticated user" do
        subject
        expect(action.authenticated_user).to be_nil
      end
    end

    context "when parameters are missing" do
      let(:params) { {} }

      it "fails with HTTP 403 Forbidden" do
        expect(subject[0]).to eq(403)
        expect(subject[1]['Content-Type']).to eq(content_type)
      end

      it "does not return authenticated user" do
        subject
        expect(action.authenticated_user).to be_nil
      end
    end
  end
end
