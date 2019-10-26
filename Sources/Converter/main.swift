//
//  main.swift
//
//
//  Created by Christian Treffs on 24.10.19.
//

import Foundation

// <SRC_ROOT>/3rdparty/cimgui/generator/output/definitions.json

struct ConversionError: Swift.Error {
    let localizedDescription: String
}

guard CommandLine.arguments.count == 3 else {
    throw ConversionError(localizedDescription: "Converter needs exactly 2 parameters: [1]: Input file path, [2]: Output file path")
}

let header = """
// -- THIS FILE IS AUTOGENERATED - DO NOT EDIT!!! ---

import CImGUI

// swiftlint:disable identifier_name

public enum ImGui2 {
"""

let footer = """
}
"""

try convert(filePath: CommandLine.arguments[1], validOnly: true) { body in
    let out: String = [header, body, footer].joined(separator: "\n\n")

    guard let data: Data = out.data(using: .utf8) else {
        throw ConversionError(localizedDescription: "Could not generate data from output string \(out)")
    }

    let outURL: URL = URL(fileURLWithPath: CommandLine.arguments[2])

    try data.write(to: outURL, options: .atomicWrite)
}