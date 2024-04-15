ASM_SOURCE = logic
CXX_SOURCE = main
OUTPUT = proj
help:
	@echo Available goals:
	@echo ' run - create and run without debugging '
	@echo ' debug - create and debug '
	@echo ' clear - remove generated files '
	@echo ' help - see this message for more information '
$(OUTPUT): $(ASM_SOURCE).asm $(CXX_SOURCE).cpp
	nasm -f elf64 -l $(ASM_SOURCE).lst $(ASM_SOURCE).asm
	g++  -Wall -o $(OUTPUT) $(ASM_SOURCE).o $(CXX_SOURCE).cpp
run: $(OUTPUT)
	./$(OUTPUT)

debug: $(OUTPUT)
	edb --run $(OUTPUT)

clear: 
	rm -f $(OUTPUT)
	rm -f $(ASM_SOURCE).lst
	rm -f $(ASM_SOURCE).o
	