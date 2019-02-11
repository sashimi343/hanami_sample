RSpec.describe Api::Views::Users::Create, type: :view do
  let(:user) { double("user", id: 1, name: "Alice", email: "alice@example.com", created_at: Time.now, updated_at: Time.now) }
  let(:account) { double("account", screen_name: "alice", password: "Encrypted$P@ssw0rd", password_digest: "Encrypted$P@ssw0rd") }
  let(:exposures) { { user: user, account: account } }
  let(:errors) { { name: ["is missing"] } }

  let(:template)  { Hanami::View::Template.new('apps/api/templates/users/create.json.jbuilder') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  describe '#render' do
    subject{ JSON.parse(rendered) }

    it "contains the information about registered user" do
      is_expected.to have_key("id")
      is_expected.to have_key("name")
      is_expected.to have_key("email")
      is_expected.to have_key("screen_name")
      is_expected.to have_key("created_at")

      expect(subject["id"]).to eq(user.id)
      expect(subject["name"]).to eq(user.name)
      expect(subject["email"]).to eq(user.email)
      expect(subject["screen_name"]).to eq(account.screen_name)
      expect(subject["created_at"]).to eq(user.created_at.to_s)
    end

    it "does not contain the password or password_digest" do
      is_expected.to_not have_key("password")
      is_expected.to_not have_key("password_digest")
    end
  end
end
