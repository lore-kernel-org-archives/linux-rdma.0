From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 07/29] IB/core: move macros from cm_msgs.h to ib_cm.h
Date: Mon, 11 Jun 2012 13:45:48 +0300
Message-ID: <1339411570-4689-8-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These macros will be reused by the mlx4 SRIOV-IB CM
paravirtualization code, and there is no reason to have
them declared both in the IB core in the mlx4 IB driver.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cm_msgs.h |   12 ------------
 include/rdma/ib_cm.h              |   12 ++++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index 7da9b21..be068f4 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -44,18 +44,6 @@
 
 #define IB_CM_CLASS_VERSION	2 /* IB specification 1.2 */
 
-#define CM_REQ_ATTR_ID		cpu_to_be16(0x0010)
-#define CM_MRA_ATTR_ID		cpu_to_be16(0x0011)
-#define CM_REJ_ATTR_ID		cpu_to_be16(0x0012)
-#define CM_REP_ATTR_ID		cpu_to_be16(0x0013)
-#define CM_RTU_ATTR_ID		cpu_to_be16(0x0014)
-#define CM_DREQ_ATTR_ID		cpu_to_be16(0x0015)
-#define CM_DREP_ATTR_ID		cpu_to_be16(0x0016)
-#define CM_SIDR_REQ_ATTR_ID	cpu_to_be16(0x0017)
-#define CM_SIDR_REP_ATTR_ID	cpu_to_be16(0x0018)
-#define CM_LAP_ATTR_ID		cpu_to_be16(0x0019)
-#define CM_APR_ATTR_ID		cpu_to_be16(0x001A)
-
 enum cm_msg_sequence {
 	CM_MSG_SEQUENCE_REQ,
 	CM_MSG_SEQUENCE_LAP,
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index 83f77ac..0e3ff30 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -262,6 +262,18 @@ struct ib_cm_event {
 	void			*private_data;
 };
 
+#define CM_REQ_ATTR_ID		cpu_to_be16(0x0010)
+#define CM_MRA_ATTR_ID		cpu_to_be16(0x0011)
+#define CM_REJ_ATTR_ID		cpu_to_be16(0x0012)
+#define CM_REP_ATTR_ID		cpu_to_be16(0x0013)
+#define CM_RTU_ATTR_ID		cpu_to_be16(0x0014)
+#define CM_DREQ_ATTR_ID		cpu_to_be16(0x0015)
+#define CM_DREP_ATTR_ID		cpu_to_be16(0x0016)
+#define CM_SIDR_REQ_ATTR_ID	cpu_to_be16(0x0017)
+#define CM_SIDR_REP_ATTR_ID	cpu_to_be16(0x0018)
+#define CM_LAP_ATTR_ID		cpu_to_be16(0x0019)
+#define CM_APR_ATTR_ID		cpu_to_be16(0x001A)
+
 /**
  * ib_cm_handler - User-defined callback to process communication events.
  * @cm_id: Communication identifier associated with the reported event.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
