package com.ar.memory

import android.annotation.SuppressLint
import android.location.Location
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.ar.memory.data.Memory
import com.ar.memory.data.MemoryDatabase
import com.ar.memory.data.MemoryRepository
import com.ar.memory.databinding.ActivityArCameraBinding
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import kotlinx.coroutines.launch

class ARCameraActivity : AppCompatActivity() {
    private lateinit var binding: ActivityArCameraBinding
    private lateinit var repository: MemoryRepository
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private var currentLocation: Location? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityArCameraBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Initialize database
        val database = MemoryDatabase.getDatabase(applicationContext)
        repository = MemoryRepository(database.memoryDao())

        // Initialize location client
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        
        getCurrentLocation()

        binding.btnSaveMemory.setOnClickListener {
            saveMemory()
        }

        binding.btnCancel.setOnClickListener {
            finish()
        }
    }

    @SuppressLint("MissingPermission")
    private fun getCurrentLocation() {
        fusedLocationClient.lastLocation
            .addOnSuccessListener { location: Location? ->
                currentLocation = location
                if (location == null) {
                    Toast.makeText(
                        this,
                        "Unable to get location",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
    }

    private fun saveMemory() {
        val memoryText = binding.memoryInput.text.toString().trim()
        
        if (memoryText.isEmpty()) {
            Toast.makeText(this, "Please enter a memory", Toast.LENGTH_SHORT).show()
            return
        }

        val location = currentLocation
        if (location == null) {
            Toast.makeText(this, "Location not available", Toast.LENGTH_SHORT).show()
            return
        }

        val memory = Memory(
            text = memoryText,
            latitude = location.latitude,
            longitude = location.longitude
        )

        lifecycleScope.launch {
            repository.insert(memory)
            runOnUiThread {
                Toast.makeText(
                    this@ARCameraActivity,
                    getString(R.string.memory_saved),
                    Toast.LENGTH_SHORT
                ).show()
                binding.memoryInput.text.clear()
            }
        }
    }
}
