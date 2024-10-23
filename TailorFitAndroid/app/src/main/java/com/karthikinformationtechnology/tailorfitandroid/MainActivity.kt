//package com.karthikinformationtechnology.tailorfitandroid
//
////import android.Manifest
////import android.graphics.Bitmap
////import android.graphics.ImageDecoder
////import android.graphics.PointF
////import android.net.Uri
////import android.os.Bundle
////import android.util.Log
////import android.widget.Button
////import android.widget.TextView
////import androidx.activity.result.contract.ActivityResultContracts
////import androidx.appcompat.app.AppCompatActivity
////import androidx.camera.core.*
////import androidx.camera.lifecycle.ProcessCameraProvider
////import androidx.camera.view.PreviewView
////import androidx.core.content.ContextCompat
////import com.google.mlkit.vision.common.InputImage
////import com.google.mlkit.vision.pose.Pose
////import com.google.mlkit.vision.pose.PoseDetection
////import com.google.mlkit.vision.pose.PoseDetectorOptions
////import com.google.mlkit.vision.pose.PoseLandmark
////import com.google.mlkit.vision.pose.defaults.PoseDetectorOptions
////import java.io.File
////import java.util.concurrent.ExecutorService
////import java.util.concurrent.Executors
////
////class MainActivity : AppCompatActivity() {
////    private lateinit var imageCapture: ImageCapture
////    private lateinit var cameraExecutor: ExecutorService
////    private lateinit var resultTextView: TextView
////    private lateinit var poseDetector: PoseDetector
////
////    override fun onCreate(savedInstanceState: Bundle?) {
////        super.onCreate(savedInstanceState)
////        setContentView(R.layout.activity_main)
////
////        val previewView = findViewById<PreviewView>(R.id.previewView)
////        val captureButton = findViewById<Button>(R.id.captureButton)
////        resultTextView = findViewById(R.id.measurementText)
////
////        cameraExecutor = Executors.newSingleThreadExecutor()
////
////        // Initialize the pose detector
////        val poseDetectorOptions = PoseDetectorOptions.Builder()
////            .setDetectorMode(PoseDetectorOptions.STREAM_MODE)
////            .build()
////        poseDetector = PoseDetection.getClient(poseDetectorOptions)
////
////        val requestPermissionLauncher = registerForActivityResult(
////            ActivityResultContracts.RequestPermission()
////        ) { isGranted: Boolean ->
////            if (isGranted) {
////                startCamera(previewView)
////            }
////        }
////        requestPermissionLauncher.launch(Manifest.permission.CAMERA)
////
////        captureButton.setOnClickListener {
////            takePicture()
////        }
////    }
////
////    private fun startCamera(previewView: PreviewView) {
////        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)
////        cameraProviderFuture.addListener({
////            val cameraProvider = cameraProviderFuture.get()
////            val preview = Preview.Builder().build().also {
////                it.setSurfaceProvider(previewView.surfaceProvider)
////            }
////
////            imageCapture = ImageCapture.Builder().build()
////            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA
////
////            try {
////                cameraProvider.unbindAll()
////                cameraProvider.bindToLifecycle(this, cameraSelector, preview, imageCapture)
////            } catch (e: Exception) {
////                Log.e("CameraX", "Camera binding failed", e)
////            }
////        }, ContextCompat.getMainExecutor(this))
////    }
////
////    private fun takePicture() {
////        val outputOptions = ImageCapture.OutputFileOptions.Builder(
////            File(externalMediaDirs.first(), "${System.currentTimeMillis()}.jpg")
////        ).build()
////
////        imageCapture.takePicture(
////            outputOptions,
////            ContextCompat.getMainExecutor(this),
////            object : ImageCapture.OnImageSavedCallback {
////                override fun onError(exception: ImageCaptureException) {
////                    Log.e("CameraX", "Image capture failed", exception)
////                }
////
////                override fun onImageSaved(outputFileResults: ImageCapture.OutputFileResults) {
////                    val imageUri = outputFileResults.savedUri
////                    Log.d("CameraX", "Image saved at: $imageUri")
////
////                    // Process the image
////                    imageUri?.let { uri ->
////                        processImage(uri)
////                    }
////                }
////            }
////        )
////    }
////
////    private fun processImage(imageUri: Uri) {
////        // Decode the image
////        val source = ImageDecoder.createSource(contentResolver, imageUri)
////        val bitmap = ImageDecoder.decodeBitmap(source)
////
////        // Create an InputImage from the Bitmap
////        val inputImage = InputImage.fromBitmap(bitmap, 0)
////
////        // Run pose detection
////        poseDetector.process(inputImage)
////            .addOnSuccessListener { pose ->
////                analyzePose(pose)
////            }
////            .addOnFailureListener { e ->
////                Log.e("Pose Detection", "Pose detection failed", e)
////            }
////    }
////
////    private fun analyzePose(pose: Pose) {
////        val landmarks = pose.allLandmarks
////
////        // Calculate measurements (Example: shoulder width and height)
////        val leftShoulder = landmarks.firstOrNull { it.landmarkType == PoseLandmark.LEFT_SHOULDER }
////        val rightShoulder = landmarks.firstOrNull { it.landmarkType == PoseLandmark.RIGHT_SHOULDER }
////        val leftHip = landmarks.firstOrNull { it.landmarkType == PoseLandmark.LEFT_HIP }
////        val rightHip = landmarks.firstOrNull { it.landmarkType == PoseLandmark.RIGHT_HIP }
////
////        if (leftShoulder != null && rightShoulder != null && leftHip != null && rightHip != null) {
////            // Calculate shoulder width
////            val shoulderWidth = calculateDistance(leftShoulder.position, rightShoulder.position)
////            // Calculate hip width
////            val hipWidth = calculateDistance(leftHip.position, rightHip.position)
////
////            // Display the results
////            resultTextView.text = "Shoulder Width: ${shoulderWidth} units\nHip Width: ${hipWidth} units"
////        } else {
////            resultTextView.text = "Could not detect all landmarks."
////        }
////    }
////
////    private fun calculateDistance(pos1: PointF, pos2: PointF): Float {
////        return Math.sqrt(
////            Math.pow((pos1.x - pos2.x).toDouble(), 2.0) +
////                    Math.pow((pos1.y - pos2.y).toDouble(), 2.0)
////        ).toFloat()
////    }
////
////    override fun onDestroy() {
////        super.onDestroy()
////        cameraExecutor.shutdown()
////        poseDetector.close()
////    }
////}
////package com.example.bodymeasurement
//package com.karthikinformationtechnology.tailorfitandroid
//import android.Manifest
//import android.content.pm.PackageManager
//import android.graphics.*
//import android.media.Image
//import android.os.Bundle
//import androidx.activity.result.contract.ActivityResultContracts
//import androidx.appcompat.app.AppCompatActivity
//import androidx.camera.core.*
//import androidx.camera.lifecycle.ProcessCameraProvider
//import androidx.core.app.ActivityCompat
//import androidx.core.content.ContextCompat
//import com.google.mlkit.vision.common.InputImage
//import com.google.mlkit.vision.pose.Pose
//import com.google.mlkit.vision.pose.PoseDetection
////import com.google.mlkit.vision.pose.PoseDetectorOptions
//import java.util.concurrent.ExecutorService
//import java.util.concurrent.Executors
//import android.util.Size
//import androidx.annotation.OptIn
//import com.google.mlkit.vision.pose.PoseLandmark
//import com.google.mlkit.vision.pose.defaults.PoseDetectorOptions
//import com.karthikinformationtechnology.tailorfitandroid.databinding.ActivityMainBinding
//import kotlin.math.pow
//import kotlin.math.sqrt
//
//class MainActivity : AppCompatActivity() {
//    private lateinit var binding: ActivityMainBinding
//    private lateinit var cameraExecutor: ExecutorService
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        // View binding setup
//        binding = ActivityMainBinding.inflate(layoutInflater)
//        setContentView(binding.root)
//
//        cameraExecutor = Executors.newSingleThreadExecutor()
//
//        // Request camera permissions
//        if (allPermissionsGranted()) {
//            startCamera()
//        } else {
//            ActivityCompat.requestPermissions(
//                this, REQUIRED_PERMISSIONS, REQUEST_CODE_PERMISSIONS
//            )
//        }
//
//        // Set up capture button listener
//        binding.captureButton.setOnClickListener {
//            takePhoto()
//        }
//
//        // Set up calculate button listener
//        binding.calculateButton.setOnClickListener {
//            calculateBodyMeasurements()
//        }
//    }
//
//    // Start CameraX preview
//    private fun startCamera() {
//        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)
//
//        cameraProviderFuture.addListener({
//            val cameraProvider: ProcessCameraProvider = cameraProviderFuture.get()
//            val preview = Preview.Builder()
//                .build()
//                .also { it.setSurfaceProvider(binding.cameraPreview.surfaceProvider) }
//
//            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA
//
//            val imageAnalyzer = ImageAnalysis.Builder()
//                .setTargetResolution(Size(1280, 720))
//                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
//                .build()
//                .also {
//                    it.setAnalyzer(cameraExecutor, PoseAnalyzer { imageBitmap, pose ->
//                        // Display captured image and key points
//                        runOnUiThread {
//                            binding.capturedImageView.setImageBitmap(imageBitmap)
//                            binding.capturedImageView.visibility = android.view.View.VISIBLE
//                            binding.inputHeightLayout.visibility = android.view.View.VISIBLE
//                        }
//                    })
//                }
//
//            cameraProvider.unbindAll()
//            cameraProvider.bindToLifecycle(
//                this, cameraSelector, preview, imageAnalyzer
//            )
//        }, ContextCompat.getMainExecutor(this))
//    }
//
//    private fun takePhoto() {
//        // Capture an image, process and detect pose
//    }
//
//    private fun calculateBodyMeasurements() {
//        // Calculate measurements based on key points and height
//    }
//
//    // PoseAnalyzer class for detecting poses
//    private class PoseAnalyzer(val callback: (Bitmap, Pose) -> Unit) : ImageAnalysis.Analyzer {
//        @OptIn(ExperimentalGetImage::class)
//
//        fun calculateArmLength(pose: Pose): Double {
//            val shoulder = pose.getPoseLandmark(PoseLandmark.RIGHT_SHOULDER)
//            val elbow = pose.getPoseLandmark(PoseLandmark.RIGHT_ELBOW)
//            val wrist = pose.getPoseLandmark(PoseLandmark.RIGHT_WRIST)
//
//            if (shoulder != null && elbow != null && wrist != null) {
//                val upperArm = distanceBetween(shoulder.position, elbow.position)
//                val lowerArm = distanceBetween(elbow.position, wrist.position)
//                return upperArm + lowerArm
//            }
//            return 0.0
//        }
//
//        fun distanceBetween(point1: PointF, point2: PointF): Double {
//            return sqrt((point1.x - point2.x).pow(2) + (point1.y - point2.y).pow(2).toDouble())
//        }
//
//        override fun analyze(imageProxy: ImageProxy) {
//            val mediaImage = imageProxy.image ?: return
//            val rotationDegrees = imageProxy.imageInfo.rotationDegrees
//            val inputImage = InputImage.fromMediaImage(mediaImage, rotationDegrees)
//
//            // Create pose detector
//            val options = PoseDetectorOptions.Builder()
//                .setDetectorMode(PoseDetectorOptions.SINGLE_IMAGE_MODE)
//                .build()
//            val poseDetector = PoseDetection.getClient(options)
//
//            // Process the image
//            poseDetector.process(inputImage)
//                .addOnSuccessListener { pose ->
//                    // Convert imageProxy to Bitmap to show on UI
//                    val bitmap = mediaImage.toBitmap() // Custom method to convert to bitmap
//                    callback(bitmap, pose)
//                }
//                .addOnFailureListener {
//                    // Handle failure
//                }
//                .addOnCompleteListener {
//                    imageProxy.close()
//                }
//        }
//    }
//
//    // Convert Image to Bitmap
//    private fun Image.toBitmap(): Bitmap {
//        // Convert ImageProxy to Bitmap
//    }
//
//    private fun allPermissionsGranted() = REQUIRED_PERMISSIONS.all {
//        ContextCompat.checkSelfPermission(
//            baseContext, it
//        ) == PackageManager.PERMISSION_GRANTED
//    }
//
//    override fun onRequestPermissionsResult(
//        requestCode: Int, permissions: Array<String>, grantResults: IntArray
//    ) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
//        if (requestCode == REQUEST_CODE_PERMISSIONS) {
//            if (allPermissionsGranted()) {
//                startCamera()
//            } else {
//                finish()
//            }
//        }
//    }
//
//    companion object {
//        private const val REQUEST_CODE_PERMISSIONS = 10
//        private val REQUIRED_PERMISSIONS = arrayOf(Manifest.permission.CAMERA)
//    }
//}
//package com.karthikinformationtechnology.tailorfitandroid
//
//import android.Manifest
//import android.content.pm.PackageManager
//import android.graphics.*
//import android.media.Image
//import android.os.Bundle
//import androidx.activity.result.contract.ActivityResultContracts
//import androidx.appcompat.app.AppCompatActivity
//import androidx.camera.core.*
//import androidx.camera.lifecycle.ProcessCameraProvider
//import androidx.core.app.ActivityCompat
//import androidx.core.content.ContextCompat
//import com.google.mlkit.vision.common.InputImage
//import com.google.mlkit.vision.pose.Pose
//import com.google.mlkit.vision.pose.PoseDetection
//import com.google.mlkit.vision.pose.defaults.PoseDetectorOptions
//import com.karthikinformationtechnology.tailorfitandroid.databinding.ActivityMainBinding
//import kotlin.math.pow
//import kotlin.math.sqrt
//import java.util.concurrent.ExecutorService
//import java.util.concurrent.Executors
//import android.util.Size
//import android.view.View
//import com.google.mlkit.vision.pose.PoseLandmark
//import java.io.ByteArrayOutputStream
//
//
//class MainActivity : AppCompatActivity() {
//    private lateinit var binding: ActivityMainBinding
//    private lateinit var cameraExecutor: ExecutorService
//
//    private var userHeightInCm: Float = 0f
//    private var poseDetected: Pose? = null
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        // View binding setup
//        binding = ActivityMainBinding.inflate(layoutInflater)
//        setContentView(binding.root)
//
//        cameraExecutor = Executors.newSingleThreadExecutor()
//
//        // Request camera permissions
//        if (allPermissionsGranted()) {
//            startCamera()
//        } else {
//            ActivityCompat.requestPermissions(
//                this, REQUIRED_PERMISSIONS, REQUEST_CODE_PERMISSIONS
//            )
//        }
//
//        // Set up capture button listener
//        binding.captureButton.setOnClickListener {
//            takePhoto()
//        }
//
//        // Set up calculate button listener
//        binding.calculateButton.setOnClickListener {
//            val heightText = binding.heightInput.text.toString()
//            if (heightText.isNotEmpty()) {
//                userHeightInCm = heightText.toFloat()
//                poseDetected?.let {
//                    val armLength = calculateArmLength(it)
//                    val chestWidth = calculateChestWidth(it)
//
//                    val sizeRecommendation = getSizeRecommendation(armLength, chestWidth)
//                    binding.sizeResult.text = "Size: $sizeRecommendation"
//                    binding.sizeResult.visibility = View.VISIBLE
//                }
//            }
//        }
//    }
//
//    // Start CameraX preview
//    private fun startCamera() {
//        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)
//
//        cameraProviderFuture.addListener({
//            val cameraProvider: ProcessCameraProvider = cameraProviderFuture.get()
//            val preview = Preview.Builder()
//                .build()
//                .also { it.setSurfaceProvider(binding.cameraPreview.surfaceProvider) }
//
//            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA
//
//            val imageAnalyzer = ImageAnalysis.Builder()
//                .setTargetResolution(Size(1280, 720))
//                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
//                .build()
//                .also {
//                    it.setAnalyzer(cameraExecutor, PoseAnalyzer { imageBitmap, pose ->
//                        // Display captured image and key points
//                        runOnUiThread {
//                            binding.capturedImageView.setImageBitmap(imageBitmap)
//                            binding.capturedImageView.visibility = View.VISIBLE
//                            binding.inputHeightLayout.visibility = View.VISIBLE
//                            poseDetected = pose
//                        }
//                    })
//                }
//
//            cameraProvider.unbindAll()
//            cameraProvider.bindToLifecycle(
//                this, cameraSelector, preview, imageAnalyzer
//            )
//        }, ContextCompat.getMainExecutor(this))
//    }
//
//    private fun takePhoto() {
//        // We don't need to explicitly take a photo since we process each frame live
//    }
//
//    private fun calculateBodyMeasurements() {
//        // Calculate body measurements after detecting pose and user height input
//    }
//
//    // PoseAnalyzer class for detecting poses and analyzing key points
//    private class PoseAnalyzer(val callback: (Bitmap, Pose) -> Unit) : ImageAnalysis.Analyzer {
//        @OptIn(ExperimentalGetImage::class)
//        override fun analyze(imageProxy: ImageProxy) {
//            val mediaImage = imageProxy.image ?: return
//            val rotationDegrees = imageProxy.imageInfo.rotationDegrees
//            val inputImage = InputImage.fromMediaImage(mediaImage, rotationDegrees)
//
//            // Create pose detector
//            val options = PoseDetectorOptions.Builder()
//                .setDetectorMode(PoseDetectorOptions.SINGLE_IMAGE_MODE)
//                .build()
//            val poseDetector = PoseDetection.getClient(options)
//
//            // Process the image
//            poseDetector.process(inputImage)
//                .addOnSuccessListener { pose ->
//                    // Convert imageProxy to Bitmap to show on UI
//                    val bitmap = imageProxy.toBitmap() // Custom method to convert to bitmap
//                    callback(bitmap, pose)
//                }
//                .addOnFailureListener {
//                    // Handle failure
//                }
//                .addOnCompleteListener {
//                    imageProxy.close()
//                }
//        }
//    }
//
//    // Convert Image to Bitmap
//    fun ImageProxy.toBitmap(): Bitmap? {
//        val yBuffer = planes[0].buffer // Y
//        val uBuffer = planes[1].buffer // U
//        val vBuffer = planes[2].buffer // V
//
//        val ySize = yBuffer.remaining()
//        val uSize = uBuffer.remaining()
//        val vSize = vBuffer.remaining()
//
//        val nv21 = ByteArray(ySize + uSize + vSize)
//
//        // U and V are swapped
//        yBuffer.get(nv21, 0, ySize)
//        vBuffer.get(nv21, ySize, vSize)
//        uBuffer.get(nv21, ySize + vSize, uSize)
//
//        val yuvImage = YuvImage(nv21, ImageFormat.NV21, width, height, null)
//        val out = ByteArrayOutputStream()
//        yuvImage.compressToJpeg(android.graphics.Rect(0, 0, width, height), 100, out)
//        val imageBytes = out.toByteArray()
//        return BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
//    }
//
//    private fun calculateArmLength(pose: Pose): Double {
//        val shoulder = pose.getPoseLandmark(PoseLandmark.RIGHT_SHOULDER)
//        val elbow = pose.getPoseLandmark(PoseLandmark.RIGHT_ELBOW)
//        val wrist = pose.getPoseLandmark(PoseLandmark.RIGHT_WRIST)
//
//        if (shoulder != null && elbow != null && wrist != null) {
//            val upperArm = distanceBetween(shoulder.position, elbow.position)
//            val lowerArm = distanceBetween(elbow.position, wrist.position)
//            return upperArm + lowerArm
//        }
//        return 0.0
//    }
//
//    private fun calculateChestWidth(pose: Pose): Double {
//        val rightShoulder = pose.getPoseLandmark(PoseLandmark.RIGHT_SHOULDER)
//        val leftShoulder = pose.getPoseLandmark(PoseLandmark.LEFT_SHOULDER)
//
//        if (rightShoulder != null && leftShoulder != null) {
//            return distanceBetween(leftShoulder.position, rightShoulder.position)
//        }
//        return 0.0
//    }
//
//    private fun distanceBetween(point1: PointF, point2: PointF): Double {
//        return sqrt((point1.x - point2.x).pow(2) + (point1.y - point2.y).pow(2).toDouble())
//    }
//
//    private fun getSizeRecommendation(armLength: Double, chestWidth: Double): String {
//        return when {
//            chestWidth < 30 -> "S"
//            chestWidth < 40 -> "M"
//            chestWidth < 50 -> "L"
//            else -> "XL"
//        }
//    }
//
//    private fun allPermissionsGranted() = REQUIRED_PERMISSIONS.all {
//        ContextCompat.checkSelfPermission(
//            baseContext, it
//        ) == PackageManager.PERMISSION_GRANTED
//    }
//
//    override fun onRequestPermissionsResult(
//        requestCode: Int, permissions: Array<String>, grantResults: IntArray
//    ) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
//        if (requestCode == REQUEST_CODE_PERMISSIONS) {
//            if (allPermissionsGranted()) {
//                startCamera()
//            } else {
//                finish()
//            }
//        }
//    }
//
//    companion object {
//        private const val REQUEST_CODE_PERMISSIONS = 10
//        private val REQUIRED_PERMISSIONS = arrayOf(Manifest.permission.CAMERA)
//    }
//}
package com.karthikinformationtechnology.tailorfitandroid

