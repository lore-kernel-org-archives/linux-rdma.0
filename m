From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Fix the max_sge reported from FW
Date: Wed, 24 Aug 2016 01:17:41 -0400
Message-ID: <1472015861-10312-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Current driver is reporting wrong values for max_sge and
max_sge_rd in query_device. This breaks the nfs rdma and iser
in some device profiles. Fixing the driver to report
correct values from FW.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 14 +++++++-------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 12 ++++++++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  4 ++--
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 16740dc..67fc0b6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1156,18 +1156,18 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->max_srq =
 		(rsp->max_srq_rpir_qps & OCRDMA_MBX_QUERY_CFG_MAX_SRQ_MASK) >>
 		OCRDMA_MBX_QUERY_CFG_MAX_SRQ_OFFSET;
-	attr->max_send_sge = ((rsp->max_write_send_sge &
+	attr->max_send_sge = ((rsp->max_recv_send_sge &
 			       OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_MASK) >>
 			      OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_SHIFT);
-	attr->max_recv_sge = (rsp->max_write_send_sge &
-			      OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_MASK) >>
-	    OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_SHIFT;
+	attr->max_recv_sge = (rsp->max_recv_send_sge &
+			      OCRDMA_MBX_QUERY_CFG_MAX_RECV_SGE_MASK) >>
+	    OCRDMA_MBX_QUERY_CFG_MAX_RECV_SGE_SHIFT;
 	attr->max_srq_sge = (rsp->max_srq_rqe_sge &
 			      OCRDMA_MBX_QUERY_CFG_MAX_SRQ_SGE_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_SRQ_SGE_OFFSET;
-	attr->max_rdma_sge = (rsp->max_write_send_sge &
-			      OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_MASK) >>
-	    OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_SHIFT;
+	attr->max_rdma_sge = (rsp->max_wr_rd_sge &
+			      OCRDMA_MBX_QUERY_CFG_MAX_RD_SGE_MASK) >>
+	    OCRDMA_MBX_QUERY_CFG_MAX_RD_SGE_SHIFT;
 	attr->max_ord_per_qp = (rsp->max_ird_ord_per_qp &
 				OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_SHIFT;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 0efc966..37df448 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -554,9 +554,9 @@ enum {
 	OCRDMA_MBX_QUERY_CFG_L3_TYPE_MASK		= 0x18,
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_SHIFT		= 0,
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_MASK		= 0xFFFF,
-	OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_SHIFT	= 16,
-	OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_MASK		= 0xFFFF <<
-				OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_SHIFT,
+	OCRDMA_MBX_QUERY_CFG_MAX_RECV_SGE_SHIFT	= 16,
+	OCRDMA_MBX_QUERY_CFG_MAX_RECV_SGE_MASK		= 0xFFFF <<
+				OCRDMA_MBX_QUERY_CFG_MAX_RECV_SGE_SHIFT,
 
 	OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_SHIFT	= 0,
 	OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_MASK	= 0xFFFF,
@@ -612,6 +612,8 @@ enum {
 	OCRDMA_MBX_QUERY_CFG_MAX_SRQ_SGE_OFFSET		= 0,
 	OCRDMA_MBX_QUERY_CFG_MAX_SRQ_SGE_MASK		= 0xFFFF <<
 				OCRDMA_MBX_QUERY_CFG_MAX_SRQ_SGE_OFFSET,
+	OCRDMA_MBX_QUERY_CFG_MAX_RD_SGE_SHIFT		= 0,
+	OCRDMA_MBX_QUERY_CFG_MAX_RD_SGE_MASK		= 0xFFFF,
 };
 
 struct ocrdma_mbx_query_config {
@@ -619,7 +621,7 @@ struct ocrdma_mbx_query_config {
 	struct ocrdma_mbx_rsp rsp;
 	u32 qp_srq_cq_ird_ord;
 	u32 max_pd_ca_ack_delay;
-	u32 max_write_send_sge;
+	u32 max_recv_send_sge;
 	u32 max_ird_ord_per_qp;
 	u32 max_shared_ird_ord;
 	u32 max_mr;
@@ -639,6 +641,8 @@ struct ocrdma_mbx_query_config {
 	u32 max_wqes_rqes_per_q;
 	u32 max_cq_cqes_per_cq;
 	u32 max_srq_rqe_sge;
+	u32 max_wr_rd_sge;
+	u32 ird_pgsz_num_pages;
 };
 
 struct ocrdma_fw_ver_rsp {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index b1a3d91..0aa8547 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -125,8 +125,8 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr,
 					IB_DEVICE_SYS_IMAGE_GUID |
 					IB_DEVICE_LOCAL_DMA_LKEY |
 					IB_DEVICE_MEM_MGT_EXTENSIONS;
-	attr->max_sge = dev->attr.max_send_sge;
-	attr->max_sge_rd = attr->max_sge;
+	attr->max_sge = min(dev->attr.max_send_sge, dev->attr.max_recv_sge);
+	attr->max_sge_rd = dev->attr.max_rdma_sge;
 	attr->max_cq = dev->attr.max_cq;
 	attr->max_cqe = dev->attr.max_cqe;
 	attr->max_mr = dev->attr.max_mr;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
