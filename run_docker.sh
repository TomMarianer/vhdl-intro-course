#!/bin/bash
if ! pgrep Xquartz > /dev/null; then
  echo "Starting Xquartz"
  Xquartz &
fi

echo "Continuing"
xhost + 127.0.0.1
echo "Continuing"
docker run --name ghdl -it --rm -e DISPLAY=host.docker.internal:0 -v ~/Documents/Repositories/vhdl-intro-course/:/hdl ghdl-gtkwave