desc "analyze the data"
task :data_analyze => :environment do
  DataAnalyzeWorker.perform_async()
end

