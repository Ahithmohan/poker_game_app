import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

import '../model/login_response_model.dart';
import '../widget/chart_line_widget.dart';

class GameView extends StatefulWidget {
  final LoginResponseModel? playerResponse;
  final int? buttonId;

  const GameView({super.key, this.playerResponse, this.buttonId});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  String? avatar;
  String? lobbyAvatar;
  String? detailAvatar;
  String? balance;
  String? serverUrl;
  bool isLoading = true;
  int? buttonId;
  int? id;
  HttpServer? _server;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _downloadAndExtractFile();
  }

  @override
  void dispose() {
    _stopServer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  /// Deletes old files if needed
  Future<void> _deleteTempFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final extractionPath = '${dir.path}/dist/';
    final zipFilePath = '${dir.path}/poker.zip';

    try {
      final extractionDir = Directory(extractionPath);
      if (await extractionDir.exists()) {
        await extractionDir.delete(recursive: true);
        debugPrint('Extracted files deleted.');
      }

      final zipFile = File(zipFilePath);
      if (await zipFile.exists()) {
        await zipFile.delete();
        debugPrint('ZIP file deleted.');
      }
    } catch (e) {
      debugPrint('Error deleting temp files: $e');
    }
  }

  /// Checks if the extracted files already exist
  Future<bool> _isAlreadyExtracted() async {
    final dir = await getApplicationDocumentsDirectory();
    final extractedFile = File('${dir.path}/dist/index.html');
    return extractedFile.exists();
  }

  /// Checks if the ZIP file already exists
  Future<bool> _isZipFileDownloaded() async {
    final dir = await getApplicationDocumentsDirectory();
    final zipFile = File('${dir.path}/poker.zip');
    return zipFile.exists();
  }

  /// Downloads and extracts the ZIP file to a permanent directory
  Future<void> _downloadAndExtractFile() async {
    setState(() {
      isLoading = true; // Show loading GIF
    });

    try {
      final isExtracted = await _isAlreadyExtracted();
      final isZipDownloaded = await _isZipFileDownloaded();

      if (isExtracted && isZipDownloaded) {
        debugPrint(
            'ZIP file is already downloaded and extracted. Skipping extraction.');
        await _startServer(await _getExtractionPath());
        if (mounted) {
          setState(() {
            isLoading = false; // Hide loading GIF
          });
        }
        return;
      }

      if (!isZipDownloaded) {
        debugPrint('Deleting old temporary files...');
        await _deleteTempFiles();
      }

      avatar = widget.playerResponse?.data?.avatar;
      buttonId = widget.buttonId;
      balance = widget.playerResponse?.data?.balance;
      lobbyAvatar = widget.playerResponse?.data?.lobbyAvatar;
      detailAvatar = widget.playerResponse?.data?.detailAvatar;
      id = widget.playerResponse?.data?.id;

      final url = widget.playerResponse?.data?.holdemGameUrl;
      if (url == null || url.isEmpty) {
        throw Exception('Game URL is null or empty.');
      }

      final dir = await getApplicationDocumentsDirectory();
      final zipFilePath = '${dir.path}/poker.zip';
      final zipFile = File(zipFilePath);

      if (!isZipDownloaded) {
        debugPrint('Starting ZIP file download from: $url');
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          await zipFile.writeAsBytes(response.bodyBytes);
          debugPrint('ZIP file downloaded successfully to: $zipFilePath');
        } else {
          throw Exception(
              'Failed to download ZIP file: ${response.statusCode}');
        }
      } else {
        debugPrint('ZIP file already exists at: $zipFilePath');
      }

      if (!isExtracted) {
        debugPrint('Extracting ZIP file...');
        await _extractZip(zipFilePath, '${dir.path}/dist/');
        debugPrint('ZIP file extracted successfully.');
      }

      debugPrint('Starting local server...');
      await _startServer(await _getExtractionPath());
    } catch (e) {
      debugPrint('Error occurred: $e');
      if (mounted) {
        _showError('Failed to download or extract files. Returning to lobby.');
        Navigator.pop(context); // Navigate back to the lobby page
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Ensure loading GIF is hidden
        });
      }
    }
  }

  /// Extracts ZIP content
  Future<void> _extractZip(String zipPath, String extractionPath) async {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filePath = '$extractionPath${file.name}';
      if (file.isFile) {
        final extractedFile = File(filePath)..createSync(recursive: true);
        await extractedFile.writeAsBytes(file.content as List<int>);
      } else {
        Directory(filePath).createSync(recursive: true);
      }
    }
    debugPrint('Files extracted to $extractionPath');
  }

  /// Starts a local server to serve extracted files
  Future<void> _startServer(String path) async {
    final handler = createStaticHandler(
      path,
      defaultDocument: 'index.html',
    );

    try {
      final ipAddress = await _getLocalIpAddress();
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 4040);

      // Allow WebSocket upgrades and CORS requests
      _server?.defaultResponseHeaders.add('Access-Control-Allow-Origin', '*');
      _server?.defaultResponseHeaders
          .add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
      _server?.defaultResponseHeaders.add('Access-Control-Allow-Headers',
          'Origin, X-Requested-With, Content-Type, Accept');

      setState(() {
        serverUrl =
            "http://$ipAddress:4040/dist/index.html?buttonId=$buttonId&avatar=$avatar&lobbyAvatar=$lobbyAvatar&detailAvatar=$detailAvatar&balance=$balance&id=$id";
        isLoading = false;
      });

      debugPrint('Server running at $serverUrl');
    } catch (e) {
      _showError('Failed to start local server: $e');
    }
  }

  /// Stops the server when the widget is disposed
  Future<void> _stopServer() async {
    if (_server != null) {
      await _server?.close(force: true);
      debugPrint('Server stopped.');
    }
  }

  /// Displays error message and stops loading
  void _showError(String message) {
    debugPrint(message);
    setState(() {
      isLoading = false;
    });
  }

  /// Gets the local IP address
  Future<String> _getLocalIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          return addr.address;
        }
      }
    }
    return '127.0.0.1';
  }

  /// Gets extraction path in permanent directory
  Future<String> _getExtractionPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/dist/';
  }

  /// Shows ChartLineWidget as a modal bottom sheet
  /// Shows ChartLineWidget as a modal bottom sheet and closes on tap outside
  void _navigateToChartPage(BuildContext context, int? playerId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: SizedBox(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping inside content
            child: const ChartLineWidget(),
          ),
        ),
      ),
    );
  }

  bool isGameLoading = true; // For overlaying the GIF

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: isLoading || serverUrl == null
              ? Stack(
                  children: [
                    Image.asset("assets/images/background.jpg"),
                    Container(
                      color: Colors.transparent,
                      child: Center(
                        child: SizedBox(
                          width: width / 2,
                          child: Image.asset(
                              "assets/Gifs/White PP Logo Animation.gif"),
                        ),
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    InAppWebView(
                      initialUrlRequest: URLRequest(url: WebUri(serverUrl!)),
                      initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                        allowFileAccessFromFileURLs: true,
                        allowUniversalAccessFromFileURLs: true,
                      ),
                      onLoadError: (controller, url, code, message) {
                        _showError('Failed to load the game: $message');
                      },
                      onWebViewCreated: (controller) {
                        controller.addJavaScriptHandler(
                          handlerName: "FlutterChannel",
                          callback: (args) {
                            if (args.isNotEmpty) {
                              var message = args[0];
                              switch (message["action"]) {
                                case "exit":
                                  Navigator.pop(context);
                                  break;
                                case "log":
                                  debugPrint(
                                      "JS Console: ${message["message"]}");
                                  break;
                                case "playerDetails":
                                  _navigateToChartPage(
                                      context, message["data"][1]);
                                  break;
                                case "gameLoaded":
                                  setState(() {
                                    isGameLoading = false;
                                  });
                                  break;
                                default:
                                  debugPrint(
                                      "Unknown action: ${message["action"]}");
                              }
                            }
                          },
                        );

                        controller.evaluateJavascript(source: '''
                  (function() {
                    console.log = (function(oldLog) {
                      return function(message) {
                        oldLog(message);
                        window.flutter_inappwebview.callHandler('FlutterChannel', { "action": "log", "message": message });
                      };
                    })(console.log);
                  })();
                ''');
                      },
                    ),

                    // Overlay GIF while game is loading
                    if (isLoading || isGameLoading)
                      Stack(
                        children: [
                          Image.asset("assets/images/background.jpg"),
                          Container(
                            color: Colors.transparent,
                            child: Center(
                              child: SizedBox(
                                width: width / 2,
                                child: Image.asset(
                                    "assets/Gifs/White PP Logo Animation.gif"),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
