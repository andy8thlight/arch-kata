# Architecture Kata

## C4 diagrams

The architecture diagrams can be found in the c4 directory. You can view them by using 
'structurizr':

podman pull structurizr/lite
podman run -it --rm -p 8080:8080 -v $PWD/c4:/usr/local/structurizr structurizr/lite
