class AddLogToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :log, :longtext
  end
end
