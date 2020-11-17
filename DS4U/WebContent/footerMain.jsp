<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
window.onscroll = function() {scrollFunction()};
function scrollFunction() {
  if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
		$("#btn_page_top").css('display', 'block'); //버튼 보임
  } else {
		$("#btn_page_top").css('display', 'none'); //버튼 안 보임
  }
}
function topFunction() {
	$("html").animate({
		scrollTop : 0
	}, 500);
}
</script>
<div id="footer">
	<div id="footer-all">
		<div id="f1">
			<div id="co-location">
				<p><span>동국대학교</span><span>DS4U</span><span>2020년 2학기</span></p>
				<p><span>Dongguk Uni.</span><span>류화동, 이원우, 김나경, 박시애</span></p>
				<p><span>팀 프로젝트 포트폴리오</span></p>
			</div>
		</div>
		<div id="f2">
			<p>***************************************************</p>
			<div id="co-sns">
				<ul>
					<li>
						<a href="#">
							<span><i class="fab fa-instagram"></i></span>
						</a>
					</li>
					<li>
						<a href="#">
							<span><i class="fab fa-facebook-square"></i></span>
						</a>
					</li>
					<li>
						<a href="#">
							<span><i class="fab fa-youtube"></i></span>
						</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<button onclick="topFunction()" id="btn_page_top">TOP</button>
</div>
