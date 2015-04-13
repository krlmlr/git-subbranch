all: test

test:
	./test.sh

init-git:
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"

git_subbranch_ignore git_subbranch_init git_subbranch_commit git_subbranch_push:
	sh ". ./functions; $@"
