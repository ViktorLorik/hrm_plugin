class AddNewColumnsToMembersTable < ActiveRecord::Migration[4.2]
  def change
    change_table :members do |t|
      t.integer :working_hours
      t.date :deadline
    end
  end
end
