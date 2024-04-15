TARGET = proj

help:
	@echo Available goals:
	@echo ' run - create and run without debugging '
	@echo ' debug - create and debug '
	@echo ' help - see this message for more information '
$(TARGET): $(TARGET).asm
	nasm -f elf64 -l $(TARGET).lst $(TARGET).asm
	ld -o $(TARGET) $(TARGET).o
run: $(TARGET)
	./$(TARGET)
debug: $(TARGET)
	edb --run $(TARGET)
clear: 
	rm -f $(TARGET)
	rm -f $(TARGET).lst
	rm -f $(TARGET).o