Hanami::Model.migration do
  change do
    create_table :accounts do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade, null: false

      column :screen_name, String, null: false, unique: true
      column :password_digest, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
