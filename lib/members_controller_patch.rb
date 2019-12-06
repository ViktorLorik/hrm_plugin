module MembersControllerPatch
  def self.included(base)
    base.class_eval do
      def new
        @member = Member.new
        @selected_levels = []
        @selected_skills = []
      end
      def create
        members = []
        if params[:membership]
          user_ids = Array.wrap(params[:membership][:user_id] || params[:membership][:user_ids])
          user_ids << nil if user_ids.empty?
          working_hour = params[:working_hours].to_i
          deadline = params[:deadline].to_date
          user_ids.each do |user_id|
            member = Member.new(:project => @project, :user_id => user_id, working_hours: working_hour, deadline: deadline)
            member.set_editable_role_ids(params[:membership][:role_ids])
            members << member
          end
          @project.members << members
        end

        respond_to do |format|
          format.html { redirect_to_settings_in_projects }
          format.js {
            @members = members
            @member = Member.new
          }
          format.api {
            @member = members.first
            if @member.valid?
              render :action => 'show', :status => :created, :location => membership_url(@member)
            else
              render_validation_errors(@member)
            end
          }
        end
      end

      def update
        if params[:membership]
          @member.set_editable_role_ids(params[:membership][:role_ids])
          @member.working_hours = params[:working_hour].to_i
          @member.deadline = params[:deadline].to_date
        end
        saved = @member.save
        respond_to do |format|
          format.html { redirect_to_settings_in_projects }
          format.js
          format.api {
            if saved
              render_api_ok
            else
              render_validation_errors(@member)
            end
          }
        end
      end

    end
  end
end