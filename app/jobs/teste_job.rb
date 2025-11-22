class TesteJob < ApplicationJob
  queue_as :default

  def perform(msg)
    Rails.logger.info "JOB TESTE >>> #{msg}"
  end
end
