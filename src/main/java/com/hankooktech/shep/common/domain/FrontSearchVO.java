package com.hankooktech.shep.common.domain;


import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Alias("frontSearch") @Getter @Setter @ToString
public class FrontSearchVO extends FrontPagingVO {
	private String pageType; //ex quickorder
	private String userid;
	private String orgcode;
	private String shipto;
	private String soldto;
	private String customercd;
	private String customername;
	private String searchshipto;
	private String countrycode;
	private String searchoption;
	private String custtype;
	private String sapitemid;
	private String searchword;
	private String description;
	private String backorder;
	private String fromdate;
	private String todate;
	private String deliverydate;
	private String ponumber;
	private String invoiceno;
	private String ordernumber;
	private String outstanding;
	private String ordertype;
	private String custcode;
	private String soldtocd;
	private String shiptocd;
	private String shipcond;
	private String plantid;
	private String[] sapitemids;
	private String[] inputqtys;
	private String[] patterns;
	private String[] customers;
	private String zflag;
	
	private String localline;
	private String pattern;
    private String size;
}
