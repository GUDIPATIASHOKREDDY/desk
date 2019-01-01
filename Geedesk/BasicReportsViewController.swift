//
//  BasicReportsViewController.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 26/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit
import Charts

class BasicReportsViewController: UIViewController,ChartViewDelegate {

    
    let months = ["Jan" , "Feb", "Mar", "Apr", "May", "June", "July", "August"]
    let numbers = [1,6,3,4,3,5,2,8]
    @IBOutlet var totalReportGraph: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        self.totalReportGraph.delegate = self
        // 2
       // self.totalReportGraph.descriptionText = "Tap node for details"
        // 3
        self.totalReportGraph.chartDescription?.textColor = UIColor.white
        self.totalReportGraph.gridBackgroundColor = UIColor.darkGray
        // 4
        self.totalReportGraph.noDataText = "No data provided"
        // 5
        
        
       
        
        let xaxis = totalReportGraph.xAxis
        //xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = false
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
       // xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = totalReportGraph.leftAxis
        yaxis.spaceTop = 0.1
        yaxis.axisMinimum = 0
        yaxis.labelPosition = .outsideChart
        yaxis.drawGridLinesEnabled = false
        
        totalReportGraph.rightAxis.enabled = false
        
         setChartData(months: numbers)
        

    
    }
    
    func setChartData(months : [Int]) {
        
    
        var lineChartEntry  = [ChartDataEntry]()
    
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: Double(numbers[i]))
            
            lineChartEntry.append(value)
        }
        
    
        let line1 = LineChartDataSet(values: lineChartEntry, label: "")
        line1.mode = .cubicBezier
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        let gradientColors = [colorTop, colorBottom] as CFArray
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        line1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        line1.drawFilledEnabled = true
        line1.lineWidth = 1.0
        line1.circleRadius = 3.0
        line1.circleColors = [UIColor.red]
        line1.fillColor = UIColor.red
        line1.highlightColor = UIColor.white
        line1.colors = [NSUIColor.black]
        let data = LineChartData()
        data.addDataSet(line1)
        totalReportGraph.data = data
        totalReportGraph.animate(xAxisDuration: 0.5, yAxisDuration: 1.5, easingOption: .easeInCirc)
       
        
        
    }
    

  

}
