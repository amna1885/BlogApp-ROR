# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :moderator
      # can :manage, Post
      can :read, :all
      can %i[approve reject unreport], Post
      can :reported_posts, Post
      can :pending_approval, Post
      can :unpublish, Post
    elsif user.has_role? :user
      can :read, :all
      can :create, Post
      can :update, Post, user_id: user.id
      can :destroy, Post, user_id: user.id
      can :like, Post
      can :report, Post
    else
      can :read, :all
    end
  end
end
