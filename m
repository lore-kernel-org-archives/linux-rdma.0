From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 05/10] IB/qib: Use rdmavt lid defines in qib
Date: Fri, 22 Jan 2016 12:45:02 -0800
Message-ID: <20160122204458.2022.65080.stgit@scvm10.sc.intel.com>
References: <20160122204145.2022.26449.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122204145.2022.26449.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Original patch for AH changes from Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, split
apart from original. This patch also removes the qib specific multicast
lid base and permissive lid defines since they are no longer needed.

Use common LID defines in qib driver.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_common.h |    2 --
 drivers/infiniband/hw/qib/qib_qp.c     |    1 +
 drivers/infiniband/hw/qib/qib_verbs.c  |    4 ++--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_common.h b/drivers/infiniband/hw/qib/qib_common.h
index 4fb78ab..1d87ec0 100644
--- a/drivers/infiniband/hw/qib/qib_common.h
+++ b/drivers/infiniband/hw/qib/qib_common.h
@@ -742,14 +742,12 @@ struct qib_tid_session_member {
 #define SIZE_OF_CRC 1
 
 #define QIB_DEFAULT_P_KEY 0xFFFF
-#define QIB_PERMISSIVE_LID 0xFFFF
 #define QIB_AETH_CREDIT_SHIFT 24
 #define QIB_AETH_CREDIT_MASK 0x1F
 #define QIB_AETH_CREDIT_INVAL 0x1F
 #define QIB_PSN_MASK 0xFFFFFF
 #define QIB_MSN_MASK 0xFFFFFF
 #define QIB_QPN_MASK 0xFFFFFF
-#define QIB_MULTICAST_LID_BASE 0xC000
 #define QIB_EAGER_TID_ID QLOGIC_IB_I_TID_MASK
 #define QIB_MULTICAST_QPN 0xFFFFFF
 
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index e8beeee..6c17c90 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -35,6 +35,7 @@
 #include <linux/err.h>
 #include <linux/vmalloc.h>
 #include <linux/jhash.h>
+#include <rdma/rdma_vt.h>
 #ifdef CONFIG_DEBUG_FS
 #include <linux/seq_file.h>
 #endif
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 84c828e..3bfa1a6 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1759,8 +1759,8 @@ static int qib_query_gid(struct ib_device *ibdev, u8 port,
 int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
 {
 	/* A multicast address requires a GRH (see ch. 8.4.1). */
-	if (ah_attr->dlid >= QIB_MULTICAST_LID_BASE &&
-	    ah_attr->dlid != QIB_PERMISSIVE_LID &&
+	if (ah_attr->dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE) &&
+	    ah_attr->dlid != be16_to_cpu(IB_LID_PERMISSIVE) &&
 	    !(ah_attr->ah_flags & IB_AH_GRH))
 		goto bail;
 	if ((ah_attr->ah_flags & IB_AH_GRH) &&

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
