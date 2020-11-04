package stf;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UserUpdateServlet")
public class UserUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String STF_ID = request.getParameter("STF_ID");
		HttpSession session = request.getSession();
		String STF_PW1 = request.getParameter("STF_PW1");
		String STF_PW2 = request.getParameter("STF_PW2");
		String STF_NM = request.getParameter("STF_NM");
		String STF_PH = request.getParameter("STF_PH");
		String STF_EML = request.getParameter("STF_EML");
		String STF_DEP = request.getParameter("STF_DEP");
		if (STF_ID == null || STF_ID.equals("") || STF_PW1 == null || STF_PW1.equals("")
				|| STF_PW2 == null || STF_PW2.equals("") || STF_NM == null || STF_NM.equals("")
				|| STF_PH == null || STF_PH.equals("") || STF_EML == null || STF_EML.equals("")
				|| STF_DEP == null || STF_DEP.equals("")) {
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "��� ������ �Է��ϼ���.");
			response.sendRedirect("update.jsp");
			return;
		}
		if (!STF_ID.equals((String) session.getAttribute("STF_ID"))) {
			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "������ �� �����ϴ�.");
			response.sendRedirect("index.jsp");
			return;	
		}
		if (!STF_PW1.equals(STF_PW2)) {
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "��й�ȣ�� ���� �ٸ��ϴ�.");
			response.sendRedirect("update.jsp");
			return;
		}
		int result = new StfDAO().update(STF_ID, STF_PW1, STF_NM, STF_PH, STF_EML, STF_DEP);
		if (result==1) {
			request.getSession().setAttribute("STF_ID", STF_ID);
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "ȸ������ ������ �����߽��ϴ�.");
			response.sendRedirect("index.jsp");
		}
		else {
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "DB ������ �߻��߽��ϴ�.");
			response.sendRedirect("update.jsp");
		}
	}
	
}
