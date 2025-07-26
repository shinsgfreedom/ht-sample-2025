<%@ page import="java.net.URLDecoder" %>

<%
   String urlName = "returnUrl=";   
   String returnUrl = getNextUrl(request.getQueryString() != null ? request.getQueryString() : request.getParameter("returnUrl"), urlName);
   
   try {
      
      returnUrl = URLDecoder.decode(returnUrl, "UTF-8");

      Object userSessionDTO = session.getAttribute("USER_SESSION");
      if(userSessionDTO!=null) {
         response.sendRedirect(returnUrl);
         return;
      }
      
      String referer = request.getHeader("referer");
      session.setAttribute("AREANREFERER", referer);   
      
   } catch(Exception e) {}
   
   returnUrl = returnUrl.replaceAll("\\$", "\\&");
   System.out.println(" ### returnUrl : "+returnUrl);

   /************************************************************
    *   ReturnURL 설정
    ************************************************************/   
   if (!returnUrl.trim().equals("")) session.setAttribute("returnURL", returnUrl);   
   response.sendRedirect("business.jsp");

%>

<%!
   public String getNextUrl(String fullPath, String urlName) {       
      if(null == fullPath) return "";
      int idx = fullPath.indexOf(urlName);
      String nextURL = "";
      if(idx > -1)
         nextURL =  fullPath.substring(idx+urlName.length());
      else 
         nextURL = fullPath;
      
      return nextURL;
   }
%>  