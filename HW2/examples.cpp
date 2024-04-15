typedef struct { char name[22]; char family[22]; int old; } student; student stud1={"Petr","Petrov",18}, stud2={"Ivan", "Ivanov", 19};

typedef struct{char z;int c [1233];}ts1;ts1 a={"aaaa",14,'a',34,54};
typedef struct{}ts1;ts1 a={'aaaa'};
typedef struct{}ts1;ts1 a={1.1};
typedef struct{double d;}ts1;ts1 a={};
typedef{int a;}ts1;
struct ts1;ts1 a={'a'};

typedef struct {};
struct {};
struct { char a[12]; } a = { 14 };
struct { char a[12]; } a = { 'aaaaa' };
