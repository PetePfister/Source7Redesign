import SwiftUI

struct ImageSlotsGrid: View {
    let slots: [ImageSlot]
    let productId: String
    let onZoom: (ImageSlot) -> Void

    let columns = [GridItem(.adaptive(minimum: 100, maximum: 160), spacing: 8)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(slots) { slot in
                SlotTile(slot: slot, productId: productId, onZoom: onZoom)
            }
        }
    }
}

struct SlotTile: View {
    let slot: ImageSlot
    let productId: String
    let onZoom: (ImageSlot) -> Void

    @State private var isHovered = false

    var body: some View {
        VStack(spacing: 0) {
            // Image area
            ZStack(alignment: .topLeading) {
                // Image or state
                Group {
                    switch slot.status {
                    case .used:
                        PlaceholderImage(tint: slot.color ?? Color(hex: "#444444"))
                            .aspectRatio(1, contentMode: .fit)
                    case .available:
                        ZStack {
                            stripePattern(color: Color(hex: "#f59e0b").opacity(0.08),
                                          accent: Color(hex: "#f59e0b").opacity(0.15))
                            VStack(spacing: 4) {
                                Text("empty")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(.s7Warn)
                                Text("slot")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(.s7Warn)
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                    case .unavailable:
                        ZStack {
                            Color.s7ErrBg
                            Text("×")
                                .font(.system(size: 18))
                                .foregroundColor(.s7Err)
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }
                }

                // Slot number badge
                Text(slot.id)
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .tracking(0.4)
                    .foregroundColor(.white.opacity(0.95))
                    .padding(.horizontal, 5)
                    .padding(.vertical, 1)
                    .background(Color.black.opacity(0.45))
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .padding(6)

                // Status indicator
                Circle()
                    .fill(statusColor)
                    .frame(width: 14, height: 14)
                    .overlay(
                        Group {
                            if slot.status == .used {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 7, weight: .bold))
                                    .foregroundColor(Color(hex: "#002b0e"))
                            } else if slot.status == .unavailable {
                                Text("×")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(Color(hex: "#2b0000"))
                            } else {
                                Text("·")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(Color(hex: "#2b1a00"))
                            }
                        }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(5)
            }

            // Meta
            VStack(alignment: .leading, spacing: 1) {
                if slot.status == .used {
                    Text("\(slot.size ?? "") · \(slot.dim ?? "")")
                        .font(.system(size: 10.5, design: .monospaced))
                        .foregroundColor(.text2)
                        .lineLimit(1)
                    Text(slot.date ?? "")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.text3)
                } else {
                    HStack(spacing: 5) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 9))
                            .foregroundColor(.text3)
                        Text("\(productId)_\(slot.id)")
                            .font(.system(size: 10.5, design: .monospaced))
                            .foregroundColor(.text1)
                            .lineLimit(1)
                            .onTapGesture {
                                copyToClipboard("\(productId)_\(slot.id)")
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.bg1)
        }
        .background(Color.bg2)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isHovered ? Color.line2 : Color.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .animation(.easeOut(duration: 0.12), value: isHovered)
        .onHover { isHovered = $0 }
        .contentShape(Rectangle())
        .onTapGesture {
            if slot.status == .used { onZoom(slot) }
        }
        .help(slot.status == .used ? "Click to zoom" : "")
    }

    private var statusColor: Color {
        switch slot.status {
        case .used: return .s7Ok
        case .available: return .s7Warn
        case .unavailable: return .s7Err
        }
    }

    private func stripePattern(color: Color, accent: Color) -> some View {
        Canvas { ctx, size in
            let stripeWidth: CGFloat = 8
            var x: CGFloat = -size.height
            while x < size.width + size.height {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x + stripeWidth, y: 0))
                path.addLine(to: CGPoint(x: x + stripeWidth + size.height, y: size.height))
                path.addLine(to: CGPoint(x: x + size.height, y: size.height))
                path.closeSubpath()
                ctx.fill(path, with: .color(accent))
                x += stripeWidth * 2
            }
        }
        .background(color)
    }
}

// MARK: - Swatch stack (two-up grid)

struct SwatchStackView: View {
    let swatches: [Swatch]
    let productId: String
    let onZoomSwatch: (Swatch, String) -> Void

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
            spacing: 10
        ) {
            ForEach(swatches) { sw in
                SwatchRowView(
                    swatch: sw,
                    productId: productId,
                    onZoom: { slot in onZoomSwatch(sw, slot) }
                )
            }
        }
        .padding(.top, 6)
    }
}

