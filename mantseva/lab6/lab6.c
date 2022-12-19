#include <stdio.h>
#include <time.h>
#include <stdlib.h>

extern void distribution(int *randarr, int *borders, int borders_len, int randarr_len, int *result);

int main()
{
    int randarr_len;
    int min;
    int max;
    int borders_len;
    printf("Enter array length\n");
    scanf("%d", &randarr_len);
    if (0 >= randarr_len)
    {
        printf("Wrong length\n");
        return 0;
    }
    printf("Enter min and max\n");
    scanf("%d %d", &min, &max);
    if (min >= max)
    {
        printf("Wrong range\n");
        return 0;
    }
    printf("Enter number of intervals\n");
    scanf("%d", &borders_len);
    if (0 >= borders_len || borders_len > 24)
    {
        printf("Wrong number\n");

        return 0;
    }
    int *borders = calloc(borders_len, sizeof(int));
    printf("Enter borders in ascending order\n");
    for (int i = 0; i < borders_len; i++)
    {
        scanf("%d", &borders[i]);
        if (borders[i]<min | borders[i]> max)
        {
            printf("Wrong border\n");
            free(borders);
            return 0;
        }
    }

    int *result = calloc(borders_len, sizeof(int));
    srand(time(NULL));

    int *randarr = calloc(randarr_len, sizeof(int));
    printf("Random numbers:\n");
    for (int i = 0; i < randarr_len; i++)
    {
        randarr[i] = min + rand() % (max - min + 1);
        printf("%d ", randarr[i]);
    }

    distribution(randarr, borders, borders_len, randarr_len, result);

    printf("\n");
    FILE *file;
    file = fopen("result.txt", "w");
    for (int i = 0; i < borders_len; i++)
    {
        if (i < borders_len - 1)
        {
            printf("%d numbers in [%d,%d) interval\n", result[i], borders[i], borders[i + 1]);
        }
        else
        {
            printf("%d numbers in [%d,%d] interval\n", result[i], borders[i], max);
        }
        fprintf(file, "interval №%d, border - %d, result - %d\n", i + 1, borders[i], result[i]);
    }
    fclose(file);
    free(result);
    free(borders);
    free(randarr);

    return 0;
}
