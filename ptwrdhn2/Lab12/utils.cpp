#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t block_offset_bits = cache_config.get_num_block_offset_bits();
  uint32_t tag_bits = cache_config.get_num_tag_bits();
  uint32_t index_bits = cache_config.get_num_index_bits();
  uint32_t mask = ((1 << tag_bits) - 1) << (block_offset_bits + index_bits);
  if(tag_bits < 32) return (address & mask) >> (index_bits + block_offset_bits);
  return address;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t block_offset_bits = cache_config.get_num_block_offset_bits();
  // uint32_t tag_bits = cache_config.get_num_tag_bits();
  uint32_t index_bits = cache_config.get_num_index_bits();
  uint32_t mask = ((1 << index_bits) - 1) << (block_offset_bits);
  if(index_bits < 32 )return (address & mask) >> (block_offset_bits);
  return 0;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t block_offset_bits = cache_config.get_num_block_offset_bits();
  // uint32_t tag_bits = cache_config.get_num_tag_bits();
  // uint32_t index_bits = cache_config.get_num_index_bits();
  uint32_t mask = ((1 << block_offset_bits) - 1);
  if(block_offset_bits < 32) return (address & mask);
  return 0;
}
