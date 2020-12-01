package board;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BoardDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;       
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		HttpSession session = request.getSession();
		String STF_ID = (String) session.getAttribute("STF_ID");
		String BOARD_SQ = request.getParameter("BOARD_SQ");
		if (BOARD_SQ == null || BOARD_SQ.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO board = boardDAO.getBoard(BOARD_SQ);
		if (!STF_ID.equals(board.getSTF_ID())) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		String savePath = request.getRealPath("/upload").replaceAll("\\\\", "/");
		String prev = boardDAO.getRealFile(BOARD_SQ);
		int result = boardDAO.delete(BOARD_SQ);
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
			response.sendRedirect("boardView.jsp");
		}
		
	}

}