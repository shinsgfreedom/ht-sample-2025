package com.hankooktech.shep.common.result;

import org.apache.commons.collections.map.ListOrderedMap;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hankooktech.shep.common.utils.CamelUtil;


public class HTDataMap extends ListOrderedMap {

	private static final long serialVersionUID = 1L;
 
	@Override
	public Object put(Object key, Object value) {
		return super.put(CamelUtil.convert2CamelCase((String) key), value);
	}

	public int getInt(String key) {
		return getInt(key, 0);
	}
	
	public int getInt(String key, int def) {
		try {
			return Integer.parseInt(super.get(key).toString().trim());
		}catch(Exception e) {
			return def;
		}
	}
	
	public Integer getInteger(String key) {
		return getInteger(key, null);
	}
	
	public Integer getInteger(String key, Integer def) {
		try {
			return Integer.parseInt(super.get(key).toString().trim());
		}catch(Exception e) {
			return def;
		}
	}
	
	public String getString(String key) {
		return getString(key, null);
	}
	
	public String getString(String key, String def) {
		try {
			return super.get(key).toString().trim();
		}catch(Exception e) {
			return def;
		}
	}
	
	public String toJsonString() {
		String json;
		try {
			json = new ObjectMapper().writeValueAsString(this);
		} catch (Exception e) {
			json ="{\"error\": \""+e.getMessage()+"\"}";
		}
		
		return json;
	}
	
}
