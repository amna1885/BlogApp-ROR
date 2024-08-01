module Postable
  extend ActiveSupport::Concern

  def approve_post
    @post.update(is_approved: true, status: :approved)
    redirect_to root_path, notice: t('posts.approve.success')
  end

  def reject_post
    @post.update(is_approved: false, status: :rejected)
    redirect_to root_path, notice: t('posts.reject.success')
  end

  def report_post
    @post.update(is_reported: true)
    redirect_to root_path, notice: t('posts.report.success')
  end

  def unreport_post
    @post.update(status: 'approved', is_reported: false)
    redirect_to reported_posts_path, notice: t('posts.unreport.success')
  end

  def unpublish_post
    @post.update(status: 'rejected', is_reported: true)
    @post.destroy
    redirect_to reported_posts_path, notice: t('posts.unpublish.success')
  end

  def pending_approval_post
    @post = Post.find(params[:id])
      if @post.update(status: :pending_approval)
        redirect_to root_path, notice: t('posts.pending_approval.success')
      else
        redirect_to root_path, alert: t('posts.pending_approval.failure')
      end
  end
end
