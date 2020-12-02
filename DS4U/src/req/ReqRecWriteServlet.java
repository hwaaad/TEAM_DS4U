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
			request.getSession().setAttribute("messageType", "�삤瑜� 硫붿떆吏�");
			request.getSession().setAttribute("messageContent", "�뙆�씪 �겕湲곕뒗 10MB瑜� 珥덇낵�븷 �닔 �뾾�뒿�땲�떎.");
			response.sendRedirect("index.jsp");
			return;
		}
		String STF_ID = multi.getParameter("STF_ID");
		HttpSession session = request.getSession();
		System.out.println(session.getAttribute("STF_ID"));	
		System.out.println(STF_ID);
		if(!STF_ID.equals((String) session.getAttribute("STF_ID"))) {
			session.setAttribute("messageType", "�삤瑜� 硫붿꽭吏�");
			session.setAttribute("messageContent", "�젒洹쇳븷 �닔 �뾾�뒿�땲�떎.");
			response.sendRedirect("index.jsp");
			return;
		}
		
		String REQ_SQ = multi.getParameter("REQ_SQ");
		String APV_NM = multi.getParameter("APV_NM");
		String REQ_APPROVAL = multi.getParameter("REQ_APPROVAL");
		System.out.println(REQ_SQ);
		System.out.println(APV_NM);
		String REQ_REC_TXT = multi.getParameter("REQ_REC_TXT");
		System.out.println(REQ_REC_TXT);
		if (REQ_REC_TXT == null || REQ_REC_TXT.equals("")) {
			session.setAttribute("messageType", "�삤瑜� 硫붿떆吏�");
			session.setAttribute("messageContent", "�뼇�떇�쓣 紐⑤몢 �엯�젰�븯�꽭�슂.");
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
		reqrecDAO.write(STF_ID, REQ_SQ, APV_NM, REQ_REC_TXT, REQ_APPROVAL, REQ_REC_FILE, REQ_REC_RFILE);
		request.getSession().setAttribute("messageType", "�꽦怨� 硫붿꽭吏�");
		request.getSession().setAttribute("messageContent", "�꽦怨듭쟻�쑝濡� 寃뚯떆臾쇱쓣 �옉�꽦�븯���뒿�땲�떎.");
		response.sendRedirect("reqView.jsp");
	}

}
