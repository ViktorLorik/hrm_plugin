module PrincipalMembershipsControllerPatch
  def self.included(base)
    base.class_eval do

      def update
        @membership.attributes = params.require(:membership).permit({:role_ids => []} , :working_hours, :deadline)
        @membership.save
        respond_to do |format|
          format.html { redirect_to_principal @principal }
          format.js
        end
      end

    end
  end
end