struct SwatchRowView: View {
    let swatch: Swatch
    let productId: String
    let onZoom: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            // 101 - color swatch chip
            SwatchCell(
                label: "101 · Swatch",
                isLoaded: swatch.s101?.ok == true,
                solidColor: swatch.s101?.ok == true ? swatch.color : nil,
                onZoom: { onZoom("101") }
            )

            // 102 - product image
            SwatchCell(
                label: "102 · Product",
                isLoaded: swatch.s102?.ok == true,
                tintColor: swatch.s102?.ok == true ? swatch.color : nil,
                onZoom: { onZoom("102") }
            )

            // Info
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(swatch.code)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(.text0)
                    Text(swatch.name)
                        .font(.system(size: 13))
                        .foregroundColor(.text1)
                }

                HStack(spacing: 8) {
                    Text("OKQ")
                        .font(.system(size: 11))
                        .foregroundColor(.text2)
                    Text(swatch.okq == 0 ? "0" : swatch.okq.formatted())
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(swatch.okq == 0 ? .s7Err : .text0)
                    if swatch.okq == 0 {
                        Pill(text: "OOS", kind: .err, size: 9)
                    }
                }
                .padding(.top, 4)

                HStack(spacing: 4) {
                    CopyButton(label: "101", value: "\(productId)_\(swatch.code)_101")
                    CopyButton(label: "102", value: "\(productId)_\(swatch.code)_102")
                }
                .padding(.top, 6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(swatchBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(swatchBorderColor, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var swatchBackground: some View {
        Group {
            if swatch.missing {
                LinearGradient(colors: [Color.s7ErrBg, Color.bg1], startPoint: .top, endPoint: .bottom)
            } else if swatch.partial {
                LinearGradient(colors: [Color.s7WarnBg, Color.bg1], startPoint: .top, endPoint: .bottom)
            } else {
                LinearGradient(colors: [Color.bg1], startPoint: .top, endPoint: .bottom)
            }
        }
    }

    private var swatchBorderColor: Color {
        if swatch.missing { return Color.s7Err.opacity(0.34) }
        if swatch.partial { return Color.s7Warn.opacity(0.34) }
        return Color.line
    }
}

struct SwatchCell: View {
    let label: String
    let isLoaded: Bool
    var solidColor: Color? = nil
    var tintColor: Color? = nil
    let onZoom: () -> Void

    @State private var isHovered = false

    var body: some View {
        VStack(spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 9.5, weight: .bold))
                .tracking(0.8)
                .foregroundColor(.text3)

            // Image box
            ZStack {
                if let solid = solidColor {
                    solid
                } else if let tint = tintColor {
                    PlaceholderImage(tint: tint)
                } else {
                    // Missing
                    MissingPattern()
                    Text("missing")
                        .font(.system(size: 10, design: .monospaced))
                        .tracking(0.6)
                        .foregroundColor(.s7Err)
                        .textCase(.uppercase)
                }
            }
            .frame(width: 84, height: 84)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.08), lineWidth: 1))
            .scaleEffect(isHovered && isLoaded ? 1.03 : 1.0)
            .animation(.easeOut(duration: 0.12), value: isHovered)
            .onHover { isHovered = $0 && isLoaded }
            .onTapGesture { if isLoaded { onZoom() } }
            .cursor(isLoaded ? .pointingHand : .arrow)

            Pill(text: isLoaded ? "✓ loaded" : "missing", kind: isLoaded ? .ok : .err, size: 9)
        }
    }
}

extension View {
    func cursor(_ cursor: NSCursor) -> some View {
        onHover { inside in
            if inside { cursor.push() } else { NSCursor.pop() }
        }
    }
}

struct MissingPattern: View {
    var body: some View {
        Canvas { ctx, size in
            let stripeWidth: CGFloat = 6
            var x: CGFloat = -size.height
            while x < size.width + size.height {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x + stripeWidth, y: 0))
                path.addLine(to: CGPoint(x: x + stripeWidth + size.height, y: size.height))
                path.addLine(to: CGPoint(x: x + size.height, y: size.height))
                path.closeSubpath()
                ctx.fill(path, with: .color(Color(hex: "#ef4444").opacity(0.12)))
                x += stripeWidth * 2
            }
        }
        .background(Color(hex: "#ef4444").opacity(0.05))
    }
}
