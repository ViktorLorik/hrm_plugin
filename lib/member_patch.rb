module MemberPatch
  def self.included(base)
    base.class_eval do
      def self.create_principal_memberships(principal, attributes)
        members = []
        if attributes
          project_ids = Array.wrap(attributes[:project_ids] || attributes[:project_id])
          role_ids = Array.wrap(attributes[:role_ids])
          working_hours = attributes[:working_hours].to_i
          deadline = attributes[:deadline].to_date
          project_ids.each do |project_id|
            member = Member.find_or_new(project_id, principal)
            member.role_ids |= role_ids
            member.working_hours = working_hours
            member.deadline = deadline
            member.save
            members << member
          end
        end
        members
      end
    end
  end
end