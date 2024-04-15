#include <iostream>
#include <stdlib.h>

// to see links to functions run:
// $ gcc -c -Wall -o main.o main.cpp 
// '-c' flag does compiling and assemby without linking
// to see object output run:
// $ readelf -s main.o
// $ readelf -sW main.o | grep "substring"
// other solution: print 'extern "C"' before functions. They will hawe same names in links

void max_substring(char *src);
void print_substring(char *begin, int length) {
    if (!begin) {
        std::cout << "Error: there is no repeatable substrings!\n";
        return;
    }

    for (int i = 0; i < length; i++)
        std::cout << *(begin + i);
    std::cout << "\n";
}

int main(void) {
    char *input = (char*)malloc(sizeof(char)*256);
    std::cout << "Введите строку:\n";
    std::cin >> input;
    std::cout << "Повторяющаяся подстрока максимальной длины:\n";
    max_substring(input);
    return 0;
}