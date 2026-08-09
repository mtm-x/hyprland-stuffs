#!/bin/zsh

# 1. Initialize the ARM emulator (Safe to run multiple times)
docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3 >/dev/null 2>&1

# 2. Check if the container exists
if docker ps -a --format '{{.Names}}' | grep -Eq "^training-test$"; then
  echo "Starting existing 'training' container..."
  docker start training-test
else
  echo "Creating new 'training' container..."
  docker run -dit -u 1000:1000 -v /home:/home -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -v /etc/shadow:/etc/shadow:ro --name training-test training:latest /bin/bash
fi

# 3. Drop into the shell
docker exec -it training-test /bin/bash
