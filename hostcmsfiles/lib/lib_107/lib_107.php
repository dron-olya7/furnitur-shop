<?php
if (Core::moduleIsActive('maillist'))
{
	?>
	<div class="newsletter-main">
		<div class="container">
			<div class="row">
				<div class="col-12">
					<div class="newsletter-header">
						<h2>Рассылка от Furniture Shop</h2>
					</div>
				</div>
				<div class="col-12">
					<div class="newsletter-wrapper">
						<form class="form-inline" method="post" action="/users/registration/">
							<div class="form-group news-form-group">
								<input class="form-control news-form-con" type="text" name="email" placeholder="Введите e-mail">
								<input type="hidden" name="fast" value="1">
								<input type="hidden" name="apply" value="1">
								<a href="#" class="news-btn" onclick="$.applyNewsletter(this); return false;">
									<i class="fa fa-paper-plane"></i>
								</a>
							</div>
						</form>
					</div>
				</div>
				<div class="col-12">
					<div class="newsletter-bottom">
						<span>Мы отправляем нашу интересную и очень полезную рассылку один раз в неделю.</span>
					</div>
				</div>
			</div>
		</div>
	</div>
	<?php
}