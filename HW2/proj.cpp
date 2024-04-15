#include <stdio.h>
#include <string>
#include <iostream>

auto example = "\
    typedef struct { char name[22]; char family[22]; int old; } student; \
    student stud1={\"Petr\",\"Petrov\",18}, stud2={\"Ivan\", \"Ivanov\", 19}; \
";
// typedef struct { char name[22]; char family[22]; int old; } student; student stud1={"Petr","Petrov",18}, stud2={"Ivan", "Ivanov", 19};
// typedef struct { int old; } student; student stud2={"Ivan", "Ivanov", 19};
typedef int  i;
// struct bca { void *p; };
typedef struct  {}bca;
typedef struct { int p; } adaskjd;
typedef struct aabc aabc1;
struct cca;



typedef struct {
    struct { int a; int b; char ss; } as;
    char dmli;
} poi_; // yes
int dlsfjkn = +1;
typedef struct{struct{int a;}as;char dmli;}poi; // without unnecessary spaces // yes
poi_ adasf = {};
typedef struct{
    int num[1];
    const int cum;
    char c;
    char sum[12];
    const char cc;
    const char sus[21];
    const struct{} abo_ba[2];
    struct{
        struct{
            struct{}b;
            struct{
                struct{
                    struct{}a;
                    struct{}b;
                }a;
                struct{}b;
            }a;
        }a;
    }b;
    struct{
        struct{
            struct{
                struct{}b;
                struct{
                    struct{
                        struct{}a;
                        struct{}b;
                    }a;
                    struct{}b;
                }a;
            }a;
        }a;
    }a;
}a; // yes

a stud1 = {1, 2, 3, 4}; // yes
// asdfdsfadsfs stud2 = {'asd','asdas',1312321}; // yes


void deleteSpaces(std::string st) {
    for (auto c : st) {

    }
}

int main(void) {
    // std::cout << "asdasdad" << std::endl;
    // a b = 1;
    return 0;
}