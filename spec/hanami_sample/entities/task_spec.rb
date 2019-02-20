RSpec.describe Task, type: :entity do
  let(:task) { Task.new(params) }
  let(:tomorrow) { Time.now + 1 * 24 * 60 * 60 }
  let(:yesterday) { Time.now - 1 * 24 * 60 * 60 }
  
  describe '#overdue?' do
    subject { task.overdue? }

    context "when deadline is tomorrow" do
      let(:params) { { title: "Run a test", description: "bundle exec rake", deadline: tomorrow, closed_at: nil } }

      it { is_expected.to be_falsey }
    end

    context "when deadline is yesterday" do
      let(:params) { { title: "Run a test", description: "bundle exec rake", deadline: yesterday, closed_at: nil } }

      it { is_expected.to be_truthy }
    end

    context "when deadline is not set" do
      let(:params) { { title: "Run a test", description: "bundle exec rake", deadline: nil, closed_at: nil } }

      it { is_expected.to be_falsey }
    end
  end

  describe '#done?' do
    subject { task.done? }

    context "when finished date is tomorrow" do
      let(:params) { { title: "Run a test", description: "bundle exec rake", deadline: nil, closed_at: tomorrow } }

      it { is_expected.to be_falsey }
    end

    context "when finished date is yesterday" do
      let(:params) { { title: "Run a test", description: "bundle exec rake", deadline: nil, closed_at: yesterday } }

      it { is_expected.to be_truthy }
    end

    context "when finished date is not set" do
      let(:params) { { title: "Run a test", description: "bundle exec rake", deadline: nil, closed_at: nil } }

      it { is_expected.to be_falsey }
    end
  end
end
