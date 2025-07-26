package com.hankooktech.shep.common.domain;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;


@Getter 
@Setter
public class SearchVO extends CommonVO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private int pageNo = 1;				/** 페이징 */
	private int pageSize = 15;
	private int totalCount = 0;
	private int totalPage = 0;
	private int startPage = 0;
	private int endPage = 15;
	private int blockSize = 10; 
	private int startBlock = 0;
	private int endBlock = 0;
	
	private String searchWord;				/** 검색조건 */ 
	private String searchOption;
	private String searchWord2;
	private String searchOption2;
	private String searchWord3;
	private String searchOption3;
	private String searchWord4;
	private String searchOption4;
	private String searchWord5;
	private String searchOption5;
	private String searchWord6;
	private String searchOption6;
	private String searchWord7;
	private String searchOption7;
	private String searchWord8;
	private String searchOption8;
	private String searchWord9;
	private String searchOption9;
	private String searchWord10;
	private String searchOption10;
	
	public void calculation() {
		
		this.totalPage = ( this.totalCount / this.pageSize ) + 1;
		this.startPage = ( (this.pageNo > 0 ? this.pageNo : 1) - 1 ) * this.pageSize;
		this.endPage =  this.pageSize;
		
		if( this.totalCount % this.pageSize == 0 ){
			this.totalPage--;
		}
		
		int totalBlock = (int)Math.ceil( this.totalCount / (double) this.pageSize );
		this.startBlock = (( this.pageNo - 1) / this.blockSize * this.blockSize ) + 1;
		this.endBlock = (( this.pageNo - 1 ) / this.blockSize * this.blockSize ) + this.blockSize;
		
		if ( this.endBlock > totalBlock ){
			this.endBlock = totalBlock;
		}
	}

}