//
//  DotGraphExporter.swift
//  Dots
//
//  Created by Travis London on 1/13/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import Foundation

public class DotGraphExporter {
    
    public func exportDotGraph(dotGraph : String, fileName : String) {

        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
        let path = dir?.appendingPathComponent(fileName)
            
        do {
            try dotGraph.write(to: path!, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {
            print("Unable to write dot graph to file: " + fileName)
        }
        
    }

}
