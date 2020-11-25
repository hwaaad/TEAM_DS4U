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

import apv.ApvDAO;
import apv.ApvDTO;

public class ApvUpdateServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		String savePath = request.getRealPath("/upload6").replaceAll("\\\\", "/");
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "���� ũ��� 10MB�� �ʰ��� �� �����ϴ�.");
			response.sendRedirect("index.jsp");
			return;
		}
		//servlet 수정!! 
		
		String STF_ID = multi.getParameter("STF_ID");
		
		HttpSession session = request.getSession();
		if (!STF_ID.equals((String) session.getAttribute("STF_ID"))) {
			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "������ �� �����ϴ�.");
			response.sendRedirect("index.jsp");
			return;	
		}
		
		
		String APV_SQ = multi.getParameter("APV_SQ");	
		
		if (APV_SQ == null || APV_SQ.equals("")) {
			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "������ �� �����ϴ�.");
			response.sendRedirect("index.jsp");
			return;	
		}
		
		ApvDAO apvDAO = new ApvDAO();
		ApvDTO apv = apvDAO.getApv(APV_SQ);
		
		if (!STF_ID.equals(apv.getSTF_ID())) {
			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "������ �� �����ϴ�.");
			response.sendRedirect("index.jsp");
			return;	
		}
		
		String APV_NM = multi.getParameter("APV_NM");
		String APV_DATE = multi.getParameter("APV_DATE");
		String APV_STT_DATE = multi.getParameter("APV_STT_DATE");
		String APV_FIN_DATE= multi.getParameter("APV_FIN_DATE");
		String APV_BUDGET = multi.getParameter("APV_BUDGET");
		String APV_PHONE = multi.getParameter("APV_PHONE");
		String APV_POLICY_SQ = multi.getParameter("APV_POLICY_SQ");
		
		if (APV_NM == null || APV_NM.equals("") || APV_DATE == null || APV_DATE.equals("")  ||
				APV_STT_DATE == null || APV_STT_DATE.equals("") || APV_FIN_DATE == null || APV_FIN_DATE.equals("") ||
						APV_BUDGET == null || APV_BUDGET.equals("") || APV_PHONE == null || APV_PHONE.equals("") ||
								APV_POLICY_SQ == null || APV_POLICY_SQ.equals("") ) 
		{
			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "����� ��� �Է��ϼ���.");
			response.sendRedirect("apvUpdate.jsp");
			return;	
		}
		String APV_FILE = "";
		String APV_RFILE = "";
		File file = multi.getFile("APV_FILE");
		if (file != null) {
			APV_FILE = multi.getOriginalFileName("APV_FILE");
			APV_RFILE = file.getName();
		}
		apvDAO.update(APV_NM, APV_DATE, APV_STT_DATE, APV_FIN_DATE, APV_BUDGET, APV_PHONE, APV_POLICY_SQ, APV_FILE, APV_RFILE,APV_SQ);
		request.getSession().setAttribute("messageType", "���� �޽���");
		request.getSession().setAttribute("messageContent", "���������� �Խù��� �����Ǿ����ϴ�.");
		response.sendRedirect("apvView.jsp");
		return;
	}
}
