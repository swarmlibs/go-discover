make:
	docker buildx bake local --load
binaries:
	docker buildx bake binaries --load
