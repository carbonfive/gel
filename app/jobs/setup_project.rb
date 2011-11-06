class SetupProject
  @queue = :deploy
  
  def self.perform(project_id)
    project = Project.find(project_id)
    project.initialize_project!
  end
end
