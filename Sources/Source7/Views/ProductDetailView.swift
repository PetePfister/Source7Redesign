import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var state: AppState
    @State private var descExpanded = false
    @State private var isRefreshing = false
    @State private var zoomSlot: ImageSlot? = nil
    @State private var zoomSwatch: (swatch: Swatch, slot: String)? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // TOP ROW: Related Items (left, 1fr) + Product card (right, 1fr)
                HStack(alignment: .top, spacing: 10) {
                    RelatedItemsView(product: product)
                        .frame(maxWidth: .infinity)

                    ProductCard(
                        product: product,
                        descExpanded: $descExpanded,
                        isRefreshing: $isRefreshing
                    )
                    .frame(maxWidth: .infinity)
                }
                .frame(minHeight: 242)

                // IMAGE SLOTS
                let ss = product.slotStats
                SectionHeader(
                    title: "Scene7 Product Detail Images",
                    subtitle: "· \(ss.used)/\(ss.total) loaded",
                    trailing: {
                        AnyView(
                            HStack(spacing: 12) {
                                LegendDot(color: .s7Ok, label: "Used (\(ss.used))")
                                LegendDot(color: .s7Warn, label: "Avail (\(ss.avail))")
                                if ss.unavail > 0 {
                                    LegendDot(color: .s7Err, label: "Blocked (\(ss.unavail))")
                                }
                            }
                        )
                    }
                )

                ImageSlotsGrid(slots: product.slots, productId: product.id) { slot in
                    zoomSlot = slot
                }

                // SWATCHES
                let ws = product.swatchStats
                SectionHeader(
                    title: "Swatches",
                    subtitle: "· \(product.swatches.count) colors · \(ws.ready) ready\(ws.partial + ws.missing > 0 ? " · \(ws.partial + ws.missing) need attention" : "")",
                    trailing: {
                        AnyView(
                            HStack(spacing: 6) {
                                CopyButton(
                                    label: "101 filenames",
                                    value: product.swatches.map { "\(product.id)_\($0.code)_101" }.joined(separator: "\n")
                                )
                                CopyButton(
                                    label: "102 filenames",
                                    value: product.swatches.map { "\(product.id)_\($0.code)_102" }.joined(separator: "\n")
                                )
                                CopyButton(
                                    label: "Color codes",
                                    value: product.swatches.map(\.code).joined(separator: "\n")
                                )
                            }
                        )
                    }
                )

                SwatchStackView(swatches: product.swatches, productId: product.id) { sw, slot in
                    zoomSwatch = (sw, slot)
                }

                // INVENTORY & PULL STATUS
                SectionHeader(title: "Inventory & Pull Status")

                HStack(alignment: .top, spacing: 10) {
                    // Color Matrix
                    VStack(alignment: .leading, spacing: 0) {
                        CardHeader(title: "Color Matrix", trailing: AnyView(
                            Text("OKQ summed across all sizes")
                                .font(.system(size: 11))
                                .foregroundColor(.text3)
                        ))
                        ColorMatrixTable(swatches: product.swatches, productId: product.id)
                    }
                    .cardStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Airtable Pull Status
                    VStack(alignment: .leading, spacing: 0) {
                        CardHeader(title: "Airtable · Pull Status", trailing: AnyView(
                            Text("\(product.pullList.count) rows")
                                .font(.system(size: 11))
                                .foregroundColor(.text3)
                        ))
                        AirtablePullTable(pullList: product.pullList)
                    }
                    .cardStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 10)

                // SHOT LIST (at bottom)
                let missing = product.missingFilenames
                SectionHeader(
                    title: "Shot List",
                    subtitle: "· \(missing.isEmpty ? "all complete" : "\(missing.count) to shoot")",
                    trailing: missing.isEmpty ? nil : {
                        AnyView(
                            CopyButton(
                                label: "Copy all filenames",
                                value: missing.map(\.name).joined(separator: "\n")
                            )
                        )
                    }
                )

                ShotListCard(missing: missing)

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
        }
        .background(Color.bg0)
        .sheet(item: $zoomSlot) { slot in
            ZoomableImageModal(
                title: "\(product.id)_\(slot.id)",
                subtitle: "\(slot.dim ?? "") · \(slot.size ?? "")",
                urlToCopy: "https://q.scene7.com/is/image/QVC/\(product.id)_\(slot.id)",
                tint: slot.color ?? Color(hex: "#3a4458"),
                kind: "USED"
            )
        }
        .sheet(isPresented: Binding(
            get: { zoomSwatch != nil },
            set: { if !$0 { zoomSwatch = nil } }
        )) {
            if let zs = zoomSwatch {
                ZoomableImageModal(
                    title: "\(product.id)_\(zs.swatch.code)_\(zs.slot)",
                    subtitle: "\(zs.swatch.code) · \(zs.swatch.name)",
                    urlToCopy: "https://q.scene7.com/is/image/QVC/\(product.id)_\(zs.swatch.code)_\(zs.slot)",
                    tint: zs.swatch.color,
                    kind: zs.slot == "101" ? "SWATCH" : "PRODUCT"
                )
            }
        }
    }
}

