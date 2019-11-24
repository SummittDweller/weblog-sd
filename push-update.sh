#!/bin/bash
cd ~/Documents/GitHub/weblog-sd
perl -i.bak -lpe 'BEGIN { sub inc { my ($num) = @_; ++$num } } s/(build = )(\d+)/$1 . (inc($2))/eg' config.toml
docker image build -t blog-update .
docker login
docker tag blog-update summittdweller/weblog-sd:latest
docker push summittdweller/weblog-sd:latest
