//
//  SEPModel.swift
//  Pset3
//
//  Created by Mert Arıcan on 5.03.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct SEPModel {
    
    private(set) var memo = Dictionary<Sr, [[Int]]>()
    // Hafızayı oluştur.
    
    private(set) var totalCount = 0
    // totalCount değişkeni, fonksiyonun kaç kez çağırıldığını takip etmek için kullanılıyor.

    private(set) var memoCount = 0
    // memoCount değişkeni, hafızadan kaç kez değer alındığını takip etmek için kullanılıyor.

    private func getBaseSolutions(for k: Int) -> [[Int]] {
        // Tüm S2(k) çözümlerini döndürür.
        var baseSolutions = [[Int]]()
        // baseSolutions adlı boş bir liste oluştur.
        let upperLimit = Int(sqrt(Double(k-1))) + 1
        // d'nin alabileceği üst limiti belirle ve upperLimit değişkenine ata.
        if k == 2 { return [[2, 2]] }
        // Eğer k = 2 ise {2,2} çözümünü döndür.
        for d in 1...upperLimit {
            // 1'den upperLimit'e kadar olan her bir d değeri için...
            if (k-1) % d == 0 {
                // Eğer d (k-1)'e tam bölünebiliyorsa...
                var solution = [Int]()
                // Boş bir çözüm kümesi oluştur.
                for _ in 1...(k-2) { solution.append(1) }
                // solution'a (k-1) adet 1'i ekle.
                solution.append(((k-1)/d)+1)
                // solution'a ((k-1/d)+1)'i ekle.
                solution.append(d+1)
                // solution'a (d+1)'i ekle.
                baseSolutions.append(solution)
                // baseSolutions'a solution'u ekle.
            }
        }
        return baseSolutions
    }
    
    private mutating func calcShell(k: Int, r: Int) -> [[Int]]? {
        // Sr(k)'nın çözüm kümesini, var ise, döndürür.
        totalCount += 1
        var sr = Sr(k: k, r: r)
        // Sr(n) değişkeni oluşturuldu
        if let solutions = memo[sr] {
            // Eğer Sr(n) değişkeni hafızadaysa (daha önceden hesaplandıysa) hafızadaki değeri döndür.
            memoCount += 1
            return solutions
        }
        if r == 2 {
            // Eğer r = 2 ise ...
            let baseSolutions = getBaseSolutions(for: k)
            // Fonksiyondan dönen değeri baseSolutions'a ata.
            sr.solutions.append(contentsOf: baseSolutions)
            // Sr(n) değişkeninin solutions listesine baseSolutions'u ekle.
            memo[sr] = sr.solutions
            // Sr(n)'i hafızaya ekle.
            return sr.solutions
        }
        let start = Int(floor(Float(k - (3*r) + 2) / Float(2)))
        // j'nin maksimum değerini belirle.
        let end = Int(pow(2.0, (Float(r-2)))) - r
        // j'nin minimum değerini belirle.
        if end > start { return nil }
        // Eğer minimum maksimumdan büyükse nil (hiç) döndür.
        for j in (end...start).reversed() {
            // minimum ve maksimum aralığını ters çevir ve her bir j değeri için ...
            if let sr2Solutions = calcShell(k: j+r, r: r-1) {
                // fonksiyondan dönen değeri sr2Solutions değişkenine ata
                for solution in sr2Solutions {
                    // sr2Solutions'taki her bir çözüm için...
                    if solution == [] { continue }
                    // eğer çözüm boş ise döngüdeki bir sonraki solution'a atla
                    let temp = solution.filter { $0 != 1 }
                    // solution'daki bir olmayan değerleri belirle.
                    let sum = Float(temp.reduce(0, +) + j)
                    // temp değerlerinin toplamını bul.
                    let w = 1 + (Float(k - r - j) / (sum))
                    // w değerini daha önceden belirlendiği üzere bul.
                    if w == floor(w) {
                        // Eğer w tam sayı ise...
                        var newSolution = solution
                        // solution değerini newSolution değişkenine ata.
                        newSolution.append(Int(w))
                        // newSolution değişkenine w değerini ekle.
                        if k - newSolution.count > 0 {
                            // Eğer eleman sayısında eksik varsa...
                            for _ in 1...(k - newSolution.count) { newSolution.append(1) }
                            // newSolution' eleman sayısındaki eksik kadar 1 ekle.
                        }
                        sr.solutions.append(newSolution)
                        // Sr(n)'nin çözüm kümesine newSolution'ı ekle.
                    }
                }
            }
        }
        memo[sr] = sr.solutions
        // Sr(n)'nin çözümünü hafızaya ekle.
        return sr.solutions
    }
    
    mutating func calcSolution(for n: Int) -> [[String]] {
        // S(n)'nin çözüm kümesini belirler. Çözümlerin metinsel açıklamasını döndürür.
        var solutions = [[Int]]()
        // Çözümler listesi oluşturulur.
        let upperLimit = Int((log2(Double(n)))) + 1
        // r'nin alabileceği üst limit belirlenir.
        for r in (2...upperLimit).reversed() {
            // üst limit ile 2 arasındaki her bir r değeri için...
            if let solution = calcShell(k: n, r: r), solution != [] {
                // Eğer bir çözüm varsa ve bu çözüm boş küme değilse çözümü çözümler listesine ekle.
                solutions.append(contentsOf:solution)
            }
        }
        // Çözümlerin metinsel açıklamasını döndür.
        return descGenerator(x: solutions)
    }
    
}

extension SEPModel {
    
    private func descGenerator(x: [[Int]]) -> [[String]] {
        var lo = [[String]]()
        for e in x {
            var count = 0
            var l = [String]()
            e.forEach { if $0 == 1 { count += 1 } else { l.append(String($0)) } }
            l.sort()
            l.append(String(count))
            if !lo.contains(l) {
                lo.append(l)
            }
        }
        return lo
    }
    
    mutating func clearModel() {
        totalCount = 0; memoCount = 0
        memo = [:]
    }
    
}
