//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Foundation

/// An enumeration representing different types of business structures.
public enum BusinessStructure: String, CaseIterable, Codable {
    /// Large taxpayers structure.
    case largeTaxpayers
    
    /// Large withholding taxpayers structure.
    case largeWithholdingTaxpayers
    
    /// Natural person structure.
    case naturalPerson
    
    /// Self withholder structrure.
    case selfWithholder
    
    /// Simple business structure.
    case simple

    /// The name of the enum.
    public static let name = "BusinessStructure"
}
