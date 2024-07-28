import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:startup_boilerplate/controllers/common/global_controller.dart';
import 'package:startup_boilerplate/controllers/common/sp_controller.dart';
import 'package:startup_boilerplate/controllers/messenger/messenger_controller.dart';
import 'package:startup_boilerplate/models/messenger/message_list_model.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';

class SocketController extends GetxController {
  @override
  void onInit() {
    socketInit();
    super.onInit();
  }

  RTCPeerConnection? testPeerConnection;

  RxList<Map<String, dynamic>> allOnlinePeers = RxList<Map<String, dynamic>>([]);
  void socketInit() async {
    var id = await SpController().getUserId();
    if (id != null) {
      Get.find<GlobalController>().userId.value = id;
    }
    ll("Connecting...GC");

    socket.connect();

    socket.on('connect', (_) {
      ll('Connected GController: ${socket.id}');
      if (Get.find<GlobalController>().userId.value != null) {
        socket.emit('mobile-chat-channel', {
          'type': "status",
          'userID': Get.find<GlobalController>().userId.value,
        });
      }
    });

    socket.on('mobile-chat-channel', (data) async {
      ll('Received active user ID: $data');

      if (data['type'] == "status") {
        Get.find<GlobalController>().populatePeerList(data['userID']);
        socket.emit('mobile-chat-peer-exchange-${data['userID']}', {
          'type': "status",
          'userID': Get.find<GlobalController>().userId.value,
        });
      }
    });

    socket.on("mobile-chat-peer-exchange-${Get.find<GlobalController>().userId.value}", (data) async {
      if (data['type'] == "status") {
        Get.find<GlobalController>().populatePeerList(data['userID']);
      } else if (data['type'] == "offer") {
        ll("ECHO OFFER: $data");
         RTCPeerConnection? peerConnection;
        Map<int, Map<String, dynamic>> allRoomMessageListMap = {for (var user in Get.find<MessengerController>().allRoomMessageList) user['userID']: user};
        if (allRoomMessageListMap.containsKey(data['userID'])) {
          if (allRoomMessageListMap[data['userID']]!['peerConnection'] != null) {
             peerConnection = allRoomMessageListMap[data['userID']]!['peerConnection'];
          }else{
         peerConnection = await createPeerConnection(Get.find<MessengerController>().configuration);
            ll("CREATED NEW PEER CoNNECTION");
         allRoomMessageListMap[data['userID']]!['peerConnection'] = peerConnection;
          }
          }
        // if (peerConnection == null) {
        //   ll("Failed to create peer connection ");
        //   return;
        // }
        // if (allRoomMessageListMap.containsKey(data['userID'])) {
        //   allRoomMessageListMap[data['userID']]!['peerConnection'] = peerConnection;
        // }
        Get.find<MessengerController>().allRoomMessageList.clear();
        Get.find<MessengerController>().allRoomMessageList.addAll(allRoomMessageListMap.values.toList());
        registerPeerConnectionListeners(peerConnection, data);

        peerConnection?.onDataChannel = (channel) {
          ll("On DATA Channel: ${channel.label}");
          // if (allRoomMessageListMap.containsKey(data['userID'])) {
          //   allRoomMessageListMap[data['userID']]!['dataChannel'] = channel;
          // }
          // Get.find<MessengerController>().allRoomMessageList.clear();
          // Get.find<MessengerController>().allRoomMessageList.addAll(allRoomMessageListMap.values.toList());
          Get.find<MessengerController>().setUpRoomDataChannel(data['userID'], channel);
          channel.onDataChannelState = (RTCDataChannelState state) {
            Get.find<MessengerController>().handleRTCEvents(state);
          };
          channel.onMessage = (RTCDataChannelMessage message) {
            ll('Received message: ${message.text}');
            ll("USER ID: ${data['userID']} DATA CHANNEL: ${channel.label}");
            int index = Get.find<MessengerController>()
                .allRoomMessageList
                .indexWhere((user) => user['userID'] == data['userID']);
            if (index != -1) {
              ll("here");
              showSnackBar(title: Get.find<MessengerController>().allRoomMessageList[index]["userName"], message: message.text, color: Colors.green);
              Get.find<MessengerController>().allRoomMessageList[index]["isSeen"] = false.obs;
              Get.find<MessengerController>().allRoomMessageList[index]["messages"].insert(
                  0,
                  MessageData(
                      text: message.text,
                      senderId: data['userID'],
                      messageText: message.text,
                      senderImage: data['userImage']),);
            }
          };
        };

        peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
          ll("GENERATED ICE CANDIDATE");
          socket.emit('mobile-chat-peer-exchange-${data['userID']}', {
            'userID': Get.find<GlobalController>().userId.value,
            'type': "candidate",
            'data': {
              'candidate': candidate.candidate,
              'sdpMid': candidate.sdpMid,
              'sdpMLineIndex': candidate.sdpMLineIndex,
            }
          });
        };
        // ll('Received peer exchange ID: $data');
        ll('Setting remote description');
        RTCSessionDescription description = RTCSessionDescription(data['data']['sdp'], data['data']['type']);
        await peerConnection?.setRemoteDescription(description);

        // Get.find<MessengerController>().peerConnection!.onSignalingState = (state) async {
        //   ll("BOOL : ${state == RTCSignalingState.RTCSignalingStateHaveRemoteOffer} STATE: $state");
        //   ll('Signaling state changed: $state');
        // };

        // var answer = await Get.find<MessengerController>().peerConnection!.createAnswer();
        // ll('Created Answer $answer');
        // await Get.find<MessengerController>().peerConnection!.setLocalDescription(answer);
      } else if (data['type'] == "candidate") {
        RTCPeerConnection? globalPeerConnection;
        ll('Got new remote ICE candidate: ${jsonEncode(data)}');
        Map<int, Map<String, dynamic>> allRoomMessageListMap = {for (var user in Get.find<MessengerController>().allRoomMessageList) user['userID']: user};
        if (allRoomMessageListMap.containsKey(data['userID'])) {
          if (allRoomMessageListMap[data['userID']]!['peerConnection'] != null) {
             globalPeerConnection = allRoomMessageListMap[data['userID']]!['peerConnection'];
          }
          else{
        globalPeerConnection = await createPeerConnection(Get.find<MessengerController>().configuration);
        }
          }
        

        Get.find<MessengerController>().registerPeerConnectionListeners(globalPeerConnection);
        globalPeerConnection!.addCandidate(
          RTCIceCandidate(
            data['data']['candidate'],
            data['data']['sdpMid'],
            data['data']['sdpMLineIndex'],
          ),
        );
      } else if (data['type'] == "answer") {
        RTCPeerConnection? icePeerConnection;
        ll('Got new remote ICE candidate: ${jsonEncode(data)}');
        Map<int, Map<String, dynamic>> allRoomMessageListMap = {for (var user in Get.find<MessengerController>().allRoomMessageList) user['userID']: user};
        if (allRoomMessageListMap.containsKey(data['userID'])) {
          icePeerConnection = allRoomMessageListMap[data['userID']]!['peerConnection'];
        }
        ll('Got Answer: ${jsonEncode(data)}');
        var answer = RTCSessionDescription(
          data['data']['sdp'],
          data['data']['type'],
        );

        ll("Someone tried to connect");
        await icePeerConnection?.setRemoteDescription(answer);
      }
    });

