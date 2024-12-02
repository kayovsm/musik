import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleDriveRepositoryImpl {
  final String clientId = 'YOUR_CLIENT_ID';
  final String clientSecret = 'YOUR_CLIENT_SECRET';
  final List<String> scopes = [drive.DriveApi.driveReadonlyScope];

  Future<drive.DriveApi> authenticate() async {
    final client = await clientViaUserConsent(ClientId(clientId, clientSecret), scopes, (url) {
      // Open the URL in the user's browser
      print('Please go to the following URL and grant access:');
      print('  => $url');
    });

    return drive.DriveApi(client);
  }

  Future<List<String>> listFilesInFolder(String folderId) async {
    final driveApi = await authenticate();
    final fileList = await driveApi.files.list(q: "'$folderId' in parents and mimeType='audio/mpeg'");
    return fileList.files?.map((file) => file.id!).toList() ?? [];
  }

  String getDirectLink(String fileId) {
    return 'https://drive.google.com/uc?export=download&id=$fileId';
  }
}