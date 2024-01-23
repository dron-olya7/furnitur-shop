<?php
	$oShop = Core_Entity::factory('Shop', Core_Array::get(Core_Page::instance()->widgetParams, 'shopId'));
?>
<div class="header-icons">
	<span class="hamburger-icon">
		<i class="fa fa-bars top"></i>
	</span>

	<span class="hamburger-icon">
		<i class="fa fa-sitemap hamburger-categories primary"></i>
	</span>
	<?php
	if (Core::moduleIsActive('search'))
	{
		?>
		<span class="search-icon">
			<i class="fa fa-search"></i>
			<form class="top-search-form hidden" action="/search/" method="get">
				<input id="search_top" class="search-top" name="text" type="text" placeholder="Поиск..."/>
				<span class="search-top-suggestions"></span>
			</form>
		</span>
		<?php
	}

	$quantity = 0;

	$Shop_Cart_Controller = Shop_Cart_Controller::instance();

	$aShop_Cart = $Shop_Cart_Controller->getAll($oShop);
	foreach ($aShop_Cart as $oShop_Cart)
	{
		$oShop_Cart->postpone == 0
			&& $quantity += $oShop_Cart->quantity;
	}

	$dNone = $quantity ? '' : 'd-none';
	?>
	<span class="little-cart-icon">
		<i class="fa fa-shopping-basket"></i>
		<span class="little-cart-icon-badge <?php echo $dNone?>"><?php echo $quantity?></span>
	</span>
	<span class="user-icon">
		<i class="fa fa-user"></i>

		<div class="user-account-wrapper">
			<a href="#" class="popup-close d-none">&times;</a>
			<?php
			if (Core::moduleIsActive('siteuser') && Core::moduleIsActive('shop'))
			{
				$class = "grid-4";
			}
			elseif (!Core::moduleIsActive('siteuser') && Core::moduleIsActive('shop'))
			{
				$class = "grid-3";
			}
			else
			{
				$class = "grid-1";
			}
			?>
			<div class="user-account <?php echo $class?>">
				<?php
				if (Core::moduleIsActive('siteuser'))
				{
					$oSiteuser = Core_Entity::factory('Siteuser')->getCurrent();

					if(!is_null($oSiteuser))
					{
						?><div class="authorize">
							<span class="authorize-title secondary">
								<i class="fa fa-user secondary"></i> Личный кабинет
							</span>
							<div class="text-center">Добро пожаловать, <?php echo htmlspecialchars($oSiteuser->login)?>!</div>
							<div class="button-wrapper text-center mt-3">
								<a href="/users/" class="btn btn-secondary" type="submit">Перейти в аккаунт</a>
								<a href="/users/?action=exit" class="btn btn-fifth mt-2 exit-account" type="submit">Выйти</a>
							</div>
						</div><?php
					}
					else
					{
						?><div class="authorize">
							<span class="authorize-title secondary">
								<i class="fa fa-user secondary"></i> Личный кабинет
							</span>
							<form action="/users/" enctype="multipart/form-data" method="POST">
								<div class="input-box">
									<input type="text" name="login" placeholder="Логин"/>
								</div>
								<div class="input-box input-box-password">
									<input type="password" placeholder="Пароль" name="password"/>
									<a href="/users/restore_password/">Забыли?</a>
								</div>
								<div class="button-wrapper text-center">
									<button class="btn btn-secondary" type="submit" name="apply" value="apply">Войти</button>
									<a href="/users/registration/" class="registration-link">Зарегистрироваться</a>
								</div>
							</form>
						</div><?php
					}
				}

				if (Core::moduleIsActive('shop'))
				{
					?>
					<div class="little-viewed">
						<?php
						// Viewed
						$Shop_Controller_Show = new Shop_Controller_Show(
							Core_Entity::factory('Shop', $oShop->id)
						);

						$Shop_Controller_Show
							->xsl(
								Core_Entity::factory('Xsl')->getByName(
									Core_Array::get(Core_Page::instance()->widgetParams, 'shortViewedXsl')
								)
							)
							->itemsPropertiesList(FALSE)
							->groupsMode('none')
							->favorite(FALSE)
							->comparing(FALSE)
							->sets(FALSE)
							->cache(FALSE)
							->limit(0)
							->viewedLimit(3)
							->show();
						?>
					</div>
					<div class="little-compare">
						<?php
						// Compare
						$Shop_Compare_Controller_Show = new Shop_Compare_Controller_Show($oShop);
						$Shop_Compare_Controller_Show
							->xsl(
								Core_Entity::factory('Xsl')->getByName(
									Core_Array::get(Core_Page::instance()->widgetParams, 'shortCompareXsl')
								)
							)
							->itemsPropertiesList(FALSE)
							->show();

						?>
					</div>
					<div class="little-wishlist">
						<?php
						// Wishlist
						$Shop_Favorite_Controller_Show = new Shop_Favorite_Controller_Show($oShop);

						$Shop_Favorite_Controller_Show
							->xsl(
								Core_Entity::factory('Xsl')->getByName(
									Core_Array::get(Core_Page::instance()->widgetParams, 'shortFavoriteXsl')
								)
							)
							->itemsPropertiesList(FALSE)
							->show();
						?>
					</div>
					<?php
				}
				?>
			</div>
			<div class="user-account-wrapper-triangle d-none d-lg-block"></div>
		</div>

		<?php
		if (Core::moduleIsActive('shop'))
		{
			$Shop_Favorite_Controller = Shop_Favorite_Controller::instance();
			$aShop_Favorites = $Shop_Favorite_Controller->getAll($oShop);

			$Shop_Compare_Controller = Shop_Compare_Controller::instance();
			$aShop_Compares = $Shop_Compare_Controller->getAll($oShop);

			$dot_class = '';

			if (count($aShop_Favorites) && !count($aShop_Compares))
			{
				$dot_class = 'favorite';
			}
			elseif (count($aShop_Compares) && !count($aShop_Favorites))
			{
				$dot_class = 'compare';
			}
			elseif (!count($aShop_Favorites) && !count($aShop_Compares))
			{
				$dot_class = 'hidden';
			}

			?>
			<span class="dot <?php echo $dot_class?>"></span>
			<?php
		}
		?>
	</span>
</div>

<?php
if (Core::moduleIsActive('search'))
{
	?>
	<div class="search-wrapper">
		<span class="popup-close">&times;</span>
		<div class="search-input-wrapper">
			<div class="input-box">
				<form class="top-search-form" action="/search/" method="get">
					<input id="search" name="text" type="text" placeholder="Поиск..."/>
				</form>
				<span><i class="fa fa-search" onclick="$('.search-input-wrapper .top-search-form').submit();"></i></span>
			</div>
		</div>
	</div>
	<?php
}

if (Core::moduleIsActive('shop'))
{
	?><div class="little-cart-wrapper"><?php
	$Shop_Cart_Controller_Show = new Shop_Cart_Controller_Show(
		Core_Entity::factory('Shop', $oShop->id)
	);

	$Shop_Cart_Controller_Show
		->xsl(
			Core_Entity::factory('Xsl')->getByName(
				Core_Array::get(Core_Page::instance()->widgetParams, 'littleCartXsl')
			)
		)
		->couponText(
			Core_Array::get(Core_Array::getSession('hostcmsOrder', array()), 'coupon_text')
		)
		->itemsPropertiesList(FALSE)
		->show();
	?></div><?php
}