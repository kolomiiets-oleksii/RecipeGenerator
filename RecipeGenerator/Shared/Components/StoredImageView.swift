import SwiftUI

/// Draws an image from encoded data, filling its frame.
///
/// Decoding happens here, so it only re-runs when `data` changes rather than
/// on every parent update.
struct StoredImageView: View {
    let data: Data

    var body: some View {
        if let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Rectangle()
                .fill(.fill.quaternary)
        }
    }
}
