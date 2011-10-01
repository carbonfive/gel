class Project < ActiveRecord::Base

  validates :name,    presence: true, uniqueness: true
  validates :git_url, presence: true

  has_many :branches, dependent: :destroy, order: 'last_commit_at desc'

  after_create   :setup
  before_destroy :cleanup

  # uninitialized (setting up)
  # cloned (cloned)

  def setup
    clone
    update_branches
    save!
  end

  def cleanup
    FileUtils.rm_rf(location) if cloned?
  end

  def update_branches(fetch_first = false)
    raise "Clone the project before updating branches." unless cloned?

    fetch

    remote_branches.each do |b|
      branches.find_or_initialize_by_name(name: b.full) do |branch|
        branch.last_commit_at = b.gcommit.date
      end
    end

    # Destroy removed branches
    branches.select { |b| !remote_branch_names.include?(b.name) }.each(&:destroy)
  end

  private

  def cloned?
    location.present? && File.directory?(location)
  end

  def clone
    return if cloned?

    repo = Git.clone(git_url, SecureRandom.hex(32), path: '/tmp/checkouts')
    self.location = repo.dir.path
  end

  def fetch
    raise "Clone the project before fetching." unless cloned?
    Git.init(location).fetch
    #repo.remote('origin').prune
  end

  def remote_branches
    @remote_branches ||= Git.init(location)
      .branches
      .remote
      .reject { |b| b.full =~ /HEAD/ }
      .select { |b| b.full =~ /master|development|feature/ }
  end

  def remote_branch_names
    @remote_branch_names ||= remote_branches.collect(&:full)
  end

end
