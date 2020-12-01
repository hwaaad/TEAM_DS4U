package board;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class BoardReplyServlet extends HttpServlet {
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
		String BOARD_SQ = multi.getParameter("BOARD_SQ");
		if (BOARD_SQ == null || BOARD_SQ.equals("")) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;	
		}
		String BOARD_TYPE = multi.getParameter("BOARD_TYPE");
		String BOARD_NM = multi.getParameter("BOARD_NM");
		String BOARD_TXT = multi.getParameter("BOARD_TXT");
		if (BOARD_NM == null || BOARD_NM.equals("") || BOARD_TXT == null || BOARD_TXT.equals("")) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "양식을 모두 입력하세요.");
			response.sendRedirect("index.jsp");
			return;	
		}
		String BOARD_FILE = "";
		String BOARD_RFILE = "";
		File file = multi.getFile("BOARD_FILE");
		if (file != null) {
			BOARD_FILE = multi.getOriginalFileName("BOARD_FILE");
			BOARD_RFILE = file.getName();
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO parent = boardDAO.getBoard(BOARD_SQ);
		boardDAO.replyUpdate(parent);
		boardDAO.reply(STF_ID, BOARD_TYPE, BOARD_NM, BOARD_TXT, BOARD_FILE, BOARD_RFILE, parent);
		request.getSession().setAttribute("messageType", "성공 메시지");
		request.getSession().setAttribute("messageContent", "성공적으로 답변이 작성되었습니다.");
		response.sendRedirect("boardView.jsp");
		return;
	}
}