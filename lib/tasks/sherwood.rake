require 'csv'

namespace :sherwood do
  PROJECT_KEYS = %w(code name feature_duration_in_days created_at updated_at)
  
  USER_KEYS = %w(email nick password_hash password_salt project_codes created_at updated_at)
  
  POST_KEYS = %w(
    status slug project_code editing_user_nick notes published created_at
    updated_at
  )
  
  desc 'display the current information of rake'
  task :info do
    puts "You are running rake task in #{Rails.env} environment."
  end

  namespace :content do
    desc 'Get random content.'
    task get_random: :environment do
      puts ContentGetterJob.perform_now
    end
  end
  
  namespace :export do
    desc 'dump out projects to csv'
    task projects: :environment do
      data = CSV.generate do |csv|
        csv << PROJECT_KEYS
        
        Project.all.find_each do |project|
          row = []
          PROJECT_KEYS.each do |key|
            row << project.send(key)
          end
          csv << row
        end
        
      end

      puts data
    end

    desc 'dump out users to csv'
    task users: :environment do
      data = CSV.generate do |csv|
        csv << USER_KEYS
        
        User.all.find_each do |user|
          row = []
          USER_KEYS.each do |key|
            row << case key
            when 'project_codes' then user.projects.map(&:code).join('|')
            else user.send(key)
            end
          end
          csv << row
        end
        
      end

      puts data
    end

    desc 'dump out posts to csv'
    task posts: :environment do
      data = CSV.generate do |csv|
        csv << POST_KEYS
        
        Post.all.find_each do |post|
          row = []
          POST_KEYS.each do |key|
            row << case key
            when 'project_code' then post.project.code
            when 'editing_user_nick' then post.editing_user.nick
            else post.send(key)
            end
          end
          csv << row
        end
        
      end

      puts data
    end
  end
  
  namespace :import do
    desc 'pump in projects from csv'
    task projects: :environment do
      CSV.parse(STDIN, headers: true) do |row|
        project_params = {}
        PROJECT_KEYS.each do |key|
          next unless row[key].present?
          project_params[key] = row[key]
        end

        puts Project.create(project_params).errors.full_messages
      end
    end
    
    desc 'pump in users from csv'
    task users: :environment do
      CSV.parse(STDIN, headers: true) do |row|
        user_params = {}
        USER_KEYS.each do |key|
          next unless row[key].present?
          case key
          when 'project_codes'
            codes = row[key].split('|')
            user_params['project_ids'] = Project.where(code: codes).pluck(:id)
          else
            user_params[key] = row[key]
          end
        end

        puts User.create(user_params).errors.full_messages
      end
    end
    
    desc 'pump in posts from csv'
    task posts: :environment do
      CSV.parse(STDIN, headers: true) do |row|
        post_params = {}
        POST_KEYS.each do |key|
          next unless row[key].present?
          case key
          when 'project_code'
            post_params['project_id'] = (Project.find_by(code: row[key]) or
              raise "Unable to find project with code: #{row[key]}").id
          when 'editing_user_nick'
            post_params['editing_user_id'] = (User.find_by(nick: row[key]) or
              raise "Unable to find user with nick: #{row[key]}").id
          else
            post_params[key] = row[key]
          end
          
        end

        puts Post.create(post_params).errors.full_messages
      end
    end
  end
end
