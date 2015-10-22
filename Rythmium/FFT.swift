//
//  FFT.swift
//  UntitledMusicGame
//
//  Created by 舒润萱 on 15/7/23.
//  Copyright © 2015年 舒润萱. All rights reserved.
//

import Foundation
import Accelerate
// 以下是Surge库中各种实现
func sqrt(x: [Double]) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vvsqrt(&results, x, [Int32(x.count)])
    
    return results
}

func fft(input: [Int16]) -> [Double] {
    var doubleInput = [Double]()
    doubleInput.reserveCapacity(input.count)
    for value in input {
        doubleInput.append(Double(value))
    }
    return fft(doubleInput)
}

func fft(input: [Double]) -> [Double] {
    var real = [Double](input)
    var imaginary = [Double](count: input.count, repeatedValue: 0.0)
    var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(floor(log2(Float(input.count))))
    let radix = FFTRadix(kFFTRadix2)
    let weights = vDSP_create_fftsetupD(length, radix)

    vDSP_fft_zipD(weights, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
    
    var magnitudes = [Double](count: input.count, repeatedValue: 0.0)
    vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))
    
    var normalizedMagnitudes = [Double](count: input.count, repeatedValue: 0.0)
    vDSP_vsmulD(sqrt(magnitudes), 1, [2.0 / Double(input.count)], &normalizedMagnitudes, 1, vDSP_Length(input.count))
    
    vDSP_destroy_fftsetupD(weights)
    
    return normalizedMagnitudes
}

func sum(x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_sveD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}
// 结束