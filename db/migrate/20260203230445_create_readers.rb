class CreateReaders < ActiveRecord::Migration[8.1]
  def change
    create_table :readers do |t|
      t.string :card_number, null: false, limit: 6
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps
    end

    add_index :readers, :card_number, unique: true
    add_index :readers, :email, unique: true
  end
end
