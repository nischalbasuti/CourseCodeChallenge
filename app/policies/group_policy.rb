class GroupPolicy <  ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @group = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    @user.instructor?
  end

  def update?
    @user.instructor?
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
