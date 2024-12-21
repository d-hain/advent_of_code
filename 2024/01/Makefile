NAME=day-01
BUILD_DIR=build

BUILD_FLAGS=-lld -vet -vet-using-param -vet-style -vet-cast

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
