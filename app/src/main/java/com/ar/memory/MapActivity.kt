package com.ar.memory

import android.Manifest
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.lifecycle.lifecycleScope
import com.ar.memory.data.MemoryDatabase
import com.ar.memory.data.MemoryRepository
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import kotlinx.coroutines.launch

class MapActivity : AppCompatActivity(), OnMapReadyCallback {
    private lateinit var map: GoogleMap
    private lateinit var repository: MemoryRepository

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_map)

        // Initialize database
        val database = MemoryDatabase.getDatabase(applicationContext)
        repository = MemoryRepository(database.memoryDao())

        // Obtain the SupportMapFragment and get notified when the map is ready to be used
        val mapFragment = supportFragmentManager
            .findFragmentById(R.id.mapFragment) as SupportMapFragment
        mapFragment.getMapAsync(this)
    }

    @SuppressLint("MissingPermission")
    override fun onMapReady(googleMap: GoogleMap) {
        map = googleMap

        // Enable location if permission is granted
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            map.isMyLocationEnabled = true
        }

        // Load and display memories on the map
        loadMemories()
    }

    private fun loadMemories() {
        lifecycleScope.launch {
            repository.allMemories.collect { memories ->
                runOnUiThread {
                    map.clear()
                    memories.forEach { memory ->
                        val position = LatLng(memory.latitude, memory.longitude)
                        map.addMarker(
                            MarkerOptions()
                                .position(position)
                                .title(memory.text)
                                .snippet("Saved at ${memory.timestamp}")
                        )
                    }

                    // Move camera to first memory if available
                    if (memories.isNotEmpty()) {
                        val firstMemory = memories.first()
                        val position = LatLng(firstMemory.latitude, firstMemory.longitude)
                        map.moveCamera(CameraUpdateFactory.newLatLngZoom(position, 15f))
                    }
                }
            }
        }
    }
}
