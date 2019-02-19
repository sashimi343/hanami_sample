require_relative '../../../spec_helper.rb'

RSpec.describe ProfilesInteractor::Show do
  before(:all) do
    @profile = { name: "Alice", email: "alice1234@example.com", screen_name: "alice1234", password: "P@ssw0rd" }
    AccountsInteractor::Register.new(@profile).call
  end

  after(:all) do
    AccountRepository.new.clear
    UserRepository.new.clear
  end

  let(:interactor) { ProfilesInteractor::Show.new(params) }
  let(:profile) { @profile }

  describe '#call' do
    subject { interactor.call }

    context "when user exists" do
      let(:params) { { user_id: AccountRepository.new.find_by_screen_name(profile[:screen_name]).user_id } }

      it { is_expected.to be_successful }

      it "returns information about specified user" do
        user = subject.user
        account = subject.account

        expect(user.name).to eq(profile[:name])
        expect(user.email).to eq(profile[:email])
        expect(account.screen_name).to eq(profile[:screen_name])
      end
    end

    context "when user does not exist" do
      let(:params) { { user_id: -1234 } }

      it { is_expected.to_not be_successful }

      it "shows error message" do
        expect(subject.errors).to_not be_empty
      end

      it "does not return any user/account informationo" do
        expect(subject.user).to be_nil
        expect(subject.account).to be_nil
      end
    end

    context "when user_id is not specified" do
      let(:params) { {} }

      it "fails with validation error" do
        subject
        expect(interactor.validation_failed?).to be_truthy
        expect(subject.errors).to_not be_empty
      end

      it "does not return any user/account informationo" do
        expect(subject.user).to be_nil
        expect(subject.account).to be_nil
      end
    end
  end
end
