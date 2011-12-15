class Branch < ActiveRecord::Base
  belongs_to :project

  symbolize :status

  validates :status,
            presence: true,
            inclusion: [ :uninitialized, :provisioning, :provisioned, :updating, :executing, :success, :failure ]

  after_create   :setup
  before_destroy :cleanup

  def slug
    self.name.parameterize
  end

  def setup
    puts "## Branch::setup"
    Resque.enqueue(DeployBranch, self.id)
  end

  def cleanup
    Dir.chdir("#{project.location}/#{self.slug}") do
      %x{vagrant destroy}
    end
    Dir.chdir("#{project.location}") do
      FileUtils.rm_rf "#{self.slug}"
    end
  end

end
