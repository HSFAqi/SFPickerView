//
//  SFDatePickerView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

public class SFDatePickerView: SFBasePickerView {

    /// 枚举类型
    /// case命名规范：年月日YMD（大写），时分秒hms（小写）
    public enum SFDateMode: String {
        /// 年月日时分秒
        case YMDhms = "yyyy/MM/dd HH:mm:ss"
        /// 年月日时分
        case YMDhm = "yyyy/MM/dd HH:mm"
        /// 年月日时
        case YMDh = "yyyy/MM/dd HH"
        /// 年月日
        case YMD = "yyyy/MM/dd"
        /// 年月
        case YM = "yyyy/MM"
        /// 年
        case Y = "yyyy"
        /// 月日时分秒
        case MDhms = "MM/dd HH:mm:ss"
        /// 月日时分
        case MDhm = "MM/dd HH:mm"
        /// 月日时
        case MDh = "MM/dd HH"
        /// 月日
        case MD = "MM/dd"
        /// 月
        case M = "MM"
        /// 日时分秒
        case Dhms = "dd HH:mm:ss"
        /// 日时分
        case Dhm = "dd HH:mm"
        /// 日时
        case Dh = "dd HH"
        /// 日
        case D = "dd"
        /// 时分秒
        case hms = "HH:mm:ss"
        /// 时分
        case hm = "HH:mm"
        /// 时
        case h = "HH"
        /// 分秒
        case ms = "mm:ss"
        /// 分
        case m = "mm"
        /// 秒
        case s = "ss"
    }
    // MARK: - Property(public)
    private var minDate: Date!
    private var maxDate: Date!
    private var selDate: Date!
    private var mode: SFDateMode!
    
    // MARK: - Property(private)    
    private var yearsArr = [String?]()
    private var monthsArr = [String?]()
    private var daysArr = [String?]()
    private var hoursArr = [String?]()
    private var minutesArr = [String?]()
    private var secondsArr = [String?]()
    
    private var selYear: String?
    private var selMonth: String?
    private var selDay: String?
    private var selHour: String?
    private var selMinute: String?
    private var selSecond: String?
    private var selValueArr = [String?]()
    
    private var selYearIndex = 0
    private var selMonthIndex = 0
    private var selDayIndex = 0
    private var selHourIndex = 0
    private var selMinuteIndex = 0
    private var selSecondIndex = 0
    private var selIndexArr = [Int]()
    
    @discardableResult
    public final class func showPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, mode: SFDateMode?, minDate: Date?, maxDate: Date?, selDate: Date?, config: SFConfig?, callback: @escaping (([Int], [SFPickerDataProtocol?]) -> Void)) -> SFDatePickerView {
        let pickerView = SFDatePickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, appearance: appearance, mode: mode, minDate: minDate, maxDate: maxDate, selDate: selDate, config: config, callback: callback)
        return pickerView
    }
    public final func showPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, mode: SFDateMode?, minDate: Date?, maxDate: Date?, selDate: Date?, config: SFConfig?, callback: @escaping (([Int], [SFPickerDataProtocol?]) -> Void)) {
        let (data, indexs) = getDataSourceWithMode(mode, minDate: minDate, maxDate: maxDate, selDate: selDate)
        self.showPickerWithTitle(title, style: .label(appearance: appearance), dataType: .mul(data: data), defaultIndexs: indexs, config: config, callback: callback)
    }
    
    /// 获取所有列的数据源
    func getDataSourceWithMode(_ mode: SFDateMode?, minDate: Date?, maxDate: Date?, selDate: Date?) -> ([[String?]], [Int]?) {
        var data = [[String?]]()
        var indexs = [Int]()
        // mode
        var usefulMode: SFDateMode
        if let m = mode {
            usefulMode = m
        }else{
            usefulMode = .YMDhms
        }
        // date最小值
        let usefulMinDate = getUsefulDate(minDate, mode: usefulMode, isMin: true)
        // date最大值
        let usefulMaxDate = getUsefulDate(maxDate, mode: usefulMode, isMin: false)
        // curDate
        var usefulSelDate: Date
        if let d = selDate {
            usefulSelDate = d
        }else{
            usefulSelDate = Date()
        }
        guard usefulSelDate >= usefulMinDate, usefulSelDate <= usefulMaxDate else {
            print("usefulMinDate:\(usefulMinDate)")
            print("usefulSelDate:\(usefulSelDate)")
            print("usefulMaxDate:\(usefulMaxDate)")
            assertionFailure("请传入正确的时间")
            fatalError()
        }
        self.minDate = usefulMinDate
        self.maxDate = usefulMaxDate
        self.selDate = usefulSelDate
        self.mode = usefulMode
        // 获取数据源
        switch usefulMode {
        case .YMDhms:
            getDateDataArr(type: .year, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .month, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .minute, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .second, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [yearsArr, monthsArr, daysArr, hoursArr, minutesArr, secondsArr]
            indexs = [selYearIndex, selMonthIndex, selDayIndex, selHourIndex, selMinuteIndex, selSecondIndex]
            break
        case .YMDhm:
            getDateDataArr(type: .year, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .month, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .minute, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [yearsArr, monthsArr, daysArr, hoursArr, minutesArr]
            indexs = [selYearIndex, selMonthIndex, selDayIndex, selHourIndex, selMinuteIndex]
            break
        case .YMDh:
            getDateDataArr(type: .year, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .month, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [yearsArr, monthsArr, daysArr, hoursArr]
            indexs = [selYearIndex, selMonthIndex, selDayIndex, selHourIndex]
            break
        case .YMD:
            getDateDataArr(type: .year, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .month, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [yearsArr, monthsArr, daysArr]
            indexs = [selYearIndex, selMonthIndex, selDayIndex]
            break
        case .YM:
            getDateDataArr(type: .year, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .month, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [yearsArr, monthsArr]
            indexs = [selYearIndex, selMonthIndex]
            break
        case .Y:
            getDateDataArr(type: .year, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [yearsArr]
            indexs = [selYearIndex]
            break
        case .MDhms:
            getDateDataArr(type: .month, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .minute, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .second, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [monthsArr, daysArr, hoursArr, minutesArr, secondsArr]
            indexs = [selMonthIndex, selDayIndex, selHourIndex, selMinuteIndex, selSecondIndex]
            break
        case .MDhm:
            getDateDataArr(type: .month, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .minute, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [monthsArr, daysArr, hoursArr, minutesArr]
            indexs = [selMonthIndex, selDayIndex, selHourIndex, selMinuteIndex]
            break
        case .MDh:
            getDateDataArr(type: .month, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [monthsArr, daysArr, hoursArr]
            indexs = [selMonthIndex, selDayIndex, selHourIndex]
            break
        case .MD:
            getDateDataArr(type: .month, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [monthsArr, daysArr]
            indexs = [selMonthIndex, selDayIndex]
            break
        case .M:
            getDateDataArr(type: .month, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [monthsArr]
            indexs = [selMonthIndex, selDayIndex]
            break
        case .Dhms:
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .minute, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .second, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [daysArr, hoursArr, minutesArr, secondsArr]
            indexs = [selDayIndex, selHourIndex, selMinuteIndex, selSecondIndex]
            break
        case .Dhm:
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .minute, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [daysArr, hoursArr, minutesArr]
            indexs = [selDayIndex, selHourIndex, selMinuteIndex]
            break
        case .Dh:
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [daysArr, hoursArr]
            indexs = [selDayIndex, selHourIndex]
            break
        case .D:
            getDateDataArr(type: .day, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [daysArr]
            indexs = [selDayIndex]
            break
        case .hms:
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .minute, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .second, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [hoursArr, minutesArr, secondsArr]
            indexs = [selHourIndex, selMinuteIndex, selSecondIndex]
            break
        case .hm:
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .minute, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [hoursArr, minutesArr]
            indexs = [selHourIndex, selMinuteIndex]
            break
        case .h:
            getDateDataArr(type: .hour, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [hoursArr]
            indexs = [selHourIndex]
            break
        case .ms:
            getDateDataArr(type: .minute, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            getDateDataArr(type: .second, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [minutesArr, secondsArr]
            indexs = [selMinuteIndex, selSecondIndex]
            break
        case .m:
            getDateDataArr(type: .minute, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [minutesArr]
            indexs = [selMinuteIndex]
            break
        case .s:
            getDateDataArr(type: .second, minDate: usefulMinDate, maxDate: usefulMaxDate, selDate: usefulSelDate)
            data = [secondsArr]
            indexs = [selSecondIndex]
            break
        }
        self.selIndexArr = indexs
        return (data, indexs)
    }
    
    /// 获取date最大最小值
    func getUsefulDate(_ date: Date?, mode: SFDateMode, isMin: Bool) -> Date {
        var usefulDate = Date()
        if let d = date {
            usefulDate = d
        }else{
            let past = Date.distantPast
            let feature = Date.distantFuture
            usefulDate = isMin ? past : feature
        }
        return usefulDate
    }
    
    /// 获取某一列的数据源
    private enum SFDateDataType {
        case year
        case month
        case day
        case hour
        case minute
        case second
    }
    private func getDateDataArr(type: SFDateDataType, minDate: Date, maxDate: Date, selDate: Date) {
        guard selDate >= minDate, selDate <= maxDate else {
            assertionFailure("请传入正确的时间")
            fatalError()
        }
        var dataArr = [String?]()
        var selValue = ""
        var selIndex = 0
        var min: Int = 0
        var max: Int = 0
        switch type {
        case .year:
            min = minDate.year
            max = maxDate.year
            selValue = String(selDate.year)
            break
        case .month:
            let startDate = Date.startDateOf(component: .year, date: selDate)
            let endDate = Date.endDateOf(component: .year, date: selDate)
            min = (minDate > startDate) ? minDate.month : startDate.month
            max = (maxDate < endDate) ? maxDate.month : endDate.month
            selValue = String(selDate.month)
            break
        case .day:
            let startDate = Date.startDateOf(component: .month, date: selDate)
            let endDate = Date.endDateOf(component: .month, date: selDate)
            min = (minDate > startDate) ? minDate.day : startDate.day
            max = (maxDate < endDate) ? maxDate.day : endDate.day
            selValue = String(selDate.day)
            break
        case .hour:
            let startDate = Date.startDateOf(component: .day, date: selDate)
            let endDate = Date.endDateOf(component: .day, date: selDate)
            min = (minDate > startDate) ? minDate.hour : startDate.hour
            max = (maxDate < endDate) ? maxDate.hour : endDate.hour
            selValue = String(selDate.hour)
            break
        case .minute:
            let startDate = Date.startDateOf(component: .hour, date: selDate)
            let endDate = Date.endDateOf(component: .hour, date: selDate)
            min = (minDate > startDate) ? minDate.minute : startDate.minute
            max = (maxDate < endDate) ? maxDate.minute : endDate.minute
            selValue = String(selDate.minute)
            break
        case .second:
            let startDate = Date.startDateOf(component: .minute, date: selDate)
            let endDate = Date.endDateOf(component: .minute, date: selDate)
            min = (minDate > startDate) ? minDate.second : startDate.second
            max = (maxDate < endDate) ? maxDate.second : endDate.second
            selValue = String(selDate.second)
            break
        }
        let range = min...max
        for i in range {
            dataArr.append(String.init(format: "%02d", i))
        }
        for (idx, value) in dataArr.enumerated() {
            if value == selValue {
                selIndex = idx
                break
            }
        }
        switch type {
        case .year:
            yearsArr = dataArr
            selYear = selValue
            selYearIndex = selIndex
            break
        case .month:
            monthsArr = dataArr
            selMonth = selValue
            selMonthIndex = selIndex
            break
        case .day:
            daysArr = dataArr
            selDay = selValue
            selDayIndex = selIndex
            break
        case .hour:
            hoursArr = dataArr
            selHour = selValue
            selHourIndex = selIndex
            break
        case .minute:
            minutesArr = dataArr
            selMinute = selValue
            selMinuteIndex = selIndex
            break
        case .second:
            secondsArr = dataArr
            selSecond = selValue
            selSecondIndex = selIndex
            break
        }
    }
    
    /// 【重写】didSelect
    public override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        updateSelDateWithMode(self.mode, component: component)
        getDataSourceWithMode(self.mode, minDate: self.minDate, maxDate: self.maxDate, selDate: self.selDate)
        
    }
    
    
    /// 选取选中列和行（component、row）时需要更换的数据源
    func updateSelDateWithMode(_ mode: SFDateMode, component: Int) {
        var types: [SFDateDataType]
        switch mode {
        case .YMDhms:
            types = [.year, .month, .day, .hour, .minute, .second]
            break
        case .YMDhm:
            types = [.year, .month, .day, .hour, .minute]
            break
        case .YMDh:
            types = [.year, .month, .day, .hour]
            break
        case .YMD:
            types = [.year, .month, .day]
            break
        case .YM:
            types = [.year, .month]
            break
        case .Y:
            types = [.year]
            break
        case .MDhms:
            types = [.month, .day, .hour, .minute, .second]
            break
        case .MDhm:
            types = [.month, .day, .hour, .minute]
            break
        case .MDh:
            types = [.month, .day, .hour]
            break
        case .MD:
            types = [.month, .day]
            break
        case .M:
            types = [.month]
            break
        case .Dhms:
            types = [.day, .hour, .minute, .second]
            break
        case .Dhm:
            types = [.day, .hour, .minute]
            break
        case .Dh:
            types = [.day, .hour]
            break
        case .D:
            types = [.day]
            break
        case .hms:
            types = [.hour, .minute, .second]
            break
        case .hm:
            types = [.hour, .minute]
            break
        case .h:
            types = [.hour]
            break
        case .ms:
            types = [.hour, .minute]
            break
        case .m:
            types = [.hour]
            break
        case .s:
            types = [.minute]
            break
        }
        let type = types[component]
        var date = updateSelDate(type: type)
        if date > self.maxDate {
            date = self.maxDate
        }
        if date < self.minDate {
            date = self.minDate
        }
        self.selDate = date
    }
    
    private func updateSelDate(type: SFDateDataType) -> Date {
        var oldValue: String?
        var newValue: String?
        var during: Int
        var date: Date
        switch type {
        case .year:
            newValue = yearsArr[selYearIndex]
            oldValue = selYear
            during = Int(newValue!)! - Int(oldValue!)!
            date = self.selDate.dateByAddingYears(during)
            break
        case .month:
            newValue = monthsArr[selMonthIndex]
            oldValue = selMonth
            during = Int(newValue!)! - Int(oldValue!)!
            date = self.selDate.dateByAddingMonths(during)
            break
        case .day:
            newValue = daysArr[selDayIndex]
            oldValue = selDay
            during = Int(newValue!)! - Int(oldValue!)!
            date = self.selDate.dateByAddingDays(during)
            break
        case .hour:
            newValue = hoursArr[selHourIndex]
            oldValue = selHour
            during = Int(newValue!)! - Int(oldValue!)!
            date = self.selDate.dateByAddingHours(during)
            break
        case .minute:
            newValue = minutesArr[selHourIndex]
            oldValue = selMinute
            during = Int(newValue!)! - Int(oldValue!)!
            date = self.selDate.dateByAddingMinutes(during)
            break
        case .second:
            newValue = secondsArr[selHourIndex]
            oldValue = selSecond
            during = Int(newValue!)! - Int(oldValue!)!
            date = self.selDate.dateByAddingSeconds(during)
            break
        }
        return date
    }
    
}
