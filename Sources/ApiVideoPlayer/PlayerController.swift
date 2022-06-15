import Foundation
import AVFoundation
import AVKit
import ApiVideoPlayerAnalytics

public class PlayerController{
    public var avPlayer: AVPlayer!
    public var events: PlayerEvents?
    private var analytics: PlayerAnalytics?
    private var option : Options?
    public var viewController: UIViewController? {
        didSet{
            print("view controller set")
        }
    }
    public var isPlaying = false {
        didSet{
            
        }
    }
    
    init(avPlayer: AVPlayer,_ events: PlayerEvents? = nil,_ vc: UIViewController? = nil, player: Player) {
        self.avPlayer = avPlayer
        self.events = events
        self.viewController = vc
        do {
              option = try Options(
                mediaUrl: player.video.src, metadata: [],
                onSessionIdReceived: { (id) in
                  print("session ID : \(id)")
                })
            } catch {
              print("error with the url")
            }

        analytics = PlayerAnalytics(options: option!)
        NotificationCenter.default.addObserver(self, selector: #selector(self.donePlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    }
    
    @available(iOS 10.0, *)
    public func isVideoPlaying()-> Bool{
        return avPlayer.isVideoPlaying()
    }
    
    public func play(){
        avPlayer.play()
        isPlaying = true
        if(self.events?.didPlay != nil){
            self.events?.didPlay!()
        }
    }
    
    public func replay(){
        analytics?.seek(from: Float(CMTimeGetSeconds(avPlayer.currentTime())), to: Float(CMTimeGetSeconds(CMTime.zero))){ (result) in
            switch result {
            case .success(let data):
                print("player analytics seek : \(data)")
            case .failure(let error):
                print("player analytics seek : \(error)")
            }
        }
        avPlayer.seek(to: CMTime.zero)
        avPlayer.play()
        analytics?.resume(){(result) in
            switch result {
            case .success(let data):
                print("player analytics play : \(data)")
            case .failure(let error):
                print("player analytics play : \(error)")
            }
        }
        
        if(self.events?.didRePlay != nil){
            self.events?.didRePlay!()
        }
    }
    
    public func pause(){
        avPlayer.pause()
        isPlaying = false
        analytics?.pause(){(result) in
            switch result {
            case .success(let data):
                print("player analytics pause : \(data)")
            case .failure(let error):
                print("player analytics pause : \(error)")
            }
        }
        if(self.events?.didPause != nil){
            self.events?.didPause!()
        }
    }
    
    public func seek(time: Double){
        guard let currentTime = avPlayer?.currentTime() else { return }
        var currentTimeInSeconds =  CMTimeGetSeconds(currentTime).advanced(by: time)
        let seekTime = CMTime(value: CMTimeValue(currentTimeInSeconds), timescale: 1)
        avPlayer?.seek(to: seekTime)
        analytics?.seek(from: Float(CMTimeGetSeconds(currentTime)), to: Float(CMTimeGetSeconds(seekTime))){(result) in
            switch result {
            case .success(let data):
                print("player analytics seek : \(data)")
            case .failure(let error):
                print("player analytics seek : \(error)")
            }
        }
        if(self.events?.didSeekTime != nil){
            if currentTimeInSeconds < 0 {
                currentTimeInSeconds = 0.0
            }
            self.events?.didSeekTime!(currentTime.seconds, currentTimeInSeconds)
        }
    }
    
    public func mute(){
        avPlayer.isMuted = true
        if(self.events?.didMute != nil){
            self.events?.didMute!()
        }
    }
    
    public func unMute(){
        avPlayer.isMuted = false
        if(self.events?.didUnMute != nil){
            self.events?.didUnMute!()
        }
    }
    
    public func isMuted() -> Bool{
        return avPlayer.isMuted
    }
    
    public func setVolume(volume: Float){
        avPlayer.volume = volume
        if(self.events?.didSetVolume != nil){
            self.events?.didSetVolume!(volume)
        }
    }
    
    public func getDuration() -> CMTime{
        return avPlayer.currentItem!.asset.duration
    }
    
    public func getCurrentTime() -> CMTime{
        return avPlayer.currentTime()
    }
    
    @available(iOS 11.0, *)
    public func goFullScreen(){
        let playerViewController = AVPlayerViewController()
        playerViewController.player = avPlayer
        print("view controller \(self.viewController.debugDescription)")
        viewController?.present(playerViewController, animated: true) {
            self.avPlayer.play()
        }
    }
    
    @objc func donePlaying(sender: Notification) {
        analytics?.end(){(result)in
            switch result {
            case .success(let data):
                print("player analytics video ended : \(data)")
            case .failure(let error):
                print("player analytics video ended : \(error)")
            }
        }
        if(self.events?.didEnd != nil){
            self.events?.didEnd!()
        }
    }
}
