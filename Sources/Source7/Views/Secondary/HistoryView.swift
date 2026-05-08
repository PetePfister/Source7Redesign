import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("History")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.text0)
                    Text("\(sampleHistory.count) items")
                        .font(.system(size: 13))
                        .foregroundColor(.text2)
                    Spacer()
                    Button("Clear History") { }
                        .font(.system(size: 11))
                        .foregroundColor(.text1)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.bg3)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.line2, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .buttonStyle(.plain)
                }
                .padding(.top, 4)
                .padding(.bottom, 14)

                VStack(spacing: 0) {
                    // Table header
                    HStack(spacing: 0) {
                        Text("PRODUCT").historyHeaderCell(width: 110)
                        Text("NAME").historyHeaderCell()
                        Text("CHECKED").historyHeaderCell(width: 160)
                        Text("SLOTS").historyHeaderCell(width: 130, center: true)
                        Text("SWATCHES").historyHeaderCell(width: 110, center: true)
                    }
                    .background(Color.bg2)

                    ForEach(sampleHistory) { item in
                        Divider().background(Color.line)
                        HistoryRow(item: item)
                            .onTapGesture { state.loadItem(item.id) }
                    }
                }
                .cardStyle()
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background(Color.bg0)
    }
}

struct HistoryRow: View {
    let item: HistoryItem
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 0) {
            Text(item.id)
                .font(.system(size: 12.5, design: .monospaced))
                .foregroundColor(.accent)
                .frame(width: 110, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)

            Text(item.name)
                .font(.system(size: 12.5))
                .foregroundColor(.text1)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)

            Text(item.checked)
                .font(.system(size: 12.5, design: .monospaced))
                .foregroundColor(.text2)
                .frame(width: 160, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)

            // Slots pills
            HStack(spacing: 4) {
                CountPill(count: item.images.used, kind: .ok)
                CountPill(count: item.images.avail, kind: .warn)
                CountPill(count: item.images.blocked, kind: .err)
            }
            .frame(width: 130)
            .padding(.vertical, 9)

            // Swatches pills
            HStack(spacing: 4) {
                CountPill(count: item.swatches.ready, kind: .ok)
                CountPill(count: item.swatches.missing, kind: .warn)
            }
            .frame(width: 110)
            .padding(.vertical, 9)
        }
        .background(isHovered ? Color.white.opacity(0.02) : Color.clear)
        .contentShape(Rectangle())
        .onHover { isHovered = $0 }
        .cursor(.pointingHand)
    }
}

struct CountPill: View {
    let count: Int
    let kind: PillStyle.Kind
    var body: some View {
        Text("\(count)")
            .font(.system(size: 10.5, weight: .semibold, design: .monospaced))
            .foregroundColor(kind.fg)
            .padding(.horizontal, 6)
            .padding(.vertical, 1)
            .background(kind.bg)
            .overlay(Capsule().stroke(kind.border, lineWidth: 1))
            .clipShape(Capsule())
    }
}

extension Text {
    @ViewBuilder
    func historyHeaderCell(width: CGFloat? = nil, center: Bool = false) -> some View {
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
