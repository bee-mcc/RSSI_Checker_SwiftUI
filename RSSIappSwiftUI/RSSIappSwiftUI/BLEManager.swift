//
//  BLEManager.swift
//  RSSIappSwiftUI
//
//  Created by Brian McCaffrey on 3/30/21.
//



//for options[] in line for when need to add - from reconnecting to corebluetooth option
// Alert the user if BT is turned off.
//CBCentralManagerOptionShowPowerAlertKey: true,

// ID to allow restoration.
//Persists the CBCentralManager’s state across app startups
//CBCentralManagerOptionRestoreIdentifierKey: "MyRestoreIdentifierKey",

import Foundation
import CoreBluetooth


//will hold the information needed about our Peripherals
struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
}


//This is the class that holds all code related to the "viewController" for our main view which holds our Bluetooth Central object
class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate{
    
    //instantiates the CBUUID object that constrains scanForPeripherals() to the devices we need to search for (in my case, Dining Room Display)
    //let peripheralIdentifier = CBUUID(string: "0X110B")
    
    //Instantiate the object that represents the Bluetooth controls of the iphone
    var myCentral: CBCentralManager!
    
    //vars
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    
    //Called when the class is initialized, and instantiates the central manager
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
    
    //this is called any time a central manager discovers any peripherals
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        var peripheralName: String!
       
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        }
        else {
            peripheralName = "Unknown"
        }
        
        if(peripheralName == "Dining Room Display"){
            let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue)
            print(newPeripheral)
            peripherals.append(newPeripheral)
            
        }

    }
    
    
    //called when buttons to start and stop scanning
    func startScanning() {
         print("startScanning")
         myCentral.scanForPeripherals(withServices: nil, options: nil)
     }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
    
    
    

}
