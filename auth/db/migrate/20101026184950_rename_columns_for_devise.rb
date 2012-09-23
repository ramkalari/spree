class RenameColumnsForDevise < ActiveRecord::Migration
  def up
    add_column :spree_users, :first_name, :string
    add_column :spree_users, :last_name, :string
  end

  def down
    remove_column :spree_users, :first_name
    remove_column :spree_users, :last_name
  end
end
