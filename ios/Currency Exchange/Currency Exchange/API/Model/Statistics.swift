//
//  Statistics.swift
//  Currency Exchange
//
//  Created by Omar Khodr on 4/30/21.
//

import Foundation

struct Statistics: Codable {
    let maxUsdToLbp: Float
    let maxLbpToUsd: Float
    
    let medianUsdToLbp: Float
    let medianLbpToUsd: Float
    
    let stdevUsdToLbp: Float
    let stdevLbpToUsd: Float
    
    let modeUsdToLbp: Float
    let modeLbpToUsd: Float
    
    let varianceUsdToLbp: Float
    let varianceLbpToUsd: Float
}
