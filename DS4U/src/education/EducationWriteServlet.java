package education;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class EducationWriteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		String savePath = request.getRealPath("/upload").replaceAll("\\\\", "/");
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "파일 크기는 10MB를 초과할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		String STF_ID = multi.getParameter("STF_ID");
		HttpSession session = request.getSession();
		if (!STF_ID.equals((String) session.getAttribute("STF_ID"))) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;	
		}
		String EDUCATION_NM = multi.getParameter("EDUCATION_NM");
		String EDUCATION_TXT = multi.getParameter("EDUCATION_TXT");
		if (EDUCATION_NM == null || EDUCATION_NM.equals("") || EDUCATION_TXT == null || EDUCATION_TXT.equals("")) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "양식을 모두 입력하세요.");
			response.sendRedirect("educationWrite.jsp");
			return;	
		}
		String EDUCATION_FILE = "";
		String EDUCATION_RFILE = "";
		File file = multi.getFile("EDUCATION_FILE");
		if (file != null) {
			EDUCATION_FILE = multi.getOriginalFileName("EDUCATION_FILE");
			EDUCATION_RFILE = file.getName();
		}
		EducationDAO educationDAO = new EducationDAO();
		educationDAO.write(STF_ID, EDUCATION_NM, EDUCATION_TXT, EDUCATION_FILE, EDUCATION_RFILE);
		request.getSession().setAttribute("messageType", "성공 메시지");
		request.getSession().setAttribute("messageContent", "성공적으로 게시물을 작성하였습니다.");
		response.sendRedirect("educationView.jsp");
		return;
	}
}