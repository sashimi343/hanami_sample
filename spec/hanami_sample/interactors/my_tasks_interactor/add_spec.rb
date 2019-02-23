require_relative '../../../spec_helper.rb'

RSpec.describe MyTasksInteractor::Add do
  before(:all) do
    TaskRepository.new.clear
    AccountRepository.new.clear
    UserRepository.new.clear

    result = AccountsInteractor::Register.new({ name: "Alice", email: "alice1234@example.com", screen_name: "alice1234", password: "P@ssw0rd" }).call
  end

  after(:all) do
    TaskRepository.new.clear
    AccountRepository.new.clear
    UserRepository.new.clear
  end

  let(:interactor) { MyTasksInteractor::Add.new(params) }
  let(:task_repository) { TaskRepository.new }
  let(:author) { UserRepository.new.find_by_email("alice1234@example.com") }
  let(:tomorrow) { Time.now + 1 * 24 * 60 * 60 }
  let(:yesterday) { Time.now - 1 * 24 * 60 * 60 }

  describe '#call' do
    subject { interactor.call }

    context "when parameters are valid" do
      let(:params) { { author_id: author.id, title: "Run a test", detail: "bundle exec rake", deadline: tomorrow } }

      it { is_expected.to be_successful }
      it "should have no errors" do
        expect(subject.errors).to be_empty
      end
      it "increases the total number of tasks" do
        expect{ subject }.to change{ task_repository.all.count }.by(1)
      end
      it "returns added task" do
        task = subject.task

        expect(task).to be_an_instance_of(Task)
        expect(task.author_id).to eq(params[:author_id])
        expect(task.title).to eq(params[:title])
        expect(task.detail).to eq(params[:detail])
        expect(task.deadline).to be_within(1).of(params[:deadline])
      end
      it "adds task as undone" do
        expect(subject.task).to_not be_done
      end
    end

    context "when finished date is provided" do
      let(:params) { { author_id: author.id, title: "Run a test", detail: "bundle exec rake", deadline: tomorrow, closed_at: yesterday } }

      it { is_expected.to be_successful }
      it "should have no errors" do
        expect(subject.errors).to be_empty
      end
      it "increases the total number of tasks" do
        expect{ subject }.to change{ task_repository.all.count }.by(1)
      end
      it "returns added task" do
        task = subject.task

        expect(task).to be_an_instance_of(Task)
        expect(task.title).to eq(params[:title])
        expect(task.detail).to eq(params[:detail])
        expect(task.deadline).to be_within(1).of(params[:deadline])
      end
      it "adds task as undone" do
        expect(subject.task).to_not be_done
        expect(subject.task.closed_at).to be_nil
      end
    end

    context "when author does not exist" do
      let(:params) { { author_id: -1234, title: "Run a test", detail: "bundle exec rake", deadline: tomorrow } }

      it { is_expected.to_not be_successful }
      it "should have errors" do
        expect(subject.errors).to_not be_empty
      end
      it "does not increase the total number of tasks" do
        expect{ subject }.to change{ task_repository.all.count }.by(0)
      end
      it "does not return task" do
        expect(subject.task).to be_nil
      end
    end

    context "when title is missing" do
      let(:params) { { author_id: author.id, detail: "bundle exec rake", deadline: tomorrow } }

      it { is_expected.to_not be_successful }
      it "should have errors" do
        expect(subject.errors).to_not be_empty
      end
      it "does not increase the total number of tasks" do
        expect{ subject }.to change{ task_repository.all.count }.by(0)
      end
      it "does not return task" do
        expect(subject.task).to be_nil
      end
    end

    context "when detail is not provided" do
      let(:params) { { author_id: author.id, title: "Run a test", deadline: tomorrow } }

      it { is_expected.to be_successful }
      it "should have no errors" do
        expect(subject.errors).to be_empty
      end
      it "increases the total number of tasks" do
        expect{ subject }.to change{ task_repository.all.count }.by(1)
      end
      it "returns added task" do
        task = subject.task

        expect(task).to be_an_instance_of(Task)
        expect(task.title).to eq(params[:title])
        expect(task.deadline).to be_within(1).of(params[:deadline])
      end
      it "sets the detail to empty string" do
        task = subject.task

        expect(task.detail).to be_empty
      end
    end

    context "when deadline is not provided" do
      let(:params) { { author_id: author.id, title: "Run a test", detail: "bundle exec rake" } }

      it { is_expected.to be_successful }
      it "should have no errors" do
        expect(subject.errors).to be_empty
      end
      it "increases the total number of tasks" do
        expect{ subject }.to change{ task_repository.all.count }.by(1)
      end
      it "returns added task" do
        task = subject.task

        expect(task).to be_an_instance_of(Task)
        expect(task.title).to eq(params[:title])
        expect(task.detail).to eq(params[:detail])
      end
      it "sets the deadline to nil" do
        task = subject.task

        expect(task.deadline).to be_nil
      end
    end
  end
end
