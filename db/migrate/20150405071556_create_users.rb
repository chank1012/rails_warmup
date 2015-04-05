class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, limit: 20
      t.string :password, limit: 20
      t.integer :count

      t.timestamps null: false
    end
  end
end
