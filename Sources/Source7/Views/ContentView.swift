import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable {
    case search    = "search"
    case history   = "history"
    case shotList  = "shotlist"
    case info      = "info"
    case airtable  = "airtable"
    case compare   = "compare"
    case settings  = "settings"

    var id: String { rawValue }
    var label: String {
        switch self {
        case .search:   return "Search"
        case .history:  return "History"
        case .shotList: return "Shot List"
        case .info:     return "Additional Info"
        case .airtable: return "Airtable"
        case .compare:  return "Compare"
        case .settings: return "Settings"
        }
    }
    var systemImage: String {
        switch self {
        case .search:   return "magnifyingglass"
        case .history:  return "clock.arrow.circlepath"
        case .shotList: return "list.bullet"
        case .info:     return "tablecells"
        case .airtable: return "square.grid.3x3"
        case .compare:  return "rectangle.split.2x1"
        case .settings: return "gearshape"
        }
    }
    var isMainNav: Bool { self == .search || self == .history }
}

class AppState: ObservableObject {
    @Published var selectedSidebar: SidebarItem = .search
    @Published var productId: String = "A729200"
    @Published var query: String = "A729200"
    @Published var products: [String: Product] = sampleProducts

    var currentProduct: Product {
        products[productId] ?? sampleProducts["A729200"]!
    }

    func loadItem(_ id: String) {
        if let p = products[id] {
            productId = p.id
            query = p.id
            selectedSidebar = .search
        }
    }

    func search() {
        let q = query.trimmingCharacters(in: .whitespaces).uppercased()
        if let p = products[q] {
            productId = p.id
            selectedSidebar = .search
        } else if let p = products[query.trimmingCharacters(in: .whitespaces)] {
            productId = p.id
            selectedSidebar = .search
        } else {
            productId = "A729200"
            query = "A729200"
            selectedSidebar = .search
        }
    }
}

struct ContentView: View {
    @StateObject private var state = AppState()

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .environmentObject(state)
                .navigationSplitViewColumnWidth(min: 180, ideal: 200, max: 220)

        } detail: {
            MainContentView()
                .environmentObject(state)
        }
        .background(Color.bg0)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Sidebar

struct SidebarView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Brand
            HStack(spacing: 1) {
                Text("Source")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.text0)
                Text("7")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.accent)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 18)
            .padding(.top, 4)

            // Main nav
            ForEach(SidebarItem.allCases.filter(\.isMainNav)) { item in
                NavButton(item: item)
            }

            // Tools section
            Text("TOOLS")
                .font(.system(size: 10, weight: .bold))
                .tracking(0.8)
                .foregroundColor(.text3)
                .padding(.horizontal, 8)
                .padding(.top, 14)
                .padding(.bottom, 6)

            ForEach(SidebarItem.allCases.filter { !$0.isMainNav }) { item in
                NavButton(item: item)
            }

            Spacer()

            // Footer connections
            SidebarFooter()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.bg0)
        .overlay(
            Rectangle()
                .frame(width: 1)
                .foregroundColor(Color.line),
            alignment: .trailing
        )
    }
}

struct NavButton: View {
    @EnvironmentObject var state: AppState
    let item: SidebarItem

    var isActive: Bool { state.selectedSidebar == item }

    var body: some View {
        Button {
            state.selectedSidebar = item
        } label: {
            HStack(spacing: 9) {
                Image(systemName: item.systemImage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isActive ? Color(hex: "#001823") : .text2)
                    .frame(width: 16)
                Text(item.label)
                    .font(.system(size: 13, weight: isActive ? .semibold : .regular))
                    .foregroundColor(isActive ? Color(hex: "#001823") : .text1)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(isActive ? Color.accent : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 7))
        }
        .buttonStyle(.plain)
    }
}

struct SidebarFooter: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider().background(Color.line)

            HStack(spacing: 7) {
                Circle()
                    .fill(Color.s7Err)
                    .frame(width: 7, height: 7)
                Text("SPT (HSN)")
                    .font(.system(size: 11))
                    .foregroundColor(.text2)
            }
            Text("Sign in to SPT")
                .font(.system(size: 11))
                .foregroundColor(.accent)

            HStack(spacing: 7) {
                Circle()
                    .fill(Color.s7Ok)
                    .frame(width: 7, height: 7)
                    .shadow(color: Color.s7Ok.opacity(0.6), radius: 3)
                Text("Source History (QVC)")
                    .font(.system(size: 11))
                    .foregroundColor(.text2)
            }
            Text("Sign out of Source History")
                .font(.system(size: 11))
                .foregroundColor(.accent)

            Text("v1.0")
                .font(.system(size: 10))
                .foregroundColor(.text3)
        }
    }
}

// MARK: - Main content area

struct MainContentView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView()
            Divider().background(Color.line)

            Group {
                switch state.selectedSidebar {
                case .search:
                    ProductDetailView(product: state.currentProduct)
                        .id(state.productId)
                case .history:
                    HistoryView()
                case .shotList:
                    ShotListView(product: state.currentProduct)
                case .info:
                    AdditionalInfoView(product: state.currentProduct)
                case .airtable:
                    AirtableView(product: state.currentProduct)
                case .compare:
                    CompareView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.bg0)
    }
}

// MARK: - Search bar

struct SearchBarView: View {
    @EnvironmentObject var state: AppState
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 13))
                    .foregroundColor(.text2)
                    .padding(.leading, 10)
                    .padding(.trailing, 8)

                TextField("Item number — A729200, M142630, 922303…", text: $state.query)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(.text0)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .onSubmit { state.search() }

                if !state.query.isEmpty {
                    Button {
                        state.query = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.text3)
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 8)
                }
            }
            .frame(height: 32)
            .background(Color.bg2)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(isFocused ? Color.accent : Color.line, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 7))

            Button {
                state.search()
            } label: {
                HStack(spacing: 6) {
                    Text("Search")
                        .font(.system(size: 13, weight: .medium))
                    Text("⌘↵")
                        .font(.system(size: 11, design: .monospaced))
                        .opacity(0.8)
                }
                .foregroundColor(Color(hex: "#001823"))
                .padding(.horizontal, 14)
                .frame(height: 32)
                .background(Color.accent)
                .clipShape(RoundedRectangle(cornerRadius: 7))
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.return, modifiers: .command)

            Button {
                // toggle dark mode (visual only)
            } label: {
                Image(systemName: "moon")
                    .font(.system(size: 15))
                    .foregroundColor(.text1)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)

            Button { } label: {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 15))
                    .foregroundColor(.text1)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color.bg0)
    }
}

// MARK: - Settings placeholder

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Settings")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.text0)

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Theme, accounts, integrations…")
                            .font(.system(size: 12))
                            .foregroundColor(.text2)
                            .padding(14)
                        Spacer()
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