import android.Manifest
import android.content.pm.PackageManager
import android.graphics.*
import android.media.Image
import android.os.Bundle
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.pose.Pose
import com.google.mlkit.vision.pose.PoseDetection
import com.google.mlkit.vision.pose.defaults.PoseDetectorOptions
import com.karthikinformationtechnology.tailorfitandroid.databinding.ActivityMainBinding
import kotlin.math.pow
import kotlin.math.sqrt
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import android.util.Size
import android.view.View
import com.google.mlkit.vision.pose.PoseLandmark
import java.io.ByteArrayOutputStream

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var cameraExecutor: ExecutorService

    private var userHeightInCm: Float = 0f
    private var poseDetected: Pose? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // View binding setup
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        cameraExecutor = Executors.newSingleThreadExecutor()

        // Request camera permissions
        if (allPermissionsGranted()) {
            startCamera()
        } else {
            ActivityCompat.requestPermissions(
                this, REQUIRED_PERMISSIONS, REQUEST_CODE_PERMISSIONS
            )
        }

        // Set up capture button listener
        binding.captureButton.setOnClickListener {
            takePhoto()
        }

        // Set up height input button listener
        binding.inputHeightButton.setOnClickListener {
            HeightInputDialogFragment { height ->
                userHeightInCm = height
                calculateAndDisplaySize()
            }.show(supportFragmentManager, "HeightInputDialog")
        }
    }

    // Start CameraX preview
    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({
            val cameraProvider: ProcessCameraProvider = cameraProviderFuture.get()
            val preview = Preview.Builder()
                .build()
                .also { it.setSurfaceProvider(binding.cameraPreview.surfaceProvider) }

            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

            val imageAnalyzer = ImageAnalysis.Builder()
                .setTargetResolution(Size(1280, 720))
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build()
                .also {
                    it.setAnalyzer(cameraExecutor, PoseAnalyzer { imageBitmap, pose ->
                        // Display captured image and key points
                        runOnUiThread {
                            binding.capturedImageView.setImageBitmap(imageBitmap)
                            binding.capturedImageView.visibility = View.VISIBLE
                            poseDetected = pose
                        }
                    })
                }

            cameraProvider.unbindAll()
            cameraProvider.bindToLifecycle(
                this, cameraSelector, preview, imageAnalyzer
            )
        }, ContextCompat.getMainExecutor(this))
    }

    private fun takePhoto() {
        // We don't need to explicitly take a photo since we process each frame live
    }

    private fun calculateAndDisplaySize() {
        poseDetected?.let {
            val armLength = calculateArmLength(it)
            val chestWidth = calculateChestWidth(it)

            val sizeRecommendation = getSizeRecommendation(armLength, chestWidth)
            binding.sizeResult.text = "Size: $sizeRecommendation"
            binding.sizeResult.visibility = View.VISIBLE
        }
    }

    // PoseAnalyzer class for detecting poses and analyzing key points
    private class PoseAnalyzer(val callback: (Bitmap, Pose) -> Unit) : ImageAnalysis.Analyzer {
        @OptIn(ExperimentalGetImage::class)
        override fun analyze(imageProxy: ImageProxy) {
            val mediaImage = imageProxy.image ?: return
            val rotationDegrees = imageProxy.imageInfo.rotationDegrees
            val inputImage = InputImage.fromMediaImage(mediaImage, rotationDegrees)

            // Create pose detector
            val options = PoseDetectorOptions.Builder()
                .setDetectorMode(PoseDetectorOptions.SINGLE_IMAGE_MODE)
                .build()
            val poseDetector = PoseDetection.getClient(options)

            // Process the image
            poseDetector.process(inputImage)
                .addOnSuccessListener { pose ->
                    // Convert imageProxy to Bitmap to show on UI
                    val bitmap = imageProxy.toBitmap() // Custom method to convert to bitmap
                    callback(bitmap, pose)
                }
                .addOnFailureListener {
                    // Handle failure
                }
                .addOnCompleteListener {
                    imageProxy.close()
                }
        }
    }

    // Convert ImageProxy to Bitmap
    fun ImageProxy.toBitmap(): Bitmap? {
        val yBuffer = planes[0].buffer // Y
        val uBuffer = planes[1].buffer // U
        val vBuffer = planes[2].buffer // V

        val ySize = yBuffer.remaining()
        val uSize = uBuffer.remaining()
        val vSize = vBuffer.remaining()

        val nv21 = ByteArray(ySize + uSize + vSize)

        // U and V are swapped
        yBuffer.get(nv21, 0, ySize)
        vBuffer.get(nv21, ySize, vSize)
        uBuffer.get(nv21, ySize + vSize, uSize)

        val yuvImage = YuvImage(nv21, ImageFormat.NV21, width, height, null)
        val out = ByteArrayOutputStream()
        yuvImage.compressToJpeg(android.graphics.Rect(0, 0, width, height), 100, out)
        val imageBytes = out.toByteArray()
        return BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
    }

    private fun calculateArmLength(pose: Pose): Double {
        val shoulder = pose.getPoseLandmark(PoseLandmark.RIGHT_SHOULDER)
        val elbow = pose.getPoseLandmark(PoseLandmark.RIGHT_ELBOW)
        val wrist = pose.getPoseLandmark(PoseLandmark.RIGHT_WRIST)

        if (shoulder != null && elbow != null && wrist != null) {
            val upperArm = distanceBetween(shoulder.position, elbow.position)
            val lowerArm = distanceBetween(elbow.position, wrist.position)
            return upperArm + lowerArm
        }
        return 0.0
    }

    private fun calculateChestWidth(pose: Pose): Double {
        val rightShoulder = pose.getPoseLandmark(PoseLandmark.RIGHT_SHOULDER)
        val leftShoulder = pose.getPoseLandmark(PoseLandmark.LEFT_SHOULDER)

        if (rightShoulder != null && leftShoulder != null) {
            return distanceBetween(leftShoulder.position, rightShoulder.position)
        }
        return 0.0
    }

    private fun distanceBetween(point1: PointF, point2: PointF): Double {
        return sqrt((point1.x - point2.x).pow(2) + (point1.y - point2.y).pow(2).toDouble())
    }

    private fun getSizeRecommendation(armLength: Double, chestWidth: Double): String {
        return when {
            chestWidth < 30 -> "S"
            chestWidth < 40 -> "M"
            chestWidth < 50 -> "L"
            else -> "XL"
        }
    }

    private fun allPermissionsGranted() = REQUIRED_PERMISSIONS.all {
        ContextCompat.checkSelfPermission(
            baseContext, it
        ) == PackageManager.PERMISSION_GRANTED
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<String>, grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CODE_PERMISSIONS) {
            if (allPermissionsGranted()) {
                startCamera()
            } else {
                finish()
            }
        }
    }

    companion object {
        private const val REQUEST_CODE_PERMISSIONS = 10
        private val REQUIRED_PERMISSIONS = arrayOf(Manifest.permission.CAMERA)
    }
}
