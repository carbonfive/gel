class AddStatusToBranch < ActiveRecord::Migration
  def change
    change_table :branches do |t|
      t.string :status
    end
  end
end
