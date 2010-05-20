From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 08/11] RDMA/cxgb4: Update some HW limits.
Date: Thu, 20 May 2010 16:58:05 -0500
Message-ID: <20100520215805.32394.34425.stgit@build.ogc.int>
References: <20100520215727.32394.90669.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100520215727.32394.90669.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/t4.h |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 333abd3..1057cb9 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -41,11 +41,13 @@
 #define T4_MAX_NUM_QP (1<<16)
 #define T4_MAX_NUM_CQ (1<<15)
 #define T4_MAX_NUM_PD (1<<15)
-#define T4_MAX_PBL_SIZE 256
-#define T4_MAX_RQ_SIZE 1024
-#define T4_MAX_SQ_SIZE 1024
-#define T4_MAX_QP_DEPTH (T4_MAX_RQ_SIZE-1)
-#define T4_MAX_CQ_DEPTH 8192
+#define T4_EQ_STATUS_ENTRIES (L1_CACHE_BYTES > 64 ? 2 : 1)
+#define T4_MAX_EQ_SIZE (65520 - T4_EQ_STATUS_ENTRIES)
+#define T4_MAX_IQ_SIZE (65520 - 1)
+#define T4_MAX_RQ_SIZE (8192 - T4_EQ_STATUS_ENTRIES)
+#define T4_MAX_SQ_SIZE (T4_MAX_EQ_SIZE - 1)
+#define T4_MAX_QP_DEPTH (T4_MAX_RQ_SIZE - 1)
+#define T4_MAX_CQ_DEPTH (T4_MAX_IQ_SIZE - 1)
 #define T4_MAX_NUM_STAG (1<<15)
 #define T4_MAX_MR_SIZE (~0ULL - 1)
 #define T4_PAGESIZE_MASK 0xffff000  /* 4KB-128MB */
@@ -79,12 +81,11 @@ struct t4_status_page {
 			sizeof(struct fw_ri_isgl)) / sizeof(struct fw_ri_sge))
 #define T4_MAX_FR_IMMD ((T4_SQ_NUM_BYTES - sizeof(struct fw_ri_fr_nsmr_wr) - \
 			sizeof(struct fw_ri_immd)))
-#define T4_MAX_FR_DEPTH 255
+#define T4_MAX_FR_DEPTH (T4_MAX_FR_IMMD / sizeof(u64))
 
 #define T4_RQ_NUM_SLOTS 2
 #define T4_RQ_NUM_BYTES (T4_EQ_SIZE * T4_RQ_NUM_SLOTS)
-#define T4_MAX_RECV_SGE ((T4_RQ_NUM_BYTES - sizeof(struct fw_ri_recv_wr) - \
-			sizeof(struct fw_ri_isgl)) / sizeof(struct fw_ri_sge))
+#define T4_MAX_RECV_SGE 4
 
 union t4_wr {
 	struct fw_ri_res_wr res;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
