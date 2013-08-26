From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/14] RDMA/ocrdma: Increate STAG array size.
Date: Mon, 26 Aug 2013 15:27:46 +0530
Message-ID: <3ad3cfa7-3f2a-4423-9f65-0f7e97cc5e1b@CMEXHTCAS1.ad.emulex.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377511071-16967-1-git-send-email-bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

1) Increase STAG Array size.
2) Max inline data size should be set to the same value
   used during QP creation
3) Set max_sge_rd to zero since we dont support RD transport in our adapters.
4) Max cqes reported in ibv_devinfo should be from QUERY_CONFIG.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 4 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 618c212..3f02755 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -994,6 +994,9 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->max_num_mr_pbl = rsp->max_num_mr_pbl;
 	attr->max_cqe = rsp->max_cq_cqes_per_cq &
 			OCRDMA_MBX_QUERY_CFG_MAX_CQES_PER_CQ_MASK;
+	attr->max_cq = (rsp->max_cq_cqes_per_cq &
+			OCRDMA_MBX_QUERY_CFG_MAX_CQ_MASK) >>
+			OCRDMA_MBX_QUERY_CFG_MAX_CQ_OFFSET;
 	attr->wqe_size = ((rsp->wqe_rqe_stride_max_dpp_cqs &
 		OCRDMA_MBX_QUERY_CFG_MAX_WQE_SIZE_MASK) >>
 		OCRDMA_MBX_QUERY_CFG_MAX_WQE_SIZE_OFFSET) *
@@ -1026,7 +1029,6 @@ static int ocrdma_check_fw_config(struct ocrdma_dev *dev,
 		return -EINVAL;
 	dev->base_eqid = conf->base_eqid;
 	dev->max_eq = conf->max_eq;
-	dev->attr.max_cq = OCRDMA_MAX_CQ - 1;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 1e2992f..35c6108 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -91,7 +91,7 @@ enum {
 
 #define OCRDMA_MAX_QP    2048
 #define OCRDMA_MAX_CQ    2048
-#define OCRDMA_MAX_STAG  2048
+#define OCRDMA_MAX_STAG  8192
 
 enum {
 	OCRDMA_DB_RQ_OFFSET		= 0xE0,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index e554fc2..e934073 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -85,7 +85,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 					IB_DEVICE_LOCAL_DMA_LKEY |
 					IB_DEVICE_MEM_MGT_EXTENSIONS;
 	attr->max_sge = min(dev->attr.max_send_sge, dev->attr.max_srq_sge);
-	attr->max_sge_rd = dev->attr.max_rdma_sge;
+	attr->max_sge_rd = 0;
 	attr->max_cq = dev->attr.max_cq;
 	attr->max_cqe = dev->attr.max_cqe;
 	attr->max_mr = dev->attr.max_mr;
@@ -1365,7 +1365,7 @@ int ocrdma_query_qp(struct ib_qp *ibqp,
 	qp_attr->cap.max_recv_wr = qp->rq.max_cnt - 1;
 	qp_attr->cap.max_send_sge = qp->sq.max_sges;
 	qp_attr->cap.max_recv_sge = qp->rq.max_sges;
-	qp_attr->cap.max_inline_data = dev->attr.max_inline_data;
+	qp_attr->cap.max_inline_data = qp->max_inline_data;
 	qp_init_attr->cap = qp_attr->cap;
 	memcpy(&qp_attr->ah_attr.grh.dgid, &params.dgid[0],
 	       sizeof(params.dgid));
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
