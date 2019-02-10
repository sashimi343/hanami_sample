RSpec.describe Api::Controllers::Users::Create, type: :action do
  let(:action) { described_class.new }
  subject(:response) { action.call(params) }

  context "when parameter is valid" do
    let(:params) { { name: "Alice", email: "alice@example.com", screen_name: "alice", password: "TestP@ssw0rd" } }

    it "is successful" do
      expect(subject[0]).to be(200)
    end
  end
end
