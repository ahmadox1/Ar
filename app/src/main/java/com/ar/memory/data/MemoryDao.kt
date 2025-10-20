package com.ar.memory.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface MemoryDao {
    @Insert
    suspend fun insert(memory: Memory): Long

    @Query("SELECT * FROM memories ORDER BY timestamp DESC")
    fun getAllMemories(): Flow<List<Memory>>

    @Query("SELECT * FROM memories WHERE id = :id")
    suspend fun getMemoryById(id: Long): Memory?

    @Query("DELETE FROM memories WHERE id = :id")
    suspend fun deleteMemory(id: Long)
}
