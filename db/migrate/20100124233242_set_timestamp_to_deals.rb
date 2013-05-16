# -*- encoding : utf-8 -*-

# Ensure deals have non null timestamps.
class SetTimestampToDeals < ActiveRecord::Migration
  def self.up
    execute "update deals set created_at = date::timestamp where created_at is null"
    execute "update deals set updated_at = created_at where updated_at is null"
  end

  def self.down
    # Do nothing
  end
end
