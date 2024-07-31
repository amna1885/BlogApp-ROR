module Postable
  extend ActiveSupport::Concern

  def approve_post
    @post.update(is_approved: true, status: :approved)
    redirect_to root_path, notice: t('posts.index.approve.success')
  end

  def reject_post
    @post.update(is_approved: false, status: :rejected)
    redirect_to root_path, notice: t('posts.index.reject.success')
  end

  def report_post
    @post.update(is_reported: true)
    redirect_to root_path, notice: t('posts.index.report.success')
  end

  def unreport_post
    @post.update(status: 'ejected', is_reported: false)
    redirect_to reported_posts_path, notice: t('posts.index.unreport.success')
  end

  def unpublish_post
    @post.update(status: 'ejected', is_reported: true)
    @post.destroy
    redirect_to reported_posts_path, notice: t('posts.index.unpublish.success')
  end

  def pending_approval_post
    @post.update(status: :pending_approval)
    redirect_to root_path, notice: t('posts.index.pending_approval.success')
  end

  def reported_posts
    @reported_posts = Post.where(is_reported: true)
  end
end
