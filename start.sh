#! /bin/bash

usermod -u 106 jenkins
groupmod -g 112 jenkins

su jenkins

( exec "/usr/local/bin/jenkins.sh")
