all: test

test: .FORCE
	./test.sh

test_in_tmp:
	rm -rf /tmp/git-subbranch
	cp -r . /tmp/git-subbranch
	cd /tmp/git-subbranch && make test

init-git:
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"

git_subbranch_ignore git_subbranch_init git_subbranch_commit git_subbranch_push:
	sh -c ". ./functions; $@"

create_artifact:
	( echo "---"; echo "layout: index"; echo "---"; echo; grep -B 1000 -A 1 "## Demonstration" README.md; echo '```'; make test_in_tmp; echo '```'; grep -A 1000 -B 2 "## Comparison" README.md ) > gh-pages-dir/index.md
	echo "markdown: redcarpet" > gh-pages-dir/_config.yml
	mkdir -p gh-pages-dir/_layouts
	cp index.html gh-pages-dir/_layouts

prepare_deploy: git_subbranch_link create_artifact git_subbranch_commit git_subbranch_push

push_deploy: prepare_deploy
	git push

.FORCE:
