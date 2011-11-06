class DeployBranch
  @queue = :deploy
  
  def self.perform(branch_id)
    puts "## DeployBranch::perform"

    branch = Branch.find(branch_id)
    branch.status = :provisioning
    branch.save!

    sleep 10
    branch.status = :provisioned
    branch.save!

    sleep 2
    branch.status = :updating
    branch.save!

    sleep 6
    branch.status = :testing
    branch.save!

    sleep 10
    branch.status = :deploying
    branch.save!

    sleep 5
    branch.status = :deployed
    branch.save!

    #env = Vagrant::Environment.new
    #env.cli("up")
    #env.primary_vm.ssh.execute do |ssh|
    #  ssh.exec!("git clone #{branch.project.git_url} source")
    #end
  end
end
