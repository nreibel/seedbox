#!/bin/sh
service minidlna stop
rm /var/cache/minidlna/files.db
service minidlna start
