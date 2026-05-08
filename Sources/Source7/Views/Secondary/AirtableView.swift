import SwiftUI

struct AirtableView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("Pull List")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.text0)
                        Text("— \(product.id)")
                            .font(.system(size: 18, weight: .semibold, design: .monospaced))
                            .foregroundColor(.text2)
                    }
                    Text("\(product.pullList.count) rows")
                        .font(.system(size: 13))
                        .foregroundColor(.text2)
                    Pill(
                        text: product.source == .q ? "QVC" : "HSN",
                        kind: product.source == .q ? .sourceQ : .sourceH
                    )
                    Spacer()
                }
                .padding(.top, 4)
                .padding(.bottom, 14)

                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 0) {
                        Text("COLOR").airtableHeader()
                        Text("PHOTOGRAPHER").airtableHeader()
                        Text("OUTPUT").airtableHeader(width: 80, center: true)
                        Text("SHOT").airtableHeader(width: 70, center: true)
                        Text("DATE SHOT").airtableHeader(width: 160)
                        Text("RETOUCHED").airtableHeader(width: 90, center: true)
                        Text("TSV").airtableHeader(width: 60, center: true)
                    }
                    .background(Color.bg2)

                    ForEach(product.pullList) { row in
                        Divider().background(Color.line)
                        AirtableRow(row: row)
                    }
                }
                .cardStyle()

                Spacer(minLength: 40)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background(Color.bg0)
    }
}

struct AirtableRow: View {
    let row: PullRow
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 0) {
            Text(row.color)
                .font(.system(size: 12))
                .foregroundColor(.text1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12).padding(.vertical, 9)

            Text(row.photographer)
                .font(.system(size: 11.5))
                .foregroundColor(.text2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12).padding(.vertical, 9)

            Text("\(row.output)")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.text1)
                .frame(width: 80, alignment: .center)
                .padding(.vertical, 9)

            Group {
                if row.shot {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.s7Ok)
                } else {
                    Text("—").foregroundColor(.text3)
                }
            }
            .frame(width: 70, alignment: .center)
            .padding(.vertical, 9)

            Text(row.dateShot ?? "—")
                .font(.system(size: 11.5, design: .monospaced))
                .foregroundColor(.text2)
                .frame(width: 160, alignment: .leading)
                .padding(.horizontal, 12).padding(.vertical, 9)

            Group {
                if row.retouched {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.s7Ok)
                } else {
                    Text("—").foregroundColor(.text3)
                }
            }
            .frame(width: 90, alignment: .center)
            .padding(.vertical, 9)

            Text("—")
                .foregroundColor(.text3)
                .frame(width: 60, alignment: .center)
                .padding(.vertical, 9)
        }
        .background(isHovered ? Color.white.opacity(0.02) : Color.clear)
        .onHover { isHovered = $0 }
    }
}

extension Text {
    @ViewBuilder
    func airtableHeader(width: CGFloat? = nil, center: Bool = false) -> some View {
        let styled = self
            .font(.system(size: 11, weight: .semibold))
            .tracking(0.4)
            .foregroundColor(.text2)
            .textCase(.uppercase)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
        let alignment: Alignment = center ? .center : .leading
        if let w = width {
            styled.frame(width: w, alignment: alignment)
        } else {
            styled.frame(maxWidth: .infinity, alignment: alignment)
        }
    }
}
