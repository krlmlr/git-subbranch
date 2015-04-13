all: test

test:
	./test.sh

init-git:
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"

git_subbranch_ignore git_subbranch_init git_subbranch_commit git_subbranch_push:
	sh -c ". ./functions; $@"

add_artifact:
	cp README.md gh-pages-dir/index.md
	cd gh-pages-dir && git add index.md && git commit -m "add artifact"
