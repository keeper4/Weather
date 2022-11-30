//
//  Kingfisher+Extention.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Kingfisher
import CoreGraphics
import Foundation

public extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    //UIScreen.main.scale,
    @discardableResult
    func setImageWithImageSize(
        with resource: Resource?,
        imageSize: CGSize,
        scale: CGFloat = 3,
        placeholder: Placeholder? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: imageSize.width * scale,
                                                                             height: imageSize.height * scale),
                                                       mode: .aspectFill)
        
        var options: KingfisherOptionsInfo = [.forceTransition,
                                              .processor(resizingProcessor)]
        
        return setImage(
            with: resource.map { .network($0) },
            placeholder: placeholder,
            options: options,
            progressBlock: progressBlock,
            completionHandler: completionHandler)
    }
}
