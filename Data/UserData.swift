import Foundation
import SwiftUI

class UserData {
    @AppStorage("userName") private var userName = ""
    @AppStorage("pushMessageTime") private var pushMessageTime = Date()
    @AppStorage("flag") private var flag = 0
    
    @AppStorage("date0") private var date0 = Date()
    @AppStorage("value0") private var value0: Double = 0.0
    @AppStorage("valid0") private var valid0: Bool = false
    @AppStorage("date1") private var date1 = Date()
    @AppStorage("value1") private var value1: Double = 0.0
    @AppStorage("valid1") private var valid1: Bool = false
    @AppStorage("date2") private var date2 = Date()
    @AppStorage("value2") private var value2: Double = 0.0
    @AppStorage("valid2") private var valid2: Bool = false
    @AppStorage("date3") private var date3 = Date()
    @AppStorage("value3") private var value3: Double = 0.0
    @AppStorage("valid3") private var valid3: Bool = false
    @AppStorage("date4") private var date4 = Date()
    @AppStorage("value4") private var value4: Double = 0.0
    @AppStorage("valid4") private var valid4: Bool = false
    @AppStorage("date5") private var date5 = Date()
    @AppStorage("value5") private var value5: Double = 0.0
    @AppStorage("valid5") private var valid5: Bool = false
    @AppStorage("date6") private var date6 = Date()
    @AppStorage("value6") private var value6: Double = 0.0
    @AppStorage("valid6") private var valid6: Bool = false
    @AppStorage("count") private var count = 0
    
    static let shared = UserData()
    
    private init() {
        if self.flag == 0 {
            self.userName = ""
            
            var dateComponents = DateComponents()
            dateComponents.hour = 22
            dateComponents.minute = 0
            dateComponents.second = 0
            let calender = Calendar.current
            self.pushMessageTime = calender.date(from: dateComponents)!
            self.flag = 1
        }
    }
    
    func setUserName(name: String) {
        self.userName = name
    }
    
    func getUserName() -> String {
        return self.userName
    }
    
    func setPushMessageTime(time: Date) {
        self.pushMessageTime = time
    }
    
    func getPushMessageTime() -> Date {
        return self.pushMessageTime
    }
    
    func updateEmotionData(date: Date, value: Double) {
        var data: [(Date, Double, Bool)] = [
            (date0, value0, valid0),
            (date1, value1, valid1),
            (date2, value2, valid2),
            (date3, value3, valid3),
            (date4, value4, valid4),
            (date5, value5, valid5),
            (date6, value6, valid6)
        ]
        
        for i in 0 ... 6 {
            if data[i].2 == true {
                if date == data[i].0 {
                    data[i].1 = value
                    break
                } else if date < data[i].0 {
                    if i == 0 && count != 7 {
                        for j in i ... 5 {
                            data[5 - j + 1] = data[5 - j]
                        }
                        data[i].0 = date
                        data[i].1 = value
                        count += 1
                        break
                    } else if i == 0 && count == 7 {
                        break
                    } else if i != 0 && count != 7 {
                        for j in 0 ... (5 - i) {
                            data[5 - j + 1] = data[5 - j]
                        }
                        data[i].0 = date
                        data[i].1 = value
                        count += 1
                        break
                    } else if i != 0 && count == 7 {
                        for j in 1 ... (i - 1) {
                            data[j - 1] = data[j]
                        }
                        data[i - 1].0 = date
                        data[i - 1].1 = value
                        break
                    }
                } else if date > data[i].0 {
                    if i == 6 {
                        for j in 1 ... i {
                            data[j - 1] = data[j]
                        }
                        data[i].0 = date
                        data[i].1 = value
                        break
                    } else {
                        continue
                    }
                }
            } else {
                data[i].0 = date
                data[i].1 = value
                data[i].2 = true
                count += 1
                break
            }
        }
        
        date0 = data[0].0
        value0 = data[0].1
        valid0 = data[0].2
        date1 = data[1].0
        value1 = data[1].1
        valid1 = data[1].2
        date2 = data[2].0
        value2 = data[2].1
        valid2 = data[2].2
        date3 = data[3].0
        value3 = data[3].1
        valid3 = data[3].2
        date4 = data[4].0
        value4 = data[4].1
        valid4 = data[4].2
        date5 = data[5].0
        value5 = data[5].1
        valid5 = data[5].2
        date6 = data[6].0
        value6 = data[6].1
        valid6 = data[6].2
    }
    
    func getEmotionData() -> [(Date, Double, Bool)] {
        let data: [(Date, Double, Bool)] = [
            (date0, value0, valid0),
            (date1, value1, valid1),
            (date2, value2, valid2),
            (date3, value3, valid3), 
            (date4, value4, valid4),
            (date5, value5, valid5),
            (date6, value6, valid6)
        ]
        
        return data
    }
    
    func analyzeEmotionData() -> [Int] {
        let data: [(Date, Double, Bool)] = [
            (date0, value0, valid0),
            (date1, value1, valid1),
            (date2, value2, valid2),
            (date3, value3, valid3),
            (date4, value4, valid4),
            (date5, value5, valid5),
            (date6, value6, valid6)
        ]
        
        var count = 0
        var positiveCount = 0
        var negativeCount = 0
        var zeroCount = 0
        var upCount = 0
        var downCount = 0
        var bigChangeCount = 0
        
        for i in 0 ... 6 {
            if data[i].2 == true {
                count += 1
                
                if data[i].1 > 0 {
                    positiveCount += 1
                } else if data[i].1 < 0 {
                    negativeCount += 1
                } else {
                    zeroCount += 1
                }
                
                if i != 0 {
                    if data[i].1 > 0 && data[i - 1].1 < 0 {
                        upCount += 1
                    } else if data[i].1 < 0 && data[i - 1].1 > 0 {
                        downCount += 1
                    }
                    
                    if data[i].1 - data[i - 1].1 > 50.0 || data[i - 1].1 - data[i].1 > 50 {
                        bigChangeCount += 1
                    }
                }
            }
        }
        
        return [count, positiveCount, negativeCount, zeroCount, upCount, downCount, bigChangeCount]
    }
}

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}
