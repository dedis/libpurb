.PHONY: all tidy lint vet test coverage

# Default "make" target to check locally that everything is ok, BEFORE pushing remotely
all: lint vet test
	@echo "Done with the standard checks"

tidy:
	go mod tidy

# Some packages are excluded from staticcheck due to deprecated warnings: #208.
lint: tidy
	golangci-lint run

vet: tidy
	go vet go.dedis.ch/libpurb/...

test: tidy
	# Test without coverage
	LLVL=""
	go test go.dedis.ch/libpurb/...

coverage: tidy
	# Test and generate a coverage output usable by sonarcloud
	LLVL=""
	go test -json -covermode=count -coverpkg=libpurb/... -coverprofile=profile.cov go.dedis.ch/libpurb/... | tee report.json
