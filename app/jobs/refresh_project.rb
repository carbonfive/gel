class RefreshProject
  @queue = :deploy

  def self.perform(project_id)
    project = Project.find(project_id)
    project.update_project!
  end
end
