import Foundation

/// ISO/IEC 14496-12 5th 8.8.7.2
struct MP4TrackFragmentHeaderBox: MP4FullBox {
    static let version: UInt8 = 0
    enum Field: UInt32 {
        case baseDataOffset = 0x000001
        case sampleDescriptionIndex = 0x000002
        case defaultSampleDuration = 0x000008
        case defaultSampleSize = 0x000010
        case defaultSampleFlags = 0x000020
        case durationIsEmpty = 0x010000
        case defaultBaseIsMoof = 0x020000
    }
    // MARK: MP4FullBox
    var size: UInt32 = 0
    let type: String = "tfhd"
    var offset: UInt64 = 0
    var children: [MP4BoxConvertible] = []
    let version: UInt8 = Self.version
    var flags: UInt32 = 0
    // MARK: MP4TrackFragmentHeaderBox
    var trackId: UInt32 = 0
    var baseDataOffset: UInt64 = 0
    var sampleDescriptionIndex: UInt32 = 0
    var defaultSampleDuration: UInt32 = 0
    var defaultSampleSize: UInt32 = 0
    var defaultSampleFlags: UInt32 = 0

    private func contains(_ value: Field) -> Bool {
        return (flags & value.rawValue) != 0
    }
}

extension MP4TrackFragmentHeaderBox: DataConvertible {
    var data: Data {
        get {
            Data()
        }
        set {
            do {
                let buffer = ByteArray(data: newValue)
                size = try buffer.readUInt32()
                _ = try buffer.readUTF8Bytes(4)
                buffer.position += 1
                flags = UInt32(try buffer.readUInt24())
                trackId = try buffer.readUInt32()
                if contains(.baseDataOffset) {
                    baseDataOffset = try buffer.readUInt64()
                }
                if contains(.sampleDescriptionIndex) {
                    sampleDescriptionIndex = try buffer.readUInt32()
                }
                if contains(.defaultSampleDuration) {
                    defaultSampleDuration = try buffer.readUInt32()
                }
                if contains(.defaultSampleSize) {
                    defaultSampleSize = try buffer.readUInt32()
                }
                if contains(.defaultSampleFlags) {
                    defaultSampleFlags = try buffer.readUInt32()
                }
            } catch {
                logger.error(error)
            }
        }
    }
}

extension MP4Box.Names {
    static let tfhd = MP4Box.Name<MP4TrackFragmentHeaderBox>(rawValue: "tfhd")
}
