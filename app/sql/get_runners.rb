######################
# GetRunners Summary #
######################
# At a high level, this is a query to return users who do not have an
# associated Fab record for the date specified.
#
# With out an optomized query, one would need to pull all the users out, and
# perhaps iterate over each of them running a query to see if they had a Fab
# created within the specified date period (this was noticably slow, somewhere
# in the 1000ms range) whereas when optimized into a single query, the time
# spent in db is around 0.9ms.

# This query will find the 'runner ups' ie all people who did not
# create their FAB between the dates p1 and p2
# Params:
# p1: A string describing the starting date in which to seek Fabs
#     (in the form "%Y-%m-%d")
# p2: A string describing the ending date  in which to seek Fabs
#     (in the form "%Y-%m-%d")
# invert: If set to true, the sql will return the complement set of User,
#     e.g. users who *did* complete their fab on time.
module Sql
  class GetRunners
    def self.to_s(p1, p2, invert: false)

      <<-EOT.strip_heredoc

        SELECT users.id, users.name
        FROM users
          LEFT JOIN fabs
          ON fabs.user_id = users.id
          GROUP BY users.id
            HAVING max(
              case
                WHEN fabs.period BETWEEN date('#{p1}') AND date('#{p2}') THEN
                  1
                ELSE
                  0
                END
            ) = #{invert ? 1 : 0}

      EOT

    end
  end
end
