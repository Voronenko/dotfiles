#!/bin/sh
EXCLUDE_FROM_GC={$EXCLUDE_FROM_GC-/etc/docker-gc-exclude}
FORCE_IMAGE_REMOVAL=1 docker-gc
