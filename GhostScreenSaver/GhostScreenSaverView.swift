//
//  GhostScreenSaverView.swift
//  GhostScreenSaver
//
//  Created by @stonechoe on 7/16/25.
//
//  Portions of this code are derived from MIT-licensed projects.
//  See respective repositories for license details.
//
//  References:
//  - https://github.com/johanremilien/PongScreenSaver

import ScreenSaver

class GhostScreenSaverView: ScreenSaverView {
    // MARK: - Constants & Configuration

    private enum Constants {
        // TODO: let these be optionated
        static let fontSize: CGFloat = 12.0
        static let defaultColor: NSColor = .white
        static let highlightColor: NSColor = .systemBlue

        static let animationDataFileName = "animation-data"
        static let animationDataFileExtension = "json"

        static let colorStartTag = "<c>"
        static let colorEndTag = "</c>"
    }

    // MARK: - State Properties

    private var animationFrames: [AttributedString] = []
    private var currentFrameIndex: Int = 0
    private var rect: CGRect = .init()

    // MARK: - Initialization

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        loadAndProcessAnimationData()

        let text = NSAttributedString(animationFrames[0])

        let size = (text.boundingRect(
            with: bounds.size, options: [
                .usesLineFragmentOrigin,
            ]
        ))
        let rect = CGRect(origin: CGPoint(
            x: (bounds.width - size.width) / 2,
            y: (bounds.height - size.height) / 2,
        ), size: size.size)

        self.rect = rect
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Data Loading & Processing

    private func loadAndProcessAnimationData() {
        // 1. Find the JSON file in the bundle.
        guard let url = Bundle(for: Self.self).url(
            forResource: Constants.animationDataFileName,
            withExtension: Constants.animationDataFileExtension
        ) else {
            fatalError("Could not find \(Constants.animationDataFileName).json in the bundle.")
        }

        do {
            let data = try Data(contentsOf: url)
            typealias RawFrameData = [[String]]
            let rawFrames = try JSONDecoder().decode(RawFrameData.self, from: data)
            animationFrames = processRawFrames(rawFrames)
        } catch {
            fatalError("Failed to load or parse animation data: \(error)")
        }
    }

    // Corrected processRawFrames function
    private func processRawFrames(_ rawFrames: [[String]]) -> [AttributedString] {
        let font = NSFont(name: "Menlo", size: Constants.fontSize) ?? NSFont.monospacedSystemFont(ofSize: Constants.fontSize, weight: .regular)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byClipping

        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: Constants.defaultColor,
            .paragraphStyle: paragraphStyle,
        ]

        let highlightAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: Constants.highlightColor,
            .paragraphStyle: paragraphStyle,
        ]

        return rawFrames.map { frameLines in
            let fullFrameString = frameLines.joined(separator: "\n")
            let attributedString = NSMutableAttributedString()
            let components = fullFrameString.components(separatedBy: Constants.colorStartTag)

            for (index, component) in components.enumerated() {
                if index == 0 {
                    // The first component is always default color.
                    attributedString.append(NSAttributedString(string: component, attributes: defaultAttributes))
                    continue
                }

                // For subsequent components, they might contain a closing tag.
                if let range = component.range(of: Constants.colorEndTag) {
                    let highlightedText = String(component[..<range.lowerBound])
                    let remainingText = String(component[range.upperBound...])

                    // Append the highlighted part.
                    attributedString.append(NSAttributedString(string: highlightedText, attributes: highlightAttributes))

                    // Append the rest with default styling.
                    attributedString.append(NSAttributedString(string: remainingText, attributes: defaultAttributes))
                } else {
                    // No closing tag found, treat as default.
                    attributedString.append(NSAttributedString(string: component, attributes: defaultAttributes))
                }
            }
            return AttributedString(attributedString)
        }
    }

    // MARK: - Animation & Drawing Lifecycle

    override func draw(_: NSRect) {
        drawBackground(.black)
        let attrStr = animationFrames[currentFrameIndex]
        drawAttrStr(attrStr)
    }

    override func animateOneFrame() {
        super.animateOneFrame()

        currentFrameIndex = (
            (currentFrameIndex + 1) % animationFrames.count
        )

        setNeedsDisplay(bounds)
    }

    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
    }

    private func drawAttrStr(_ attrStr: AttributedString) {
        let text = NSAttributedString(attrStr)
        text.draw(in: rect)
    }
}
