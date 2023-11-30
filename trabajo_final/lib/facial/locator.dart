import 'package:get_it/get_it.dart';
import 'package:trabajo_final/facial/services/camera_service.dart';
import 'package:trabajo_final/facial/services/face_detector_service.dart';
import 'package:trabajo_final/facial/services/face_vector_service.dart';
import 'package:trabajo_final/facial/services/ml_service.dart';

final locator = GetIt.instance;

void setupService() {
  locator.registerLazySingleton<CameraService>(() => CameraService());

  locator.registerLazySingleton<MLService>(() => MLService());

  locator
      .registerLazySingleton<FaceDetectorService>(() => FaceDetectorService());

  locator.registerLazySingleton<FaceVectorService>(() => FaceVectorService());
}
