CC := clang
CFLAGS := -fobjc-arc -Wall -Wextra -Werror
FRAMEWORKS := -framework Foundation
TARGET := copy-semantics-demo

.PHONY: run clean

$(TARGET): Sources/main.m
	$(CC) $(CFLAGS) $(FRAMEWORKS) $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)
