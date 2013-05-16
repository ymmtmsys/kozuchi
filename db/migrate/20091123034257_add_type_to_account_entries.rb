# -*- encoding : utf-8 -*-

class AddTypeToAccountEntries < ActiveRecord::Migration
  def self.up
    add_column :account_entries, :type, :string
    execute "update account_entries set account_entries.type = deals.type from deals where deals.id = account_entries.deal_id;"
  end

  def self.down
    remove_column :account_entries, :type
  end
end
