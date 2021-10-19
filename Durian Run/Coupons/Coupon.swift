//
//  Coupon.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/10/19.
//

import Foundation

class Coupon: NSObject, NSCoding {
    
    let couponType: String
    let expirationDate: Double
    var numberOfUse: Int
    
    override init() {
        couponType = "Durian Coupon"
        expirationDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 7).timeIntervalSince1970
        numberOfUse = 1
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
