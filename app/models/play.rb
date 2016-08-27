class Play < ActiveRecord::Base
  serialize :vec
  serialize :num
  serialize :season
end
