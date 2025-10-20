package com.ar.memory.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "memories")
data class Memory(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val text: String,
    val latitude: Double,
    val longitude: Double,
    val timestamp: Long = System.currentTimeMillis()
)
