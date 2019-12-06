namespace :redmine do
  namespace :load_test_data do

    task load_users: :environment do
      login = 'Felhasznalo'
      number = 5
      100.times do
        user = User.new :firstname => "Felhasznalo",
                        :lastname => number.to_s,
                        :mail => "Felhasznalo#{number}@example.net",
                        :status => 1
        user.login = login + number.to_s
        user.password = "jelszo123"
        user.admin = false
        user.custom_field_values.first.value = [20, 25, 30, 35, 40].shuffle.first
        user.custom_field_values.second.value = UserCustomField.second.possible_values.shuffle.first
        user.custom_field_values.third.value = UserCustomField.third.possible_values.shuffle.first(2)

        user.save!
        number += 1
      end
    end

    task load_projects: :environment do
      number = 5
      20.times do
        project = Project.new :name => "Project #{number}", :identifier => "project-#{number}"
        project.save!
        number += 1
      end
    end

    task add_users_to_projects: :environment do
      roles =  Role.where(name: %w[Vezető Fejlesztő Bejelentő])
      working_hours = [10, 15, 20, 30, 40]
      deadlines = [nil, Date.today + 120]
      users = User.where(firstname: "Felhasznalo").shuffle
      number = 5
      projects = []
      20.times do
        projects.push(Project.find_by(name: "Project #{number}"))
        number += 1
      end

      users_with_two_pro = users.pop(15)
      users_with_three_pro = users.pop(5)
      users_with_two_pro.each do |user|
        projects.shuffle.first(2).each do |project|
          member = Member.new(user_id: user.id, project_id: project.id, working_hours: working_hours.shuffle.first, deadline: deadlines.shuffle.first)
          member.roles = [roles.shuffle.first]
          member.save!
        end
      end
      users_with_three_pro.each do |user|
        projects.shuffle.first(3).each do |project|
          member = Member.new(user_id: user.id, project_id: project.id, working_hours: working_hours.shuffle.first, deadline: deadlines.shuffle.first)
          member.roles = [roles.shuffle.first]
          member.save!
        end
      end
      users.each do |user|
        member = Member.new(user_id: user.id, project_id: projects.shuffle.first.id, working_hours: working_hours.shuffle.first, deadline: deadlines.shuffle.first)
        member.roles = [roles.shuffle.first]
        member.save!
      end
    end

  end
end