From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.10 1/4] IB/iser: Add module version
Date: Wed,  1 May 2013 16:25:24 +0300
Message-ID: <1367414727-22680-2-git-send-email-ogerlitz@mellanox.com>
References: <1367414727-22680-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1367414727-22680-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add displaying module version, update the version to 1.1,
and remove the DRV_DATE define.

Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    6 +++---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 0ab8c9c..69e0d7c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -82,10 +82,10 @@ module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
 int iser_debug_level = 0;
 
-MODULE_DESCRIPTION("iSER (iSCSI Extensions for RDMA) Datamover "
-		   "v" DRV_VER " (" DRV_DATE ")");
+MODULE_DESCRIPTION("iSER (iSCSI Extensions for RDMA) Datamover");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Alex Nezhinsky, Dan Bar Dov, Or Gerlitz");
+MODULE_VERSION(DRV_VER);
 
 module_param_named(debug_level, iser_debug_level, int, 0644);
 MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default:disabled)");
@@ -682,7 +682,7 @@ static umode_t iser_attr_is_visible(int param_type, int param)
 
 static struct scsi_host_template iscsi_iser_sht = {
 	.module                 = THIS_MODULE,
-	.name                   = "iSCSI Initiator over iSER, v." DRV_VER,
+	.name                   = "iSCSI Initiator over iSER",
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
 	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 5babdb3..0da04bf 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -65,8 +65,7 @@
 
 #define DRV_NAME	"iser"
 #define PFX		DRV_NAME ": "
-#define DRV_VER		"0.1"
-#define DRV_DATE	"May 7th, 2006"
+#define DRV_VER		"1.1"
 
 #define iser_dbg(fmt, arg...)				\
 	do {						\
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
