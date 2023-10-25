class AddDeletedToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :deleted, :boolean
  end
end
