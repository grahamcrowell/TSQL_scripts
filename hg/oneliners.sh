# undo local (not added or commit) changes
repo=deployment
src=http://saga.visier.corp/hg/visier/$repo
dst=/home/local/VISIER/gcrowell/$repo
rev=DvToScalaTool
hg clone --rev $rev --verbose --uncompressed $src $dst