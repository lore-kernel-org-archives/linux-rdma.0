From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/10] IB/hfi1: Correct 8051 link parameter settings
Date: Tue, 24 May 2016 12:51:00 -0700
Message-ID: <20160524195058.19706.59020.stgit@scvm10.sc.intel.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524194746.19706.42976.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Two 8051 link settings, external device config and tuning method,
were written in the wrong location and the previous settings were
not cleared.  For both, clear the old value and write the new
value.

Fixes: 8ebd4cf1852a ("staging/rdma/hfi1: Add active and optical cable support")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.h     |    6 ++++++
 drivers/infiniband/hw/hfi1/platform.c |    6 ++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 1948706..66a3279 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -398,6 +398,12 @@
 /* Lane ID for general configuration registers */
 #define GENERAL_CONFIG 4
 
+/* LINK_TUNING_PARAMETERS fields */
+#define TUNING_METHOD_SHIFT 24
+
+/* LINK_OPTIMIZATION_SETTINGS fields */
+#define ENABLE_EXT_DEV_CONFIG_SHIFT 24
+
 /* LOAD_DATA 8051 command shifts and fields */
 #define LOAD_DATA_FIELD_ID_SHIFT 40
 #define LOAD_DATA_FIELD_ID_MASK 0xfull
diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index ae0e498..03df932 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -540,7 +540,8 @@ static void apply_tunings(
 	/* Enable external device config if channel is limiting active */
 	read_8051_config(ppd->dd, LINK_OPTIMIZATION_SETTINGS,
 			 GENERAL_CONFIG, &config_data);
-	config_data |= limiting_active;
+	config_data &= ~(0xff << ENABLE_EXT_DEV_CONFIG_SHIFT);
+	config_data |= ((u32)limiting_active << ENABLE_EXT_DEV_CONFIG_SHIFT);
 	ret = load_8051_config(ppd->dd, LINK_OPTIMIZATION_SETTINGS,
 			       GENERAL_CONFIG, config_data);
 	if (ret != HCMD_SUCCESS)
@@ -553,7 +554,8 @@ static void apply_tunings(
 	/* Pass tuning method to 8051 */
 	read_8051_config(ppd->dd, LINK_TUNING_PARAMETERS, GENERAL_CONFIG,
 			 &config_data);
-	config_data |= tuning_method;
+	config_data &= ~(0xff << TUNING_METHOD_SHIFT);
+	config_data |= ((u32)tuning_method << TUNING_METHOD_SHIFT);
 	ret = load_8051_config(ppd->dd, LINK_TUNING_PARAMETERS, GENERAL_CONFIG,
 			       config_data);
 	if (ret != HCMD_SUCCESS)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
