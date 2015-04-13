all: test

test:
	./test.sh

init-git:
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"

git_subbranch_ignore git_subbranch_init git_subbranch_commit git_subbranch_push:
	sh -c ". ./functions; $@"

create_artifact:
	cp README.md gh-pages-dir/index.md

prepare_deploy: create_artifact git_subbranch_commit git_subbranch_push
