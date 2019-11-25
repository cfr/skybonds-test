import Foundation

let shares = ["1.5", "3", "6", "1.5"]

/* O(n), 3 итерации по массиву размера N (с удачной оптимизацией или for-циклом может быть две итерации)
   2N memory: n+1 doubles (8 bytes), n strings (~8 bytes)
 */
func percents3f(from shares: [String]) -> [String] {
    
    let ss = shares.map { Double($0) ?? 0.0 }
    let sum = ss.reduce(0.0) { $0 + $1 }
    
    guard sum > 0 else { return [] }
    
    return ss.map { String(format: "%.3f", $0 / (sum/100.0)) }
}

print(percents3f(from: shares))


/*
 1. Долевое строительство
 Дан массив из N долей, представленных в виде N рациональных:
 [
 '1.5',
 '3', '6', '1.5'
 ]
 Задача
 Написать программу, представляющую эти доли в процентном выражении с точностью до трех знаков после запятой:
 [
 '12.500', '25.000', '50.000', '12.500'
 ]
 Ожидаемое решение
 ● программа на языке Swift 3/4 в виде одного исходного файла, без использования сторонних библиотек, если можно - использовать Playground
 ● вычислительная сложность алгоритма и оценка необходимой памяти для его выполнения,
 ● ограничения на размер входного массива, при котором алгоритм будет выполняться разумное время (до 5 секунд, например).
 */
