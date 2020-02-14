//
//  WeightHistoryViewController.swift
//  DailyDozen
//
//  Copyright © 2019 Nutritionfacts.org. All rights reserved.
//
// swiftlint: disable cyclomatic_complexity
// swiftlint: disable function_body_length
// swiftlint: disable type_body_length

import UIKit
import Charts

class WeightHistoryBuilder {

    // MARK: Nested
    private struct Strings {
        static let storyboard = "WeightHistory"
    }

    // MARK: Methods
    /// Instantiates and returns the initial view controller for a storyboard.
    ///
    /// - Returns: The initial view controller in the storyboard.
    static func instantiateController() -> WeightHistoryViewController {
        let storyboard = UIStoryboard(name: Strings.storyboard, bundle: nil)
        guard
            let viewController = storyboard
                .instantiateInitialViewController() as? WeightHistoryViewController
            else { fatalError("Did not instantiate `WeightHistory` controller") }
        viewController.title = "Weight History"

        return viewController
    }
}

// MARK: -

class WeightHistoryViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet private weak var controlPanel: ControlPanel! // Buttons: << < … > >>
    @IBOutlet private weak var scaleControl: UISegmentedControl! // Day|Month|Year
    @IBOutlet weak var weightEditDataButton: UIButton!
    @IBOutlet weak var weightTitleUnits: UILabel!
    
    // MARK: - Properties
    private var weightViewModel: WeightHistoryViewModel!
    private var currentTimeScale = TimeScale.day
    private let realm = RealmProvider()

    private var chartSettings: (year: Int, month: Int)! {
        didSet {
            lineChartView.clear()
            
            if isImperial() {
                weightTitleUnits.text = "Weight (lbs)"
            } else {
                weightTitleUnits.text = "Weight (kg)"
            }
            
            if currentTimeScale == .day {
                controlPanel.isHidden = false
                controlPanel.superview?.isHidden = false

                var canLeft = true
                if chartSettings.month == 0, chartSettings.year == 0 {
                    canLeft = false
                }

                var canRight = true

                if chartSettings.year == weightViewModel.lastYearIndex,
                    chartSettings.month == weightViewModel.lastMonthIndex(for: weightViewModel.lastYearIndex) {
                    canRight = false
                }

                controlPanel.configure(canSwitch: (left: canLeft, right: canRight))

                let data = weightViewModel.monthData(yearIndex: chartSettings.year, monthIndex: chartSettings.month)
                
                // :DEBUG:LOG_VERBOSE:
                //print("## Weight History: \(data.month) chartSettings(year:\(chartSettings.year), month:\(chartSettings.month)) ##") 
                //var i = 0
                //for point in data.points {
                //    let dataStr = """
                //    \(point.anyDate) • \
                //    \(point.dateAM?.datestampHHmm ?? "nil") \(String(format: "%.2f", point.kgAM ?? -1.0)) • \
                //    \(point.datePM?.datestampHHmm ?? "nil") \(String(format: "%.2f", point.kgPM ?? -1.0)) 
                //    """
                //    print(dataStr)
                //    i += 1
                //}

                controlPanel.setLabels(month: data.month, year: weightViewModel.yearName(yearIndex: chartSettings.year))
                
                updateChart(points: data.points, scale: .day)
                //chartView.configure(with: data.map, for: currentTimeScale)
            } else if currentTimeScale == .month {
                controlPanel.isHidden = false
                controlPanel.superview?.isHidden = false

                let canLeft = chartSettings.year != 0
                let canRight = chartSettings.year != weightViewModel.lastYearIndex
                controlPanel.configure(canSwitch: (left: canLeft, right: canRight))

                let data = weightViewModel.yearlyData(yearIndex: chartSettings.year)

                // :DEBUG:LOG_VERBOSE:
                //print("## Weight History: \(data.year) chartSettings(year:\(chartSettings.year), month:\(chartSettings.month)) ##")
                //var i = 0
                //for point in data.points {
                //    let dataStr = """
                //    \(point.anyDate) • \
                //    \(point.dateAM?.datestampHHmm ?? "nil") \(String(format: "%.2f", point.kgAM ?? -1.0)) • \
                //    \(point.datePM?.datestampHHmm ?? "nil") \(String(format: "%.2f", point.kgPM ?? -1.0)) 
                //    """
                //    print(dataStr)
                //    i += 1
                //}

                controlPanel.setLabels(year: data.year)

                updateChart(points: data.points, scale: .month)
                //chartView.configure(with: data.map, for: currentTimeScale)
            } else {
                controlPanel.isHidden = true
                controlPanel.superview?.isHidden = true
                                
                // Multiple years
                updateChart(points: weightViewModel.fullDataMap(), scale: .year)
                //chartView.configure(with: weightViewModel.fullDataMap(), for: currentTimeScale)
            }
        }
    }

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.greenColor
        navigationController?.navigationBar.tintColor = UIColor.white

        lineChartView.xAxis.valueFormatter = self
        setViewModel()
        //updateChart(fromDate: Date(), toDate: Date()) // :!!!:
    }
    
    // -------------------------
    
    // IB action, then updateChartWithData
    private func updateChartWithData(am: [ChartDataEntry], pm: [ChartDataEntry], range: Double) {
        switch currentTimeScale {
        case .day:
            break
        case .month:
            break
        case .year:
            break
        }
        
        let lineChartDataSetAM = LineChartDataSet(entries: am, label: "AM")
        lineChartDataSetAM.colors = [UIColor.yellowSunglowColor]
        lineChartDataSetAM.circleColors = [UIColor.yellowSunglowColor]
        lineChartDataSetAM.circleHoleRadius = 0.0 // Default: 4.0
        lineChartDataSetAM.circleRadius = 4.0 // Default: 8.0
        lineChartDataSetAM.drawValuesEnabled = false
        lineChartDataSetAM.lineWidth = 2.0 // Default: 1
        lineChartDataSetAM.mode = .linear // .cubicBezier

        let lineChartDataSetPM = LineChartDataSet(entries: pm, label: "PM")
        lineChartDataSetPM.colors = [UIColor.redFlamePeaColor]
        lineChartDataSetPM.circleColors = [UIColor.redFlamePeaColor]
        lineChartDataSetPM.circleHoleRadius = 0.0 // Default: 4.0
        lineChartDataSetPM.circleRadius = 4.0 // Default: 8.0
        lineChartDataSetPM.drawValuesEnabled = false
        lineChartDataSetAM.lineWidth = 2.0 // Default: 1
        lineChartDataSetPM.mode = .linear // .cubicBezier

        let lineChartData = LineChartData(dataSets: [lineChartDataSetAM, lineChartDataSetPM])
        lineChartView.data = lineChartData
        lineChartView.xAxis.drawLabelsEnabled = false
        //lineChartView.xAxis.axisRange = range
        lineChartView.xAxis.axisMinimum = 0.0
        lineChartView.xAxis.axisMaximum = range
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
    }
    
    func updateChart(points: [DailyWeightReport], scale: TimeScale) {
        
        guard 
            let firstDatestampKey = points.first?.anyDate.datestampKey,
            let firstDayOfMonth = Date(datestampKey: "\(firstDatestampKey.prefix(6))01"),
            let firstDayOfYear = Date(datestampKey: "\(firstDatestampKey.prefix(4))0101")
            else { return }
        
        // day scale = 60 seconds * 60 minutes * 24 hours
        var xScaleFactor = 60.0*60.0*24.0 // default: .day (seconds/day)
        var xAxisRange = 31.0 // daily for 31 days
        var fromTimeInterval = firstDayOfMonth.timeIntervalSince1970
        if scale == .month {
            fromTimeInterval = firstDayOfYear.timeIntervalSince1970
            xScaleFactor = 60.0*60.0*24.0 * 30.44 // .month (seconds/average_julian_month)
            xAxisRange = 12.0 // monthly for year
        } else if currentTimeScale == .year {
            fromTimeInterval = firstDayOfYear.timeIntervalSince1970
            xScaleFactor = 60.0*60.0*24.0 * 365.25 // .year (seconds/average_julian_year)
            xAxisRange = 3 // yearly for 3 years
        }
        
        //var dataEntries = [
        //    ChartDataEntry(x: 1.0, y: 144.3),
        //    ChartDataEntry(x: 3.0, y: 143.5),
        //]
        //dataEntriesAM.append(ChartDataEntry(x: 4.0, y: 144.5))
        var dataEntriesAM = [ChartDataEntry]()
        var dataEntriesPM = [ChartDataEntry]()
        
        for dailyWeightRecord in points {
            if let dateAM = dailyWeightRecord.dateAM,
                let kgAM = dailyWeightRecord.kgAM {
                let xTimeInterval: TimeInterval = dateAM.timeIntervalSince1970
                let x = (xTimeInterval - fromTimeInterval) / xScaleFactor
                var y = kgAM
                if isImperial() {
                    y = kgAM * 2.204
                }
                let chartDataEntry = ChartDataEntry(x: x, y: y)
                dataEntriesAM.append(chartDataEntry)
            }
            if let datePM = dailyWeightRecord.datePM,
                let kgPM = dailyWeightRecord.kgPM {
                let xTimeInterval: TimeInterval = datePM.timeIntervalSince1970
                let x = (xTimeInterval - fromTimeInterval) / xScaleFactor
                var y = kgPM
                if isImperial() {
                    y = kgPM * 2.204
                }
                let chartDataEntry = ChartDataEntry(x: x, y: y)
                dataEntriesPM.append(chartDataEntry)
            }
        }

        // :DEBUG:LOG_VERBOSE:
        //print("\n•••••••••••••••••••••••••••••••••••••••••••••••••")
        //print("••• WeightHistoryViewController updateChart() •••")
        //print("••• INPUT: points @ scale:\(scale.toString()) •••")
        //for dailyWeightReport in points {
        //    print(dailyWeightReport.toString())
        //}
        //print("••• OUTPUT: dataEntries @ xAxisRange:\(xAxisRange) •••")
        //print("••• AM (x,y)")
        //for chartDataEntry: ChartDataEntry in dataEntriesAM {
        //    print(chartDataEntry.toStringXY())
        //}
        //print("••• PM (x,y)")
        //for chartDataEntry in dataEntriesPM {
        //    print(chartDataEntry.toStringXY())
        //}
        
        updateChartWithData(am: dataEntriesAM, pm: dataEntriesPM, range: xAxisRange)
    }
    
    private func isImperial() -> Bool {
        guard
            let unitsTypePrefStr = UserDefaults.standard.string(forKey: SettingsKeys.unitsTypePref),
            let currentUnitsType = UnitsType(rawValue: unitsTypePrefStr)
            else {
                return true
        }
        if currentUnitsType == .imperial {
            return true
        }
        return false
    }
    
    // -------------------------

    private func setViewModel() {
        let realm = RealmProvider()
        
        let weights = realm.getDailyWeights()
        guard weights.am.count + weights.pm.count > 0 else {
            controlPanel.isHidden = true
            scaleControl.isEnabled = false
            controlPanel.superview?.isHidden = true
            return
        }
        
        weightViewModel = WeightHistoryViewModel(amRecords: weights.am, pmRecords: weights.pm)
        let lastYearIndex = weightViewModel.lastYearIndex
        chartSettings = (lastYearIndex, weightViewModel.lastMonthIndex(for: lastYearIndex))
    }

    // MARK: - Actions
    
    @IBAction func editDataButtonPressed(_ sender: UIButton) {
        let viewController = WeightPagerBuilder.instantiateController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func toFirstButtonPressed(_ sender: UIButton) {
        chartSettings = (0, 0)
    }

    @IBAction private func toPreviousButtonPressed(_ sender: UIButton) {
        if chartSettings.month > 0 && currentTimeScale == .day {
            chartSettings.month -= 1
        } else if chartSettings.year > 0 {
            let year = chartSettings.year - 1
            let month = weightViewModel.lastMonthIndex(for: year)
            chartSettings = (year, month)
        }
    }

    @IBAction private func toNextButtonPressed(_ sender: UIButton) {
        if chartSettings.month < weightViewModel.lastMonthIndex(for: chartSettings.year) && currentTimeScale == .day {
            chartSettings.month += 1
        } else if chartSettings.year < weightViewModel.lastYearIndex {
            let year = chartSettings.year + 1
            let month = 0
            chartSettings = (year, month)
        }
    }

    @IBAction private func toLastButtonPressed(_ sender: UIButton) {
        let lastYearIndex = weightViewModel.lastYearIndex
        chartSettings = (lastYearIndex, weightViewModel.lastMonthIndex(for: lastYearIndex))
    }

    @IBAction private func timeScaleChanged(_ sender: UISegmentedControl) {
        guard let timeScale = TimeScale(rawValue: sender.selectedSegmentIndex) else { return }
        currentTimeScale = timeScale

        switch currentTimeScale {
        case .day:
            let lastYearIndex = weightViewModel.lastYearIndex
            chartSettings = (lastYearIndex, weightViewModel.lastMonthIndex(for: lastYearIndex))
        case .month:
            let lastYearIndex = weightViewModel.lastYearIndex
            chartSettings = (lastYearIndex, 0)
        case .year:
            chartSettings = (0, 0)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - IAxisValueFormatter
extension WeightHistoryViewController: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let labels: [String]
        if currentTimeScale == .day {
            labels = weightViewModel.datesLabels(yearIndex: chartSettings.year, monthIndex: chartSettings.month)
        } else if currentTimeScale == .month {
            labels = weightViewModel.monthsLabels(yearIndex: chartSettings.year)
        } else {
            labels = weightViewModel.fullDataLabels()
        }
        let index = Int(value)
        guard index < labels.count else { return "" }
        return labels[index]
    }
}
