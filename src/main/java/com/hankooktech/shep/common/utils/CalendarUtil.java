package com.hankooktech.shep.common.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CalendarUtil {
	
	private Calendar cal = Calendar.getInstance();
	private SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

	// 당일
	public String getToDay(Date now) {
		return getDay(now, 0);
	}

	// 어제
	public String getYesterDay(Date now) {
		return getDay(now, -1);
	}

	// 날짜 계산 함수
	public String getDay(Date now, Integer day) {
		cal.setTime(now);
		if (day!=null) cal.add(Calendar.DATE, day);
		return sf.format(cal.getTime());
	}

	// 전월 1일
	public String getPreviousMonth(Date now) {
		return getMonth(now, -1);
	}

	// 다음달 1일
	public String getNextMonth(Date now) {
		return getMonth(now, 1);
	}

	public String getMonth(Date now, Integer month) {
		cal.setTime(now);
		if (month!=null) {
			cal.add(Calendar.MONTH, month);
		}
		return sf.format(cal.getTime());
	}

	// 전월 1일 (month=-1)
	// 전전월 1일 (month=-2)
	public String getMonthMinDay(Date now, Integer month) {
		cal.setTime(now);
		if (month!=null) {
			cal.add(Calendar.MONTH, month);
		}
		cal.set(Calendar.DAY_OF_MONTH, cal.getActualMinimum(Calendar.DAY_OF_MONTH));
		return sf.format(cal.getTime());
	}

	public String getMonthMaxDay(Date now, Integer month) {
		cal.setTime(now);
		if (month!=null) {
			cal.add(Calendar.MONTH, month);
		}
		cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
		return sf.format(cal.getTime());
	}

	public String getYear(Date now, Integer year) {
		cal.setTime(now);
		if (year!=null) {
			cal.add(Calendar.YEAR, year);
		}
		return sf.format(cal.getTime());
	}

	// 전년 1일 (year=-1)
	// 전전년 1일 (year=-2)
	public String getYearMinDay(Date now, Integer year) {
		cal.setTime(now);
		if (year!=null) {
			cal.add(Calendar.YEAR, year);
		}
		cal.set(Calendar.DAY_OF_MONTH, cal.getActualMinimum(Calendar.DAY_OF_MONTH));
		return sf.format(cal.getTime());
	}

	public String getYearMaxDay(Date now, Integer year) {
		cal.setTime(now);
		if (year!=null) {
			cal.add(Calendar.YEAR, year);
		}
		cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
		return sf.format(cal.getTime());
	}

	public String getDateString(Date now, Integer year, Integer month, Integer day) {
		cal.setTime(now);
		if (year!=null) {
			cal.add(Calendar.YEAR, year);
		}
		if (month!=null) {
			cal.add(Calendar.MONTH, month);
		}
		if (day!=null) cal.add(Calendar.DATE, day);
		return sf.format(cal.getTime());
	}

	public String getMinYearString(Date now, Integer year, Integer adjustValue) {
		cal.setTime(now);
		if (year!=null) {
			cal.add(Calendar.YEAR, year);
			cal.set(Calendar.DAY_OF_YEAR, cal.getActualMinimum(Calendar.DAY_OF_YEAR));
		}
		if (adjustValue!=null) {
			cal.add(Calendar.MONTH, adjustValue);
		}
		return sf.format(cal.getTime());
	}

	public String getMaxYearString(Date now, Integer year, Integer adjustValue) {
		cal.setTime(now);
		if (year!=null) {
			cal.add(Calendar.YEAR, year);
			cal.set(Calendar.DAY_OF_YEAR, cal.getActualMaximum(Calendar.DAY_OF_YEAR));
		}
		if (adjustValue!=null) {
			cal.add(Calendar.MONTH, adjustValue);
		}
		return sf.format(cal.getTime());
	}

	public String getMinMonthString(Date now, Integer month, Integer adjustValue) {
		cal.setTime(now);
		if (month!=null) {
			cal.add(Calendar.MONTH, month);
			cal.set(Calendar.DAY_OF_MONTH, cal.getActualMinimum(Calendar.DAY_OF_MONTH));
		}
		if (adjustValue!=null) {
			cal.add(Calendar.MONTH, adjustValue);
		}
		return sf.format(cal.getTime());
	}

	public String getMaxMonthString(Date now, Integer month, Integer adjustValue) {
		cal.setTime(now);
		if (month!=null) {
			cal.add(Calendar.MONTH, month);
			cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
		}
		if (adjustValue!=null) {
			cal.add(Calendar.MONTH, adjustValue);
		}
		return sf.format(cal.getTime());
	}
	
	public String getLast(Date now, Integer month, Integer adjustValue) {
		cal.setTime(now);
		if (month!=null) {
			cal.add(Calendar.MONTH, month);
			cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
		}
		if (adjustValue!=null) {
			cal.add(Calendar.MONTH, adjustValue);
		}
		return sf.format(cal.getTime());
	}
	
	public String getYearMonthFirstDay(Date now, Integer month) {
		cal.setTime(now);
		cal.set(Calendar.MONTH, month-1);
		cal.set(Calendar.DAY_OF_MONTH, cal.getActualMinimum(Calendar.DAY_OF_MONTH));
		return sf.format(cal.getTime());
	}
	
	public String getYearMonthLastDay(Date now, Integer month) {
		cal.setTime(now);
		cal.set(Calendar.MONTH, month-1);
		cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
		return sf.format(cal.getTime());
	}
	
	/**
	 * getDate
	 * 
	 * @param cal
	 * @param pattern
	 * @return
	 */
	private static String getDate(GregorianCalendar cal, String pattern) {
		SimpleDateFormat formatter = new SimpleDateFormat(pattern);
		return formatter.format(cal.getTime());
	}
	
	/**
	 * getNowDate
	 * 
	 * @param pattern
	 * @return
	 */
	public static String getNowDate(String pattern) {
		GregorianCalendar cal = new GregorianCalendar();
		return getDate(cal, pattern);
	}
	
	/**
	 * changeFormatDatesSring
	 * 
	 * @param src
	 * @param pattern
	 * @return
	 */
	public static String changeFormatDatesSring(String src, String src_patt, String dest_patt) {
		SimpleDateFormat formatter = new SimpleDateFormat(src_patt);
		GregorianCalendar cal = new GregorianCalendar(); 
		try {
			cal.setTime(formatter.parse(src));
		} catch (ParseException e) {
			e.printStackTrace();
			return "";
		}
		return getDate(cal, dest_patt);
	}
	
	/**
	 * getDateAsAddMonth
	 * 
	 * @param pattern
	 * @param amt
	 * @return
	 */
	public static String getDateAsAddMonth(String pattern, int amt) {
		GregorianCalendar cal = new GregorianCalendar();
		cal.add(GregorianCalendar.MONTH, amt);
		return  getDate(cal, pattern);
	}
	
	
	/**
	 * getDateAdded
	 * 
	 * @param baseDate (yyyyMMdd)
	 * @param amt
	 * @return
	 */
	public static GregorianCalendar getDateNow(String baseDate) {
		GregorianCalendar cal = null;
		try {
			if (baseDate != null && baseDate.length() == 8) {
				cal = new GregorianCalendar(Integer.parseInt(baseDate.substring(0, 4)), 1 - Integer.parseInt(baseDate.substring(4, 6)), Integer.parseInt(baseDate.substring(6, 8)));
			} 
			else if (baseDate != null && baseDate.length() == 6) {
				cal = new GregorianCalendar(Integer.parseInt(baseDate.substring(0, 4)), Integer.parseInt(baseDate.substring(4, 6)) - 1, 1);
			} 
			else {
				cal = new GregorianCalendar();
			}
		} catch (Exception e) {
			cal = new GregorianCalendar();
		}
		
		return  cal;
	}
	
	
	/**
	 * getDateAdded
	 * 
	 * @param baseDate (yyyyMMdd)
	 * @param amt
	 * @return
	 */
	public static String getDateAdded(String baseDate, int amt, String pattern) {
		GregorianCalendar cal = null;
		
		cal = getDateNow(baseDate);
		cal.add(Calendar.DATE, amt);
		
		return  getDate(cal, pattern);
	}
	
	
	/**
	 * getDateAdded
	 * 
	 * @param baseDate (yyyyMMdd)
	 * @param amt
	 * @return
	 */
	public static String getDateAdded(String baseDate, int amt) {
		return getDateAdded(baseDate, amt, "yyyyMMdd");
	}
	
	
	/**
	 * getFirstDateOfMonth
	 * 
	 * @param baseYearMonth (yyyyMM)
	 * @param amt
	 * @return
	 */
	public static String getFirstDateOfMonth(String baseYearMonth) {
		GregorianCalendar cal = null;
		
		cal = getDateNow(baseYearMonth);
		
		return getDate(cal, "yyyyMM") + "01";
	}
	
	
	/**
	 * getLastDateOfMonth
	 * 
	 * @param baseYearMonth (yyyyMM)
	 * @param amt
	 * @return
	 */
	public static String getLastDateOfMonth(String baseYearMonth) {
		GregorianCalendar cal = null;
		
		cal = getDateNow(baseYearMonth);
		
		return getDate(cal, "yyyyMM") + cal.getActualMaximum(Calendar.DAY_OF_MONTH);
	}
	
	
	/**
	 * getRangeYears
	 * 
	 * @param range
	 * @return
	 */
	public static String[] getRangeYears(int range) {
		String pattern = "yyyy";
		String[] res = new String[range + 1];
		GregorianCalendar cal = new GregorianCalendar();
		for (int i = 0; i <= range; i++) {
			if (i == 0) {
				cal.add(GregorianCalendar.YEAR, -1);
				res[i] = getDate(cal, pattern);
			} else {
				cal.add(GregorianCalendar.YEAR, +1);
				res[i] = getDate(cal, pattern);
			}
		}
		return res;
	}
}
