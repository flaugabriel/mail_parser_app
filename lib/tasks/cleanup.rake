namespace :cleanup do
  desc "Delete processing logs older than N days (default 30)"
  task old_processing_logs: :environment do
    days = ENV.fetch("DAYS", 30).to_i
    ProcessingLog.where("processed_at < ?", Time.current - days.days).delete_all
    puts "Deleted processing logs older than #{days} days"
  end
end