// MARK: - Product identity card (right side)

struct ProductCard: View {
    let product: Product
    @Binding var descExpanded: Bool
    @Binding var isRefreshing: Bool
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
                    Pill(
                        text: product.source.label,
                        kind: product.source == .q ? .sourceQ : .sourceH,
                        size: 11
                    )
                    Text(product.id)
                        .font(.system(size: 19, weight: .bold, design: .monospaced))
                        .foregroundColor(.text0)
                    Button {
                        copyToClipboard(product.id)
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 11))
                            .foregroundColor(.text2)
                    }
                    .buttonStyle(.plain)

                    Button { } label: {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 11))
                            .foregroundColor(.text2)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    // Next Air inline with ID
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                            .foregroundColor(.s7Info)
                        Text("NEXT AIR")
                            .font(.system(size: 10, weight: .bold))
                            .tracking(0.5)
                            .foregroundColor(.text3)
                        Text(product.nextAir.date)
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(.text0)
                        Text("· \(product.nextAir.hour)")
                            .font(.system(size: 11))
                            .foregroundColor(.text2)
                        Pill(text: product.nextAir.show, kind: .info, size: 9)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, 11)
                .padding(.bottom, 4)
            }

            // Body
            VStack(alignment: .leading, spacing: 0) {
                Text(product.title)
                    .font(.system(size: 14.5, weight: .semibold))
                    .foregroundColor(.text0)
                    .lineSpacing(2)
                    .padding(.bottom, 8)

                Text("DESCRIPTION")
                    .font(.system(size: 9.5, weight: .bold))
                    .tracking(1.0)
                    .foregroundColor(.text3)
                    .padding(.bottom, 2)

                Text(product.longDesc)
                    .font(.system(size: 12))
                    .foregroundColor(.text1)
                    .lineSpacing(3)
                    .lineLimit(descExpanded ? nil : 4)
                    .fixedSize(horizontal: false, vertical: true)

                if product.longDesc.count > 180 {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            descExpanded.toggle()
                        }
                    } label: {
                        Text(descExpanded ? "Show less" : "Show more")
                            .font(.system(size: 11.5))
                            .foregroundColor(.accent)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }

                Divider()
                    .background(Color.line)
                    .padding(.vertical, 10)
                    .padding(.horizontal, -14)

                // Footer
                HStack(spacing: 8) {
                    Text("Checked \(product.lastChecked)")
                        .font(.system(size: 10))
                        .foregroundColor(.text2)
                    if isRefreshing {
                        ProgressView()
                            .scaleEffect(0.6)
                            .frame(width: 12, height: 12)
                    }
                    Button {
                        isRefreshing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            isRefreshing = false
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 10))
                            Text("Refresh")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(.text1)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.bg3)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.line2, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
            .padding(.top, 4)
        }
        .cardStyle()
    }
}

