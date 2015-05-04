all: directory git
	/bin/bash -i; \
	cd $(HOME)/tmp/tom_servo; \
	rake setup:setup_env


git: directory
	git clone --depth 1 git@github.com:sensu-plugins/tom_servo.git $(HOME)/tmp/tom_servo

directory:
	rm -rf $(HOME)/tmp
	mkdir $(HOME)/tmp
