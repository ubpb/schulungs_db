class AddPositionToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :position, :integer, index: true

    Category.order(:title).each.with_index(1) do |category, index|
      category.update_column :position, index
    end
  end
end
