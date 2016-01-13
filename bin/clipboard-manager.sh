#!/bin/sh

occ=$(xclip -sel clip -o | sed 's/[\"]/\\&/g')

while sleep 2; do
    ncc=$(xclip -sel clip -o | sed 's/[\"]/\\&/g')
    if [ "${occ}" != "${ncc}" ]; then
        emacsclient -e "(kill-new \"${ncc}\")"
        occ=${ncc}
    fi
done
