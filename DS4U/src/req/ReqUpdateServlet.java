package req;

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

public class ReqUpdateServlet extends HttpServlet{
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
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent","파일 크기는 10MB를 초과할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		//servlet 占쎈땾占쎌젟!! 
		
		String STF_ID = multi.getParameter("STF_ID");
		HttpSession session = request.getSession();
		if (!STF_ID.equals((String) session.getAttribute("STF_ID"))) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;	
		}
		
		
		String REQ_SQ = multi.getParameter("REQ_SQ");	
		if (REQ_SQ == null || REQ_SQ.equals("")) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "오류SQ null.");
			response.sendRedirect("index.jsp");
			return;	
		}
		
		ReqDAO reqDAO = new ReqDAO();
		ReqDTO req = reqDAO.getReq(REQ_SQ);
		
		if (!STF_ID.equals(req.getSTF_ID())) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent","접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;	
		}
		
		
		
		String APV_NM = multi.getParameter("APV_NM");
		String APV_OBJ = multi.getParameter("APV_OBJ");
		String APV_CONT = multi.getParameter("APV_CONT");
		String APV_DATE = multi.getParameter("APV_DATE");
		if (APV_NM == null || APV_NM.equals("") || APV_OBJ == null || APV_OBJ.equals("")
				|| APV_CONT == null || APV_CONT.equals("") || APV_DATE == null || APV_DATE.equals("")) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "양식을 모두 입력하세요.");
			response.sendRedirect("reqUpdate.jsp");
			return;	
		}
		String REQ_DATE ="";
		String REQ_REC_DATE = "";
		String REQ_SUB_DATE = "";
		String REQ_FILE = "";
		String REQ_RFILE = "";
		File file = multi.getFile("REQ_FILE");
		if (file != null) {
			REQ_FILE = multi.getOriginalFileName("REQ_FILE");
			REQ_RFILE = file.getName();
		}
		System.out.println(REQ_FILE);
		System.out.println(REQ_RFILE);
		int APV_SQ = Integer.parseInt(multi.getParameter("APV_SQ")); 
		
		
		reqDAO.update(APV_SQ, APV_NM, APV_OBJ, APV_CONT, APV_DATE, REQ_SQ);
		reqDAO.update_apv_date(APV_SQ);
		reqDAO.file_update(REQ_FILE, REQ_RFILE, REQ_SQ);
		request.getSession().setAttribute("messageType", "성공 메세지");
		request.getSession().setAttribute("messageContent", "성공적으로 게시물이 수정되었습니다.");
		response.sendRedirect("reqView.jsp");
		return;
	}
}
