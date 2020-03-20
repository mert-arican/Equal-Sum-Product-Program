//
//  Sr.swift
//  Pset3
//
//  Created by Mert Arıcan on 5.03.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct Sr: Hashable {
    
    // Hashable protokolünü sağlayan objeler karşılaştırılabilir olmalıdır.
    static func == (lhs: Sr, rhs: Sr) -> Bool {
        // Eğer iki Sr değişkeninin k ve r değerleri aynı ise bunlar eşit kabul edilir.
        lhs.k == rhs.k && lhs.r == rhs.r
    }
    
    let k: Int
    // Sr(k)'daki k değeridir.
    
    let r: Int
    // Sr(k)'daki r değeridir.
    
    var solutions = [[Int]]()
    // Sr(k)'nın çözüm kümesini temsil eder, başlangıç değeri boş listedir.
    
    init(k: Int, r: Int) {
        // Sr struct'ının oluşturucusudur.
        self.k = k ; self.r = r
    }
    
    func hash(into hasher: inout Hasher) {
    /* Sr türündeki değişkenleri Dictionary türüyle kullanabilmek için hash değerleri gerekir.
        hasher'a değişkenin hash değeri oluşturulurken hangi değişkenleri kullanacağı iletilir. */
        hasher.combine(k)
        hasher.combine(r)
    }
    
}
