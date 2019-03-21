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
    @user.instructor_of? @group.course or
      Subscriber.where(user: @user, group: @group, course: @group.course).count >=1
  end

  def create?
    @user.instructor_of? @group.course
  end

  def update?
    @user.instructor_of? @group.course
  end

  def destroy?
    @user.instructor_of? @group.course
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
