From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 20/28] IB/hfi1: Disable external device configuration
 requests
Date: Mon, 25 Jul 2016 13:39:51 -0700
Message-ID: <20160725203950.4800.59636.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

QSFP CDR enablement is now controlled by determining power class
and the configuration file. We disable the DC 8051 from requesting
enablement or disabling of TX and RX CDRs by removing the code
that allowed the DC 8051 to request changes.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/platform.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index 03df932..41af629 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -537,20 +537,6 @@ static void apply_tunings(
 	u8 precur = 0, attn = 0, postcur = 0, external_device_config = 0;
 	u8 *cache = ppd->qsfp_info.cache;
 
-	/* Enable external device config if channel is limiting active */
-	read_8051_config(ppd->dd, LINK_OPTIMIZATION_SETTINGS,
-			 GENERAL_CONFIG, &config_data);
-	config_data &= ~(0xff << ENABLE_EXT_DEV_CONFIG_SHIFT);
-	config_data |= ((u32)limiting_active << ENABLE_EXT_DEV_CONFIG_SHIFT);
-	ret = load_8051_config(ppd->dd, LINK_OPTIMIZATION_SETTINGS,
-			       GENERAL_CONFIG, config_data);
-	if (ret != HCMD_SUCCESS)
-		dd_dev_err(
-			ppd->dd,
-			"%s: Failed to set enable external device config\n",
-			__func__);
-
-	config_data = 0; /* re-init  */
 	/* Pass tuning method to 8051 */
 	read_8051_config(ppd->dd, LINK_TUNING_PARAMETERS, GENERAL_CONFIG,
 			 &config_data);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
