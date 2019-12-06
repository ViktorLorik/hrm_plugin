module MyProjectsHelper
  def self.render_projects_block
    memberships = Member.where(user_id: User.current.id)
    projects = []
    memberships.each do |membership|
      projects.push({
                        :project => Project.find(membership.project_id).name,
                        :working_hours => membership.working_hours,
                        :deadline => membership.deadline
                    })
    end
    projects
  end
end