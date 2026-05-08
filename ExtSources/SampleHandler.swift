import ReplayKit

class SampleHandler: RPBroadcastSampleHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // เริ่มระบบแปลภาษา
        SpeechTranslator.shared.startTranslating()
    }
    
    override func broadcastPaused() { }
    
    override func broadcastResumed() { }
    
    override func broadcastFinished() {
        // หยุดทำงานเมื่อกดยกเลิกอัดหน้าจอ
        SpeechTranslator.shared.stopTranslating()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case .audioApp:
            // นี่คือจุดที่เราได้ยินเสียง System Audio (เกม, Youtube)
            SpeechTranslator.shared.appendAudioBuffer(sampleBuffer)
        default:
            break
        }
    }
}
