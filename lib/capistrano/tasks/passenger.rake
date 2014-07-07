namespace :passenger do
  desc 'Start passenger'
  task :start do
    command = []
    command << 'start'
    command << current_path

    if fetch :passenger_use_socket
      command << "--socket #{fetch :passenger_socket_file}"
    else
      command << "--address #{fetch :passenger_address}"
      command << "--port #{fetch :passenger_port}"
    end

    command << "--pid-file #{fetch :passenger_pid_file}"
    command << "--log-file #{fetch :passenger_log_file}"
    command << "--environment #{fetch :rails_env}"
    command << "--daemonize"

    on roles(:app) do
      within release_path do
        execute :passenger, command.join(' ')
      end
    end
  end

  desc 'Stop passenger'
  task :stop do
    on roles(:app) do
      within release_path do
        execute :passenger, "stop --pid-file #{fetch :passenger_pid_file} ; true"
        execute :rm, '-f', fetch(:passenger_pid_file)
        execute :rm, '-f', fetch(:passenger_socket_file)
      end
    end
  end

  desc 'Stop and start passenger'
  task :full_restart do
    invoke 'deploy:stop'
    invoke 'deploy:start'
  end

  desc 'Restart passenger'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
end

namespace :deploy do
  desc 'Start application'
  task :start
  after :start, 'passenger:start'

  desc 'Stop application'
  task :stop
  after :stop, 'passenger:stop'

  desc 'Stop then start application'
  task :full_restart
  after :full_restart, 'passenger:full_restart'

  desc 'Restart'
  task :restart
  after :restart, 'passenger:restart'
end

namespace :load do
  task :defaults do
    set :passenger_pid_file,    -> { Pathname.new(current_path).join('tmp', 'pids', "#{fetch :rails_env}.pid") }
    set :passenger_log_file,    -> { Pathname.new(current_path).join('log', "#{fetch :rails_env}.pid") }
    set :passenger_socket_file, -> { Pathname.new(current_path).join('tmp', 'sockets', "#{fetch :rails_env}.sock") }
    set :passenger_address,     '127.0.0.1'
    set :passenger_port,        3000
    set :passenger_use_socket,  false
  end
end
