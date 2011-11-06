class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.references :project
      t.string     :status, default: 'uninitialized'
      t.string     :name
      t.datetime   :last_commit_at

      t.timestamps
    end

    add_index :branches, :project_id
  end
end
