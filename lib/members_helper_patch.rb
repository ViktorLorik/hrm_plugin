module MembersHelperPatch
  def self.included(base)
    base.class_eval do

      def render_principals_for_new_members(project, limit=100)


        selected_skills = []
        selected_levels = []
        text_search = nil
        # params[:form_data]&.[](:"3")[:name].split('-').first ==         principal_count = scope.count
        25.times do |i|
          parameter = params[:form_data]&.[](:"#{i}")
          break if parameter.nil?
          name = parameter&.[](:name)&.split('-')&.first
          value = parameter&.[](:name)&.split('-')&.second
          if  name == "skill"
            selected_skills.push(UserCustomField.find_by(name: "Skills").possible_values[value.to_i])
          elsif name == "levels"
            selected_levels.push(UserCustomField.find_by(name: "Level").possible_values[value.to_i])
          elsif name == "principal_search"
            text_search = parameter&.[](:value)
          end
        end
        like_criterion = params[:q].nil? ? text_search : params[:q]
        scope = Principal.active.visible.sorted.not_member_of(project).like(like_criterion)
        principal_count = scope.count
        principal_pages = Redmine::Pagination::Paginator.new principal_count, limit, params['page']
        principals = scope.offset(principal_pages.offset).limit(principal_pages.per_page).to_a
        unless selected_levels.empty? && selected_skills.empty? && text_search.nil?
          principals = principals.select { |user|
            (selected_skills - user.custom_field_values.select { |cfv| cfv.custom_field['name'] == 'Skills' }[0]&.value).empty? &&
                (selected_levels - [user.custom_field_values.select { |cfv| cfv.custom_field['name'] == 'Level' }[0].value]).empty? }
        end

        s = content_tag('div',
                        content_tag('div', principals_check_box_tags('membership[user_ids][]', principals), :id => 'principals'),
                        :class => 'objects-selection'
        )

        links = pagination_links_full(principal_pages, principal_count, :per_page_links => false) {|text, parameters, options|
          link_to text, autocomplete_project_memberships_path(project, parameters.merge(:q => params[:q], :format => 'js')), :remote => true
        }

        s + content_tag('span', links, :class => 'pagination')
      end
    end
  end
end