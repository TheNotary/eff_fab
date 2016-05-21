# All staff members are sorted by their Team, thus you'll note the /users
# page addresses Team.all rather than User.all, enabling the virtual team of
# "runner_ups" to exist and sort the staff members
class Team < ActiveRecord::Base
  has_many :users

  default_scope { order(weight: :asc) }

  def self.all_including_runner_ups(eager_load = true)
    teams = if eager_load
      self.all.includes(users: { current_period_fab: [:forward, :backward] })
    else
      self.all
    end

    teams << self.runner_ups
  end

  def self.runner_ups
    Team.new(name: "Team Runner Up", weight: 200)
  end

  # A runner is a person who did not create their FAB passed in as target_period
  def self.get_runners(target_period = Fab.get_start_of_current_fab_period)
    # pick the date range we'll be search for fabs to be created in
    p1 = target_period.strftime("%Y-%m-%d")
    p2 = (target_period + 1.day).strftime("%Y-%m-%d")

    query_string = Sql::GetRunners.to_s(p1,p2)
    runners = User.find_by_sql(query_string)
  end

end
