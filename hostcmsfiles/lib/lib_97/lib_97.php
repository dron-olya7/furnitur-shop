<?php
$aImages = Core_Array::get(Core_Page::instance()->widgetParams, 'image');
$aTexts = Core_Array::get(Core_Page::instance()->widgetParams, 'text');
?>
<main class="content main">
	<div class="main-slider">
		<div class="container arrows-container"></div>
		<div class="main-slider-list js-slider-main">
			<?php
			foreach ($aImages as $key => $path)
			{
				?>
				<div class="main-slider-item">
					<div class="main-slider-img">
						<img class="lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" data-bg="<?php echo htmlspecialchars($path)?>" />
					</div>
					<?php
					if (isset($aTexts[$key]) && strlen($aTexts[$key]))
					{
						?>
						<div class="container">
							<div class="content-wrapper gradient"><?php echo $aTexts[$key]?></div>
						</div>
						<?php
					}
					?>
				</div>
				<?php
			}
			?>
		</div>
	</div>
</main>