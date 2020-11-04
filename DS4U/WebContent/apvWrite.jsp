<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="stf.StfDTO" %>
<%@ page import="stf.StfDAO" %>
<!DOCTYPE html>
<html>
<%
	String STF_ID = null;
	if (session.getAttribute("STF_ID") != null) {
		STF_ID = (String) session.getAttribute("STF_ID");
	}
	if (STF_ID == null) {
		session.setAttribute("messageType", "���� �޽���");
		session.setAttribute("messageContent", "�α����� �ʿ��մϴ�.");
		response.sendRedirect("index.jsp");
		return;		
	}
	StfDTO stf = new StfDAO().getUser(STF_ID);
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">  <!-- ������ ���� ����ϴ� ��Ÿ�±� -->
       <!-- viewport = ȭ�� ǥ�ÿ���, content = ����Ͽ� �°� ũ�� ����, initial = �ʱ�ȭ�� ����, shrink-to-fit=no = ���ӹ��� -->
	<link rel="stylesheet" href="css/bootstrap.css"> <!-- ��Ÿ�Ͻ�Ʈ bootstrap.css ���� -->
	<link rel="stylesheet" href="css/custom.css"> <!-- ����  -->
	<title>���ﱳ�����</title>
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<!-- <script type="text/javascript"> --> 
	<!-- 
		function removeCheck() {
			 if (confirm("����Ͻðڽ��ϱ�?") == true){    //Ȯ��

				 window.open('', '_self', '');

				 window.close();

			 }else{   //���

			     return false;

			 }
		}
		function registerCheck() {
			 if (confirm("����Ͻðڽ��ϱ�?") == true){    //Ȯ��

				 window.open('', '_self', '');

				 window.close();

			 }else{   //���

			     return false;

			 }
		} 
		
	</script>-->
    <!--  <title>����ȭ��� ���</title>
    
    <style>
        #wrap{
            width:530px;
            margin-left:auto; 
            margin-right:auto;
            text-align:center;
        }
        
        table{
            border:3px solid skyblue
        }
        
        td{
            border:1px solid skyblue
        }
        
        #title{
            background-color:skyblue
        }
    </style>-->
