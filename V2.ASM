.data
    oneChar db ?   ; Оголошення одного символьного байту для зберігання одного символу.
    searchParam db 255 dup(?)   ; Оголошення масиву з 255 байтів для пошуку параметрів.
    currentLine db 255 dup(?)   ; Оголошення масиву з 255 байтів для поточного рядка.
count dw 0   ; Оголошення двобайтової змінної для лічильника.


_start: 
call read_next                   ; Виклик процедури read_next для читання наступного символу.
call decimal_to_binary          ; Виклик процедури decimal_to_binary для перетворення десяткового числа в двійкове.
call bubble_sort                ; Виклик процедури bubble_sort для сортування.
call calculate_median          ; Виклик процедури calculate_median для обчислення медіани.
call calculate_average         ; Виклик процедури calculate_average для обчислення середнього значення.

mov eax, 1     ; Завантаження номера системного виклику "exit" у регістр eax. Він відповідає за завершення програми.
xor ebx, ebx  ; Обнулення регістра ebx, який використовується як аргумент для системного виклику.
int 0x80          ; Виклик системного виклику з номером 0x80 (128 у десятковій системі), що виконує системний виклик "exit".


read_next:
        mov ah, 3Fh                    ; Завантаження номера операції для читання з файлу.
        mov bx, 0                          ; BX = 0 (стандартний ввід).
        mov cx, 1                          ; Одноразове читання.
        mov dx, offset oneChar   ; Завантаження адреси для зберігання прочитаного символу.
        int 21h                                ; Виклик інтеррупції для читання символу.
        or ax, ax                              ; Перевірка, чи символ не є кінцем файлу.
        jz read_end                         ; Якщо символ кінця файлу, перейти до read_end.
        mov al, [oneChar]           ; Завантаження прочитаного символу в регістр AL.
        mov [currentLine + si], al    ; Збереження прочитаного символу в масиві currentLine.
        mov dl, [currentLine + si]     ; Завантаження символу для виведення.
        mov ah, 02h                        ; Завантаження номера операції для виведення символу.
        int 21h                                ; Виклик інтеррупції для виведення символу.
        inc si                                   ; Інкрементування індексу масиву currentLine.
        cmp al, 0Ah                        ; Порівняння символу з кінцем рядка.
        jz find_string_count_preparation     ; Якщо кінець рядка, перейти до find_string_count_preparation.
        jmp read_next                           ; Перехід до read_next для читання наступного символу.


decimal_to_binary: 
  .CODE 
    MAIN PROC FAR 
      MOV AX, @DATA    ; Завантаження адреси сегменту даних в регістр AX.
      MOV DS, AX       ; Завантаження адреси сегменту даних у регістр DS.

    mov ax, d1         ; Завантаження значення змінної d1 в регістр AX.
    CALL PRINT         ; Виклик підпрограми PRINT для виведення значення на екран.
    MOV AH, 4CH        ; Завантаження номера системного виклику "exit" у регістр AH.
    INT 21H           ; Виклик системного виклику для завершення програми.
  
MAIN ENDP            ; Кінець головної процедури.

PRINT PROC           ; Початок підпрограми виведення.
  mov cx, 0          ; Ініціалізація лічильника cx нулем.
  mov dx, 0          ; Ініціалізація регістра dx нулем.
label1:             ; Мітка для циклу.
  cmp ax, 0          ; Порівняння значення ax з нулем.
  je print1          ; Якщо ax дорівнює нулю, перейти на мітку print1.
  div bx             ; Ділення ax на bx, результат зберігається у ax, а залишок - у dx.
  push dx            ; Зберігання залишку у стек.
  inc cx             ; Інкрементування лічильника cx.
  xor dx, dx         ; Обнулення регістра dx.
  jmp label1         ; Перехід на мітку label1 для продовження циклу.
print1:             ; Мітка для виведення результату.
  cmp cx, 0          ; Порівняння лічильника cx з нулем.
  je exit            ; Якщо cx дорівнює нулю, завершити виведення.
  pop dx             ; Вилучення значення зі стеку у регістр dx.
  add dx, 48         ; Додавання 48 до dx для отримання ASCII-коду цифри.
  mov ah, 02h        ; Завантаження номера системного виклику для виведення символу у регістр ah.
  int 21h            ; Виклик системного виклику для виведення символу.
  dec cx             ; Декрементування лічильника cx.
  jmp print1         ; Повернення на мітку print1 для виведення наступної цифри.
exit:               ; Мітка для виходу з підпрограми.
  ret               ; Повернення до місця виклику підпрограми.

PRINT ENDP           ; Кінець підпрограми виведення.
END MAIN             ; Кінець головної програми.  


bubble_sort: 
array DW 3, 2, 6, 4, 1 
count DW 5
    mov cx, word ptr count        ; Завантаження кількості елементів масиву.
    dec cx                                          ; Зменшення лічильника на 1.
outerLoop:
    push cx                                          ; Збереження значення лічильника у стек.
    lea si, array                              ; Завантаження адреси початку масиву в регістр SI.
innerLoop:
    mov ax, [si]                               ; Завантаження значення елемента масиву в регістр AX.
    cmp ax, [si+2]                           ; Порівняння поточного елемента з наступним.
    jl nextStep                               ; Якщо поточний менший за наступний, перейти на nextStep.
    xchg [si+2], ax                         ; Обмін значень, якщо поточний більший за наступний.
    mov [si], ax                               ; Збереження нового значення поточного елемента.
nextStep:
    add si, 2                                      ; Перехід до наступного елемента масиву.
    loop innerLoop                           ; Повторення внутрішнього циклу.
    pop cx                                          ; Відновлення значення лічильника зі стеку.
    loop outerLoop                          ; Повторення зовнішнього циклу.


calculate_median: 
mov ax, 0                                      ; Очищення регістра AX.
mov bx, count                              ; Завантаження кількості елементів масиву в регістр BX.
mov dx, bx                                     ; Копіювання кількості елементів для подальшого використання.
shr bx, 1                                         ; Зсув значення вправо на 1 (ділення на 2).
jnc no_remainder                           ; Якщо немає залишку, перейти до no_remainder.
inc ax                                              ; Інкрементувати результат, якщо є залишок.
no_remainder:
mov si, 0                                         ; Очищення регістра SI.
mov cx, bx                                      ; Завантаження кількості елементів масиву в лічильник.
calculate_median_loop:
add ax, [array + si]                     ; Додавання значення елемента масиву до результату.
add si, 2                                         ; Перехід до наступного елемента масиву.
loop calculate_median_loop            ; Повторення циклу.
mov dx, ax                                     ; Завантаження результату до регістра DX.
mov ax, dx                                     ; Копіювання результату для подальшого використання.
div dx                                              ; Ділення AX на DX для обчислення медіани.


calculate_average: 
mov ax, 0                                       ; Очищення регістра AX.
mov si, 0                                         ; Очищення регістра SI.
mov cx, count                                 ; Завантаження кількості елементів масиву в лічильник.
calculate_average_loop:
    add ax, [array + si]                   ; Додавання значення елемента масиву до результату.
    add si, 2                                      ; Перехід до наступного елемента масиву.
    loop calculate_average_loop        ; Повторення циклу.
mov dx, 0                                        ; Очищення регістра DX.
mov bx, count                                ; Завантаження кількості елементів масиву в регістр BX.
div bx                                                ; Ділення AX на BX для обчислення середнього значення.