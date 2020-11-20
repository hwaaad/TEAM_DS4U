package stf;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.SHA256;

@WebServlet("/UserRegisterServlet")
public class UserRegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String STF_ID = request.getParameter("STF_ID");
		String STF_PW1 = request.getParameter("STF_PW1");
		String STF_PW2 = request.getParameter("STF_PW2");
		String STF_NM = request.getParameter("STF_NM");
		String STF_PH = request.getParameter("STF_PH");
		String STF_EML = request.getParameter("STF_EML");
		String STF_DEP = request.getParameter("STF_DEP");
		String STF_PF = request.getParameter("STF_PF");
		if (STF_ID == null || STF_ID.equals("") || STF_PW1 == null || STF_PW1.equals("")
				|| STF_PW2 == null || STF_PW2.equals("") || STF_NM == null || STF_NM.equals("")
				|| STF_PH == null || STF_PH.equals("") || STF_EML == null || STF_EML.equals("")
				|| STF_DEP == null || STF_DEP.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력하세요.");
			response.sendRedirect("join.jsp");
			return;
		}
		if (!STF_PW1.equals(STF_PW2)) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "비밀번호가 서로 다릅니다.");
			response.sendRedirect("join.jsp");
			return;
		}
		int result = new StfDAO().register(STF_ID, STF_PW1, STF_NM, STF_PH, STF_EML, STF_DEP, "", SHA256.getSHA256(STF_EML), false);
		if (result==1) {
			request.getSession().setAttribute("STF_ID", STF_ID);
			request.getSession().setAttribute("messageType", "성공 메시지");
			request.getSession().setAttribute("messageContent", "회원가입에 성공했습니다. 이메일 인증을 진행해주세요.");
			response.sendRedirect("emailSend.jsp");
		}
		else {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "이미 존재하는 회원입니다.");
			response.sendRedirect("join.jsp");
		}
	}
	
}