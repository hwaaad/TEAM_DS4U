package req;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class ReqRecWriteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		String savePath = request.getRealPath("/upload4").replaceAll("\\\\", "/");
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "���� ũ��� 10MB�� �ʰ��� �� �����ϴ�.");
			response.sendRedirect("index.jsp");
			return;
		}
		String STF_ID = multi.getParameter("STF_ID");
		HttpSession session = request.getSession();
		System.out.println(session.getAttribute("STF_ID"));	
		System.out.println(STF_ID);
		if(!STF_ID.equals((String) session.getAttribute("STF_ID"))) {
			session.setAttribute("messageType", "���� �޼���");
			session.setAttribute("messageContent", "������ �� �����ϴ�.");
			response.sendRedirect("index.jsp");
			return;
		}
		
		String REQ_SQ = multi.getParameter("REQ_SQ");
		String APV_NM = multi.getParameter("APV_NM");
		System.out.println(REQ_SQ);
		System.out.println(APV_NM);
		String REQ_REC_TXT = multi.getParameter("REQ_REC_TXT");
		System.out.println(REQ_REC_TXT);
		if (REQ_REC_TXT == null || REQ_REC_TXT.equals("")) {
			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "����� ��� �Է��ϼ���.");
			response.sendRedirect("reqReciveWrite.jsp");
			return;	
		}
		String REQ_REC_FILE = "";
		String REQ_REC_RFILE = "";
		File file = multi.getFile("REQ_REC_FILE");
		if (file != null) {
			REQ_REC_FILE = multi.getOriginalFileName("REQ_REC_FILE");
			REQ_REC_RFILE = file.getName();
		}
		
		ReqDAO reqDAO = new ReqDAO();
		reqDAO.update_req_rec_date(REQ_SQ);
		
		ReqRecDAO reqrecDAO = new ReqRecDAO();
		reqrecDAO.write(STF_ID, REQ_SQ, APV_NM, REQ_REC_TXT, REQ_REC_FILE, REQ_REC_RFILE);
		request.getSession().setAttribute("messageType", "���� �޼���");
		request.getSession().setAttribute("messageContent", "���������� �Խù��� �ۼ��Ͽ����ϴ�.");
		response.sendRedirect("reqView.jsp");
	}

}
