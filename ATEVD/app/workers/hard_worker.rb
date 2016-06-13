class HardWorker
  include Sidekiq::Worker
  def perform(count)
      puts "work #{count} time"
  end
end