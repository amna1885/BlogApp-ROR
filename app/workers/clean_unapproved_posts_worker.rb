# frozen_string_literal: true

class CleanUnapprovedPostsWorker
  include Sidekiq::Worker

  def perform
    Post.where(is_approved: nil).where('created_at < ?', 30.days.ago).destroy_all
  end
end
