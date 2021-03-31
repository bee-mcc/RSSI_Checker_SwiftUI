//
//  BLEManager.swift
//  RSSIappSwiftUI
//
//  Created by Brian McCaffrey on 3/30/21.
//

import Foundation
import CoreBluetooth


//will hold the information needed about Our Peripherals
struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate{
    
    //the object that represents the Bluetooth controls of the iphone
    var myCentral: CBCentralManager!
    @Published var peripherals = [Peripheral]()
    
    //var letting us know if myCentral has bluetooth switched on
    @Published var isSwitchedOn = false
    
    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }
    
    //this is called whenever the central manager updates its state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    
    //this is called any time a central manager connects to peripherals
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        var peripheralName: String!
       
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        }
        else {
            peripheralName = "Unknown"
        }
       
        let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue)
        print(newPeripheral)
        peripherals.append(newPeripheral)
    }
    
    
    //buttons to start and stop scanning
    func startScanning() {
         print("startScanning")
         myCentral.scanForPeripherals(withServices: nil, options: nil)
     }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
    
    
    

}
