class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :status
      t.string :name
      t.string :git_url
      t.string :location

      t.timestamps
    end
  end
end
