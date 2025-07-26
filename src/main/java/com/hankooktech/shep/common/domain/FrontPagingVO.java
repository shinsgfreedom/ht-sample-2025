package com.hankooktech.shep.common.domain;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Alias("paging") @Getter @Setter @ToString
public class FrontPagingVO {
	private int pageNo = 1;				/** 페이징 */
	private int pageSize = 15;
	private int totalCount = 0;
	private int totalPage = 0;
	private int startPage = 0;
	private int endPage = 15;
	private int blockSize = 10; 
	private int startBlock = 0;
	private int endBlock = 0;
	
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
