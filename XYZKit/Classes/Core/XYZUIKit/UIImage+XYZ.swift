//
//  UIImage+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2021/12/27.
//

import Foundation
import UIKit

// MARK: Creat from Color

public extension UIImage {
    /// 生成一个纯色图片
    static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    /// 生成一个渐变色图片
    static func image(with size: CGSize = CGSize(width: 5, height: 5),
                      gradientDirection: XYZGradientView.XYZGradientDirection = .horizontal,
                      colors: [UIColor],
                      locations: [NSNumber]? = nil) -> UIImage
    {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let glayer = CAGradientLayer()
            glayer.frame = CGRect(origin: .zero, size: size)
            glayer.gradient(gradientDirection, colors: colors.map { $0.cgColor }, locations: locations)

            if let context = UIGraphicsGetCurrentContext() {
                glayer.render(in: context)
            }
        }
    }
}

// MARK: Down-sampling

public extension UIImage {
    /// 图片下采样 降低内存占用
    /// - Parameter viewSize: 视图的size 会在此size内保持原图的比例进行下采样(等同 AspectFit)
    /// - Returns: 新image
    func downSamplingToViewSize(_ viewSize: CGSize) -> UIImage? {
        let scle = UIScreen.main.scale
        return self.downSamplingToPixelSize(CGSizeMake(viewSize.width*scle, viewSize.height*scle))
    }

    /// 图片下采样 降低内存占用
    /// - Parameter pixelSize: 会在此像素size内保持原图的比例进行下采样(等同 AspectFit)
    /// - Returns: 新image
    func downSamplingToPixelSize(_ pixelSize: CGSize) -> UIImage? {
        if #available(iOS 15, *) {
            // 这个方法会保持原图的scale 乘这个size 计算出需要缩至的像素size范围
            // 为了保持下采样后正好匹配viewSize 这里需要处理下
            return self.preparingThumbnail(of: CGSizeMake(pixelSize.width / self.scale,
                                                          pixelSize.height / self.scale))
        }

        guard let data = pngData(), let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let attr = [kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceThumbnailMaxPixelSize: max(pixelSize.width, pixelSize.height)] as [CFString: Any] as CFDictionary
        guard let imgref = CGImageSourceCreateThumbnailAtIndex(source, 0, attr) else { return nil }
        return UIImage(cgImage: imgref)
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

// MARK: Clip

public extension UIImage {
    func roundCornerRadius(radius: CGFloat,
                           corners: UIRectCorner,
                           borderWidth: CGFloat = 0,
                           borderColor: UIColor? = nil) -> UIImage
    {
        // 1. 参数验证，防止无效参数
        let adjustedRadius = radius >= 0 ? radius : 0
        var adjustedBorderWidth = borderWidth > 0 ? borderWidth : 0

        if adjustedRadius != radius {
            print("Warning: Invalid radius value. Radius must be non-negative. Using 0 as default.")
        }

        if adjustedBorderWidth != borderWidth {
            print("Warning: Invalid border width value. Border width must be positive. Using 0 as default.")
        }

        // 额外检查 borderWidth 大于图像最小尺寸的一半时，打印警告
        let minSize = min(self.size.width, self.size.height)
        if adjustedBorderWidth >= minSize / 2 {
            print("Warning: Border width is too large. It exceeds half the image size, which may lead to unexpected results.")
            adjustedBorderWidth = minSize / 2 - 1 // 防止过大边框
        }

        // 2. 使用 UIGraphicsImageRenderer 进行绘制
        let renderer = UIGraphicsImageRenderer(size: self.size)

        return renderer.image { context in
            let ctx = context.cgContext
            let rect = CGRect(origin: .zero, size: self.size)

            // 3. 绘制图像和圆角
            ctx.saveGState()
            let path = UIBezierPath(roundedRect: rect.insetBy(dx: adjustedBorderWidth, dy: adjustedBorderWidth),
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: adjustedRadius, height: adjustedRadius))
            path.addClip()
            self.draw(in: rect)
            ctx.restoreGState()

            // 4. 绘制边框
            if let borderColor = borderColor, adjustedBorderWidth > 0 {
                ctx.saveGState()
                let strokeInset = (floor(adjustedBorderWidth*self.scale) + 0.5) / self.scale
                let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
                let strokeRadius = adjustedRadius
                let borderPath = UIBezierPath(roundedRect: strokeRect,
                                              byRoundingCorners: corners,
                                              cornerRadii: CGSize(width: strokeRadius, height: strokeRadius))
                borderPath.close()
                borderPath.lineWidth = adjustedBorderWidth
                borderColor.setStroke()
                borderPath.stroke()
            }
        }
    }
}
