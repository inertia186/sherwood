class PostProcessJob < ApplicationJob
  queue_as :default

  def perform
    Project.find_each do |project|
      feature_duration = project.feature_duration_in_days.days.ago
      posts = project.posts.accepted.created(feature_duration, false)
      posts.deactivate_all!
    end
  end
end
