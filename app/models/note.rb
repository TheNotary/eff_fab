# Generated via 
# $  rails g model Notes fab_id:integer body:text forward:boolean achievement:boolean
class Note < ActiveRecord::Base
  belongs_to :fab
end
