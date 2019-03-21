class CoursePolicy <  ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @course = record
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
    @user.instructor_of? @course
  end

  def destroy?
    @user.instructor_of? @course
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
