import 'package:flutter_webrtc/flutter_webrtc.dart' as webRTC;
import 'package:get/get.dart';
import 'package:startup_boilerplate/controllers/messenger/messenger_controller.dart';

class MessengerHelper {
  final MessengerController messengerController = Get.find<MessengerController>();
  Future<void> openUserMedia(isAudioCall) async {
    var stream = await webRTC.navigator.mediaDevices.getUserMedia({'video': isAudioCall ? false : true, 'audio': true});

    messengerController.localStream = stream;
    if (!isAudioCall) {
      messengerController.localRenderer.srcObject = stream;
      messengerController.isLocalFeedStreaming.value = true;
    } else {
      messengerController.isLocalFeedStreaming.value = false;
    }
  }

  Future<void> hangUp() async {
    List<webRTC.MediaStreamTrack> tracks = messengerController.localRenderer.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });

    if (messengerController.remoteStream != null) {
      messengerController.remoteStream!.getTracks().forEach((track) => track.stop());
    }

    messengerController.localStream!.dispose();
    messengerController.remoteStream?.dispose();
  }

  Future<void> switchCamera(userID) async {
    // webRTC.RTCPeerConnection? peerConnection;
    // Map<int, Map<String, dynamic>> allRoomMessageListMap = {for (var user in Get.find<MessengerController>().allRoomMessageList) user['userID']: user};
    // if (allRoomMessageListMap.containsKey(userID)) {
    //   peerConnection = allRoomMessageListMap[userID]!['peerConnection'];
    // }
    var videoTrack = messengerController.localStream?.getVideoTracks().first;

    webRTC.Helper.switchCamera(videoTrack!);
    // if (videoTrack != null) {
    //   var currentFacingMode = videoTrack.getSettings()['facingMode'];
    //   String newFacingMode = currentFacingMode == 'user' ? 'environment' : 'user';

    //   await videoTrack.stop();
    //   // Get a new video stream with the desired facing mode
      // var newStream = await webRTC.navigator.mediaDevices.getUserMedia({
      //   'video': {'facingMode': newFacingMode},
      //   'audio': true,
      // });

    //   var newVideoTrack = newStream.getVideoTracks().first;

    //   messengerController.localStream?.addTrack(newVideoTrack);
    //   peerConnection!.addTrack(newVideoTrack, newStream);

    //   messengerController.localRenderer.srcObject = newStream;

    //   messengerController.localStream = newStream;

    //   messengerController.isLocalFeedStreaming.value = true;
    // }
  }

  Future<void> toggleMuteAudio() async {
    var audioTrack = messengerController.localStream?.getAudioTracks().first;

    if (audioTrack != null) {
      audioTrack.enabled = !audioTrack.enabled;
    }
  }
}
