//
//  ContentView.swift
//  gak
//
//  Created by Beers,Theo on 5/31/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
  @State private var input = ""
  @State private var character: Character? = nil
  @State private var unicodeName: String = ""
  @State private var errorMessage: String?

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Enter a Unicode code point (e.g., 063A or U+063A):")
        .font(.title3)
      TextField("Code point", text: $input)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .font(.title3)
        .onSubmit { processInput() }

      if let character = character {
        Text("\(character)")
          .font(.system(size: 64))
          .frame(maxWidth: .infinity, alignment: .center)
        Text("Character name: \(unicodeName)")
          .font(.title3)
        Button("Copy to Clipboard") {
          NSPasteboard.general.clearContents()
          NSPasteboard.general.setString(String(character), forType: .string)
        }
      } else if let errorMessage = errorMessage {
        Text("Error: \(errorMessage)")
          .foregroundColor(.red)
          .font(.title3)
      }

      Spacer()
    }
    .padding()
    .frame(width: 400, height: 300)
  }

  func processInput() {
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    let hex = trimmed.replacingOccurrences(of: "U+", with: "")

    guard let scalarValue = UInt32(hex, radix: 16),
      let scalar = UnicodeScalar(scalarValue)
    else {
      character = nil
      unicodeName = ""
      errorMessage = "Invalid code point"
      return
    }

    character = Character(scalar)
    unicodeName = scalar.properties.name ?? "(no name found)"
    errorMessage = nil
  }
}
