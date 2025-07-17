it: clean build
build: binaries
clean:
	rm -rf bin || true
docker:
	docker buildx bake local --load
binaries:
	docker buildx bake binaries --load
