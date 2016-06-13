
all: 
	redis-server --daemonize yes 
	bundle exec sidekiq -P sidekiq.pid &
	rake data_generate
	rake data_analyze
	echo yq4kamvg | sudo -S  service apache2 restart

stop:
	sidekiqctl stop sidekiq.pid
	redis-cli shutdown
	#echo yq4kamvg | sudo -S  service apache2 stop

apache: 
	echo yq4kamvg | sudo -S  service apache2 restart
