# Source7 — macOS SwiftUI App

Product image management tool for QVC/HSN. Dark-themed macOS app implemented from the Claude Design prototype.

## Opening in Xcode

1. Open Xcode
2. **File → Open…** → select the `Source7/` folder (the one containing `Package.swift`)
3. Xcode will recognize it as a Swift Package and open it
4. Select the **Source7** scheme and a macOS destination
5. Press **⌘R** to build and run

> Requires macOS 14 (Sonoma) and Xcode 15+.

## Structure

```
Source7/
├── Package.swift
└── Sources/Source7/
    ├── Source7App.swift          ← App entry point
    ├── Models/
    │   ├── Product.swift         ← Data models (Product, Swatch, ImageSlot, etc.)
    │   └── SampleData.swift      ← Sample QVC/HSN products (A729200, A556954, 922303)
    ├── Theme/
    │   └── AppTheme.swift        ← Colors, fonts, shared components (Pill, CopyButton, etc.)
    └── Views/
        ├── ContentView.swift     ← NavigationSplitView layout + SearchBar + Sidebar
        ├── ProductDetailView.swift ← Main search/product view
        ├── Components/
        │   ├── RelatedItemsView.swift  ← List/Tree toggle for GROUP/AD/COMP relationships
        │   └── ImageSlotsGrid.swift    ← Scene7 image slots + swatch rows (101/102)
        └── Secondary/
            ├── HistoryView.swift       ← Lookup history table
            ├── ShotListView.swift      ← Shot list with copy buttons
            ├── AdditionalInfoView.swift ← Future scripts, color matrix, pricing, memos
            ├── AirtableView.swift      ← Pull list table
            └── CompareView.swift       ← Side-by-side product comparison
```

## Features

- **Search** — type any item number (A729200, A556954, 922303) and press ⌘↵
- **Related Items** — GROUP, AUTO-DELIVERY, and COMPONENT badges with List/Tree toggle
- **Scene7 Image Slots** — color-coded status (used/available/unavailable), click to zoom
- **Swatches** — 101 color chip + 102 product image side-by-side per color, with OKQ
- **Color Matrix** — OKQ summed per swatch, with Article IDs
- **Airtable Pull Status** — photographer, shot/retouched status per color
- **Shot List** — missing filenames with one-click copy
- **Zoomable Image Modal** — drag to pan, zoom controls, copy URL
- **History** — checked items with slot/swatch status counts
- **Compare** — side-by-side diff of two products (differences highlighted)

## Connecting Real Data

Replace `SampleData.swift` with API calls to your Scene7 / QVC / HSN backends.
The `AppState` class in `ContentView.swift` owns the product dictionary — inject
real products there and the rest of the views update automatically.
