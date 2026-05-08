import SwiftUI

struct AdditionalInfoView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("Additional Info")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.text0)
                    Text("— \(product.id)")
                        .font(.system(size: 18, weight: .semibold, design: .monospaced))
                        .foregroundColor(.text2)
                }
                .padding(.top, 4)
                .padding(.bottom, 14)

                // Future Scripts
                VStack(alignment: .leading, spacing: 0) {
                    CardHeader(title: "Future Scripts", trailing: AnyView(
                        Text("\(product.futureScripts.count) scheduled")
                            .font(.system(size: 11))
                            .foregroundColor(.text2)
                    ))
                    Divider().background(Color.line)

                    // Header
                    HStack(spacing: 0) {
                        Text("DATE").scriptHeaderCell(width: 90)
                        Text("HOUR").scriptHeaderCell(width: 60)
                        Text("SHOW").scriptHeaderCell(width: 70)
                        Text("TYPE").scriptHeaderCell()
                        Text("HOST").scriptHeaderCell(width: 80)
                        Text("GUEST").scriptHeaderCell(width: 60)
                        Text("APPEARANCE").scriptHeaderCell(width: 110)
                    }
                    .background(Color.bg2)

                    ForEach(product.futureScripts) { script in
                        Divider().background(Color.line)
                        HStack(spacing: 0) {
                            Text(script.date)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.text1)
                                .frame(width: 90, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 9)
                            Text(script.hour)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.text1)
                                .frame(width: 60, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 9)
                            Pill(text: script.show, kind: .info, size: 9.5)
                                .frame(width: 70, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 9)
                            Text(script.type)
                                .font(.system(size: 11.5))
                                .foregroundColor(.text2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 9)
                            Text(script.host ?? "—")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.text1)
                                .frame(width: 80, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 9)
                            Text(script.guest ?? "—")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.text1)
                                .frame(width: 60, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 9)
                            Text(script.appearance ?? "—")
                                .font(.system(size: 11.5))
                                .foregroundColor(.text2)
                                .frame(width: 110, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 9)
                        }
                    }
                }
                .cardStyle()

                // Color Matrix
                VStack(alignment: .leading, spacing: 0) {
                    CardHeader(title: "Color Matrix", trailing: AnyView(
                        CopyButton(
                            label: "Copy color codes",
                            value: product.swatches.map(\.code).joined(separator: "\n")
                        )
                    ))
                    Divider().background(Color.line)
                    HStack(spacing: 0) {
                        Text("CODE").scriptHeaderCell(width: 80)
                        Text("COLOR").scriptHeaderCell()
                        Text("ARTICLE ID").scriptHeaderCell(width: 120)
                        Text("OKQ (ON-HAND)").scriptHeaderCell(width: 140, trailing: true)
                    }
                    .background(Color.bg2)

                    ForEach(product.swatches) { sw in
                        Divider().background(Color.line)
                        HStack(spacing: 0) {
                            Text(sw.code)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.text1)
                                .frame(width: 80, alignment: .leading)
                                .padding(.horizontal, 12).padding(.vertical, 9)

                            HStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(sw.color)
                                    .frame(width: 14, height: 14)
                                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                Text(sw.name)
                                    .font(.system(size: 12))
                                    .foregroundColor(.text1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12).padding(.vertical, 9)

                            Text(articleId(product: product, sw: sw))
                                .font(.system(size: 11.5, design: .monospaced))
                                .foregroundColor(.text3)
                                .frame(width: 120, alignment: .leading)
                                .padding(.horizontal, 12).padding(.vertical, 9)

                            Text(sw.okq == 0 ? "0" : sw.okq.formatted())
                                .font(.system(size: 12, weight: sw.okq == 0 ? .bold : .regular, design: .monospaced))
                                .foregroundColor(sw.okq == 0 ? .s7Err : .text0)
                                .frame(width: 140, alignment: .trailing)
                                .padding(.horizontal, 12).padding(.vertical, 9)
                        }
                    }
                }
                .cardStyle()

                // Pricing & Memos
                HStack(alignment: .top, spacing: 10) {
                    // Pricing
                    VStack(alignment: .leading, spacing: 0) {
                        CardHeader(title: "Pricing")
                        Divider().background(Color.line)
                        Group {
                            InfoRow(label: "Current", value: "$\(String(format: "%.2f", product.price))", mono: true)
                            Divider().background(Color.line)
                            InfoRow(label: "Easy Pay", value: product.easyPay)
                            Divider().background(Color.line)
                            InfoRow(label: "Lowest 12mo", value: "$\(String(format: "%.2f", product.price * 0.85))", mono: true)
                            Divider().background(Color.line)
                            InfoRow(label: "Future", value: "$\(String(format: "%.2f", product.price))", mono: true)
                        }
                    }
                    .cardStyle()
                    .frame(maxWidth: .infinity)

                    // Memos
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            CardHeader(title: "Memos")
                            Pill(text: "2 items", kind: .info, size: 9.5)
                                .padding(.trailing, 14)
                        }
                        Divider().background(Color.line)
                        VStack(alignment: .leading, spacing: 0) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("PLANNING · 04/22/2026")
                                    .font(.system(size: 11))
                                    .foregroundColor(.text3)
                                Text("Reorder window opens 05/15. Confirm color counts with vendor.")
                                    .font(.system(size: 12))
                                    .foregroundColor(.text1)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)

                            Divider().background(Color.line)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("PRICING · 04/30/2026")
                                    .font(.system(size: 11))
                                    .foregroundColor(.text3)
                                Text("Approved Easy Pay terms locked through Q3.")
                                    .font(.system(size: 12))
                                    .foregroundColor(.text1)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                        }
                    }
                    .cardStyle()
                    .frame(maxWidth: .infinity)
                }

                Spacer(minLength: 40)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background(Color.bg0)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var mono: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12.5))
                .foregroundColor(.text2)
            Spacer()
            Text(value)
                .font(mono ? .system(size: 12.5, design: .monospaced) : .system(size: 12.5))
                .foregroundColor(.text0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
    }
}

private func articleId(product: Product, sw: Swatch) -> String {
    let base = Int(product.id.filter(\.isNumber)) ?? 1234567
    let offset = Int(sw.code.unicodeScalars.first?.value ?? 0)
    let shifted = (base + offset) % 9000000 + 1000000
    return "A\(shifted)"
}

extension Text {
    @ViewBuilder
    func scriptHeaderCell(width: CGFloat? = nil, trailing: Bool = false) -> some View {
        let styled = self
            .font(.system(size: 11, weight: .semibold))
            .tracking(0.4)
            .foregroundColor(.text2)
            .textCase(.uppercase)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        let alignment: Alignment = trailing ? .trailing : .leading
        if let w = width {
            styled.frame(width: w, alignment: alignment)
        } else {
            styled.frame(maxWidth: .infinity, alignment: alignment)
        }
    }
}
