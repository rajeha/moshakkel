#!/usr/bin/env bash
# remove diacrits
perl -CSDL -ple 's/[^\p{Arabic}\p{Punct}\s]//g'
