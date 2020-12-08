#!/bin/bash

web_server_address="${1}"

rm -f test1G
rm -f test1G.*

wget --progress=bar:force:noscroll -q --show-progress "${web_server_address}:9000/test1G" 1>&2

exit