require_relative '../../../spec_helper.rb'

RSpec.describe AccountsInteractor::Authenticate do
  before(:all) do
    AccountsInteractor::Register.new(name: "Bob", email: "bob@example.com", screen_name: "bob1234", password: "P@ssw0rd").call
  end

  after(:all) do
    UserRepository.new.clear
    AccountRepository.new.clear
  end

  let(:interactor) { AccountsInteractor::Authenticate.new(params) }

  describe '#call' do
    subject { interactor.call }

    context "when screen_name and password are both correct" do
      let(:params) { { screen_name: "bob1234", password: "P@ssw0rd" } }

      it { is_expected.to be_successful }
      it "has no errors" do
        expect(subject.errors).to be_empty
      end
      it "returns authenticated user" do
        authenticated_user = subject.authenticated_user

        expect(authenticated_user).to be_instance_of(User)
        expect(authenticated_user.name).to eq("Bob")
        expect(authenticated_user.email).to eq("bob@example.com")
      end
    end

    context "when password is incorrect" do
      let(:params) { { screen_name: "bob1234", password: "booboo" } }

      it { is_expected.to_not be_successful }
      it "has errors" do
        expect(subject.errors).to_not be_empty
      end
      it "does not return authenticated user" do
        authenticated_user = subject.authenticated_user

        expect(authenticated_user).to be_nil
      end
    end

    context "when screen_name is incorrect" do
      let(:params) { { screen_name: "booboo", password: "P@ssw0rd" } }

      it { is_expected.to_not be_successful }
      it "has errors" do
        expect(subject.errors).to_not be_empty
      end
      it "does not return authenticated user" do
        authenticated_user = subject.authenticated_user

        expect(authenticated_user).to be_nil
      end
    end

    context "when parameters are missing" do
      let(:params) { {} }

      it { is_expected.to_not be_successful }
      it "has errors" do
        expect(subject.errors).to_not be_empty
      end
      it "fails with validation error" do
        subject
        expect(interactor.validation_failed?).to be_truthy
      end
      it "does not return authenticated user" do
        authenticated_user = subject.authenticated_user

        expect(authenticated_user).to be_nil
      end
    end
  end
end
