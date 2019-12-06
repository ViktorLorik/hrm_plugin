Redmine::Plugin.register :hrm_plugin do
  name 'Human Resources Management Plugin'
  author 'Lőrik Viktor'
  description 'This is a plugin for Redmine'
  version '1.0.0'
end

Rails.application.config.to_prepare do
  unless MembersController.include?(MembersControllerPatch)
    MembersController.send(:include, MembersControllerPatch)
  end
  unless MembersHelper.include?(MembersHelperPatch)
    MembersHelper.send(:include, MembersHelperPatch)
  end
  unless PrincipalMembershipsController.include?(PrincipalMembershipsControllerPatch)
    PrincipalMembershipsController.send(:include, PrincipalMembershipsControllerPatch)
  end
  unless Member.include?(MemberPatch)
    Member.send(:include, MemberPatch)
  end
end