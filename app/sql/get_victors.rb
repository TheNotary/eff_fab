# This query is unused and here for demo purposes.
# returns a string that can be used to query for all users who *did* complete
# their fabs between the specified date range.
# Params:
# p1: A string describing the starting date in which to seek Fabs
#     (in the form "%Y-%m-%d")
# p2: A string describing the ending date  in which to seek Fabs
#     (in the form "%Y-%m-%d")
module Sql
  class GetVictors
    def self.to_s(p1, p2)
      GetRunners.to_s(p1, p2, invert: true)
    end
  end
end
