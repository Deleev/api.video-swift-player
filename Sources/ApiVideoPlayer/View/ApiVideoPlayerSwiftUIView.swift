import SwiftUI

@available(iOS 14, macOS 11.0, *)
public struct ApiVideoPlayerSwiftUIView: UIViewRepresentable {
  public typealias UIViewType = ApiVideoPlayerView

  let videoId: String
  let videoType: VideoType
  public var view: ApiVideoPlayerView

  public init(videoId: String, videoType: VideoType) {
    self.videoId = videoId
    self.videoType = videoType
    self.view = ApiVideoPlayerView(frame: .zero, videoId: videoId, videoType: videoType)
  }

  public func setViewController(vc: String) {
    print("setViewController \(vc)")
  }

  public func makeUIView(context _: Context) -> ApiVideoPlayerView {
    return self.view
  }

  public func updateUIView(_: UIViewType, context _: Context) {}

  public func play() {
    self.view.play()
  }

  public func pause() {
    self.view.pause()
  }
}

@available(iOS 14, macOS 11.0, *)
struct ApiVideoPlayerSwiftUIView_Previews: PreviewProvider {
  struct Test: View {
    var body: some View {
      ApiVideoPlayerSwiftUIView(videoId: "vi2G6Qr8ZVE67dWLNymk7qbc", videoType: .vod)
    }
  }

  static var previews: some View {
    Test()
  }
}
