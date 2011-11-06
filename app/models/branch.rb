class Branch < ActiveRecord::Base
  belongs_to :project

  symbolize :status

  validates :status,
            presence: true,
            inclusion: [ :uninitialized, :provisioning, :provisioned, :updating, :testing, :deploying, :deployed ]

  after_create :setup

  private

  def setup
    puts "## Branch::setup"
    Resque.enqueue(DeployBranch, self.id)
  end

end
