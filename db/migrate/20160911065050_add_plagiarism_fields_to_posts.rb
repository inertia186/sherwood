class AddPlagiarismFieldsToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :plagiarism_results_url, :string
    add_column :posts, :plagiarism_checked_at, :timestamp
  end
end
