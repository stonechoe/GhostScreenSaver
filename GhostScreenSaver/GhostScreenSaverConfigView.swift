//
//  GhostScreenSaverConfigView.swift
//  GhostScreenSaver
//
//  Created by @stonechoe on 7/23/25.
//

import SwiftUI
import ScreenSaver

struct GhostScreenSaverConfigView: View {
    @State private var fontSize: Double
    @State private var highlightColor: Color
    
    // UserDefaults keys
    private enum UserDefaultsKeys {
        static let fontSize = "GhostScreenSaver.fontSize"
        static let highlightColorRed = "GhostScreenSaver.highlightColor.red"
        static let highlightColorGreen = "GhostScreenSaver.highlightColor.green"
        static let highlightColorBlue = "GhostScreenSaver.highlightColor.blue"
        static let highlightColorAlpha = "GhostScreenSaver.highlightColor.alpha"
    }
    
    init() {
        let userDefaults = ScreenSaverDefaults(forModuleWithName: "GhostScreenSaver")!
        
        // Load saved values or use defaults
        let savedFontSize = userDefaults.double(forKey: UserDefaultsKeys.fontSize)
        self._fontSize = State(initialValue: savedFontSize > 0 ? savedFontSize : 12.0)
        
        // Load saved color or use default
        let red = userDefaults.double(forKey: UserDefaultsKeys.highlightColorRed)
        let green = userDefaults.double(forKey: UserDefaultsKeys.highlightColorGreen)
        let blue = userDefaults.double(forKey: UserDefaultsKeys.highlightColorBlue)
        let alpha = userDefaults.double(forKey: UserDefaultsKeys.highlightColorAlpha)
        
        if red == 0 && green == 0 && blue == 0 && alpha == 0 {
            // Default to system blue
            self._highlightColor = State(initialValue: Color.blue)
        } else {
            self._highlightColor = State(initialValue: Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ghost Screen Saver Settings")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Font Size")
                    .font(.headline)
                
                HStack {
                    Slider(value: $fontSize, in: 8...24, step: 1) {
                        Text("Font Size")
                    }
                    .onChange(of: fontSize) { _, newValue in
                        saveFontSize(newValue)
                    }
                    
                    Text("\(Int(fontSize))pt")
                        .frame(width: 40, alignment: .trailing)
                        .monospacedDigit()
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Highlight Color")
                    .font(.headline)
                
                HStack {
                    ColorPicker("Highlight Color", selection: $highlightColor)
                        .labelsHidden()
                        .frame(width: 50, height: 30)
                        .onChange(of: highlightColor) { _, newValue in
                            saveHighlightColor(newValue)
                        }
                    
                    Text("Choose the color for highlighted text")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Reset to Defaults") {
                    resetToDefaults()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .frame(width: 400, height: 200)
    }
    
    private func saveFontSize(_ size: Double) {
        let userDefaults = ScreenSaverDefaults(forModuleWithName: "GhostScreenSaver")!
        userDefaults.set(size, forKey: UserDefaultsKeys.fontSize)
        userDefaults.synchronize()
    }
    
    private func saveHighlightColor(_ color: Color) {
        let userDefaults = ScreenSaverDefaults(forModuleWithName: "GhostScreenSaver")!
        let nsColor = NSColor(color)
        let rgbColor = nsColor.usingColorSpace(.sRGB) ?? nsColor
        
        userDefaults.set(Double(rgbColor.redComponent), forKey: UserDefaultsKeys.highlightColorRed)
        userDefaults.set(Double(rgbColor.greenComponent), forKey: UserDefaultsKeys.highlightColorGreen)
        userDefaults.set(Double(rgbColor.blueComponent), forKey: UserDefaultsKeys.highlightColorBlue)
        userDefaults.set(Double(rgbColor.alphaComponent), forKey: UserDefaultsKeys.highlightColorAlpha)
        userDefaults.synchronize()
    }
    
    private func resetToDefaults() {
        fontSize = 12.0
        highlightColor = Color.blue
        
        saveFontSize(fontSize)
        saveHighlightColor(highlightColor)
    }
}

#Preview {
    GhostScreenSaverConfigView()
}
