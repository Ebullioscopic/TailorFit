package com.karthikinformationtechnology.tailorfitandroid

import android.Manifest
import android.graphics.Bitmap
import android.graphics.ImageDecoder
import android.graphics.PointF
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.TextView
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.pose.Pose
import com.google.mlkit.vision.pose.PoseDetection
import com.google.mlkit.vision.pose.PoseDetectorOptions
import com.google.mlkit.vision.pose.PoseLandmark
import com.google.mlkit.vision.pose.defaults.PoseDetectorOptions
import java.io.File
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MainActivity : AppCompatActivity() {
    private lateinit var imageCapture: ImageCapture
    private lateinit var cameraExecutor: ExecutorService
    private lateinit var resultTextView: TextView
    private lateinit var poseDetector: PoseDetector

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val previewView = findViewById<PreviewView>(R.id.previewView)
        val captureButton = findViewById<Button>(R.id.captureButton)
        resultTextView = findViewById(R.id.measurementText)

        cameraExecutor = Executors.newSingleThreadExecutor()

        // Initialize the pose detector
        val poseDetectorOptions = PoseDetectorOptions.Builder()
            .setDetectorMode(PoseDetectorOptions.STREAM_MODE)
            .build()
        poseDetector = PoseDetection.getClient(poseDetectorOptions)

        val requestPermissionLauncher = registerForActivityResult(
            ActivityResultContracts.RequestPermission()
        ) { isGranted: Boolean ->
            if (isGranted) {
                startCamera(previewView)
            }
        }
        requestPermissionLauncher.launch(Manifest.permission.CAMERA)

        captureButton.setOnClickListener {
            takePicture()
        }
    }

    private fun startCamera(previewView: PreviewView) {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)
        cameraProviderFuture.addListener({
            val cameraProvider = cameraProviderFuture.get()
            val preview = Preview.Builder().build().also {
                it.setSurfaceProvider(previewView.surfaceProvider)
            }

            imageCapture = ImageCapture.Builder().build()
            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

            try {
                cameraProvider.unbindAll()
                cameraProvider.bindToLifecycle(this, cameraSelector, preview, imageCapture)
            } catch (e: Exception) {
                Log.e("CameraX", "Camera binding failed", e)
            }
        }, ContextCompat.getMainExecutor(this))
    }

    private fun takePicture() {
        val outputOptions = ImageCapture.OutputFileOptions.Builder(
            File(externalMediaDirs.first(), "${System.currentTimeMillis()}.jpg")
        ).build()

        imageCapture.takePicture(
            outputOptions,
            ContextCompat.getMainExecutor(this),
            object : ImageCapture.OnImageSavedCallback {
                override fun onError(exception: ImageCaptureException) {
                    Log.e("CameraX", "Image capture failed", exception)
                }

                override fun onImageSaved(outputFileResults: ImageCapture.OutputFileResults) {
                    val imageUri = outputFileResults.savedUri
                    Log.d("CameraX", "Image saved at: $imageUri")

                    // Process the image
                    imageUri?.let { uri ->
                        processImage(uri)
                    }
                }
            }
        )
    }

    private fun processImage(imageUri: Uri) {
        // Decode the image
        val source = ImageDecoder.createSource(contentResolver, imageUri)
        val bitmap = ImageDecoder.decodeBitmap(source)

        // Create an InputImage from the Bitmap
        val inputImage = InputImage.fromBitmap(bitmap, 0)

        // Run pose detection
        poseDetector.process(inputImage)
            .addOnSuccessListener { pose ->
                analyzePose(pose)
            }
            .addOnFailureListener { e ->
                Log.e("Pose Detection", "Pose detection failed", e)
            }
    }

    private fun analyzePose(pose: Pose) {
        val landmarks = pose.allLandmarks

        // Calculate measurements (Example: shoulder width and height)
        val leftShoulder = landmarks.firstOrNull { it.landmarkType == PoseLandmark.LEFT_SHOULDER }
        val rightShoulder = landmarks.firstOrNull { it.landmarkType == PoseLandmark.RIGHT_SHOULDER }
        val leftHip = landmarks.firstOrNull { it.landmarkType == PoseLandmark.LEFT_HIP }
        val rightHip = landmarks.firstOrNull { it.landmarkType == PoseLandmark.RIGHT_HIP }

        if (leftShoulder != null && rightShoulder != null && leftHip != null && rightHip != null) {
            // Calculate shoulder width
            val shoulderWidth = calculateDistance(leftShoulder.position, rightShoulder.position)
            // Calculate hip width
            val hipWidth = calculateDistance(leftHip.position, rightHip.position)

            // Display the results
            resultTextView.text = "Shoulder Width: ${shoulderWidth} units\nHip Width: ${hipWidth} units"
        } else {
            resultTextView.text = "Could not detect all landmarks."
        }
    }

    private fun calculateDistance(pos1: PointF, pos2: PointF): Float {
        return Math.sqrt(
            Math.pow((pos1.x - pos2.x).toDouble(), 2.0) +
                    Math.pow((pos1.y - pos2.y).toDouble(), 2.0)
        ).toFloat()
    }

    override fun onDestroy() {
        super.onDestroy()
        cameraExecutor.shutdown()
        poseDetector.close()
    }
}
