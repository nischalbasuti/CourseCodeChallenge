class GroupPolicy <  ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @user_other = record
  end

  def index?
    @user.instructor?
  end

  def show?
    @user.instructor? or @user == @user_other
  end

  def create?
    true
  end

  def update?
    @user.instructor? or @user == @user_other
  end

  def destroy?
    @user.instructor?
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
