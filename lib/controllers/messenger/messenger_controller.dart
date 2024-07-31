import 'dart:io';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:startup_boilerplate/controllers/common/global_controller.dart';
import 'package:startup_boilerplate/controllers/common/sp_controller.dart';
import 'package:startup_boilerplate/controllers/messenger/messenger_helper.dart';
import 'package:startup_boilerplate/models/common/common_data_model.dart';
import 'package:startup_boilerplate/models/common/common_error_model.dart';
import 'package:startup_boilerplate/models/messenger/message_list_model.dart';
import 'package:startup_boilerplate/models/messenger/room_list_model.dart';
import 'package:startup_boilerplate/services/api_services.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/utils/constants/urls.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MessengerController extends GetxController {
  final SpController spController = SpController();
  final ApiServices apiController = ApiServices();
  final GlobalController globalController = Get.find<GlobalController>();
  final TextEditingController messageTextEditingController = TextEditingController();
  final RxBool isSendEnabled = RxBool(false);
  final RxInt selectedRoomIndex = RxInt(-1);

  final FocusNode messageFocusNode = FocusNode();
  final RxBool isMessageTextFieldFocused = RxBool(false);
  @override
  void onInit() {
    checkInternetConnectivity();
    messageFocusNode.addListener(() {
      if (messageFocusNode.hasFocus) {
        isMessageTextFieldFocused.value = true;
      } else {
        isMessageTextFieldFocused.value = false;
      }
    });
    localRenderer.initialize();
    remoteRenderer.initialize();
    super.onInit();
  }

  void checkCanSendMessage() {
    if (messageTextEditingController.text.trim() == "") {
      isSendEnabled.value = false;
    } else {
      isSendEnabled.value = true;
    }
  }

  //=====================================================
  //!          Check for internet connection
  //=====================================================

  late StreamSubscription<InternetConnectionStatus> internetConnectivitySubscription;
  final RxBool isInternetConnectionAvailable = RxBool(false);
  Future<void> initConnectivity() async {
    try {
      bool internetConnectivityResult = await InternetConnectionChecker().hasConnection;
      if (internetConnectivityResult != true) {
        isInternetConnectionAvailable.value = false;
      } else {
        isInternetConnectionAvailable.value = true;
      }
    } on SocketException catch (e) {
      ll('Connectivity status error: $e');
      isInternetConnectionAvailable.value = false;
    } on PlatformException catch (e) {
      ll('Connectivity status error: $e');
      isInternetConnectionAvailable.value = false;
    }
  }

  Future<void> checkInternetConnectivity() async {
    await initConnectivity();
    internetConnectivitySubscription = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            isInternetConnectionAvailable.value = true;
            break;
          case InternetConnectionStatus.disconnected:
            isInternetConnectionAvailable.value = false;
            break;
        }
      },
    );
  }

  //* Variables
  RTCDataChannel? targetDataChannel;
  RTCPeerConnection? targetPeerConnection;
  final RxList connectedUserID = RxList([]);
  final Map<String, dynamic> configuration = {
    'iceServers': [
      {'urls': "stun:stun.l.google.com:19302"},
      {
        "urls": [
          "turn:54.91.252.241:3478",
        ],
        "username": "user1",
        "credential": "123456",
      },
    ],
  };

  //* API calls
  final RxBool isInboxLoading = RxBool(false);
  final RxBool roomListScrolled = RxBool(false);
  final Rx<RoomListModel?> roomListData = Rx<RoomListModel?>(null);
  final RxList<RoomData> roomList = RxList<RoomData>([]);
  final Rx<RoomData?> selectedReceiver = Rx<RoomData?>(null);
  Future<void> getRoomList() async {
    try {
      isInboxLoading.value = true;
      String suffixUrl = '?take=15';
      String? token = await spController.getBearerToken();
      var response = await apiController.commonApiCall(
        requestMethod: get,
        token: token,
        url: kuGetRoomList + suffixUrl,
      ) as CommonDM;
      if (response.success == true) {
        roomList.clear();
        roomListScrolled.value = false;
        roomListData.value = RoomListModel.fromJson(response.data);
        roomList.addAll(roomListData.value!.rooms!.data!);
        geAllRoomMessages();
        isInboxLoading.value = false;
      } else {
        isInboxLoading.value = true;
        ErrorModel errorModel = ErrorModel.fromJson(response.data);
        if (errorModel.errors.isEmpty) {
          showSnackBar(title: ksError.tr, message: response.message, color: cRedColor);
        } else {
          showSnackBar(title: ksError.tr, message: errorModel.errors[0].message, color: cRedColor);
        }
      }
    } catch (e) {
      isInboxLoading.value = true;
      ll('getRoomList error: $e');
    }
  }

  final RxBool isMessageListLoading = RxBool(false);
  final RxBool messageListScrolled = RxBool(false);
  final Rx<MessageListModel?> messageListData = Rx<MessageListModel?>(null);
  final RxList<MessageData> messageList = RxList<MessageData>([]);
  Future<void> getMessageList(roomID) async {
    try {
      isMessageListLoading.value = true;
      String suffixUrl = '?take=15';
      String? token = await spController.getBearerToken();
      var response = await apiController.commonApiCall(
        requestMethod: get,
        token: token,
        url: "$kuGetMessageList?room_id=$roomID$suffixUrl&page=1&message_id=",
      ) as CommonDM;
      if (response.success == true) {
        messageList.clear();
        roomListScrolled.value = false;
        messageListData.value = MessageListModel.fromJson(response.data);
        messageList.addAll(messageListData.value!.messages!.data!);
        populateRoomMessageList(roomID, messageList);
        isMessageListLoading.value = false;
      } else {
        isMessageListLoading.value = true;
        ErrorModel errorModel = ErrorModel.fromJson(response.data);
        if (errorModel.errors.isEmpty) {
          showSnackBar(title: ksError.tr, message: response.message, color: cRedColor);
        } else {
          showSnackBar(title: ksError.tr, message: errorModel.errors[0].message, color: cRedColor);
        }
      }
    } catch (e) {
      isMessageListLoading.value = true;
      ll('getMessageList error: $e');
    }
  }

  // Send through API
  final RxBool isSendMessageLoading = RxBool(false);
  Future<void> sendBatchMessages(message) async {
    try {
      isSendMessageLoading.value = true;
      String? token = await spController.getBearerToken();
      Map<String, dynamic> body = {
        'room_id': selectedReceiver.value!.id.toString(),
        'message': message.toString(),
      };
      var response = await apiController.commonApiCall(
        requestMethod: post,
        url: kuSendMessage,
        body: body,
        token: token,
      ) as CommonDM;
      if (response.success == true) {
      } else {
        isSendMessageLoading.value = false;
        ErrorModel errorModel = ErrorModel.fromJson(response.data);
        if (errorModel.errors.isEmpty) {
          showSnackBar(title: ksError.tr, message: response.message, color: cRedColor);
        } else {
          showSnackBar(title: ksError.tr, message: errorModel.errors[0].message, color: cRedColor);
        }
      }
    } catch (e) {
      isSendMessageLoading.value = false;
      ll('sendBatchMessages error: $e');
    }
  }
  //* END

  //* other functions

  List<String> messageQueue = [];
  int batchSize = 1;

  void sendMessage(String message, RTCDataChannel dataChannel) async {
    ll(dataChannel.label);
    if (isInternetConnectionAvailable.value) {

      setMessage(selectedReceiver.value!.id, MessageData(text: message, senderId: globalController.userId.value, messageText: message));

      sendViaDataChannel(message, dataChannel);

      messageQueue.add(message);

      if (messageQueue.length >= batchSize && isInternetConnectionAvailable.value) {
        for (int i = 0; i < messageQueue.length; i++) {
          sendBatchMessages(messageQueue[i]);
        }
        messageQueue.clear();
      }
      messageTextEditingController.clear();
    }
  }

  void setUpRoomDataChannel(userID, dataChannel, peerConnection) async {
    targetDataChannel = dataChannel;
    targetPeerConnection = peerConnection;
    ll("Set up room data channel: $targetDataChannel $dataChannel");
    Map<int, Map<String, dynamic>> roomMap = {for (var onlineUser in allRoomMessageList) onlineUser['userID']: onlineUser};

    if (roomMap.containsKey(userID)) {
      roomMap[userID]!['dataChannelLabel'] = dataChannel.label;
      roomMap[userID]!['dataChannel'] = dataChannel;
      roomMap[userID]!['peerConnection'] = peerConnection;
    }
    allRoomMessageList.clear();
    allRoomMessageList.addAll(roomMap.values.toList());
  }

  RxList<Map<String, dynamic>> allRoomMessageList = RxList<Map<String, dynamic>>([]);
  void geAllRoomMessages() {
    for (int i = 0; i < roomList.length; i++) {
      allRoomMessageList.add({
        "roomID": roomList[i].id,
        "userID": roomList[i].roomUserId,
        "dataChannelLabel": "",
        "dataChannel": null,
        "peerConnection": null,
        "status": false.obs,
        "userName": roomList[i].roomName,
        "userImage": roomList[i].roomImage![0],
        "isSeen": true.obs,
        "messages": RxList([]),
      });
    }
    if (globalController.allOnlineUsers.isNotEmpty) {
      updateRoomListWithOnlineUsers();
    }
  }

  void updateRoomListWithOnlineUsers() {
    Map<int, Map<String, dynamic>> onlineUserMap = {for (var onlineUser in globalController.allOnlineUsers) onlineUser['userID']: onlineUser};

    for (var room in allRoomMessageList) {
      if (onlineUserMap.containsKey(room['userID'])) {
        room['status'] = true.obs;
      }
    }
    RxList<Map<String, dynamic>> temporaryAllRoomMessageList = RxList<Map<String, dynamic>>([]);
    temporaryAllRoomMessageList.addAll(allRoomMessageList);
    allRoomMessageList.clear();
    allRoomMessageList.addAll(temporaryAllRoomMessageList);
  }

  void populateRoomMessageList(roomID, messageList) {
    int index = allRoomMessageList.indexWhere((user) => user['roomID'] == roomID);
    if (index != -1) {
      allRoomMessageList[index]["messages"].clear();
      allRoomMessageList[index]["messages"].addAll(messageList);
    }
  }

  //* END
  void handleRTCEvents(RTCDataChannelState state) {
    switch (state) {
      case RTCDataChannelState.RTCDataChannelOpen:
        ll('dc connection success');

        break;

      case RTCDataChannelState.RTCDataChannelClosed:
        ll(' dc closed ');

        break;
      case RTCDataChannelState.RTCDataChannelConnecting:
        break;
      case RTCDataChannelState.RTCDataChannelClosing:
        break;
    }
  }

  void connectUser(userID) async {
    Map<int, Map<String, dynamic>> allRoomMessageListMap = {for (var user in allRoomMessageList) user['userID']: user};
    RTCPeerConnection peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners(peerConnection);
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit();
    String dataChannelName = "${Get.find<GlobalController>().userId.value}-$userID";
    RTCDataChannel dataChannel = await peerConnection.createDataChannel(dataChannelName, dataChannelDict);

    if (allRoomMessageListMap.containsKey(userID)) {
      allRoomMessageListMap[userID]!['peerConnection'] = peerConnection;
      allRoomMessageListMap[userID]!['dataChannel'] = dataChannel;
    }
    allRoomMessageList.clear();
    allRoomMessageList.addAll(allRoomMessageListMap.values.toList());

    dataChannel.onDataChannelState = (RTCDataChannelState state) {
      ll("STATE CHANGED: $state");
    };
    dataChannel.onMessage = (RTCDataChannelMessage message) {
      ll('Received message: ${message.text}');
      ll("USER NAME: $userID DATA CHANNEL: ${dataChannel.label}");
      int index = allRoomMessageList.indexWhere((user) => user['userID'] == userID);
      if (index != -1) {
        showSnackBar(title: allRoomMessageList[index]["userName"], message: message.text, color: Colors.green);
        allRoomMessageList[index]["isSeen"] = false.obs;
        allRoomMessageList[index]["messages"].insert(
            0,
            MessageData(
                text: message.text,
                senderId: Get.find<MessengerController>().selectedReceiver.value!.roomUserId,
                messageText: message.text,
                senderImage: Get.find<MessengerController>().selectedReceiver.value!.roomImage![0]));
      }
    };
    peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      socket.emit('mobile-chat-peer-exchange-$userID', {
        'userID': Get.find<GlobalController>().userId.value,
        'type': "candidate",
        'data': {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        }
      });
    };

    RTCSessionDescription offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    socket.emit('mobile-chat-peer-exchange-$userID', {
      'userID': Get.find<GlobalController>().userId.value,
      'type': "offer",
      'dataChannelLabel': dataChannel.label,
      'data': {
        'sdp': offer.sdp,
        'type': offer.type,
      },
    });

    ll("CORE DATACHANNEL: ${dataChannel.state}");
    setUpRoomDataChannel(userID, dataChannel, peerConnection);
  }

  void sendViaDataChannel(String message, dataChannel) {
    ll("Before sending message: ${dataChannel}");
    if (dataChannel.state == RTCDataChannelState.RTCDataChannelOpen) {
      ll("sending message");
      dataChannel.send(RTCDataChannelMessage(message));
    }
  }

  void registerPeerConnectionListeners(RTCPeerConnection? peerConnection) {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      ll('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      ll('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      ll('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      ll('ICE connection state change: $state');
    };

    peerConnection?.onTrack = (RTCTrackEvent event) async {
      ll('Got remote track mc: ${event.streams[0]}');

      if (Get.find<MessengerController>().remoteStream == null) {
        ll('Initializing remoteStream');
        remoteStream = await createLocalMediaStream('remoteStream');
      } else {
        ll('remoteStream already initialized');
      }

      event.streams[0].getTracks().forEach((track) {
        ll('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
        remoteRenderer.srcObject = remoteStream;
        isRemoteFeedStreaming.value = true;
      });
    };

    peerConnection?.onAddTrack = (MediaStream stream, MediaStreamTrack track) async {
      ll("GETTING REMOTE TRACK MC");
      if (remoteStream == null) {
        ll('Initializing remoteStream');
        remoteStream = await createLocalMediaStream('remoteStream');
      } else {
        ll('remoteStream already initialized');
      }
      remoteRenderer.srcObject = stream;
      remoteStream = stream;
      isRemoteFeedStreaming.value = true;
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      ll("Add remote stream");

    };

  }

  // Set Messages
  void setMessage(userID, messageData) {
    int index = allRoomMessageList.indexWhere((user) => user['roomID'] == userID);
    if (index != -1) {
      allRoomMessageList[index]["messages"].insert(0, messageData);
    }
  }

  // * AUDIO VIDEO CALL
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  MediaStream? localStream;
  MediaStream? remoteStream;
  final RxInt? selectedUserID = RxInt(-1);
  final RxString callState = RxString("online");
  final RxString callerName = RxString("");
  final RxString callerImage = RxString("");
  final RxInt callerID = RxInt(-1);
  final RxBool isLocalFeedStreaming = RxBool(false);
  final RxBool isRemoteFeedStreaming = RxBool(false);
  final RxBool isUserTypeSender = RxBool(false);
  final RxBool isAudioCallState = RxBool(false);

  void initiateVideoCall(RTCPeerConnection? peerConnection, userID, isAudioCall) async {
    await MessengerHelper().openUserMedia(isAudioCall);

    localStream?.getTracks().forEach((track) {
      ll("ON VIDEO CALL START GETTING LOCAL TRACK: $track");
      peerConnection?.addTrack(track, localStream!);
    });
    RTCSessionDescription? offer;

    if(isAudioCall){
       offer = await peerConnection!.createOffer({
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': false,
    });
    }else{
     offer = await peerConnection!.createOffer();
    }
    if(isAudioCall){
    Helper.setSpeakerphoneOn(false);
    }else{
      Helper.setSpeakerphoneOn(true);
    }

    await peerConnection.setLocalDescription(offer);
    socket.emit('mobile-video-call-$userID', {
      'userID': Get.find<GlobalController>().userId.value,
      'callStatus': "inCall",
      'callType': isAudioCall?"audio":"video",
      'type': "offer",
      'data': {
        'sdp': offer.sdp,
        'type': offer.type,
      },
    });

    // todo: may need to store the peer connection
  }

  void ringUser(userID, isAudioCall) {
    isUserTypeSender.value = true;
    Map<int, Map<String, dynamic>> allRoomMessageListMap = {for (var user in Get.find<MessengerController>().allRoomMessageList) user['userID']: user};
    if (allRoomMessageListMap.containsKey(userID)) {
      Get.find<MessengerController>().callerName.value = allRoomMessageListMap[userID]!['userName'];
      Get.find<MessengerController>().callerImage.value = allRoomMessageListMap[userID]!['userImage'];
    }
    socket.emit('mobile-video-call-$userID', {
      'userID': Get.find<GlobalController>().userId.value,
      'callStatus': "ringing",
      'callType': isAudioCall?"audio":"video",
      'type': "offer",
    });
    callState.value = "ringing";
    if(isAudioCall){
      isAudioCallState.value = true;
    }else{
      isAudioCallState.value = false;
    }
    Get.toNamed(krCallScreen);
  }
}
