class CreateSkillsUserCustomField < ActiveRecord::Migration[4.2]

  def self.up
    create_user_custom_field
  end

  def self.down
    delete_user_custom_field
  end


  def self.create_user_custom_field
    UserCustomField.create!([{
                                 name: "Skills",
                                 field_format: "list",
                                 possible_values: %w[Java C++ Ruby],
                                 is_required: false,
                                 is_filter: true,
                                 searchable: true,
                                 editable: true,
                                 multiple: true,
                                 format_store: {"url_pattern"=>"", "edit_tag_style"=>"check_box"}}])
  end

  def self.delete_user_custom_field
    UserCustomField.find_by(name: "Skills").destroy!
  end

end