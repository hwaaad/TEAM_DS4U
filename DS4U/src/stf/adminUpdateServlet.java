package stf;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class adminUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String STF_ID = request.getParameter("STF_ID");
		String STF_DEP = request.getParameter("STF_DEP");
		HttpSession session = request.getSession();
		String STF_ADM = request.getParameter("STF_ADM");
		if (STF_ID == null || STF_ID.equals("") || STF_ADM == null || STF_ADM.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력하세요.");
			response.sendRedirect("stfManage.jsp");
			return;
		}
		/*if (!STF_ID.equals((String) session.getAttribute("STF_ID"))) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;	
		}*/
		System.out.println(STF_DEP);
		String changeID = (String) session.getAttribute("STF_ID");
		int result;
		if(STF_ADM.equals("관리자"))
			result = new StfDAO().dep_Update(STF_ID, "부서4");
		else
			result = new StfDAO().dep_Update(changeID, STF_DEP);
		if (result==1) {
			request.getSession().setAttribute("STF_ID", changeID);
			request.getSession().setAttribute("messageType", "성공 메시지");
			request.getSession().setAttribute("messageContent", "회원정보 수정에 성공했습니다.");
			response.sendRedirect("index.jsp");
		}
		else {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "DB 오류가 발생했습니다.");
			response.sendRedirect("stfManage.jsp");
		}
	}
	
}
