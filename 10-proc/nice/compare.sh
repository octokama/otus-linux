#!/usr/bin/env bash

./notnice.sh &
sudo nice -n -20 ./nice.sh &