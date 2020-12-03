package stf;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.SHA256;

@WebServlet("/UserFindServlet")
public class UserFindServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String STF_ID = request.getParameter("STF_ID");
		if (STF_ID == null || STF_ID.equals("")) {
			response.getWriter().write("-1");
		} else if (new StfDAO().registerCheck(STF_ID) == 0) {
			try {
				response.getWriter().write(find(STF_ID));
			} catch (Exception e) {
				e.printStackTrace();
				response.getWriter().write("-1");
			}			
		} else {
			response.getWriter().write("-1");
		}

	}
	public String find(String STF_ID) throws Exception {
		StringBuffer result = new StringBuffer("");
		result.append("{\"STF_PF\":\"" + new StfDAO().getProfile(STF_ID) + "\"}");
		return result.toString();
	}
}