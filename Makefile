build: binaries
docker:
	docker buildx bake local --load
binaries:
	docker buildx bake binaries --load
