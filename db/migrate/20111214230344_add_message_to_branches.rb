class AddMessageToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :message, :string
  end
end
