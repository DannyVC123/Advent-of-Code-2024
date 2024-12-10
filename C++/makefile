# Compiler settings
CXX = g++
CXXFLAGS = -std=c++17 -g -Wall -lm -lpthread --coverage -Wno-unused-variable -Wno-unused-function -Wno-write-strings

# Source files
SRC = main.cpp

# Output executable
OUT = a.out

build:
	rm -f $(OUT) *.gcda *.gcno
	$(CXX) $(CXXFLAGS) $(SRC) -o $(OUT)

run:
	rm -f *.gcda
	./$(OUT)

valgrind:
	rm -f $(OUT) *.gcda *.gcno
	$(CXX) $(CXXFLAGS) $(SRC) -o $(OUT)
	valgrind --tool=memcheck --leak-check=full ./$(OUT)

clean:
	rm -f $(OUT) *.gcda *.gcno
