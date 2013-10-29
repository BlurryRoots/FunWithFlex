COMPILER = g++
COMPILER_FLAGS = -std=c++11 -Wall

PROJECT_NAME = lispish

BUILD_PATH = bin
SCRIPT_PATH = scripts

TEST_SCRIPT = test.lispish

LEXER = $(PROJECT_NAME).lexer
PARSER = $(PROJECT_NAME).parser

LEX = flex
LEX_FLAGS = -o $(LEXER).cpp

# platform dependent options
ifeq ($(OS),Windows_NT)
	OUTFILE = $(PROJECT_NAME).exe
	CHMOD =
	RUNCOMMAND = cd $(BUILD_PATH)/ && $(OUTFILE) < $(TEST_SCRIPT)
else
	OUTFILE = $(PROJECT_NAME)
	CHMOD = chmod +x $(BINARIES)/$(OUTFILE)
	RUNCOMMAND = ./$(BUILD_PATH)/$(OUTFILE) < $(TEST_SCRIPT)
endif

clean:
	rm -f $(LEXER).cpp
	rm -rf $(BUILD_PATH)

prepare:	
	mkdir $(BUILD_PATH)

# create the lexer source
create-lexer:
	$(LEX) $(LEX_FLAGS) $(PROJECT_NAME).l

# no compiler flags here, they cause weird flex errors
build-lexer:
	$(COMPILER) -c $(LEXER).cpp -o $(BUILD_PATH)/$(LEXER).o

build-parser:	
	$(COMPILER) $(COMPILER_FLAGS) -c $(PARSER).cpp -o $(BUILD_PATH)/$(PARSER).o

link:
	cd $(BUILD_PATH) && $(COMPILER) $(PARSER).o $(LEXER).o -o $(OUTFILE)
	$(CHMOD)

test:
	cp -av $(SCRIPT_PATH)/$(TEST_SCRIPT) $(BUILD_PATH)
	$(RUNCOMMAND)

all: clean prepare create-lexer build-lexer build-parser link test
