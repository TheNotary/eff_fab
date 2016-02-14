class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :fab_id
      t.text :body
      t.boolean :forward
      t.boolean :achievement

      t.timestamps null: false
    end
  end
end
