proot-version      = proot-latest
care-version       = care-latest

prefix = $(PWD)/prefix
$(prefix):
	mkdir $@

packages = ./packages

