package com.hankooktech.shep.common.result;

import java.util.ArrayList;

import com.hankooktech.shep.common.domain.FrontSearchVO;
import com.hankooktech.shep.common.domain.SearchVO;

import lombok.ToString;


@ToString
public class HTDataList extends ArrayList<HTDataMap> {

	private static final long serialVersionUID = 1L;
	 
	public HTDataMap getPage(SearchVO searchVO){
		
		HTDataMap page = null;
		int totalCount = 0;
		
		if ( this.size() > 0 ) {
			
			HTDataMap data = this.get(0);
			
			if ( null != data.get("totalcount") ) {
				totalCount = Integer.parseInt( data.get("totalcount").toString() );
			}
			
			if ( null != searchVO ) {
				
				page = new HTDataMap();
				
				searchVO.setTotalCount(totalCount);
				searchVO.calculation();

				page.put("listCount", searchVO.getTotalCount());	// 전체 게시물 수
				page.put("pageCount", searchVO.getTotalPage());   	// 전체 페이지 수
				page.put("pageNo", searchVO.getPageNo());		 	// 현재 페이지 번호
				
			}
			
		}
		
		return page;
	}
	
	/**
	 * getPage
	 * 
	 * @param frontSearch
	 * @return
	 */
	public HTDataMap getPage(FrontSearchVO frontSearch){
		
		HTDataMap page = null;
		int totalCount = 0;
		
		if ( this.size() > 0 ) {
			
			HTDataMap data = this.get(0);
			
			if ( null != data.get("totalcount") ) {
				totalCount = Integer.parseInt( data.get("totalcount").toString() );
			}
			
			if ( null != frontSearch ) {
				
				page = new HTDataMap();
				
				if (1 > frontSearch.getTotalCount()) {
					frontSearch.setTotalCount(totalCount);
				}
				
				frontSearch.calculation();
				
				page.put("listCount", frontSearch.getTotalCount());	// 전체 게시물 수
				page.put("pageCount", frontSearch.getTotalPage());   	// 전체 페이지 수
				page.put("blockSize", frontSearch.getBlockSize());     // 페이지 블럭 사이즈
				page.put("pageNo", frontSearch.getPageNo());		 	// 현재 페이지 번호
				
			}
			
		}
		
		return page;
	}

}