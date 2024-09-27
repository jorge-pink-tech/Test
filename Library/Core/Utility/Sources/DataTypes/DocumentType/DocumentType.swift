//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Foundation

/// An enumeration representing different types of document types.
public enum DocumentType: String, CaseIterable, Codable {
    /// The document type representing a foreign identification.
    case foreignId
    
    /// The document type representing a standard identification.
    case identification
    
    /// The document type representing a passport.
    case passport
    
    /// The document type representing a tax identification number.
    case taxIdentificationNumber
    
    /// The document type representing a document without identification.
    case withoutIdentification

    /// The name of the enum.
    public static let name = "DocumentType"
}
