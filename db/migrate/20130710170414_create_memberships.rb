class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :organization, index: true
      t.references :user, index: true
      t.boolean :is_admin

      t.timestamps
    end
  end
end
