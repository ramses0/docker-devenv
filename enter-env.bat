docker run -v c:/Users/Admin/Documents/:/home/rames/Git -v c:/Users/Admin/Documents/:/home/rames/host -v c:/Users/Admin/.ssh/:/home/rames/.ssh -p 127.0.0.1:1235:5900 -w /home/rames/ -i -t rames-devenv:latest bash

echo "Hello -v c:/Users/Admin/Documents/:/home/rames/Git -v c:/Users/Admin/Documents/:/home/rames/host"
