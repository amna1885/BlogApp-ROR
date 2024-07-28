# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  def index?
    user.has_role?(:admin) || user.has_role?(:moderator) || user.has_role?(:user)
  end

  def show?
    user.has_role?(:admin) || user.has_role?(:moderator) || user.has_role?(:user)
  end

  def create?
    user.has_role?(:admin)
  end

  def update?
    user.has_role?(:admin) || user.has_role?(:moderator)
  end

  def destroy?
    user.has_role?(:admin)
  end

  class Scope < Scope
    def resolve
      if user.has_role?(:admin)
        scope.all
      elsif user.has_role?(:moderator)
        scope.where(moderator_id: user.id)
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
