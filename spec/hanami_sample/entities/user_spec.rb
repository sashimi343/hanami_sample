require_relative '../../spec_helper.rb'

RSpec.describe User, type: :entity do
  let(:params) { { name: "Alice", email: "alice@example.com" } }
  let(:user) { User.new(params) }
  subject { user }

  its(:name) { is_expected.to eq params[:name] }
  its(:email) { is_expected.to eq params[:email] }
end
