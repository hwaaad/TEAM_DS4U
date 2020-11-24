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

import req.ReqDAO;

public class ReqfileWriteServlet  extends HttpServlet {

	
		private static final long serialVersionUID = 1L;
	       
		protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			MultipartRequest multi = null;
			int fileMaxSize = 10 * 1024 * 1024;
			String savePath = request.getRealPath("/upload5").replaceAll("\\\\", "/");
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
			
			int REQ_SQ = Integer.parseInt(multi.getParameter("REQ_SQ")); 
			String APV_NM = multi.getParameter("APV_NM");
			
			
			String REQ_SUB_DATE="";
			String REQF_FILE = "";
			String REQF_RFILE = "";
			File file = multi.getFile("REQF_FILE");
			
			if (file != null) {
				REQF_FILE = multi.getOriginalFileName("REQF_FILE");
				REQF_RFILE = file.getName();
			}
			
			ReqfileDAO reqfDAO = new ReqfileDAO();
			ReqDAO reqDAO = new ReqDAO();
			reqDAO.update_req_sub_date(REQ_SQ);
			
			reqfDAO.write(STF_ID,REQ_SQ,APV_NM, REQF_FILE, REQF_RFILE);
			ReqfileDTO reqf = null;
			reqfDAO.update(reqf); 
			request.getSession().setAttribute("messageType", "���� �޼���");
			request.getSession().setAttribute("messageContent", "���������� �Խù��� �ۼ��Ͽ����ϴ�.");
			response.sendRedirect("reqView.jsp");
		}

	}
