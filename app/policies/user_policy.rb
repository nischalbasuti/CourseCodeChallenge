class UserPolicy <  ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @user_other = record
  end

  def index?
    @user.instructor?
  end

  def show?
    (@user.instructor? and @user_other.student?) or @user == @user_other
  end

  def create?
    true
  end

  def update?
    (@user.instructor? and @user_other.student?) or @user == @user_other
  end

  def destroy?
    @user.instructor? and @user_other.student?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
