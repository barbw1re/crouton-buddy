#!/bin/bash

cd $(dirname "$0")

tar -zcvf crouton-buddy.tar.gz crouton-buddy/
(( $? )) && exit 1

gitSwitch() {
    git stash && git checkout "$0" && git stash pop
}

mv crouton-buddy.tar.gz ..

gitSwitch assets

mv ../crouton-buddy.tar.gz .
git add crouton-buddy.tar.gz
git commit
git push

gitSwitch dev

exit 0
