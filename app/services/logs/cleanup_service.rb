# frozen_string_literal: true

module Logs
  class CleanupService
    DEFAULT_RETENTION_DAYS = 30

    def initialize(retention_days: nil)
      @days = (retention_days || ENV.fetch("LOG_RETENTION_DAYS", DEFAULT_RETENTION_DAYS)).to_i
    end

    def call
      cutoff = @days.days.ago

      logs_to_remove = LogProcessamento.where("created_at < ?", cutoff)
      removed_count  = logs_to_remove.delete_all

      puts "[Logs::CleanupService] Removidos #{removed_count} registros anteriores a #{@days} dias."

      removed_count
    end
  end
end
