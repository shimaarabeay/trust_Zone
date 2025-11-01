import 'dart:convert'; // مهم عشان jsonEncode
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_trust_zone/features/home/home/presentation/manager/picture_cubit/picture_state.dart';
import 'package:my_trust_zone/utils/token_helper.dart';

class PictureCubit extends Cubit<PictureState> {
  PictureCubit() : super(PictureInitial());

  Future<void> uploadSelectedImage(XFile pickedFile) async {
    try {
      emit(PictureUploading());

      // 1. جلب SAS URL من API
      final sasResponse = await http.get(Uri.parse('https://trustzone.azurewebsites.net/api/UserProfile/generateProfilePictureUploadSas'));
      if (sasResponse.statusCode != 200) {
        emit(PictureError('Failed to get upload SAS URL'));
        return;
      }

      final sasUrl = sasResponse.body;
      print('SAS URL: $sasUrl');

      // 2. رفع الصورة على Azure Blob Storage باستخدام PUT
      Uint8List imageBytes = await pickedFile.readAsBytes();

      final putResponse = await http.put(
        Uri.parse(sasUrl),
        headers: {
          'x-ms-blob-type': 'BlockBlob',
          'Content-Type': 'application/octet-stream',
        },
        body: imageBytes,
      );

      if (putResponse.statusCode != 201 && putResponse.statusCode != 200) {
        emit(PictureError('Failed to upload image to storage'));
        return;
      }

      print('✅ Image uploaded to Azure Blob');

      // 3. استخراج اسم الملف من الرابط
      final fileName = Uri.parse(sasUrl).pathSegments.last;
      final imageUrl = sasUrl.split('?').first;
      final token = await TokenHelper.getToken();

      print('📤 Sending image update with URL: $imageUrl');

      // 4. استدعاء API تحديث صورة البروفايل مع اسم الملف والرابط
      final updateProfileResponse = await http.put(
        Uri.parse('https://trustzone.azurewebsites.net/api/UserProfile/ProfilePicture/$fileName'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'imageUrl': imageUrl, // تأكدي من اسم الحقل المطلوب
        }),
      );

      if (updateProfileResponse.statusCode != 200) {
        print('❌ Update response: ${updateProfileResponse.body}');
        emit(PictureError('Failed to update profile picture URL'));
        return;
      }

      print('✅ Profile picture updated successfully');
      emit(PictureImageUploaded(imageUrl));
    } catch (e) {
      emit(PictureError(e.toString()));
    }
  }
}
