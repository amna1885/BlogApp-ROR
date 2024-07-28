class CleanUnapprovedPostsWorker
  include Sidekiq::Worker

  def perform
    Post.where(approved: nil).where('created_at < ?', 30.days.ago).destroy_all
  end
end
