//
//  StatisticheMemoriaViewController.swift
//  App2
//
//  Created by Franco Cirillo on 18/04/21.
//

import UIKit
import Charts

class StatisticheMemoriaViewController: UIViewController, ChartViewDelegate {
    
    let defaults = UserDefaults.standard
    var lineChart = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        lineChart.backgroundColor=UIColor(named: "Color4")
        lineChart.xAxis.labelPosition = .bottom
        lineChart.animate(xAxisDuration: 1)
        lineChart.xAxis.drawLabelsEnabled=false
        lineChart.rightAxis.enabled=false
        lineChart.leftAxis.labelTextColor=UIColor.white
        lineChart.legend.textColor = UIColor.white
        
        lineChart.frame = CGRect(x: 0, y: 0,
                                 width: self.view.frame.size.width,
                                 height: self.view.frame.size.width)
        lineChart.center = view.center
        view.addSubview(lineChart)
        
        var entries = [ChartDataEntry]()
        
//        for x in 0..<20 {
//            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
//        }
        let mem = (defaults.array(forKey: "Memoria") ?? Array()) as! [Int]
        for x in 0..<(mem.count) {
            entries.append(ChartDataEntry(x: Double(x), y: Double(mem[x])))
        }
        lineChart.xAxis.setLabelCount(mem.count-1, force: false)
        
        
        let set = LineChartDataSet(entries: entries, label: "Tentativi")
//        set.colors = ChartColorTemplates.material()
//        set.addColor(UIColor.white)
        set.setColor(UIColor.white)
        set.setCircleColors(UIColor.white)
        set.valueTextColor=UIColor.white
        set.fillColor=UIColor.white
        set.drawFilledEnabled=true
//        set.fillAlpha=0.8
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
    
 /*
    override func viewWillAppear(_ animated: Bool) {
        let x:[Float] = [10,100,263,489]
        let y:[Float] = [10,120,500,800]

        let agg_renderer: AGGRenderer = AGGRenderer()
        var lineGraph = LineGraph<Float,Float>(enablePrimaryAxisGrid: true)
        lineGraph.addSeries(x, y, label: "Plot 1", color: .lightBlue)
        lineGraph.plotTitle.title = "SINGLE SERIES"
        lineGraph.plotLabel.xLabel = "X-AXIS"
        lineGraph.plotLabel.yLabel = "Y-AXIS"
        lineGraph.plotLineThickness = 3.0
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return
            }
            do {
                try lineGraph.drawGraphAndOutput(fileName: directory.appendingPathComponent("grafico")!.description, renderer: agg_renderer)
//                    data.write(to: directory.appendingPathComponent("fileName.png")!)
            } catch {
                print(error.localizedDescription)
                return
            }
        
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            var img=UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("grafico").path)
            image.image=img
            }
        }
 */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
