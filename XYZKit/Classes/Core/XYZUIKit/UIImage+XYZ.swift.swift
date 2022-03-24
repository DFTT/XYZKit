//
//  UIImage+XYZ.swift.swift
//  XYZKit
//
//  Created by 大大东 on 2021/12/27.
//

import Foundation
import UIKit

// MARK: Creat from Color

public extension UIImage {
    static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: Compress

public extension UIImage {
    ///  压缩图片 jpeg
    /// - Parameters:
    ///   - img: 待压缩图片
    ///   - maxKBCost: 压缩后的最大值 (KB) 默认500
    ///   - maxPicelW: 分辨率宽的最大值 (保持原比例 降低分辨率, 默认856, iPhone设备max  = 428pt * 926)
    /// - Returns: data with jpeg format
    static func tryCompress(_ img: UIImage, maxKBCost: Int = 500, maxPixelW: Int = 856) -> Data? {
        func __kbCost(_ byte: Int) -> Int {
            return Int(ceilf(Float(byte) / 1024))
        }
        
        func __compressPixel(_ img: UIImage, maxPixelW: Int) -> UIImage {
            let originW = Int(img.size.width*img.scale)
            let originH = Int(img.size.height*img.scale)
            
            var newImage: UIImage?
            if originW > maxPixelW {
                // 降低分辨率到允许的最大值(等比缩小)
                let newW = maxPixelW
                let newH = Int(floorf(Float(maxPixelW) / Float(originW)*Float(originH)))
                autoreleasepool {
                    UIGraphicsBeginImageContextWithOptions(CGSize(width: newW, height: newH), false, 1)
                    img.draw(in: CGRect(x: 0, y: 0, width: newW, height: newH))
                    newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                }
            }
            return newImage ?? img
        }
        
        func __compressQuality(_ img: UIImage, bestCostKB: Int) -> Data? {
            // 二分法寻找最佳压缩质量
            var defultData, bestData: Data?
            var begin = 0
            var end = 100
            while begin + 1 < end {
                let index = (begin + end) / 2
                guard let compresData = img.jpegData(compressionQuality: CGFloat(index) / 100) else {
                    assertionFailure("compress quality Failure, please check code ...")
                    break
                }
                let compressCost = __kbCost(compresData.count)
                
                if compressCost > bestCostKB {
                    end = index
                    if defultData == nil || (compressCost < __kbCost(defultData?.count ?? 0)) {
                        defultData = compresData
                    }
                } else if compressCost < bestCostKB {
                    begin = index
                    if bestData == nil || (compressCost > __kbCost(bestData?.count ?? 0)) {
                        bestData = compresData
                    }
                } else {
                    bestData = compresData
                    break
                }
            }
            return bestData ?? defultData ?? img.jpegData(compressionQuality: 0.8)
        }
        
        // jpegData: 这个方法 quality:1 得到data.cout也许会比实际图片大
        if let imgData = img.jpegData(compressionQuality: 0.8), __kbCost(imgData.count) <= maxKBCost {
            return imgData
        }
        
        // 1. 降低分辨率到允许的最大值(等比缩小)
        let maxPixelImg = __compressPixel(img, maxPixelW: maxPixelW)
        if let finalData = maxPixelImg.jpegData(compressionQuality: 0.8),
           __kbCost(finalData.count) <= maxKBCost
        {
            return finalData
        }
    
        // 2. 二分法压缩质量
        let lowstQualityData = __compressQuality(maxPixelImg, bestCostKB: maxKBCost)
        if let data = lowstQualityData,
           __kbCost(data.count) <= maxKBCost
        {
            return data
        }
        
        // 3. 再次逐步降低分辨率
        var step3Image: UIImage!
        if let data = lowstQualityData {
            step3Image = UIImage(data: data) ?? maxPixelImg
        } else {
            step3Image = maxPixelImg
        }
        var finalData: Data?
        let distant = Float(maxPixelW) / 15
        bkTag: while true {
            finalData = step3Image.jpegData(compressionQuality: 0.8)
            if let finalData = finalData, __kbCost(finalData.count) <= maxKBCost {
                break bkTag
            }
            let imgWitdh = Float(step3Image.size.width*step3Image.scale)
            if imgWitdh < distant*5 {
                break bkTag
            }
            step3Image = __compressPixel(step3Image, maxPixelW: Int(imgWitdh - distant))
        }

        return finalData ?? lowstQualityData
    }
}
