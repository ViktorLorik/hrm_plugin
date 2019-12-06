class CreateWorkhourUserCustomField < ActiveRecord::Migration[4.2]

  def self.up
    create_user_custom_field
  end

  def self.down
    delete_user_custom_field
  end

  def self.create_user_custom_field
    UserCustomField.create!([{
                                 name: "Workhour/Week",
                                 field_format: "int",
                                 is_required: true,
                                 is_filter: true,
                                 editable: false}])
  end

  def self.delete_user_custom_field
    UserCustomField.find_by(name: "Workhour/Week").destroy!
  end

end