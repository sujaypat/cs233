#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
	// TODO
	auto config = this->_cache_config;
	uint32_t block_offset = 0;
	uint32_t index = this->_index << config.get_num_block_offset_bits();
	uint32_t tag = this->get_tag() << (config.get_num_index_bits() + config.get_num_block_offset_bits());
	return (tag | index | block_offset);
	// return 0;
}
