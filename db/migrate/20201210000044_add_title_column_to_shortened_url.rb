class AddTitleColumnToShortenedUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :shortened_urls, :title, :string
  end
end
