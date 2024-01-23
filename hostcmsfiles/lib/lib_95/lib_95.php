<?php
$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->widgetParams, 'shopId'));
$shopXsl = Core_Array::get(Core_Page::instance()->widgetParams, 'shopXsl');
?>
<div class="container">
	<div class="footer-inner">
		<div class="footer-lists">
			<div class="footer-lists-item">
				<?php
				$Shop_Controller_Show = new Shop_Controller_Show(
					Core_Entity::factory('Shop', $oShop->id)
				);

				$Shop_Controller_Show
					->xsl(
						Core_Entity::factory('Xsl')->getByName($shopXsl)
					)
					->groupsMode('tree')
					->group(0)
					->viewed(FALSE)
					->favorite(FALSE)
					->comparing(FALSE)
					->itemsPropertiesList(FALSE)
					->commentsPropertiesList(FALSE)
					->limit(0)
					->itemsForbiddenTags(array('text', 'description'))
					->show();
				?>
			</div>
			<div class="footer-lists-item">
				<span class="footer-lists-item-title">Информация</span>
				<ul>
					<li><a href="/delivery/" class="footer-link">Доставка</a></li>
					<li><a href="/payment/" class="footer-link">Оплата</a></li>
					<li><a href="/refund/" class="footer-link">Возврат и обмен</a></li>
					<li><a href="/map/" class="footer-link">Карта сайта</a></li>
			   </ul>
			</div>
			<div class="footer-lists-item">
				<span class="footer-lists-item-title">Контакты</span>
				<div class="address">
					<p>127001, г. Екатеринбург, ул. Маршала Жукова, д. 117</p>
					<p><span class="font-weight-bold"> +7 (343) 987-65-43</span></p>
					<p><span><a href="mailto:admin@mysite.ru">admin@mysite.ru</a></span></p>
				</div>
				<div class="social">
					<ul>
						<li>
							<a class="twitter" href="http://twitter.com/hostcms" target="_blank">
								<i class="fa fa-twitter"></i>
							</a>
						</li>
						<li>
							<a class="facebook" href="#" target="_blank">
								<i class="fa fa-facebook"></i>
							</a>
						</li>
						<li>
							<a class="vk" href="https://vk.com/hostcms_ru" target="_blank">
								<i class="fa fa-vk"></i>
							</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>