From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] bnxt_re: Make room for mapping beyond 32 entries
Date: Tue, 17 Oct 2017 14:01:35 +0530
Message-ID: <20171017083135.30806-1-somnath.kotur@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Latest chip requires indexes 32 to 47 be used for the internal HW block
that manages queue mapping.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.h | 2 +-
 drivers/infiniband/hw/bnxt_re/roce_hsi.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.h b/drivers/infiniband/hw/bnxt_re/qplib_res.h
index e872075..2e5c052 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.h
@@ -169,7 +169,7 @@ struct bnxt_qplib_ctx {
 	u32				cq_count;
 	struct bnxt_qplib_hwq		cq_tbl;
 	struct bnxt_qplib_hwq		tim_tbl;
-#define MAX_TQM_ALLOC_REQ		32
+#define MAX_TQM_ALLOC_REQ		48
 #define MAX_TQM_ALLOC_BLK_SIZE		8
 	u8				tqm_count[MAX_TQM_ALLOC_REQ];
 	struct bnxt_qplib_hwq		tqm_pde;
diff --git a/drivers/infiniband/hw/bnxt_re/roce_hsi.h b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
index eeb55b2..c3cba606 100644
--- a/drivers/infiniband/hw/bnxt_re/roce_hsi.h
+++ b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
@@ -2644,7 +2644,7 @@ struct creq_query_func_resp_sb {
 	u8 l2_db_space_size;
 	__le16 max_srq;
 	__le32 max_gid;
-	__le32 tqm_alloc_reqs[8];
+	__le32 tqm_alloc_reqs[12];
 };
 
 /* Set resources command response (16 bytes) */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
