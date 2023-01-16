class WebrtcService {
  final Map<String, dynamic> configuration = {
    'iceServers': [
      {'url': 'stun:stun1.l.google.com:19302'},
    ]
  };

  final Map<String, dynamic> offerSdpConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };
}
