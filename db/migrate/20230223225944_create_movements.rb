class CreateMovements < ActiveRecord::Migration[7.0]
  def change
    create_table :movements do |t|

      t.timestamps
    end
  end
end
