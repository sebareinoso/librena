class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.text :summary, null: false

      t.timestamps
    end
  end
end
