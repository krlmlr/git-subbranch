all: test

test: .FORCE
	./test.sh

init-git:
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"

git_subbranch_ignore git_subbranch_init git_subbranch_commit git_subbranch_push:
	sh -c ". ./functions; $@"

create_artifact:
	( echo "---"; echo "layout: index"; echo "---"; echo; grep -B 1000 -A 1 "## Demonstration" README.md; echo '```'; make; echo '```'; grep -A 1000 -B 2 "## Comparison" README.md ) > gh-pages-dir/index.md
	echo "markdown: redcarpet" > gh-pages-dir/_config.yml
	mkdir -p gh-pages-dir/_layouts
	cp index.html gh-pages-dir/_layouts

prepare_deploy: create_artifact git_subbranch_commit git_subbranch_push

push_deploy: prepare_deploy
	git push

.FORCE:
