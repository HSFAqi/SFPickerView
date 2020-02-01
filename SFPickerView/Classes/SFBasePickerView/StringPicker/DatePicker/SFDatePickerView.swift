//
//  SFDatePickerView.swift
//  SFPickerView_Example
//
//  Created by 黄山锋 on 2020/1/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

// TODO:
// 1，语言本地化
// 2，自定义时间格式化

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

public class SFDatePickerView: SFStringPickerView {

    // MARK: - Property(private)
    private(set) var minDate: Date!
    private(set) var maxDate: Date!
    private(set) var selDate: Date!
    private(set) var mode: SFDateMode!
    private(set) var format: String!
    
    private var yearsValueArr = [String?]()
    private var monthsValueArr = [String?]()
    private var daysValueArr = [String?]()
    private var hoursValueArr = [String?]()
    private var minutesValueArr = [String?]()
    private var secondsValueArr = [String?]()
    private var currentDataSource = [[String?]]()
    
    private var yearsArr = [Int?]()
    private var monthsArr = [Int?]()
    private var daysArr = [Int?]()
    private var hoursArr = [Int?]()
    private var minutesArr = [Int?]()
    private var secondsArr = [Int?]()
    
    private var selYear: Int?
    private var selMonth: Int?
    private var selDay: Int?
    private var selHour: Int?
    private var selMinute: Int?
    private var selSecond: Int?
    
    private var selYearIndex = 0
    private var selMonthIndex = 0
    private var selDayIndex = 0
    private var selHourIndex = 0
    private var selMinuteIndex = 0
    private var selSecondIndex = 0
    private var selIndexArr = [Int]()
    
    /// 【Date】类方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - mode: 模式
    ///   - minDate: 时间最小值
    ///   - maxDate: 时间最大值
    ///   - selDate: 当前时间选中值
    ///   - config: 配置
    ///   - callback: 回调
    @discardableResult
    public final class func showPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, mode: SFDateMode?, minDate: Date?, maxDate: Date?, selDate: Date?, format: String?, config: SFConfig?, callback: @escaping ((Date, String) -> Void)) -> SFDatePickerView {
        let pickerView = SFDatePickerView(frame: CGRect.zero)
        pickerView.showPickerWithTitle(title, appearance: appearance, mode: mode, minDate: minDate, maxDate: maxDate, selDate: selDate, format: format, config: config, callback: callback)
        return pickerView
    }
    
    /// 【Date】对象方法
    /// - Parameters:
    ///   - title: 标题
    ///   - appearance: 自定义外观
    ///   - mode: 模式
    ///   - minDate: 时间最小值
    ///   - maxDate: 时间最大值
    ///   - selDate: 当前时间选中值
    ///   - config: 配置
    ///   - callback: 回调
    public final func showPickerWithTitle(_ title: String?, appearance: SFPickerLabelAppearance?, mode: SFDateMode?, minDate: Date?, maxDate: Date?, selDate: Date?, format: String?, config: SFConfig?, callback: @escaping ((Date, String) -> Void)) {
        getDataSourceWithMode(mode, minDate: minDate, maxDate: maxDate, selDate: selDate, format: format)
        self.showStringPickerWithTitle(title, appearance: appearance, dataType: .mul(data: self.currentDataSource), defaultIndexs: self.selIndexArr, config: config) { (indexs, values) in
            let dateString = self.selDate.stringWithFormat(self.format)
            callback(self.selDate, dateString)
        }
    }
    
    /// 获取所有列的数据源
    private func getDataSourceWithMode(_ mode: SFDateMode?, minDate: Date?, maxDate: Date?, selDate: Date?, format: String?) {
        // mode
        var usefulMode: SFDateMode
        if let m = mode {
            usefulMode = m
        }else{
            usefulMode = .YMDhms
        }
        if let usefulFormat = format {
            self.format = usefulFormat
        }else{
            self.format = usefulMode.rawValue
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
        updateCurrentDataSource()
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
    
    /// 更新当前数据源
    private func updateCurrentDataSource() {
        var data = [[String?]]()
        var indexs = [Int]()
        switch self.mode {
        case .YMDhms:
            getDateDataArr(type: .year)
            getDateDataArr(type: .month)
            getDateDataArr(type: .day)
            getDateDataArr(type: .hour)
            getDateDataArr(type: .minute)
            getDateDataArr(type: .second)
            data = [yearsValueArr, monthsValueArr, daysValueArr, hoursValueArr, minutesValueArr, secondsValueArr]
            indexs = [selYearIndex, selMonthIndex, selDayIndex, selHourIndex, selMinuteIndex, selSecondIndex]
            break
        case .YMDhm:
            getDateDataArr(type: .year)
            getDateDataArr(type: .month)
            getDateDataArr(type: .day)
            getDateDataArr(type: .hour)
            getDateDataArr(type: .minute)
            data = [yearsValueArr, monthsValueArr, daysValueArr, hoursValueArr, minutesValueArr]
            indexs = [selYearIndex, selMonthIndex, selDayIndex, selHourIndex, selMinuteIndex]
            break
        case .YMDh:
            getDateDataArr(type: .year)
            getDateDataArr(type: .month)
            getDateDataArr(type: .day)
            getDateDataArr(type: .hour)
            data = [yearsValueArr, monthsValueArr, daysValueArr, hoursValueArr]
            indexs = [selYearIndex, selMonthIndex, selDayIndex, selHourIndex]
            break
        case .YMD:
            getDateDataArr(type: .year)
            getDateDataArr(type: .month)
            getDateDataArr(type: .day)
            data = [yearsValueArr, monthsValueArr, daysValueArr]
            indexs = [selYearIndex, selMonthIndex, selDayIndex]
            break
        case .YM:
            getDateDataArr(type: .year)
            getDateDataArr(type: .month)
            data = [yearsValueArr, monthsValueArr]
            indexs = [selYearIndex, selMonthIndex]
            break
        case .Y:
            getDateDataArr(type: .year)
            data = [yearsValueArr]
            indexs = [selYearIndex]
            break
        case .MDhms:
            getDateDataArr(type: .month)
            getDateDataArr(type: .day)
            getDateDataArr(type: .hour)
            getDateDataArr(type: .minute)
            getDateDataArr(type: .second)
            data = [monthsValueArr, daysValueArr, hoursValueArr, minutesValueArr, secondsValueArr]
            indexs = [selMonthIndex, selDayIndex, selHourIndex, selMinuteIndex, selSecondIndex]
            break
        case .MDhm:
            getDateDataArr(type: .month)
            getDateDataArr(type: .day)
            getDateDataArr(type: .hour)
            getDateDataArr(type: .minute)
            data = [monthsValueArr, daysValueArr, hoursValueArr, minutesValueArr]
            indexs = [selMonthIndex, selDayIndex, selHourIndex, selMinuteIndex]
            break
        case .MDh:
            getDateDataArr(type: .month)
            getDateDataArr(type: .day)
            getDateDataArr(type: .hour)
            data = [monthsValueArr, daysValueArr, hoursValueArr]
            indexs = [selMonthIndex, selDayIndex, selHourIndex]
            break
        case .MD:
            getDateDataArr(type: .month)
            getDateDataArr(type: .day)
            data = [monthsValueArr, daysValueArr]
            indexs = [selMonthIndex, selDayIndex]
            break
        case .M:
            getDateDataArr(type: .month)
            data = [monthsValueArr]
            indexs = [selMonthIndex]
            break
        case .Dhms:
            getDateDataArr(type: .day)
            getDateDataArr(type: .hour)
            getDateDataArr(type: .minute)
            getDateDataArr(type: .second)
            data = [daysValueArr, hoursValueArr, minutesValueArr, secondsValueArr]
            indexs = [selDayIndex, selHourIndex, selMinuteIndex, selSecondIndex]
            break
        case .Dhm:
            getDateDataArr(type: .day)
            getDateDataArr(type: .hour)
            getDateDataArr(type: .minute)
            data = [daysValueArr, hoursValueArr, minutesValueArr]
            indexs = [selDayIndex, selHourIndex, selMinuteIndex]
            break
        case .Dh:
            getDateDataArr(type: .day)
            getDateDataArr(type: .hour)
            data = [daysValueArr, hoursValueArr]
            indexs = [selDayIndex, selHourIndex]
            break
        case .D:
            getDateDataArr(type: .day)
            data = [daysValueArr]
            indexs = [selDayIndex]
            break
        case .hms:
            getDateDataArr(type: .hour)
            getDateDataArr(type: .minute)
            getDateDataArr(type: .second)
            data = [hoursValueArr, minutesValueArr, secondsValueArr]
            indexs = [selHourIndex, selMinuteIndex, selSecondIndex]
            break
        case .hm:
            getDateDataArr(type: .hour)
            getDateDataArr(type: .minute)
            data = [hoursValueArr, minutesValueArr]
            indexs = [selHourIndex, selMinuteIndex]
            break
        case .h:
            getDateDataArr(type: .hour)
            data = [hoursValueArr]
            indexs = [selHourIndex]
            break
        case .ms:
            getDateDataArr(type: .minute)
            getDateDataArr(type: .second)
            data = [minutesValueArr, secondsValueArr]
            indexs = [selMinuteIndex, selSecondIndex]
            break
        case .m:
            getDateDataArr(type: .minute)
            data = [minutesValueArr]
            indexs = [selMinuteIndex]
            break
        case .s:
            getDateDataArr(type: .second)
            data = [secondsValueArr]
            indexs = [selSecondIndex]
            break
        case .none:
            break
        }
        self.selIndexArr = indexs
        self.currentDataSource = data
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
    private func getDateDataArr(type: SFDateDataType) {
        guard selDate >= minDate, selDate <= maxDate else {
            assertionFailure("请传入正确的时间")
            fatalError()
        }
        var dataArr = [Int?]()
        var dataValueArr = [String?]()
        var selInt: Int!
        var selIndex = 0
        var min: Int = 0
        var max: Int = 0
        var unit: String = ""
        switch type {
        case .year:
            min = minDate.year
            max = maxDate.year
            unit = "年"
            selInt = selDate.year
            break
        case .month:
            let startDate = Date.startDateOf(component: .year, date: selDate)
            let endDate = Date.endDateOf(component: .year, date: selDate)
            min = (minDate > startDate) ? minDate.month : startDate.month
            max = (maxDate < endDate) ? maxDate.month : endDate.month
            unit = "月"
            selInt = selDate.month
            break
        case .day:
            let startDate = Date.startDateOf(component: .month, date: selDate)
            let endDate = Date.endDateOf(component: .month, date: selDate)
            min = (minDate > startDate) ? minDate.day : startDate.day
            max = (maxDate < endDate) ? maxDate.day : endDate.day
            unit = "日"
            selInt = selDate.day
            break
        case .hour:
            let startDate = Date.startDateOf(component: .day, date: selDate)
            let endDate = Date.endDateOf(component: .day, date: selDate)
            min = (minDate > startDate) ? minDate.hour : startDate.hour
            max = (maxDate < endDate) ? maxDate.hour : endDate.hour
            unit = "时"
            selInt = selDate.hour
            break
        case .minute:
            let startDate = Date.startDateOf(component: .hour, date: selDate)
            let endDate = Date.endDateOf(component: .hour, date: selDate)
            min = (minDate > startDate) ? minDate.minute : startDate.minute
            max = (maxDate < endDate) ? maxDate.minute : endDate.minute
            unit = "分"
            selInt = selDate.minute
            break
        case .second:
            let startDate = Date.startDateOf(component: .minute, date: selDate)
            let endDate = Date.endDateOf(component: .minute, date: selDate)
            min = (minDate > startDate) ? minDate.second : startDate.second
            max = (maxDate < endDate) ? maxDate.second : endDate.second
            unit = "秒"
            selInt = selDate.second
            break
        }
        let range = min...max
        for i in range {
            dataArr.append(i)
            dataValueArr.append(String.init(format: "%02d%@", i, unit))
        }
        let selValueWithUnit = String.init(format: "%02d%@", selInt, unit)
        for (idx, value) in dataValueArr.enumerated() {
            if value == selValueWithUnit {
                selIndex = idx
                break
            }
        }
        switch type {
        case .year:
            yearsArr = dataArr
            yearsValueArr = dataValueArr
            selYear = selInt
            selYearIndex = selIndex
            break
        case .month:
            monthsArr = dataArr
            monthsValueArr = dataValueArr
            selMonth = selInt
            selMonthIndex = selIndex
            break
        case .day:
            daysArr = dataArr
            daysValueArr = dataValueArr
            selDay = selInt
            selDayIndex = selIndex
            break
        case .hour:
            hoursArr = dataArr
            hoursValueArr = dataValueArr
            selHour = selInt
            selHourIndex = selIndex
            break
        case .minute:
            minutesArr = dataArr
            minutesValueArr = dataValueArr
            selMinute = selInt
            selMinuteIndex = selIndex
            break
        case .second:
            secondsArr = dataArr
            secondsValueArr = dataValueArr
            selSecond = selInt
            selSecondIndex = selIndex
            break
        }
    }
    
    /// 【重写】didSelect
    public override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        updateSelDateWithComponent(component, row: row)
        updateCurrentDataSource()
        updateDataSource(dataType: .mul(data: self.currentDataSource), defaultIndexs: self.selIndexArr)
        for (component, row) in self.selIndexArr.enumerated() {
            self.pickerView.reloadComponent(component)
            self.pickerView.selectRow(row, inComponent: component, animated: true)
        }
    }
    
    /// 选取选中列和行（component、row）时需要更换的数据源
    private func updateSelDateWithComponent(_ component: Int, row: Int) {
        var types = [SFDateDataType]()
        switch self.mode {
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
        case .none:
            break
        }
        let type = types[component]
        var date = updateSelDate(type: type, row: row)
        if date > self.maxDate {
            date = self.maxDate
        }
        if date < self.minDate {
            date = self.minDate
        }
        self.selDate = date
    }
    
    /// 更新选中时间selDate
    private func updateSelDate(type: SFDateDataType, row: Int) -> Date {
        var oldValue: Int?
        var newValue: Int?
        var during: Int
        var date: Date
        switch type {
        case .year:
            newValue = yearsArr[row]
            oldValue = selYear
            during = newValue! - oldValue!
            date = self.selDate.dateByAddingYears(during)
            break
        case .month:
            newValue = monthsArr[row]
            oldValue = selMonth
            during = newValue! - oldValue!
            date = self.selDate.dateByAddingMonths(during)
            break
        case .day:
            newValue = daysArr[row]
            oldValue = selDay
            during = newValue! - oldValue!
            date = self.selDate.dateByAddingDays(during)
            break
        case .hour:
            newValue = hoursArr[row]
            oldValue = selHour
            during = newValue! - oldValue!
            date = self.selDate.dateByAddingHours(during)
            break
        case .minute:
            newValue = minutesArr[row]
            oldValue = selMinute
            during = newValue! - oldValue!
            date = self.selDate.dateByAddingMinutes(during)
            break
        case .second:
            newValue = secondsArr[row]
            oldValue = selSecond
            during = newValue! - oldValue!
            date = self.selDate.dateByAddingSeconds(during)
            break
        }
        return date
    }
    
}