    socket.on('disconnect', (_) {
      ll('Disconnected');
    });

    socket.on('error', (error) {
      ll('Socket error: $error');
    });
  }

  void disconnectSocket() {
    socket.clearListeners();
    socket.disconnect();
    socket.dispose();
  }

  void registerPeerConnectionListeners(RTCPeerConnection? peerConnection, data) {
    ll("REGISTERING PEER CONNECTION: ${peerConnection}");
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      ll('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      ll('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) async {
      ll('Signaling state change: $state');
      if (state == RTCSignalingState.RTCSignalingStateHaveRemoteOffer) {
        try {
          var answer = await peerConnection.createAnswer();
          ll('Created Answer $answer');
          await peerConnection.setLocalDescription(answer);

          socket.emit('mobile-chat-peer-exchange-${data['userID']}', {
            'userID': Get.find<GlobalController>().userId.value,
            'type': "answer",
            'data': {
              'sdp': answer.sdp,
              'type': answer.type,
            }
          });
        } catch (e) {
          ll("EXCEPTION: $e");
        }
      }
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      ll('ICE connection state change: $state');
    };

    // peerConnection?.onAddStream = (MediaStream stream) {
    //   print("Add remote stream");
    //   onAddRemoteStream?.call(stream);
    //   remoteStream = stream;
    // };
  }

  void populatePeerList(Map<String, dynamic> newUserData) {
    int index = allOnlinePeers.indexWhere((user) => user['userID'] == newUserData['userID']);
    Get.find<MessengerController>().connectedUserID.add(newUserData['userID']);
    if (index != -1) {
      allOnlinePeers[index]['peerID'] = newUserData['peerID'];
    } else {
      allOnlinePeers.add(newUserData);
    }
    // if(Get.find<MessengerController>().allRoomMessageList.isNotEmpty){
    //   Get.find<MessengerController>().updateRoomListWithOnlineUsers();
    // }
  }
}