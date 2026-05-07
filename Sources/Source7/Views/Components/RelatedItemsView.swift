import SwiftUI

struct RelatedItemsView: View {
    let product: Product
    @EnvironmentObject var state: AppState
    @State private var viewMode: RelatedViewMode = .list

    enum RelatedViewMode { case list, tree }

    private var r: Relationships { product.relationships }
    private var rows: [RelatedRow] { r.allRows }

    private var accentColor: Color {
        r.hasAD ? .adLine : r.hasGroup ? .grpLine : .line
    }
    private var accentBg: Color {
        r.hasAD ? .adBg : r.hasGroup ? .grpBg : .clear
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Card header
            HStack(spacing: 8) {
                Image(systemName: "link")
                    .font(.system(size: 11))
                    .foregroundColor(.text2)
                Text("RELATED ITEMS")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.8)
                    .foregroundColor(.text2)
                if r.hasAny {
                    Text("· \(rows.count) total")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.text3)
                }

                Spacer()

                if r.hasGroup {
                    Pill(text: "GROUP", kind: .grp)
                }
                if r.hasAD {
                    Pill(text: "AD", kind: .ad)
                }
                if r.hasComponents {
                    Pill(text: "COMP", kind: .comp)
                }
                if !r.hasAny {
                    Text("None")
                        .font(.system(size: 11))
                        .foregroundColor(.text3)
                } else {
                    // List/Tree toggle
                    HStack(spacing: 0) {
                        SegButton(label: "List", isActive: viewMode == .list) {
                            viewMode = .list
                        }
                        SegButton(label: "Tree", isActive: viewMode == .tree) {
                            viewMode = .tree
                        }
                    }
                    .background(Color.bg0)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.line, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)

