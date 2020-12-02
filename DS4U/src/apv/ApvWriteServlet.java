package apv;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class ApvWriteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;    
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		MultipartRequest multi2 = null;
		int fileMaxSize = 10 * 1024 * 1024;
		String savePath = request.getRealPath("/upload7").replaceAll("\\\\", "/");
		try {
			multi2 = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "파일 크기는 10MB를 초과할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		String STF_ID = multi2.getParameter("STF_ID");
		HttpSession session = request.getSession();
		if (!STF_ID.equals((String) session.getAttribute("STF_ID"))) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;	
		}
		String APV_NM = multi2.getParameter("APV_NM");
		String APV_DATE = multi2.getParameter("startDate") + '~' + multi2.getParameter("endDate");
		String APV_STT_DATE = multi2.getParameter("APV_STT_DATE");
		String APV_FIN_DATE = multi2.getParameter("APV_FIN_DATE");
		String APV_BUDGET = multi2.getParameter("APV_BUDGET");
		//String APV_COM = multi2.getParameter("APV_COM");
		String APV_PHONE = multi2.getParameter("APV_PHONE");
		String APV_POLICY_SQ = multi2.getParameter("APV_POLICY_SQ");
		if (APV_NM == null || APV_NM.equals("") || APV_DATE == null || APV_DATE.equals("")
				|| APV_STT_DATE == null || APV_STT_DATE.equals("") || APV_FIN_DATE == null || APV_FIN_DATE.equals("")
				|| APV_BUDGET == null || APV_BUDGET.equals("") || APV_PHONE == null || APV_PHONE.equals("") 
				|| APV_POLICY_SQ == null || APV_POLICY_SQ.equals("")) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "양식을 모두 입력하세요.");
			response.sendRedirect("apvWrite.jsp");
			return;	
		}
		String APV_FILE = "";
		String APV_RFILE = "";
		File file = multi2.getFile("APV_FILE");
		if (file != null) {
			APV_FILE = multi2.getOriginalFileName("APV_FILE");
			APV_RFILE = file.getName();
		}
		ApvDAO apvDAO = new ApvDAO();
		apvDAO.write(STF_ID, APV_NM, APV_DATE, APV_STT_DATE, APV_FIN_DATE, APV_BUDGET, APV_PHONE, APV_POLICY_SQ);
		System.out.println(APV_FILE);
		System.out.println(APV_RFILE);
		
		apvDAO.file_write(APV_FILE, APV_RFILE);
		request.getSession().setAttribute("messageType", "성공 메시지");
		request.getSession().setAttribute("messageContent", "성공적으로 게시물을 작성하였습니다.");
		response.sendRedirect("apvView.jsp");
	}
}
