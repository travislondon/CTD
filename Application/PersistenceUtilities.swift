//
//  PersistenceUtilities.swift
//  Dots
//
//  Created by Travis London on 1/13/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import Foundation

public class PersistenceUtil {
    public static func getPersistencedDotGraphs() -> [String] {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: dir!, includingPropertiesForKeys: nil, options: [])
            
            let graphFiles = directoryContents.filter{ $0.pathExtension == "dotGraph" }
            let fileNames = graphFiles.map{ $0.deletingPathExtension().lastPathComponent }
            return fileNames
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return [String]()
    }
    
    public static func getURLFor(name: String) -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let path = dir?.appendingPathComponent(name)
        
        return path!
    }
    
    public static func removeDotGraph(name: String) {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let path = dir?.appendingPathComponent(name).appendingPathExtension("dotGraph")
        
        do {
            try FileManager.default.removeItem(at: path!)
        } catch let error as NSError {
            print(error.localizedDescription)
        }

    }
}
