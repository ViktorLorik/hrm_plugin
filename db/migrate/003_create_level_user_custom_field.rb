class CreateLevelUserCustomField < ActiveRecord::Migration[4.2]

  def self.up
    create_user_custom_field
  end

  def self.down
    delete_user_custom_field
  end


  def self.create_user_custom_field
    UserCustomField.create!([{
                                 name: "Level",
                                 field_format: "list",
                                 possible_values: %w[Junior Midlevel Senior],
                                 is_required: false,
                                 is_filter: true,
                                 searchable: true,
                                 editable: false}])
  end

  def self.delete_user_custom_field
    UserCustomField.find_by(name: "Level").destroy!
  end

end