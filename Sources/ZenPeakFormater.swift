
import Foundation
import Combine
import SwiftUI
import UIKit
extension ZenPeakEngine {
    
    public func zenParseSnippet() {
        let sample = "{\"keyX\": \"valueY\"}"
        if let data = sample.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: [])
                print("zenParseSnippet -> success: \(obj)")
            } catch {
                print("zenParseSnippet -> error: \(error)")
            }
        }
    }
    

    public func zenSimulateWait() {
        print("zenSimulateWait -> waiting 1 second.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("zenSimulateWait -> done waiting.")
        }
    }
    
    public func zenHasDuplicateStrings(_ arr: [String]) -> Bool {
        let setCount = Set(arr).count
        let hasDup = (setCount != arr.count)
        print("zenHasDuplicateStrings -> \(hasDup)")
        return hasDup
    }
    
    public func zenMergeIntArrays(_ a: [Int], _ b: [Int]) -> [Int] {
        var merged = a
        for x in b {
            if !merged.contains(x) {
                merged.append(x)
            }
        }
        print("zenMergeIntArrays -> \(merged)")
        return merged
    }
}
