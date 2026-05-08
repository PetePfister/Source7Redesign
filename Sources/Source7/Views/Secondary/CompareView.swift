import SwiftUI

struct CompareView: View {
    @EnvironmentObject var state: AppState
    @State private var aId: String = "A729200"
    @State private var bId: String = "A556954"

    private var productList: [Product] { Array(sampleProducts.values).sorted { $0.id < $1.id } }

    private var productA: Product { sampleProducts[aId] ?? sampleProducts["A729200"]! }
    private var productB: Product { sampleProducts[bId] ?? sampleProducts["A556954"]! }

    private struct CompareRow {
        let label: String
        let a: String
        let b: String
        var isDiff: Bool { a != b }
    }

    private var rows: [CompareRow] {
        let ssA = productA.slotStats, ssB = productB.slotStats
        let wsA = productA.swatchStats, wsB = productB.swatchStats
        return [
            CompareRow(label: "Source",         a: productA.source == .q ? "QVC" : "HSN",        b: productB.source == .q ? "QVC" : "HSN"),
            CompareRow(label: "Title",          a: productA.title,                                b: productB.title),
            CompareRow(label: "Price",          a: "$\(String(format: "%.2f", productA.price))",  b: "$\(String(format: "%.2f", productB.price))"),
            CompareRow(label: "Slots used",     a: "\(ssA.used)/\(ssA.total)",                   b: "\(ssB.used)/\(ssB.total)"),
            CompareRow(label: "Slots blocked",  a: "\(ssA.unavail)",                              b: "\(ssB.unavail)"),
            CompareRow(label: "Swatches ready", a: "\(wsA.ready)/\(wsA.total)",                  b: "\(wsB.ready)/\(wsB.total)"),
            CompareRow(label: "Group",          a: productA.relationships.group ?? "—",           b: productB.relationships.group ?? "—"),
            CompareRow(label: "Auto-Delivery",  a: productA.relationships.autoDelivery ?? "—",   b: productB.relationships.autoDelivery ?? "—"),
            CompareRow(label: "Components",     a: productA.relationships.components.isEmpty ? "—" : productA.relationships.components.joined(separator: ", "),
                                                b: productB.relationships.components.isEmpty ? "—" : productB.relationships.components.joined(separator: ", ")),
            CompareRow(label: "Next Air",       a: "\(productA.nextAir.date) · \(productA.nextAir.show)", b: "\(productB.nextAir.date) · \(productB.nextAir.show)"),
            CompareRow(label: "Last Checked",   a: productA.lastChecked,                         b: productB.lastChecked),
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("Compare")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.text0)
                    Text("Side-by-side · differences highlighted")
                        .font(.system(size: 13))
                        .foregroundColor(.text2)
                    Spacer()
                }
                .padding(.top, 4)
                .padding(.bottom, 14)

                // Compare grid
                VStack(spacing: 0) {
                    // Header row with pickers
                    HStack(spacing: 0) {
                        Text("Item")
                            .font(.system(size: 11, weight: .semibold))
                            .tracking(0.4)
                            .foregroundColor(.text2)
                            .textCase(.uppercase)
                            .frame(width: 220, alignment: .leading)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 11)
                            .background(Color.bg2)

                        Rectangle().frame(width: 1).foregroundColor(Color.line)

                        // Picker A
                        Picker("", selection: $aId) {
                            ForEach(productList) { p in
                                Text("\(p.id) — \(String(p.title.prefix(40)))").tag(p.id)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.bg2)
                        .pickerStyle(.menu)

                        Rectangle().frame(width: 1).foregroundColor(Color.line)

                        // Picker B
                        Picker("", selection: $bId) {
                            ForEach(productList) { p in
                                Text("\(p.id) — \(String(p.title.prefix(40)))").tag(p.id)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.bg2)
                        .pickerStyle(.menu)
                    }

                    ForEach(rows, id: \.label) { row in
                        Divider().background(Color.line)
                        HStack(spacing: 0) {
                            Text(row.label)
                                .font(.system(size: 11, weight: .semibold))
                                .tracking(0.4)
                                .foregroundColor(.text2)
                                .textCase(.uppercase)
                                .frame(width: 220, alignment: .leading)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 11)
                                .background(Color.bg2)

                            Rectangle().frame(width: 1).foregroundColor(Color.line)

                            Text(row.a)
                                .font(.system(size: 12.5))
                                .foregroundColor(.text1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 11)
                                .background(row.isDiff ? Color(hex: "#f59e0b").opacity(0.08) : Color.clear)

                            Rectangle().frame(width: 1).foregroundColor(Color.line)

                            Text(row.b)
                                .font(.system(size: 12.5))
                                .foregroundColor(.text1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 11)
                                .background(row.isDiff ? Color(hex: "#f59e0b").opacity(0.08) : Color.clear)
                        }
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