            // Body
            if !r.hasAny {
                Text("No related groups, components, or auto-deliveries on this item.")
                    .font(.system(size: 12))
                    .foregroundColor(.text2)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 14)
            } else if viewMode == .list {
                RelatedListBody(rows: rows, product: product)
            } else {
                RelatedTreeBody(product: product)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            r.hasAny
            ? LinearGradient(
                colors: [accentBg, Color.bg1],
                startPoint: .top,
                endPoint: .bottom
            )
            : LinearGradient(colors: [Color.bg1], startPoint: .top, endPoint: .bottom)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(r.hasAny ? accentColor : Color.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Segmented button

struct SegButton: View {
    let label: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 10.5, weight: .medium))
                .foregroundColor(isActive ? .text0 : .text2)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(isActive ? Color.bg3 : Color.clear)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - List body

struct RelatedListBody: View {
    let rows: [RelatedRow]
    let product: Product
    @EnvironmentObject var state: AppState
    @State private var copiedRow: String? = nil

    var body: some View {
        VStack(spacing: 3) {
            ForEach(rows) { row in
                RelatedRowView(
                    row: row,
                    knownTitle: state.products[row.id]?.shortDesc,
                    onLoad: { state.loadItem(row.id) }
                )
            }

            // Footer
            HStack {
                Spacer()
                CopyButton(
                    label: "Copy all \(rows.count) IDs",
                    value: rows.map(\.id).joined(separator: "\n")
                )
            }
            .padding(.top, 6)
            .padding(.bottom, 2)
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
    }
}

struct RelatedRowView: View {
    let row: RelatedRow
    let knownTitle: String?
    let onLoad: () -> Void
    @State private var isHovered = false

    private var pillKind: PillStyle.Kind {
        switch row.kind {
        case .group: return .grp
        case .autoDelivery: return .ad
        case .component: return .comp
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            // Kind pill (override to sky blue as in design)
            Text(row.kind.label)
                .font(.system(size: 9.5, weight: .semibold, design: .monospaced))
                .foregroundColor(Color(hex: "#38bdf8"))
                .padding(.horizontal, 6)
                .padding(.vertical, 1)
                .background(Color(hex: "#38bdf8").opacity(0.043))
                .overlay(Capsule().stroke(Color(hex: "#38bdf8"), lineWidth: 1))
                .clipShape(Capsule())
                .frame(width: 50, alignment: .leading)

            Text(row.id)
                .font(.system(size: 11.5, weight: .semibold, design: .monospaced))
                .foregroundColor(.accent)
                .frame(width: 78, alignment: .leading)

            if let title = knownTitle {
                Text(title)
                    .font(.system(size: 11.5))
                    .foregroundColor(.text1)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("not loaded")
                    .font(.system(size: 11.5))
                    .foregroundColor(.text3)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                copyToClipboard(row.id)
            } label: {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 11))
                    .foregroundColor(.text2)
            }
            .buttonStyle(.plain)
            .frame(width: 22, height: 22)
            .opacity(isHovered ? 1 : 0.5)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(isHovered ? Color.white.opacity(0.06) : Color.white.opacity(0.025))
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.line, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .contentShape(Rectangle())
        .onTapGesture { onLoad() }
        .onHover { isHovered = $0 }
        .contextMenu {
            Button("Copy \(row.id)") { copyToClipboard(row.id) }
            Button("Load \(row.id)") { onLoad() }
        }
        .help("Click to load · right-click to copy ID")
    }
}

// MARK: - Tree body

struct RelatedTreeBody: View {
    let product: Product
    @EnvironmentObject var state: AppState

    private var r: Relationships { product.relationships }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let group = r.group {
                    TreeBranch(
                        parentLabel: "GROUP",
                        parentId: group,
                        pillKind: .grp,
                        children: r.groupItems,
                        childKind: .group,
                        selfId: product.id
                    )
                }
                if let ad = r.autoDelivery {
                    TreeBranch(
                        parentLabel: "AUTO-DELIVERY",
                        parentId: ad,
                        pillKind: .ad,
                        children: r.adItems,
                        childKind: .autoDelivery,
                        selfId: product.id
                    )
                }
                if !r.components.isEmpty {
                    TreeBranch(
                        parentLabel: "COMPONENTS",
                        parentId: "linked to \(product.id)",
                        pillKind: .comp,
                        children: r.components,
                        childKind: .component,
                        selfId: product.id
                    )
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
    }
}

struct TreeBranch: View {
    let parentLabel: String
    let parentId: String
    let pillKind: PillStyle.Kind
    let children: [String]
    let childKind: RelatedRow.RelatedKind
    let selfId: String
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Parent node
            HStack(spacing: 8) {
                Pill(text: parentLabel, kind: pillKind)
                Text(parentId)
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundColor(.text0)
            }
            .padding(.vertical, 4)

            // Children indented
            VStack(alignment: .leading, spacing: 3) {
                ForEach(children, id: \.self) { childId in
                    let isSelf = childId == selfId
                    let knownTitle = state.products[childId]?.shortDesc

                    HStack(spacing: 8) {
                        Pill(text: childKind.label, kind: pillKind, size: 9)

                        Text(childId)
                            .font(.system(size: 11.5, weight: isSelf ? .bold : .semibold, design: .monospaced))
                            .foregroundColor(isSelf ? .text0 : .accent)

                        if isSelf {
                            Pill(text: "YOU ARE HERE", kind: .info, size: 9)
                        }

                        if let title = knownTitle, !isSelf {
                            Text(title)
                                .font(.system(size: 11))
                                .foregroundColor(.text2)
                                .lineLimit(1)
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(isSelf ? Color.s7InfoBg : Color.white.opacity(0.02))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(isSelf ? Color.s7Info.opacity(0.34) : Color.line, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !isSelf { state.loadItem(childId) }
                    }
                    .contextMenu {
                        Button("Copy \(childId)") { copyToClipboard(childId) }
                        if !isSelf { Button("Load \(childId)") { state.loadItem(childId) } }
                    }
                }
            }
            .padding(.leading, 14)
            .overlay(
                Rectangle()
                    .frame(width: 1.5)
                    .foregroundColor(Color.line2)
                    .padding(.leading, 7),
                alignment: .leading
            )
        }
    }
}
