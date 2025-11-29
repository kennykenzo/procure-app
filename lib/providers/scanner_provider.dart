import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Scanner state
class ScannerState {
  final bool isScanning;
  final String? scannedBarcode;
  final String? scannedNfcId;
  final String? error;

  const ScannerState({
    this.isScanning = false,
    this.scannedBarcode,
    this.scannedNfcId,
    this.error,
  });

  ScannerState copyWith({
    bool? isScanning,
    String? scannedBarcode,
    String? scannedNfcId,
    String? error,
  }) {
    return ScannerState(
      isScanning: isScanning ?? this.isScanning,
      scannedBarcode: scannedBarcode ?? this.scannedBarcode,
      scannedNfcId: scannedNfcId ?? this.scannedNfcId,
      error: error ?? this.error,
    );
  }
}

/// Provider for scanner state
final scannerProvider = Provider<ScannerState>((ref) {
  return const ScannerState();
});

/// Helper functions for scanner
final scannerNotifierProvider = Provider<ScannerNotifier>((ref) {
  return ScannerNotifier(ref);
});

class ScannerNotifier {
  final Ref ref;
  ScannerState _state = const ScannerState();

  ScannerNotifier(this.ref);

  ScannerState get state => _state;

  void startScanning() {
    _state = _state.copyWith(isScanning: true, error: null);
  }

  void stopScanning() {
    _state = _state.copyWith(isScanning: false);
  }

  void setScannedBarcode(String barcode) {
    _state = _state.copyWith(
      scannedBarcode: barcode,
      isScanning: false,
      error: null,
    );
  }

  void setScannedNfcId(String nfcId) {
    _state = _state.copyWith(
      scannedNfcId: nfcId,
      isScanning: false,
      error: null,
    );
  }

  void setError(String error) {
    _state = _state.copyWith(error: error, isScanning: false);
  }

  void clearScan() {
    _state = const ScannerState();
  }
}
