#!/bin/sh

bundle
rake db:reset
rake spec
