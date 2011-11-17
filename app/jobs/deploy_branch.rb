require 'fileutils'

class DeployBranch
  @queue = :deploy

  def self.perform(branch_id)
    branch = Branch.find(branch_id)
    project = branch.project

    begin
      puts "## DeployBranch::perform - #{project.name} - #{branch.name}"

      branch.status = :provisioning
      branch.save!

      Dir.chdir(project.location) do
        unless Dir.exists?(branch.slug)
          puts "# Creating branch directory"
          Dir.mkdir(branch.slug)
        end
        Dir.chdir(branch.slug) do
          puts "# Copying vagrantfile"
          FileUtils.cp "#{project.location}/repo/Vagrantfile", "#{project.location}/#{branch.slug}"
          puts "# Copying cookbooks"
          FileUtils.cp_r "#{project.location}/repo/cookbooks", "#{project.location}/#{branch.slug}"
          puts "# Starting/provisioning vagrant environment"
          %x{vagrant up}
          puts "# Creating ssh_config"
          %x{vagrant ssh_config > ssh_config}
          puts "# Removing pre-existing source from vm"
          %x{ssh -q -F #{project.location}/#{branch.slug}/ssh_config default "rm -rf ./repo"}
          puts "# Copying project files to vm"
          %x{scp -q -F #{project.location}/#{branch.slug}/ssh_config -r #{project.repo_location} default:./repo}
          puts "# Running gel script"
          %x{ssh -q -F #{project.location}/#{branch.slug}/ssh_config default "source /etc/profile.d/rvm.sh; cd repo; ./gel.sh"}
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
