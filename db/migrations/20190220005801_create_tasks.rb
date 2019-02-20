Hanami::Model.migration do
  change do
    create_table :tasks do
      primary_key :id

      foreign_key :author_id, :users, on_delete: :cascade, null: false

      column :title, String, null: false
      column :detail, String, null: false
      column :deadline, DateTime
      column :closed_at, DateTime

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
