require 'fileutils'

class DeployBranch
  @queue = :deploy

  def self.perform(branch_id)
    branch = Branch.find(branch_id)
    project = branch.project

    begin
      branch.status = :provisioning
      branch.save!

      puts "## DeployBranch::perform"

      Dir.chdir(project.location) do
        Dir.mkdir(branch.slug) unless Dir.exists?(branch.slug)
        Dir.chdir(branch.slug) do
          FileUtils.cp "#{project.location}/repo/Vagrantfile", "#{project.location}/#{branch.slug}"
          FileUtils.cp_r "#{project.location}/repo/cookbooks", "#{project.location}/#{branch.slug}"
          %x{vagrant up}
          %x{vagrant ssh_config > ssh_config}
          %x{scp -F #{project.location}/#{branch.slug}/ssh_config -r #{project.repo_location} default:./repo}
          %x{ssh -F #{project.location}/#{branch.slug}/ssh_config ""}
        end
      end

    rescue => e
      puts e
      branch.status = :uninitialized
      branch.save!
      return
    end

    branch.status = :provisioned
    branch.save!

    #sleep 2
    #branch.status = :updating
    #branch.save!
    #
    #sleep 6
    #branch.status = :testing
    #branch.save!
    #
    #sleep 10
    #branch.status = :deploying
    #branch.save!
    #
    #sleep 5
    #branch.status = :deployed
    #branch.save!

    #env = Vagrant::Environment.new
    #env.cli("up")
    #env.primary_vm.ssh.execute do |ssh|
    #  ssh.exec!("git clone #{branch.project.git_url} source")
    #  ssh.exec!("cd source; git checkout #{sha}")
    #end
  end
end
