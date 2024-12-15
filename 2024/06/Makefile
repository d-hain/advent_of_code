NAME=day-06
BUILD_DIR=build

ifndef (VISUALIZE)
	VISUALIZE=false
endif

BUILD_FLAGS=-define:VISUALIZE=$(VISUALIZE) -lld -vet-shadowing -vet-using-stmt -vet-using-param -vet-style

.PHONY: run-debug run-release build-release

run-debug: $(BUILD_DIR)
	odin run src -out:$(BUILD_DIR)/$(NAME) -debug $(BUILD_FLAGS)

run-release: $(BUILD_DIR)/release
	odin run src -out:$(BUILD_DIR)/release/$(NAME) $(BUILD_FLAGS)

build-release: $(BUILD_DIR)/release
	odin build src -out:$(BUILD_DIR)/release/$(NAME) $(BUILD_FLAGS)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/release:
	mkdir -p $(BUILD_DIR)/release
