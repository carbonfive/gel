class Branch < ActiveRecord::Base
  belongs_to :project

  symbolize :status

  validates :status,
            presence: true,
            inclusion: [ :uninitialized, :provisioning, :provisioned, :updating, :testing, :deploying, :deployed ]

  def deploy!
    Resque.enqueue(Deployer, self.id)
  end

  #before_transition :parked => any - :parked, :do => :put_on_seatbelt
  #
  #after_transition :on => :crash, :do => :tow
  #after_transition :on => :repair, :do => :fix
  #after_transition any => :parked do |vehicle, transition|
  #  vehicle.seatbelt_on = false
  #end
  #
  #after_failure :on => :ignite, :do => :log_start_failure
  #
  #around_transition do |vehicle, transition, block|
  #  start = Time.now
  #  block.call
  #  vehicle.time_used += Time.now - start
  #end
  #
  #event :park do
  #  transition [:idling, :first_gear] => :parked
  #end

  #state_machine :status, :initial => :uninitialized do
  #
  #  event :deploy do
  #    transition [:deployed, :uninitialized] => :provisioning
  #  end
  #
  #  after_transition :uninitialized => :provisioning do |branch|
  #    Resque.enqueue(Deployer, branch.id)
  #  end
  #
  #end
end
