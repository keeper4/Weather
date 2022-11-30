//
//  MKPlacemark+Extension.swift
//  Manzanita
//
//  Created by Oleksandr Chyzh on 13.01.2022.
//  Copyright © 2022 Manzanita. All rights reserved.
//

import Contacts
import MapKit

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
