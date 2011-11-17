#!/bin/sh

export RAILS_ENV=test
bundle > log/build.out
rake db:reset >> log/build.out
rake spec >> log/build.out

