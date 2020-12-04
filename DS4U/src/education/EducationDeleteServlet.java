package education;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class EducationDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;       
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		HttpSession session = request.getSession();
		String STF_ID = (String) session.getAttribute("STF_ID");
		String EDUCATION_SQ = request.getParameter("EDUCATION_SQ");
		if (EDUCATION_SQ == null || EDUCATION_SQ.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		EducationDAO educationDAO = new EducationDAO();
		EducationDTO education = educationDAO.getEducation(EDUCATION_SQ);
		if (!STF_ID.equals(education.getSTF_ID())) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		String savePath = request.getRealPath("/upload").replaceAll("\\\\", "/");
		String prev = educationDAO.getRealFile(EDUCATION_SQ);
		int result = educationDAO.delete(EDUCATION_SQ);
		if (result == -1) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		} else {
			File prevFile = new File(savePath + "/" + prev);
			if (prevFile.exists()) {
				prevFile.delete();
			}
			request.getSession().setAttribute("messageType", "성공 메시지");
			request.getSession().setAttribute("messageContent", "삭제에 성공했습니다.");
			response.sendRedirect("educationView.jsp");
		}
		
	}

}