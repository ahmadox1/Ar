package com.ar.memory.data

import kotlinx.coroutines.flow.Flow

class MemoryRepository(private val memoryDao: MemoryDao) {
    
    val allMemories: Flow<List<Memory>> = memoryDao.getAllMemories()

    suspend fun insert(memory: Memory): Long {
        return memoryDao.insert(memory)
    }

    suspend fun getMemoryById(id: Long): Memory? {
        return memoryDao.getMemoryById(id)
    }

    suspend fun deleteMemory(id: Long) {
        memoryDao.deleteMemory(id)
    }
}
