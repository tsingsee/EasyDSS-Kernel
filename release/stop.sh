#!/bin/bash
CWD=$(cd "$(dirname $0)";pwd)

$CWD/easydss -s stop > /dev/null 2>&1
