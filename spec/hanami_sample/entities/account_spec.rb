require 'bcrypt'
require_relative '../../spec_helper.rb'

RSpec.describe Account, type: :entity do
  let(:params) { { screen_name: "alice", password: "TestP@ssw0rd" } }
  let(:account) { Account.new(params) }
  subject { account }

  its(:screen_name) { is_expected.to eq params[:screen_name] }
  its(:password) { is_expected.to be_an_instance_of(BCrypt::Password) }
  its(:password_digest) { is_expected.to be_an_instance_of(BCrypt::Password) }
end