</head>
<body>
    <nav class ="navbar navbar-default">   <!-- navbar-���� -->
        <div class="navbar-header">   <!-- Ȩ������ �ΰ� -->
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expand="false">
				<!-- class="navbar-toggle collapsed" : �׺���̼� ȭ�� �������-->
				<!-- data-toggle="collapse" : ����Ͽ��� Ŭ�� �� �޴� ���� -->				
                <span class ="icon-bar"></span> <!-- �ٿ����� ���� ¦��� -->
                <span class ="icon-bar"></span> <!-- ������ �̹��� -->
                <span class ="icon-bar"></span>
            </button>
			<a class="navbar-brand" href="index.jsp"><img alt="Brand" src="images/logo.jpg"></a>	
            	<!-- bootstrap navbar �⺻ �޴��� -->
                               
        </div>        
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">       <!-- navbar-nav : �׺���̼� �� �޴� -->
                <li><a href="index.jsp">����</a></li>
                <li><a href="boardView.jsp">�Խ���</a></li>
            	<li class="active"><a href="apvView.jsp">����ȭ���</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                	<a href="#" class = "dropdown-toggle"
                    	data-toggle="dropdown" role ="button" aria-haspopup="true"
                    	aria-expanded="false">ȸ������<span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                    	<li><a href="update.jsp">ȸ����������</a></li> 
                        <li><a href="logoutAction.jsp">�α׾ƿ�</a></li>                  
                    </ul>
                </li>
            </ul>
        <form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
			<input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="������ �Է��ϼ���." aria-label="Search">
			<button class="btn btn-outline-success my-2 my-sm-0" type="submit">�˻�</button>
		</form>            
       	</div>
    </nav> 
    <!-- ����, ������ �ٱ������� auto�� �ָ� �߾����ĵȴ�.  -->
    <div class="container">
		<form method="post" action="./apvWrite" enctype="multipart/form-data">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3"><h4>����ȭ��� ���</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>1. �����</h5></td>
						<td><input class="form-control" type="text" id="APV_NM" name="APV_NM" maxlength="64" placeholder="������� �Է��ϼ���."></td>
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>2. ��� �Ⱓ</h5></td>
						<td><input class="form-control" type="text" id="APV_DATE" name="APV_DATE" maxlength="64" placeholder="����Ⱓ�� �Է��ϼ���."></td>				
					</tr>		
					<tr>
						<td style="width: 130px; text-align: left;"><h5>3. ��� ������</h5></td>
						<td colspan="2"><input class="form-control" id="APV_STT_DATE" type="text" name="APV_STT_DATE" maxlength="10" placeholder="��� �������� �Է��ϼ���."></td>				
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>4. ��� ������</h5></td>
						<td colspan="2"><input class="form-control" id="APV_FIN_DATE" type="text" name="APV_FIN_DATE" maxlength="10" placeholder="��� �������� �Է��ϼ���."></td>				
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>5. �ҿ� ����</h5></td>
						<td colspan="2"><input class="form-control" id="APV_BUDGET" type="text" name="APV_BUDGET" maxlength="15" placeholder="�ҿ� ����(��)�� �Է��ϼ���."></td>				
					</tr>
					<tr>
						<td style="width: 130px;"><h5>6. ���̵�</h5></td>
						<td><h5><%= stf.getSTF_ID() %></h5>
						<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>"></td>						
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>7. ����ó</h5></td>						
						<td colspan="2"><input class="form-control" id="APV_PHONE" type="text" name="APV_PHONE" maxlength="30" placeholder="����ó�� �Է��ϼ���."></td>							
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>8. �����ħ��ȣ</h5></td>						
						<td colspan="2"><input class="form-control" id="APV_POLICY_SQ" type="text" name="APV_POLICY_SQ" maxlength="30" placeholder="�����ħ��ȣ�� �Է��ϼ���."></td>							
					</tr>
					<tr>
						<td style="width: 110px;"><h5>���� ���ε�</h5></td>
						<td colspan="2">
							<input type="file" name="APV_FILE" class="file">
							<div class="input-group	col-xs-12">
								<span class="input-group-addon"><i class="glyphicon glyphicon-picture"></i></span>
								<input type="text" class="form-control input-lg" disabled placeholder="�����ħ ÷������">
								<span class="input-group-btn">
									<button class="browse btn btn-primary input-lg" type="button"><i class="glyphicon glyphicon-search"></i>����ã��</button>
								</span>
							</div>
						</td>				
					</tr>		

					<tr>
						<td style="text-align: left;" colspan="3"><h5 style="color: red;"></h5><input class="btn btn-primary pull-right" type="submit" value="���"></td>
					</tr>																														
				</tbody>
			</table>
			<!-- <input class="btn btn-primary pull-right" type="button" value="���" onclick="removeCheck()"> -->
			<!--<input class="btn btn-primary pull-right" type="submit" value="���" onclick="registerCheck()"> -->			
		</form>
	</div>
	
	<%
		String messageContent = null;
		if (session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		String messageType = null;
		if (session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}
		if (messageContent != null) {
	%>
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content <% if(messageType.equals("���� �޽���")) out.println("panel-warning"); else out.println("panel-success");%>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%= messageType %>
						</h4>
					</div>
					<div class="modal-body">
						<%= messageContent %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">Ȯ��</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
		$('#messageModal').modal("show");
	</script>		
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<script type="text/javascript">
		$(document).on('click', '.browse', function() {
			var file = $(this).parent().parent().parent().find('.file');
			file.trigger('click');
		});
		$(document).on('change', '.file', function() {
			$(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
		});
	</script>        
</body>
</html>