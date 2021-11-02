//
//  Coupon.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/10/19.
//

import Foundation

class Coupon: NSObject, NSCoding {
    
    let couponType: String
    private let expirationDate: Double
    var numberOfUse: Int
    
    override init() {
        couponType = "Durian Coupon"
        expirationDate = Date(timeIntervalSinceNow: 7).timeIntervalSince1970
        numberOfUse = 1
    }
    
    init(random: Bool) {
        if random {
            couponType = "Random Coupon \(arc4random_uniform(32))"
            expirationDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * Double(arc4random_uniform(31) + 1)).timeIntervalSince1970
            numberOfUse = Int(1 + arc4random_uniform(5))
        } else {
            couponType = "Durian Coupon"
            expirationDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 7).timeIntervalSince1970
            numberOfUse = 1
        }
    }
    
    init(type: String, duration_day: Int, use: Int) {
        couponType = type
        expirationDate = Date(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * duration_day)).timeIntervalSince1970
        numberOfUse = use
    }
    
    init(type: String, expiration_date: Double, use: Int) {
        couponType = type
        expirationDate = expiration_date
        numberOfUse = use
    }
    
    required convenience init?(coder: NSCoder)
    {
        guard let decodedType = coder.decodeObject(forKey: "type") as? String
        else { return nil }
        
        self.init(
            type: decodedType,
            expiration_date: coder.decodeDouble(forKey: "date"),
            use: coder.decodeInteger(forKey: "uses")
        )
    }
    
   
    func encode(with coder: NSCoder) {
        coder.encode(couponType, forKey: "type")
        coder.encode(expirationDate, forKey: "date")
        coder.encode(numberOfUse, forKey: "uses")
    }
    
    func getExprirationDate() -> String {
        return Date(timeIntervalSince1970: expirationDate).toString(dateFormat: "MMM dd, yyyy HH:mm")
    }
    
    func checkDate() -> Bool {
       return Date(timeIntervalSinceNow: 0).timeIntervalSince1970 <= expirationDate
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
