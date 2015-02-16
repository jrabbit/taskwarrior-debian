#!/bin/sh
set -e -u -x
dfsg_version="$1"
version="${dfsg_version%+dfsg*}"
tag="v$(echo "$version" | tr '~' '.')"
tmpdir=$(mktemp -d -t task.get-orig-source.XXXXXX)
orig_dir="task-${dfsg_version}.orig"
git clone -b "$tag" --depth 1 https://git.tasktools.org/scm/tm/task.git "$tmpdir/${orig_dir}"
rm -rf "$tmpdir"/*.orig/package-config/ # not included in upstream tarballs
rm -rf "$tmpdir"/*.orig/doc/misc/ # not included in upstream tarballs
rm -rf "$tmpdir"/*.orig/doc/ref/ # non-editable with free tools (see bug #737478)
export TAR_OPTIONS='--owner root --group root --mode a+rX --format ustar'
tar -cJ --wildcards --exclude '.git*' -C "$tmpdir/" "${orig_dir}" \
> "task_${dfsg_version}.orig.tar.xz"
rm -rf "$tmpdir"

# vim:ts=4 sw=4 et
