#include"iostream"
#include <fstream>

using namespace std;
std::ofstream file("out.txt");

extern "C" {void func(int* arr, int length, int* lgi, int count, int* res, int* sum); }

int main() {
    srand(time(NULL));
    int length;
    int Xmin, Xmax;
    int count;

    do {
        cout << "Array size: ";
        cin >> length;
    } while ((length > 16000) || (length < 0));

    do {
        cout << "XMin: ";
        cin >> Xmin;
        cout << "XMax: ";
        cin >> Xmax;
    } while (Xmin > Xmax);

    int* arr = new int[length];
    for (int i = 0; i < length; i++)
        arr[i] = Xmin + rand() % (Xmax - Xmin + 1);

    do {
        cout << "Number of the intervals: ";
        cin >> count;
    } while ((count > 24) || (count < 1) || (count > (Xmax - Xmin + 1)));

    int* lgi = new int[count];
    for (int i = 0; i < count; i++) {
        do {
            cout << "Border " << i + 1 << ": ";
            cin >> lgi[i];
        } while ((lgi[i] < Xmin) || (lgi[i] > Xmax));
    }

    for (int i = 0; i < count; i++)
        for (int j = i; j < count; j++)
            if (lgi[i] > lgi[j])
                swap(lgi[i], lgi[j]);

    file << "Array: ";
    std::cout << "Array: ";
    for (int i = 0; i < length; i++) {
        file << arr[i] << " ";
        std::cout << arr[i] << " ";
    }

    for (int i = 0; i < length; i++)
        for (int j = i; j < length; j++)
            if (arr[i] > arr[j])
                swap(arr[i], arr[j]);


    int* res = new int[count];
    for (int i = 0; i < count; i++)
        res[i] = 0;

    int* sum = new int[count];
    for (int i = 0; i < count; i++)
        res[i] = 0;

    func(arr, length, lgi, count, res, sum);

    std::cout << "\n";
    file << "\n";
    cout << "Index\tBorder\tCount\tSum\n";
    file << "Index\tBorder\tCount\tSum\n";
    for (int i = 0; i < count; i++) {
        cout << i + 1 << "\t" << lgi[i] << "\t" << res[i] << "\t" << sum[i] << "\n";
        file << i + 1 << "\t" << lgi[i] << "\t" << res[i] << "\t" << sum[i] << "\n";
    }

    file.close();
    return 0;
}
