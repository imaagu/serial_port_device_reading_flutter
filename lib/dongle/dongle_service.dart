import 'package:flutter_libserialport/flutter_libserialport.dart';

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}

class DongleService {
  static init() async {
    final deviceList = SerialPort.availablePorts;
    for (int i = 0; i < deviceList.length; i++) {
      final address = deviceList.elementAt(i);
      final port = SerialPort(address);
      print("Vendor Id: ${port.vendorId ?? ''}");
      print("Product Id: ${port.productId ?? ''}");
      print("Serial No.: ${port.serialNumber ?? ''}");
      print("Name: ${port.name ?? ''}");
      print("Product Name: ${port.productName ?? ''}");
      print("Manufacturer: ${port.manufacturer ?? ''}");
      print("Mac Address: ${port.macAddress ?? ''}");
      print("Device Number: ${port.deviceNumber ?? ''}");
      var configu = SerialPortConfig();
      configu.baudRate = 115200;
      configu.bits = 8;
      configu.parity = 0;
      port.config = configu;
      SerialPortReader reader = SerialPortReader(port, timeout: 10);
      print(port.isOpen);
      try {
        port.openReadWrite();
        print(port.isOpen);
        reader.stream.listen((data) {
          print('received : $data');
        });
      } on SerialPortError catch (_, err) {
        if (port.isOpen) {
          //port.close();
          print('serial port error');
        }
      } catch (e) {
        print('error');
        if (port.isOpen) {
          port.close();
        }
      }

      //   ..baudRate = 115200
      //   ..bits = 8
      //   ..stopBits = 1
      //   ..parity = SerialPortParity.none
      //   ..rts = SerialPortRts.flowControl
      //   ..cts = SerialPortCts.flowControl
      //   ..dsr = SerialPortDsr.flowControl
      //   ..dtr = SerialPortDtr.flowControl
      //   ..setFlowControl(SerialPortFlowControl.rtsCts);
      // port.open(mode: 2);

      //   if (!port.isOpen) {
      //     print("Port not opened: ${SerialPort.lastError}");
      //     port.close();
      //   } else {
      //     try {
      //       final serialPortReader = SerialPortReader(port);
      //       print('serialPortReader');
      //       print(serialPortReader);
      //       serialPortReader.stream.listen((data) {
      //         String message = String.fromCharCodes(data);
      //         print(message);
      //       });
      //     } catch (e) {
      //       print(SerialPort.lastError);
      //       port.close();
      //     }
      //   }
    }
  }
}
