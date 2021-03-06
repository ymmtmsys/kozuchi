# -*- encoding : utf-8 -*-
class Entry::Balance < Entry::Base
  belongs_to :deal,
             :class_name => 'Deal::Balance',
             :foreign_key => 'deal_id'


  scope :without_initial, :conditions => {:initial_balance => false}

  validates :balance, :presence => true, :numericality => {:only_integer => true, :allow_blank => true}

  # amountが変わるような更新はされない（作り直しになる）想定
  before_create :set_amount

  def balance=(a)
    self[:balance] = self.class.parse_amount(a)
  end

  def summary
    initial_balance? ? '残高確認（初回）' : '残高確認'
  end

  def partner_account_name
    initial_balance? ? '' : '不明金'
  end

  def reversed_amount
    self.amount.blank? ? self.amount : self.amount.to_i * -1
  end

  private

  def set_amount
    current_initial_balance = self.class.find_by_account_id_and_initial_balance(account_id, true, :include => :deal)
    this_will_be_initial = !current_initial_balance || current_initial_balance.deal.date > self.date || (current_initial_balance.deal.date == self.date && current_initial_balance.deal.daily_seq > self.daily_seq)
    self.amount = balance - balance_before(this_will_be_initial)
  end

  # この残高記入直前の残高を求める
  def balance_before(ignore_initial = false)
    raise "date or daily_seq is nil!" unless self.date && self.daily_seq
    account.balance_before(date, daily_seq, ignore_initial)
  end

end
