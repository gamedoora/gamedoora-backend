class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|

      # unique uid for user
      t.string :uid, length: 11

      # user basic details columns
      t.string :first_name, length: 128, null: false
      t.string :middle_name, length: 128
      t.string :last_name, length: 128
      t.string :email, null: false
      t.string :password_digest, null: false
      t.datetime :dob
      t.integer :is_active, limit: 1, default: 1
      t.integer :is_deleted, limit: 1, default: 0

      # track user sign in
      t.bigint :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip, length: 64
      t.string :last_sign_in_ip, length: 64

      # confirmation
      t.string :confirmation_token, length: 64
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      # omniauth columns
      t.string :provider_name, length: 64
      t.string :provider_uid, length: 64

      # recoverable
      t.string :reset_password_token, length: 64
      t.datetime :reset_password_sent_at

      t.timestamps
    end

    # unique indexes
    add_index :users, :uid, name: "index_users_on_uid", unique: true
    add_index :users, :email, name: "index_users_on_email", unique: true
    add_index :users, :confirmation_token, name: "index_users_on_confirmation_token", unique: true
    add_index :users, :reset_password_token, name: "index_users_on_reset_password_token", unique: true

    # added index on fields to increase searching
    add_index :users, :first_name, name: "index_users_on_first_name"
    add_index :users, :middle_name, name: "index_users_on_middle_name"
    add_index :users, :last_name, name: "index_users_on_last_name"
    add_index :users, :is_active, name: "index_users_on_is_active"

  end
end
