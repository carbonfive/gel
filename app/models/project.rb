class Project < ActiveRecord::Base

  has_many :branches, dependent: :destroy, order: 'last_commit_at desc'

  validates :name,    presence: true, uniqueness: true
  validates :git_url, presence: true

  after_create  :setup
  after_destroy :cleanup

  def repo_location
    self.location + "/repo/"
  end

  def slug
    self.name.parameterize
  end

  # uninitialized
  #  cloning
  # cloned
  #  extracting_branches
  # ready

  state_machine :status, :initial => :uninitialized do
    event :initialize_project do
      transition :uninitialized => :cloning
    end

    event :finish_initialize_project do
      transition :cloning => :cloned
    end

    event :update_project do
      transition [:cloned, :ready] => :updating
    end

    event :finish_update_project do
      transition :updating => :ready
    end

    after_transition :uninitialized => :cloning do |project|
      puts "Cloning repository..."
      project.clone_repository
      project.finish_initialize_project!
    end

    after_transition any => :cloned do |project|
      puts "Cloned for the first time, updating project and branches..."
      project.update_project!
    end

    after_transition any => :updating do |project|
      puts "Updating branches..."
      project.update_branches
      project.finish_update_project!
    end
  end

  def setup
    Resque.enqueue(SetupProject, self.id)
  end

  def refresh
    Resque.enqueue(RefreshProject, self.id)
  end

  def cleanup
    FileUtils.rm_rf(location)
  end

  def update_branches
    #raise "Clone the project before updating branches." unless cloned?

    fetch

    remote_branches.each do |b|
      branches.find_or_initialize_by_name(name: b.full) do |branch|
        branch.last_commit_at = b.gcommit.date
      end
    end

    # Destroy removed branches
    branches.select { |b| !remote_branch_names.include?(b.name) }.each(&:destroy)
  end

  def clone_repository
    self.location = "/tmp/checkouts/#{SecureRandom.hex(32)}"
    FileUtils.mkdir_p self.location
    Git.clone(git_url, 'repo', path: self.location)
  end

  def fetch
    #raise "Clone the project before fetching." unless cloned?
    Git.init(repo_location).fetch
    #repo.remote('origin').prune
  end

  def remote_branches
    @remote_branches ||= Git.init(repo_location)
      .branches
      .reject { |b| b.full =~ /HEAD/ }
      .reject { |b| b.full =~ /master/ }
      .select { |b| b.full =~ /^remotes/ }
      .select { |b| b.full =~ /master|development|feature/ }
  end

  def remote_branch_names
    @remote_branch_names ||= remote_branches.collect(&:full)
  end

end
