# -*- encoding : utf-8 -*-

class AddLinkedExEntryConfirmedToAccountEntries < ActiveRecord::Migration
  def self.up
    add_column :account_entries, :linked_ex_entry_confirmed, :boolean, :null => false, :default => false

    execute "update account_entries set linked_ex_entry_confirmed = deals.confirmed from deals where account_entries.linked_ex_deal_id = deals.id"
  end

  def self.down
    remove_column :account_entries, :linked_ex_entry_confirmed
  end
end
