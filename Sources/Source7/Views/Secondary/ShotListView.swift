import SwiftUI

struct ShotListView: View {
    let product: Product

    private var slotItems: [(name: String, status: String, date: String?)] {
        product.slots.map { s in
            (
                name: "\(product.id)_\(s.id)",
                status: s.status == .used ? "ok" : "missing",
                date: s.status == .used ? s.date : nil
            )
        }
    }

    private var swatch102Items: [(name: String, status: String, date: String?)] {
        product.swatches.map { s in
            (
                name: "\(product.id)_\(s.code)_102",
                status: s.s102?.ok == true ? "ok" : "missing",
                date: s.s102?.date
            )
        }
    }

    private var allMissing: [String] {
        (slotItems + swatch102Items).filter { $0.status != "ok" }.map(\.name)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("Shot List")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.text0)
                        Text("— \(product.id)")
                            .font(.system(size: 18, weight: .semibold, design: .monospaced))
                            .foregroundColor(.text2)
                    }
                    Text("\(slotItems.count + swatch102Items.count) filenames")
                        .font(.system(size: 13))
                        .foregroundColor(.text2)
                    Spacer()
                    if !allMissing.isEmpty {
                        CopyButton(
                            label: "Copy missing only",
                            value: allMissing.joined(separator: "\n")
                        )
                    }
                    CopyButton(
                        label: "Copy all",
                        value: (slotItems + swatch102Items).map(\.name).joined(separator: "\n")
                    )
                }
                .padding(.top, 4)
                .padding(.bottom, 14)

                HStack(alignment: .top, spacing: 10) {
                    // Product detail slots
                    VStack(alignment: .leading, spacing: 0) {
                        CardHeader(title: "Product Detail Images", trailing: AnyView(
                            Text("\(slotItems.count) slots")
                                .font(.system(size: 11))
                                .foregroundColor(.text2)
                        ))
                        ForEach(slotItems, id: \.name) { item in
                            ShotListRow(
                                name: item.name,
                                status: item.status,
                                date: item.date,
                                icon: "photo"
                            )
                        }
                    }
                    .cardStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Swatch 102
                    VStack(alignment: .leading, spacing: 0) {
                        CardHeader(title: "Swatch 102 Images", trailing: AnyView(
                            Text("\(swatch102Items.count) colors")
                                .font(.system(size: 11))
                                .foregroundColor(.text2)
                        ))
                        ForEach(swatch102Items, id: \.name) { item in
                            ShotListRow(
                                name: item.name,
                                status: item.status,
                                date: item.date,
                                icon: "paintpalette"
                            )
                        }
                    }
                    .cardStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background(Color.bg0)
    }
}

struct ShotListRow: View {
    let name: String
    let status: String
    let date: String?
    let icon: String
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(.text3)
            Text(name)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.text0)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            if status == "ok" {
                Pill(text: date ?? "ok", kind: .ok, size: 9.5)
            } else {
                Pill(text: "Missing", kind: status == "missing" ? .warn : .err, size: 9.5)
            }
            Button {
                copyToClipboard(name)
            } label: {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 10))
                    .foregroundColor(.text2)
                    .opacity(isHovered ? 1 : 0.5)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(isHovered ? Color.white.opacity(0.025) : Color.clear)
        .overlay(Divider().background(Color.line).frame(height: 1), alignment: .top)
        .onHover { isHovered = $0 }
    }
}
