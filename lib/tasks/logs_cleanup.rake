namespace :maintenance do
  desc "Limpa logs antigos da tabela log_processamentos"
  task cleanup_logs: :environment do
    puts "Iniciando limpeza de logs antigos..."

    result = Logs::CleanupService.new.call

    puts "Limpeza concluída. Registros removidos: #{result}."
  end
end
