//
//  PlayerModelInfoEnum.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/11.
//

enum PlayerModelInfo : Int {
    case base = 0, type1, type2, type3, type4, type5, type6
    
    var cost: Int {
        get {
            switch self {
            case .base:
                return 0
            case .type1:
                return 100
            case .type2:
                return 200
            case .type3:
                return 300
            default:
                return 1000
            }
        }
    }
    
    var name: String {
        get {
            switch self {
            case .base:
                return "No Skill"
            case .type1:
                return "Quill Spray"
            case .type2:
                return "Time Walk"
            case .type3:
                return "Power Shot"
            default:
                return "Coming Soon"
            }
        }
    }
    
    var model: Durian {
        get {
            switch self {
            case .type1:
                return DurianWithAttack()
            case .type2:
                return DurianWithDash()
            case .type3:
                return DurianWithGun()
            default:
                return Durian()
            }
        }
    }
}
