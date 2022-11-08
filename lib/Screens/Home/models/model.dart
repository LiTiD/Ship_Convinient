import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;
  final int? rating;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.rating,
  });
}

final mapMarkers = [
  MapMarker(
      image: 'assets/img/nhahang.png',
      title: 'Alexander The Great Restaurant',
      address: '8 Plender St, London NW1 0JT, United Kingdom',
      location: LatLng(10.835891999192754, 106.81437587683985),
      rating: 4),
  MapMarker(
      image: 'assets/img/nhahang.png',
      title: 'Mestizo Mexican Restaurant',
      address: '103 Hampstead Rd, London NW1 3EL, United Kingdom',
      location: LatLng(10.83517544580333, 106.80407619415136),
      rating: 5),
  MapMarker(
      image: 'assets/img/nhahang.png',
      title: 'The Shed',
      address: '122 Palace Gardens Terrace, London W8 4RT, United Kingdom',
      location: LatLng(10.832519968287508, 106.79763889247107),
      rating: 2),
  MapMarker(
      image: 'assets/img/nhahang.png',
      title: 'Gaucho Tower Bridge',
      address: '2 More London Riverside, London SE1 2AP, United Kingdom',
      location: LatLng(10.844406208155235, 106.80712318361338),
      rating: 3),
  MapMarker(
    image: 'assets/img/nhahang.png',
    title: 'Bill\'s Holborn Restaurant',
    address: '42 Kingsway, London WC2B 6EY, United Kingdom',
    location: LatLng(10.845502078836116, 106.82025527904118),
    rating: 1,
  ),
];