// MARK: - Legend dot

struct LegendDot: View {
    let color: Color
    let label: String
    var body: some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 7, height: 7)
            Text(label).font(.system(size: 11)).foregroundColor(.text3)
        }
    }
}

// MARK: - Card header reusable

struct CardHeader: View {
    let title: String
    var trailing: AnyView? = nil
    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .bold))
                .tracking(0.8)
                .foregroundColor(.text2)
            Spacer()
            trailing
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }
}

// MARK: - Color matrix table

struct ColorMatrixTable: View {
    let swatches: [Swatch]
    let productId: String

    var body: some View {
        VStack(spacing: 0) {
            // Header row
            HStack(spacing: 0) {
                Color.clear.frame(width: 24)
                TableHeaderCell("Code", width: 64)
                TableHeaderCell("Name")
                TableHeaderCell("Article ID", width: 100)
                TableHeaderCell("OKQ", width: 60, alignment: .trailing)
            }
            .background(Color.bg2)

            ForEach(swatches) { sw in
                Divider().background(Color.line)
                HStack(spacing: 0) {
                    // Color chip
                    RoundedRectangle(cornerRadius: 3)
                        .fill(sw.color)
                        .frame(width: 12, height: 12)
                        .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        .frame(width: 24, alignment: .center)
                    TableCell(sw.code, width: 64, mono: true)
                    TableCell(sw.name)
                    TableCell(articleId(sw), width: 100, mono: true, muted: true)
                    // OKQ
                    Text(sw.okq == 0 ? "0 OOS" : sw.okq.formatted())
                        .font(.system(size: 11.5, design: sw.okq == 0 ? .monospaced : .monospaced))
                        .foregroundColor(sw.okq == 0 ? .s7Err : .text0)
                        .fontWeight(sw.okq == 0 ? .bold : .regular)
                        .frame(width: 60, alignment: .trailing)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                }
            }
        }
    }

    private func articleId(_ sw: Swatch) -> String {
        let base = Int(productId.filter(\.isNumber)) ?? 1234567
        let shifted = (base + Int(sw.code.unicodeScalars.first?.value ?? 0)) % 9000000 + 1000000
        return "A\(shifted)"
    }
}

struct TableHeaderCell: View {
    let text: String
    var width: CGFloat? = nil
    var alignment: Alignment = .leading

    init(_ text: String, width: CGFloat? = nil, alignment: Alignment = .leading) {
        self.text = text
        self.width = width
        self.alignment = alignment
    }

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 10, weight: .semibold))
            .tracking(0.4)
            .foregroundColor(.text2)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(width: width, maxWidth: width == nil ? .infinity : nil, alignment: alignment)
    }
}

struct TableCell: View {
    let text: String
    var width: CGFloat? = nil
    var mono: Bool = false
    var muted: Bool = false
    var alignment: Alignment = .leading

    init(_ text: String, width: CGFloat? = nil, mono: Bool = false, muted: Bool = false, alignment: Alignment = .leading) {
        self.text = text
        self.width = width
        self.mono = mono
        self.muted = muted
        self.alignment = alignment
    }

    var body: some View {
        Text(text)
            .font(mono ? .system(size: 11.5, design: .monospaced) : .system(size: 11.5))
            .foregroundColor(muted ? .text2 : .text1)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .frame(width: width, maxWidth: width == nil ? .infinity : nil, alignment: alignment)
    }
}

// MARK: - Airtable pull status table

