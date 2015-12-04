//
// Creates an EZAudioFile from an MPMediaItem representing a song coming from
// an iOS device's iPod library. Since an MPMediaItem's URL is always prefixed
// with an ipod:// path we must use the AVAssetExportSession to first export
// the song to a file path that the EZAudioFile can actually find in the app's bundle.
//
#include "EZAudioFile.h"