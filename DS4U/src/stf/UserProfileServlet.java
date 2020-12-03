package stf;

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

@WebServlet("/UserProfileServlet")
public class UserProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		String savePath = request.getRealPath("/profile").replaceAll("\\\\", "/");
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "파일 크기는 10MB를 넘을 수 없습니다.");
			response.sendRedirect("pfUpdate.jsp");
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
		String fileName = "";
		File file = multi.getFile("STF_PF");
		if (file != null) {
			String ext = file.getName().substring(file.getName().lastIndexOf(".") + 1);
			if (ext.equals("jpg") || ext.equals("png") || ext.equals("gif") || ext.equals("PNG")) {
				String prev = new StfDAO().getUser(STF_ID).getSTF_PF();
				File prevFile = new File(savePath + "/" + prev);
				if (prevFile.exists()) {
					prevFile.delete();
				}
				fileName = file.getName();
			} else {
				if (file.exists()) {
					file.delete();
				}
				session.setAttribute("messageType", "오류 메시지");
				session.setAttribute("messageContent", "이미지 파일만 업로드 가능합니다.");
				response.sendRedirect("pfUpdate.jsp");
				return;				
			}
		}
		new StfDAO().profile(STF_ID, fileName);
		session.setAttribute("messageType", "성공 메시지");
		session.setAttribute("messageContent", "프로필 사진이 변경되었습니다.");
		response.sendRedirect("myPage.jsp");
		return;	
	}

}
