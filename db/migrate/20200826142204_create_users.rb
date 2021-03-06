class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.text :first_name
      t.text :last_name
      t.text :password_digest
      t.text :email
      t.string :provider
      t.string :uid
      t.timestamps
    end
    execute 'ALTER TABLE users ALTER COLUMN first_name TYPE VARCHAR(60);'
    execute 'ALTER TABLE users ALTER COLUMN last_name TYPE VARCHAR(60);'
    execute 'ALTER TABLE users ALTER COLUMN password_digest TYPE VARCHAR(60);'
    execute 'ALTER TABLE users ALTER COLUMN email TYPE VARCHAR(60);'
  end
end
