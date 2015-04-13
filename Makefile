all: test

test:
	./test.sh

init-git:
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"
