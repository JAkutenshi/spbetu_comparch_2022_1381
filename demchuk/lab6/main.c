#include <stdio.h>
#include "stdlib.h"
#include "time.h"

int cmp(const void *a, const void *b){
    return *(int*)a - *(int*)b;
}

void func (int*, int*, int, int, int*);

int main () {
    srand(time(NULL));
    int NumRanDat, Xmin, Xmax, NInt;

    printf("Введите длину массива, диапазон изменения массива и количество интервалов:\n");
    scanf("%d %d %d %d", &NumRanDat, &Xmin, &Xmax, &NInt);

    if (NumRanDat < 0 || NumRanDat > 16384 || Xmin >= Xmax || NInt < 0 || NInt > 24){
        printf("Неверно введенные данные.\n");
        return 0;
    }

    int* LGrInt = calloc(NInt, sizeof(int));

    printf("Введите левые границы интервалов интервалов:\n");

    for (int i = 0; i < NInt - 1; i++){
        scanf("%d", &LGrInt[i]);
        if (LGrInt[i] < Xmin || LGrInt[i] > Xmax){
            printf("Неверно введенные данные.\n");
            return 0;
        }
    }

    qsort(LGrInt, NInt-1, sizeof(int), cmp);

    int* arr = calloc(NumRanDat, sizeof(int));
    printf("Массив псевдослучайных чисел:\n");
    for (int i = 0; i < NumRanDat; i++){
        arr[i] = rand() % (Xmax - Xmin) + Xmin;
        printf("%d ", arr[i]);
    }
    printf("\n");

    int* res = calloc(NInt, sizeof(int));
    for (int i = 0; i < NInt; i++){
        res[i] = 0;
    }

    func(arr, LGrInt, NInt, NumRanDat, res);

    FILE* file = fopen("result.txt", "w");
    
    printf("Результат:\n");
    printf("%d\t%d\t%d\n", 1, Xmin, res[0]);
    fprintf(file, "%d\t%d\t%d\n", 1, Xmin, res[0]);
    for (int i = 2; i < NInt + 1; i++){
        printf("%d\t%d\t%d\n", i, LGrInt[i-2], res[i-1]);
        fprintf(file, "%d\t%d\t%d\n", i, LGrInt[i-2], res[i-1]);
    }

    fclose(file);
    free(LGrInt);
    free(arr);
    free(res);

    return 0;
}
