class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.references :referred_by, foreign_key: { to_table: :users }
      t.string :referral_code
      t.timestamps
    end
    add_index :users, :email_address, unique: true
    add_index :users, :referral_code, unique: true
  end
end
