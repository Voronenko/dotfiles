#!/bin/bash

dd if=/dev/zero of=onetimetestfile  bs=64k count=16k conv=fdatasync; rm onetimetestfile
