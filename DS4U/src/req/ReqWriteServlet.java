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

public class ReqWriteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		String savePath = request.getRealPath("/upload3").replaceAll("\\\\", "/");
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
		
		int APV_SQ = Integer.parseInt(multi.getParameter("APV_SQ")); 
		
		String APV_NM = multi.getParameter("APV_NM");
		String APV_OBJ = multi.getParameter("APV_OBJ");
		String APV_CONT = multi.getParameter("APV_CONT");
		String APV_DATE = multi.getParameter("APV_DATE");
		if (APV_NM == null || APV_NM.equals("") || APV_OBJ == null || APV_OBJ.equals("")
				|| APV_CONT == null || APV_CONT.equals("") || APV_DATE == null || APV_DATE.equals("")) {
			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "����� ��� �Է��ϼ���.");
			response.sendRedirect("reqWrite.jsp");
			return;	
		}
		
		String REQ_REC_DATE = "";
		String REQ_SUB_DATE = "";
		String REQ_FILE = "";
		String REQ_RFILE = "";
		File file = multi.getFile("REQ_FILE");
		if (file != null) {
			REQ_FILE = multi.getOriginalFileName("REQ_FILE");
			REQ_RFILE = file.getName();
		}
		
		
		ReqDAO reqDAO = new ReqDAO();
		reqDAO.write(STF_ID,APV_SQ, APV_NM, APV_OBJ, APV_CONT, APV_DATE,  REQ_REC_DATE, REQ_SUB_DATE);
		reqDAO.update_apv_date(APV_SQ);
		reqDAO.file_write(REQ_FILE, REQ_RFILE);
		request.getSession().setAttribute("messageType", "���� �޼���");
		request.getSession().setAttribute("messageContent", "���������� �Խù��� �ۼ��Ͽ����ϴ�.");
		response.sendRedirect("reqView.jsp");
	}

}
