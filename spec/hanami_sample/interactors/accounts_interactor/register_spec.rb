require_relative '../../../spec_helper.rb'

RSpec.describe AccountsInteractor::Register do
  before do
    user_repository.clear
    account_repository.clear
  end

  let(:interactor) { AccountsInteractor::Register.new(params, user_repository: user_repository, account_repository: account_repository) }
  let(:user_repository) { UserRepository.new }
  let(:account_repository) { AccountRepository.new }

  describe '#call' do
    subject { interactor.call }

    context "with valid parameters" do
      let(:params) { { name: "Alice", "email": "alice@example.com", screen_name: "alice", password: "TestP@ssw0rd" } }

      it { is_expected.to be_successful }
      it "should have no errors" do
        expect(subject.errors).to be_empty
      end
      it "increase the total number of registered users" do
        expect{ subject }.to change{ user_repository.all.count }.by(1)
      end
      it "increase the total number of registered accounts" do
        expect{ subject }.to change{ account_repository.all.count }.by(1)
      end
    end

    context "with no name" do
      let(:params) { { "email": "alice@example.com", screen_name: "alice", password: "TestP@ssw0rd" } }

      it { is_expected.to_not be_successful }
      it "should have errors" do
        expect(subject.errors).to_not be_empty
      end
      it "does not increase the total number of registered users" do
        expect{ subject }.to change{ user_repository.all.count }.by(0)
      end
      it "does not increase the total number of registered accounts" do
        expect{ subject }.to change{ account_repository.all.count }.by(0)
      end
    end

    context "with no email" do
      let(:params) { { name: "Alice", screen_name: "alice", password: "TestP@ssw0rd" } }

      it { is_expected.to_not be_successful }
      it "should have errors" do
        expect(subject.errors).to_not be_empty
      end
      it "does not increase the total number of registered users" do
        expect{ subject }.to change{ user_repository.all.count }.by(0)
      end
      it "does not increase the total number of registered accounts" do
        expect{ subject }.to change{ account_repository.all.count }.by(0)
      end
    end

    context "with no screen name" do
      let(:params) { { name: "Alice", "email": "alice@example.com", password: "TestP@ssw0rd" } }

      it { is_expected.to_not be_successful }
      it "should have errors" do
        expect(subject.errors).to_not be_empty
      end
      it "does not increase the total number of registered users" do
        expect{ subject }.to change{ user_repository.all.count }.by(0)
      end
      it "does not increase the total number of registered accounts" do
        expect{ subject }.to change{ account_repository.all.count }.by(0)
      end
    end

    context "with no password" do
      let(:params) { { name: "Alice", "email": "alice@example.com", screen_name: "alice" } }

      it { is_expected.to_not be_successful }
      it "should have errors" do
        expect(subject.errors).to_not be_empty
      end
      it "does not increase the total number of registered users" do
        expect{ subject }.to change{ user_repository.all.count }.by(0)
      end
      it "does not increase the total number of registered accounts" do
        expect{ subject }.to change{ account_repository.all.count }.by(0)
      end
    end
  end
end
