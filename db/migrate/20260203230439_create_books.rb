class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :serial_number, null: false, limit: 6
      t.string :title, null: false
      t.string :author, null: false

      t.timestamps
    end

    add_index :books, :serial_number, unique: true
    add_index :books, :author
    add_index :books, :title
  end
end
