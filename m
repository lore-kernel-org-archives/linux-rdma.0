From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Corrected queue SGE calculation.
Date: Fri, 8 Jun 2012 21:26:11 +0530
Message-ID: <5503e0d3-a509-46f5-b59f-13eb8993094c@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mahesh.Vardhamanaiah-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Fixed max sge calculation for sq, rq, srq for all hardware types.

Signed-off-by: Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    3 +++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |    3 +++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    6 +++---
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 037f5ce..48970af 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -61,6 +61,7 @@ struct ocrdma_dev_attr {
 	u32 max_inline_data;
 	int max_send_sge;
 	int max_recv_sge;
+	int max_srq_sge;
 	int max_mr;
 	u64 max_mr_size;
 	u32 max_num_mr_pbl;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 5704bb9..ea94caf 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1002,6 +1002,9 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->max_recv_sge = (rsp->max_write_send_sge &
 			      OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_SHIFT;
+	attr->max_srq_sge = (rsp->max_srq_rqe_sge &
+			      OCRDMA_MBX_QUERY_CFG_MAX_SRQ_SGE_MASK) >>
+	    OCRDMA_MBX_QUERY_CFG_MAX_SRQ_SGE_OFFSET;
 	attr->max_ord_per_qp = (rsp->max_ird_ord_per_qp &
 				OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_SHIFT;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 8411441..c75cbdf 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -418,6 +418,9 @@ enum {
 
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_SHIFT		= 0,
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_MASK		= 0xFFFF,
+	OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_SHIFT	= 16,
+	OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_MASK		= 0xFFFF <<
+				OCRDMA_MBX_QUERY_CFG_MAX_WRITE_SGE_SHIFT,
 
 	OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_SHIFT	= 0,
 	OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_MASK	= 0xFFFF,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index d16d172..0e88088 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -83,8 +83,8 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 					IB_DEVICE_SHUTDOWN_PORT |
 					IB_DEVICE_SYS_IMAGE_GUID |
 					IB_DEVICE_LOCAL_DMA_LKEY;
-	attr->max_sge = dev->attr.max_send_sge;
-	attr->max_sge_rd = dev->attr.max_send_sge;
+	attr->max_sge = min(dev->attr.max_send_sge, dev->attr.max_srq_sge);
+	attr->max_sge_rd = 0;
 	attr->max_cq = dev->attr.max_cq;
 	attr->max_cqe = dev->attr.max_cqe;
 	attr->max_mr = dev->attr.max_mr;
@@ -97,7 +97,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	    min(dev->attr.max_ord_per_qp, dev->attr.max_ird_per_qp);
 	attr->max_qp_init_rd_atom = dev->attr.max_ord_per_qp;
 	attr->max_srq = (dev->attr.max_qp - 1);
-	attr->max_srq_sge = attr->max_sge;
+	attr->max_srq_sge = attr->max_srq_sge;
 	attr->max_srq_wr = dev->attr.max_rqe;
 	attr->local_ca_ack_delay = dev->attr.local_ca_ack_delay;
 	attr->max_fast_reg_page_list_len = 0;
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
