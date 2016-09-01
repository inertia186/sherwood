namespace :sherwood do
  namespace :content do
    desc 'Get random content.'
    task get_random: :environment do
      puts ContentGetterJob.perform_now
    end
  end
end
