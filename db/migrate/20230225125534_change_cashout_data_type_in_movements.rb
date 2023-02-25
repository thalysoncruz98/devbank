class ChangeCashoutDataTypeInMovements < ActiveRecord::Migration[7.0]
  def change
    add_column :movements, :new_cashout, :float

    Movement.reset_column_information
    Movement.find_each do |m|
      m.update(new_cashout: m.cashout.to_f)
    end

    remove_column :movements, :cashout
    rename_column :movements, :new_cashout, :cashout
  end
end
