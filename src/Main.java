import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Клас для обчислення медіани та середнього значення десяткових чисел
 */
public class Main {

    /**
     * Головний метод програми
     */
    public static void main(String[] args) throws IOException {
        System.out.println("Введіть десяткові числа, розділені пробілом або новим рядком:");
        Long[] decimalNumbers = readDecimalNumbersFromInput();

        BinaryNumber[] binaryNumbers = convertToBinary(decimalNumbers);
        mergeSort(binaryNumbers, 0, binaryNumbers.length - 1);

        // Вивід медіани та середнього значення
        long median = calculateMedian(binaryNumbers);
        double average = calculateAverage(binaryNumbers);
        System.out.println("Результат:");
        System.out.println(median);
        System.out.println(average);
    }

    /**
     * Метод для зчитування десяткових чисел з консолі
     */
    private static Long[] readDecimalNumbersFromInput() throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String line = reader.readLine();
        String[] tokens = line.trim().split("\\s+");
        Long[] decimalNumbers = new Long[tokens.length];
        for (int i = 0; i < tokens.length; i++) {
            try {
                decimalNumbers[i] = Long.parseLong(tokens[i]);
            } catch (NumberFormatException e) {
                // Ігноруємо некоректні числа
            }
        }
        return decimalNumbers;
    }

    /**
     * Метод для конвертації десяткових чисел у бінарне представлення
     */
    private static BinaryNumber[] convertToBinary(Long[] decimalNumbers) {
        BinaryNumber[] binaryNumbers = new BinaryNumber[decimalNumbers.length];
        for (int i = 0; i < decimalNumbers.length; i++) {
            binaryNumbers[i] = new BinaryNumber(decimalNumbers[i]);
        }
        return binaryNumbers;
    }

    /**
     * Метод для сортування масиву бінарних чисел методом злиття
     */
    private static void mergeSort(BinaryNumber[] array, int left, int right) {
        if (left < right) {
            int mid = (left + right) / 2;
            mergeSort(array, left, mid);
            mergeSort(array, mid + 1, right);
            merge(array, left, mid, right);
        }
    }

    /**
     * Метод для злиття двох підмасивів під час сортування злиттям
     */
    private static void merge(BinaryNumber[] array, int left, int mid, int right) {
        int n1 = mid - left + 1;
        int n2 = right - mid;

        BinaryNumber[] leftArray = new BinaryNumber[n1];
        BinaryNumber[] rightArray = new BinaryNumber[n2];

        System.arraycopy(array, left, leftArray, 0, n1);
        System.arraycopy(array, mid + 1, rightArray, 0, n2);

        int i = 0, j = 0;
        int k = left;
        while (i < n1 && j < n2) {
            if (leftArray[i].compareTo(rightArray[j]) <= 0) {
                array[k] = leftArray[i];
                i++;
            } else {
                array[k] = rightArray[j];
                j++;
            }
            k++;
        }

        while (i < n1) {
            array[k] = leftArray[i];
            i++;
            k++;
        }

        while (j < n2) {
            array[k] = rightArray[j];
            j++;
            k++;
        }
    }

    /**
     * Метод для обчислення медіани з відсортованого масиву бінарних чисел
     */
    private static long calculateMedian(BinaryNumber[] array) {
        int size = array.length;
        if (size % 2 == 0) {
            return (array[size / 2 - 1].getValue() + array[size / 2].getValue()) / 2;
        } else {
            return array[size / 2].getValue();
        }
    }

    /**
     * Метод для обчислення середнього значення з масиву бінарних чисел
     */
    private static double calculateAverage(BinaryNumber[] array) {
        long sum = 0;
        for (BinaryNumber binaryNumber : array) {
            sum += binaryNumber.getValue();
        }
        return (double) sum / array.length;
    }

    /**
     * Вкладений клас, який представляє бінарне число
     */
    private static class BinaryNumber implements Comparable<BinaryNumber> {
        private final long value;

        /**
         * Конструктор, який створює об'єкт бінарного числа з десяткового числа
         */
        public BinaryNumber(long decimalNumber) {
            this.value = Math.min(decimalNumber, Short.MAX_VALUE);
        }

        /**
         * Метод, що повертає значення бінарного числа
         */
        public long getValue() {
            return value;
        }

        /**
         * Порівняння двох бінарних чисел
         */
        @Override
        public int compareTo(BinaryNumber other) {
            return Long.compare(this.value, other.value);
        }
    }
}










