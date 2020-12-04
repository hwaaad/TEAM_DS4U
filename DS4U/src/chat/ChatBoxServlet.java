package chat;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import stf.StfDAO;

@WebServlet("/ChatBoxServlet")
public class ChatBoxServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");		
		String STF_ID = request.getParameter("STF_ID");
		if(STF_ID == null || STF_ID.equals("")) {
			response.getWriter().write("0");
		} else {
			try {
				HttpSession session = request.getSession();
				if (!URLDecoder.decode(STF_ID, "UTF-8").equals((String) session.getAttribute("STF_ID"))) {
					response.getWriter().write("");
					return;
				}
				STF_ID = URLDecoder.decode(STF_ID, "UTF-8");
				response.getWriter().write(getBox(STF_ID));
			} catch (Exception e) {
				response.getWriter().write("");
			}
		}
	}
	public String getBox(String STF_ID) {
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\" : [");
		ChatDAO chatDAO = new ChatDAO();
		ArrayList<ChatDTO> chatList = chatDAO.getBox(STF_ID);
		if(chatList.size() == 0) return "";
		for(int i = chatList.size()-1; i>=0; i--) {
			String unread = "";
			String STF_PF = "";
			if (STF_ID.equals(chatList.get(i).getToID())) {
				unread = chatDAO.getUnreadChat(chatList.get(i).getFromID(), STF_ID) + "";
				if (unread.equals("0")) unread = "";
			}
			if (STF_ID.equals(chatList.get(i).getToID())) {
				STF_PF = new StfDAO().getProfile(chatList.get(i).getFromID());
			} else {
				STF_PF = new StfDAO().getProfile(chatList.get(i).getToID());
			}
			result.append("[{\"value\" : \"" + chatList.get(i).getFromID() + "\"},");
			result.append("{\"value\" : \"" + chatList.get(i).getToID() + "\"},");
			result.append("{\"value\" : \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\" : \"" + chatList.get(i).getChatTime() + "\"},");
			result.append("{\"value\" : \"" + unread + "\"},");
			result.append("{\"value\" : \"" + STF_PF + "\"}]");
			if(i != 0) result.append(",");
		}
		result.append("], \"last\" : \"" + chatList.get(chatList.size() -1).getChatID() + "\"}");
		return result.toString();
	}

}