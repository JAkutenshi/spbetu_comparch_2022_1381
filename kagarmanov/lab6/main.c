#include <stdio.h>
#include <stdlib.h>
#include <time.h>


int rand_between(int const from, int const to) {
  if (to == from)
    return to;
  if (to < from)
    return rand_between(to, from);
  return from + rand() % (to-from+1);

}



void module(int*, int*, int, int, int*);

int cmp(const void *a, const void *b){
    return *(int*)a - *(int*)b;
}

int main () {
    srand(time(NULL));
    int NumRanDat, Xmin, Xmax, NInt;

    printf("\t---Введите длину массива, минимум и максимум диапазона и количество интервалов---:\n");
    scanf("%d %d %d %d", &NumRanDat, &Xmin, &Xmax, &NInt);

    int* LGrInt = calloc(NInt, sizeof(int));

    printf("\t---Введите левые границы интервалов---(их %d)\n", NInt-1);
    LGrInt[0] = Xmin;
    for (int i = 1; i < NInt; i++){
        scanf("%d", &LGrInt[i]);
    }

    qsort(LGrInt, NInt-1, sizeof(int), cmp);

    int* arr = calloc(NumRanDat, sizeof(int));
    printf("\t---Массив псевдослучайных чисел---:\n");
    for (int i = 0; i < NumRanDat; i++){
        arr[i] = rand_between(Xmin, Xmax);
        printf("%d ", arr[i]);
    }
    printf("\n");

    int* res = calloc(NInt, sizeof(int));

    module(arr, LGrInt, NInt, NumRanDat, res);
    qsort(arr, NumRanDat, sizeof(int), cmp);

    for (int i = 0; i < NumRanDat; i++)
        printf("%d ", arr[i]);
    printf("\n");
    FILE* file = fopen("answer.txt", "w");

    printf("\t---Результат--:\n");
    printf("%d)\t[%d;%d)\t%d\n", 1, Xmin,LGrInt[1], res[0]);
    fprintf(file, "%d)\t[%d;%d)\t%d\n", 1, Xmin,LGrInt[0], res[0]);
    int tmp;
    for (int i = 1; i < NInt-1; i++){
        printf("%d)\t[%d;%d)\t%d\n", i+1, LGrInt[i],LGrInt[i+1], res[i]);
        fprintf(file, "%d)\t[%d;%d)\t%d\n", i+1, LGrInt[i],LGrInt[i+1], res[i]);
        tmp = i;
    }
    printf("%d)\t[%d;%d]\t%d\n", tmp+1, LGrInt[NInt-1], Xmax, res[NInt-1]);
    fprintf(file, "%d)\t[%d;%d]\t%d\n", tmp+1, LGrInt[NInt-2], Xmax, res[NInt-1]);

    free(LGrInt);
    free(arr);
    free(res);
    fclose(file);

    return 0;
}
