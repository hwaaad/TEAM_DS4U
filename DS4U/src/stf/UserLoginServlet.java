package stf;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;       

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String STF_ID = request.getParameter("STF_ID");
		String STF_PW = request.getParameter("STF_PW");
		if (STF_ID == null || STF_ID.equals("") || STF_PW == null || STF_PW.equals("")) {
			request.getSession().setAttribute("messageType","오류 메시지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력하세요.");
			response.sendRedirect("login.jsp");
			return;
		}
		int result = new StfDAO().login(STF_ID, STF_PW);
		if (result == 1) {
			request.getSession().setAttribute("STF_ID", STF_ID);
			request.getSession().setAttribute("messageType","성공 메시지");
			request.getSession().setAttribute("messageContent", "로그인에 성공했습니다.");
			
			//관리자 계정인 경우 첫화면 페이지는 대시보드 
			if (STF_ID.equals("admin")){
			
				response.sendRedirect("index2.jsp");
				return;	
			}
			//사업부서인 경우 일반 페이지 
			else {
			response.sendRedirect("index.jsp");
		}
		}
		else if (result == 2) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent",  "비밀번호를 다시 확인하세요.");
			response.sendRedirect("login.jsp");
		}
		else if (result == 0) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "아이디가 없습니다.");
			response.sendRedirect("login.jsp");
		}
		else if (result == -1) {
			request.getSession().setAttribute("messageType","오류 메시지");
			request.getSession().setAttribute("messageContent",  "DB 오류가 발생했습니다.");
			response.sendRedirect("login.jsp");
		}
	}

}
