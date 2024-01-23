<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://234">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	
	<!-- МагазинКарточкаЗаказа -->
	
	<xsl:template match="/shop">
		<p style="margin-bottom: 40px"><img src="/admin/images/logo.gif" alt="(^) HostCMS" title="HostCMS" /></p>
		
		<table cellpadding="2" cellspacing="2" border="0" width="100%">
			<xsl:apply-templates select="shop_company"/>
		</table>
		
		<h2 align="center">&labelTitle; <xsl:value-of select="shop_order/invoice" /> &labelFrom; <xsl:value-of select="shop_order/datetime" /></h2>
		
		<table cellpadding="2" cellspacing="2" border="0" width="100%">
			<xsl:apply-templates select="shop_order"/>
		</table>
		
		<br/>
		
		<table cellspacing="0" cellpadding="3" width="100%">
			<tr>
				<td class="td_header">
					№
				</td>
				<td class="td_header">
					&labelName;
				</td>
				<td class="td_header">
					&labelMarking;
				</td>
				<td class="td_header">
					&labelMeasure;
				</td>
				<td class="td_header">
				&labelPrice;,<xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/sign" />
				</td>
				<td class="td_header">
					&labelQuantity;
				</td>
				<td class="td_header">
					&labelTaxPrice;
				</td>
				<td class="td_header">
				&labelTax;,<xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/sign" />
				</td>
				<td class="td_header" style="border-right: 1px solid black; white-space: nowrap;">
				&labelSum;,<xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/sign" />
				</td>
			</tr>
			
			<xsl:apply-templates select="shop_order/shop_order_item"/>
		</table>
		
		<table width="100%" cellspacing="0" cellpadding="3">
			<tr class="tr_footer">
				<td width="80%" align="right" style="border-bottom: 1px solid black;" colspan="6">
					&labelLine1;
				</td>
				<td width="80%" align="right"  style="border-bottom: 1px solid black;" colspan="2">
					<xsl:value-of select="/shop/shop_order/shop_tax_value_sum" /><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/sign" />
				</td>
			</tr>
			<tr class="tr_footer">
				<td align="right" colspan="6">
					&labelTotal;
				</td>
				<td align="right" colspan="2">
					<xsl:value-of select="/shop/shop_order/shop_order_item_sum" /><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/sign" />
				</td>
			</tr>
		</table>
		
		<table cellpadding="2" cellspacing="2" border="0"  width="100%">
			<tr>
				<td valign="top" width="30%">
					&labelPaymentSystem;
				</td>
				<td valign="top">
					<b><xsl:value-of select="/shop/shop_order/shop_payment_system/name" /></b>
				</td>
			</tr>
			<tr>
				<td valign="top">
					&labelPaid;
				</td>
				<td valign="top">
					<xsl:choose>
					<xsl:when test="/shop/shop_order/paid != 0"><b>&labelYes;</b></xsl:when>
						<xsl:otherwise>&labelNo;</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td valign="top">
					&labelCanceled;
				</td>
				<td valign="top">
					<xsl:choose>
					<xsl:when test="/shop/shop_order/canceled != 0"><b>&labelYes;</b></xsl:when>
						<xsl:otherwise>&labelNo;</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			
			<xsl:if test="/shop/shop_order/shop_order_status_id != 0">
				<tr>
					<td valign="top">
						&labelOrderStatus;
					</td>
					<td valign="top">
					<b><xsl:value-of select="/shop/shop_order/shop_order_status/name" /><xsl:text> </xsl:text>(<xsl:value-of select="/shop/shop_order/status_datetime" />)</b>
					</td>
				</tr>
			</xsl:if>
			
			<xsl:if test="/shop/shop_order/shop_delivery_condition_id != 0">
				<tr>
					<td valign="top">
						&labelDeliveryType;
					</td>
					<td valign="top">
					<b><xsl:value-of select="/shop/shop_order/shop_delivery/name" /><xsl:text> </xsl:text>(<xsl:value-of select="/shop/shop_order/shop_delivery/shop_delivery_condition/name" />)</b>
					</td>
				</tr>
			</xsl:if>
			
			<xsl:if test="/shop/shop_order/description != ''">
				<tr>
					<td valign="top">
						&labelOrderDescription;
					</td>
					<td>
						<xsl:value-of select="/shop/shop_order/description" />
					</td>
				</tr>
			</xsl:if>
			
			<xsl:if test="/shop/shop_order/system_information != ''">
				<tr>
					<td valign="top">
						&labelSystemInformation;
					</td>
					<td>
						<xsl:value-of select="/shop/shop_order/system_information" />
					</td>
				</tr>
			</xsl:if>
			
			<xsl:if test="/shop/shop_order/source_id != 0">
			<tr><td colspan="2"></td></tr>
				<tr>
					<td>&labelService;</td>
					<td><xsl:value-of select="/shop/shop_order/source/service" /></td>
				</tr>
				<tr>
					<td>&labelCampaign;</td>
					<td><xsl:value-of select="/shop/shop_order/source/campaign" /></td>
				</tr>
				<tr>
					<td>&labelAd;</td>
					<td><xsl:value-of select="/shop/shop_order/source/ad" /></td>
				</tr>
				<tr>
					<td>&labelSource;</td>
					<td><xsl:value-of select="/shop/shop_order/source/source" /></td>
				</tr>
				<tr>
					<td>&labelMedium;</td>
					<td><xsl:value-of select="/shop/shop_order/source/medium" /></td>
				</tr>
				<tr>
					<td>&labelContent;</td>
					<td><xsl:value-of select="/shop/shop_order/source/content" /></td>
				</tr>
				<tr>
					<td>&labelTerm;</td>
					<td><xsl:value-of select="/shop/shop_order/source/term" /></td>
				</tr>
			</xsl:if>
			
		</table>
	</xsl:template>
	
	<xsl:template match="shop_company">
		<tr>
			<td valign="top" width="17%">
				&labelSupplier;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="name" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelKPP;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="kpp" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelPsrn;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="psrn" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelAddress;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="address" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelPhone;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="phone" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelFax;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="fax" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelEmail;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="email" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelSite;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="site" />
				</b>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="shop_order">
		<tr>
			<td valign="top" width="17%">
				&labelCompany;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="company" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelContact;
			</td>
			<td valign="top">
				<b>
				<xsl:value-of select="surname" /><xsl:text> </xsl:text><xsl:value-of select="name" /><xsl:text> </xsl:text><xsl:value-of select="patronymic" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelAddress;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="/shop/full_address" />
				</b>
			</td>
		</tr>
		<xsl:if test="siteuser/node()">
			<tr>
				<td valign="top">
					&labelUser;
				</td>
				<td valign="top">
					<b>
					<xsl:value-of select="siteuser/login" /><xsl:text> </xsl:text>(код<xsl:text> </xsl:text><xsl:value-of select="siteuser/@id" />)
					</b>
				</td>
			</tr>
		</xsl:if>
		<tr>
			<td valign="top">
				&labelPhone;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="phone" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelFax;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="fax" />
				</b>
			</td>
		</tr>
		<tr>
			<td valign="top">
				&labelEmail;
			</td>
			<td valign="top">
				<b>
					<xsl:value-of select="email" />
				</b>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="shop_order_item">
		<tr>
			<td style="text-align: center;" class="td_main_2" >
				<xsl:value-of select="position()" />
			</td>
			<td class="td_main_2">
				<xsl:value-of select="name" />
			</td>
			<td class="td_main_2">
				<xsl:value-of select="marking" />
			</td>
			<td class="td_main_2">
				<xsl:value-of select="shop_measure/name" />
			</td>
			<td class="td_main_2">
				<xsl:value-of select="price - tax" />
			</td>
			<td style="text-align: center;" class="td_main_2">
				<xsl:value-of select="quantity" />
			</td>
			<td style="text-align: center;" class="td_main_2">
				<xsl:choose>
					<xsl:when test="rate &gt; 0">
						<xsl:value-of select="rate" />%
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="rate" /></xsl:otherwise>
				</xsl:choose>
			</td>
			<td style="text-align: center;" class="td_main_2">
				<xsl:value-of select="tax * quantity" />
			</td>
			<td class="td_main_2" style="border-right: 1px solid black; white-space: nowrap;">
				<xsl:value-of select="price * quantity" />
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>