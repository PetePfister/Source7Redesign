import SwiftUI

// MARK: - Color palette matching the design

extension Color {
    // Backgrounds
    static let bg0 = Color(hex: "#0a0f1a")
    static let bg1 = Color(hex: "#0f1521")
    static let bg2 = Color(hex: "#141c2b")
    static let bg3 = Color(hex: "#1b2436")
    static let bg4 = Color(hex: "#243049")

    // Borders
    static let line  = Color(hex: "#1f2a3f")
    static let line2 = Color(hex: "#2a3650")

    // Text
    static let text0 = Color(hex: "#f3f5fa")
    static let text1 = Color(hex: "#c8d0de")
    static let text2 = Color(hex: "#8892a8")
    static let text3 = Color(hex: "#5d6680")

    // Status
    static let s7Ok      = Color(hex: "#22c55e")
    static let s7OkBg    = Color(hex: "#22c55e").opacity(0.12)
    static let s7Warn    = Color(hex: "#f59e0b")
    static let s7WarnBg  = Color(hex: "#f59e0b").opacity(0.14)
    static let s7Err     = Color(hex: "#ef4444")
    static let s7ErrBg   = Color(hex: "#ef4444").opacity(0.12)
    static let s7Info    = Color(hex: "#60a5fa")
    static let s7InfoBg  = Color(hex: "#60a5fa").opacity(0.12)

    // Relationship
    static let grp    = Color(hex: "#c084fc")
    static let grpBg  = Color(hex: "#c084fc").opacity(0.14)
    static let grpLine = Color(hex: "#c084fc").opacity(0.4)
    static let ad     = Color(hex: "#f472b6")
    static let adBg   = Color(hex: "#f472b6").opacity(0.14)
    static let adLine = Color(hex: "#f472b6").opacity(0.4)
    static let comp   = Color(hex: "#fbbf24")
    static let compBg = Color(hex: "#fbbf24").opacity(0.14)

    // Source
    static let sourceQ = Color(hex: "#6ee7b7")
    static let sourceH = Color(hex: "#fda4af")

    // Accent
    static let accent = Color(hex: "#38bdf8")

    // Hex initializer
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch h.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

// MARK: - Fonts

extension Font {
    static let mono = Font.system(.body, design: .monospaced)
    static let monoSmall = Font.system(size: 11, weight: .regular, design: .monospaced)
    static let monoTiny = Font.system(size: 10, weight: .regular, design: .monospaced)
}

// MARK: - Shared view modifiers

struct CardStyle: ViewModifier {
    var borderColor: Color = .line
    func body(content: Content) -> some View {
        content
            .background(Color.bg1)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func cardStyle(borderColor: Color = .line) -> some View {
        modifier(CardStyle(borderColor: borderColor))
    }
}

// MARK: - Pill component

struct PillStyle {
    enum Kind {
        case ok, warn, err, info, grp, ad, comp, mono, sourceQ, sourceH

        var bg: Color {
            switch self {
            case .ok: return .s7OkBg
            case .warn: return .s7WarnBg
            case .err: return .s7ErrBg
            case .info: return .s7InfoBg
            case .grp: return .grpBg
            case .ad: return .adBg
            case .comp: return .compBg
            case .mono: return Color.bg3
            case .sourceQ: return Color(hex: "#6ee7b7").opacity(0.12)
            case .sourceH: return Color(hex: "#fda4af").opacity(0.12)
            }
        }

        var fg: Color {
            switch self {
            case .ok: return Color(hex: "#86efac")
            case .warn: return Color(hex: "#fcd34d")
            case .err: return Color(hex: "#fca5a5")
            case .info: return Color(hex: "#93c5fd")
            case .grp: return Color(hex: "#d8b4fe")
            case .ad: return Color(hex: "#fbcfe8")
            case .comp: return Color(hex: "#fde68a")
            case .mono: return .text2
            case .sourceQ: return .sourceQ
            case .sourceH: return .sourceH
            }
        }

        var border: Color {
            switch self {
            case .ok: return Color(hex: "#22c55e").opacity(0.32)
            case .warn: return Color(hex: "#f59e0b").opacity(0.34)
            case .err: return Color(hex: "#ef4444").opacity(0.34)
            case .info: return Color(hex: "#60a5fa").opacity(0.34)
            case .grp: return .grpLine
            case .ad: return .adLine
            case .comp: return Color(hex: "#fbbf24").opacity(0.4)
            case .mono: return .line2
            case .sourceQ: return Color(hex: "#6ee7b7").opacity(0.35)
            case .sourceH: return Color(hex: "#fda4af").opacity(0.35)
            }
        }
    }
}

struct Pill: View {
    let text: String
    let kind: PillStyle.Kind
    var size: CGFloat = 10.5

    var body: some View {
        Text(text)
            .font(.system(size: size, weight: .semibold, design: .monospaced))
            .foregroundColor(kind.fg)
            .padding(.horizontal, 6)
            .padding(.vertical, 1)
            .background(kind.bg)
            .overlay(Capsule().stroke(kind.border, lineWidth: 1))
            .clipShape(Capsule())
    }
}

// MARK: - Copy to clipboard

func copyToClipboard(_ text: String) {
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(text, forType: .string)
}

// MARK: - Section header

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var trailing: (() -> AnyView)? = nil

    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .tracking(1.0)
                .foregroundColor(.text2)
                .textCase(.uppercase)
            if let sub = subtitle {
                Text(sub)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.text3)
            }
            Spacer()
            trailing?()
        }
        .padding(.top, 18)
        .padding(.bottom, 8)
    }
}

// MARK: - Icon button

struct IconButton: View {
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.text1)
                .frame(width: 28, height: 28)
                .background(Color.clear)
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.clear, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .background(Color.clear)
        .contentShape(Rectangle())
        .onHover { h in }
    }
}

// MARK: - Copy button

struct CopyButton: View {
    let label: String
    let value: String
    @State private var copied = false

    var body: some View {
        Button {
            copyToClipboard(value)
            copied = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied = false }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                    .font(.system(size: 10))
                Text(copied ? "Copied" : label)
                    .font(.system(size: 11))
            }
            .foregroundColor(copied ? .s7Ok : .text1)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.bg3)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.line2, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Placeholder image (colored gradient to simulate loaded product images)

struct PlaceholderImage: View {
    var tint: Color = Color(hex: "#3a4458")
    var label: String? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [tint.opacity(0.25), tint.opacity(0.5), tint.opacity(0.19)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [Color.white.opacity(0.4), Color.clear],
                center: UnitPoint(x: 0.3, y: 0.3),
                startRadius: 0,
                endRadius: 60
            )
            if let lbl = label {
                Text(lbl)
                    .font(.system(size: 9.5, weight: .medium, design: .monospaced))
                    .tracking(1.0)
                    .foregroundColor(.white.opacity(0.55))
                    .textCase(.uppercase)
            }
        }
    }
}
