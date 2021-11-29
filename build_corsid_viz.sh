docker build -t corsid-viz .
docker run --name vue_app_container --rm -it -d -p 8080:8080 corsid-viz
