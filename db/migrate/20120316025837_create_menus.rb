class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.string :path
      t.boolean :completed

      t.timestamps
    end
  end
end