struct AirtablePullTable: View {
    let pullList: [PullRow]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TableHeaderCell("Color")
                TableHeaderCell("Photographer")
                TableHeaderCell("Shot", width: 50, alignment: .center)
                TableHeaderCell("Retch", width: 60, alignment: .center)
            }
            .background(Color.bg2)

            if pullList.isEmpty {
                Text("No pull list rows linked.")
                    .font(.system(size: 11.5))
                    .foregroundColor(.text3)
                    .padding(14)
            } else {
                ForEach(pullList) { row in
                    Divider().background(Color.line)
                    HStack(spacing: 0) {
                        TableCell(row.color)
                        TableCell(row.photographer, muted: true)
                        // Shot
                        Group {
                            if row.shot {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.s7Ok)
                            } else {
                                Text("—").foregroundColor(.text3)
                            }
                        }
                        .frame(width: 50, alignment: .center)
                        .padding(.vertical, 7)
                        // Retouched
                        Group {
                            if row.retouched {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.s7Ok)
                            } else {
                                Text("—").foregroundColor(.text3)
                            }
                        }
                        .frame(width: 60, alignment: .center)
                        .padding(.vertical, 7)
                    }
                }
            }
        }
    }
}

// MARK: - Shot list card

struct ShotListCard: View {
    let missing: [(name: String, kind: String)]

    let cols = [GridItem(.adaptive(minimum: 220), spacing: 4)]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if missing.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12))
                        .foregroundColor(.s7Ok)
                    Text("All product slots and swatch images present.")
                        .font(.system(size: 12))
                        .foregroundColor(.text2)
                }
                .padding(14)
            } else {
                LazyVGrid(columns: cols, spacing: 4) {
                    ForEach(missing, id: \.name) { item in
                        HStack(spacing: 10) {
                            Image(systemName: item.kind == "slot" ? "photo" : "paintpalette")
                                .font(.system(size: 11))
                                .foregroundColor(.text3)
                            Text(item.name)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.text0)
                                .lineLimit(1)
                            Spacer()
                            Pill(text: "Missing", kind: .warn, size: 9)
                            Button {
                                copyToClipboard(item.name)
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 10))
                                    .foregroundColor(.text2)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .background(Color.bg2.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
                .padding(8)
            }
        }
        .cardStyle()
    }
}

// MARK: - Zoom modal

struct ZoomableImageModal: View {
    let title: String
    let subtitle: String
    let urlToCopy: String
    let tint: Color
    let kind: String

    @Environment(\.dismiss) var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var copied = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundColor(.text0)
                Pill(text: kind, kind: .ok, size: 9.5)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.text2)

                Spacer()

                // Zoom controls
                HStack(spacing: 4) {
                    Button {
                        withAnimation { scale = max(0.25, scale / 1.25) }
                    } label: {
                        Text("−")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.text1)
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.plain)

                    Text("\(Int(scale * 100))%")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.text2)
                        .frame(minWidth: 44)
                        .multilineTextAlignment(.center)

                    Button {
                        withAnimation { scale = min(8, scale * 1.25) }
                    } label: {
                        Text("+")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.text1)
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.plain)

                    Button {
                        withAnimation { scale = 1; offset = .zero }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 12))
                            .foregroundColor(.text1)
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(Color.bg0)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.line, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 6))

                Button {
                    copyToClipboard(urlToCopy)
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied = false }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 11))
                        Text(copied ? "Copied" : "Copy URL")
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

                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13))
                        .foregroundColor(.text1)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
                .keyboardShortcut(.escape, modifiers: [])
            }
            .padding(12)

            // Image stage
            ZStack {
                Color.black
                PlaceholderImage(tint: tint)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { v in offset = CGSize(width: offset.width + v.translation.width, height: offset.height + v.translation.height) }
                    )
                    .onTapGesture(count: 2) {
                        withAnimation { scale = 1; offset = .zero }
                    }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 540)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.line, lineWidth: 1))
            .padding(.horizontal, 12)

            // Hints
            HStack(spacing: 8) {
                ForEach(["Scroll or +/− to zoom", "·", "Drag to pan", "·", "Double-click or 0 to reset", "·", "Esc to close"], id: \.self) { hint in
                    Text(hint)
                        .font(.system(size: 10.5, design: hint == "·" ? .default : .monospaced))
                        .foregroundColor(.text3)
                }
            }
            .padding(.vertical, 12)
        }
        .background(Color.bg1)
        .frame(width: 800, height: 660)
    }
}

