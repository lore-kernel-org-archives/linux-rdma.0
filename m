From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Corrected Queue max values.
Date: Fri, 8 Jun 2012 21:25:52 +0530
Message-ID: <bb3bb1ac-9ff5-4980-b851-cf598ea6bf30@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mahesh.Vardhamanaiah-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Fixed  code to read the max wqe and max rqe values from
mailbox response.

Signed-off-by: Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c  |   15 +++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h |    2 +-
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index f26314f..5704bb9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -990,8 +990,6 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 			      struct ocrdma_dev_attr *attr,
 			      struct ocrdma_mbx_query_config *rsp)
 {
-	int max_q_mem;
-
 	attr->max_pd =
 	    (rsp->max_pd_ca_ack_delay & OCRDMA_MBX_QUERY_CFG_MAX_PD_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_PD_SHIFT;
@@ -1037,18 +1035,15 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->max_inline_data =
 	    attr->wqe_size - (sizeof(struct ocrdma_hdr_wqe) +
 			      sizeof(struct ocrdma_sge));
-	max_q_mem = OCRDMA_Q_PAGE_BASE_SIZE << (OCRDMA_MAX_Q_PAGE_SIZE_CNT - 1);
-	/* hw can queue one less then the configured size,
-	 * so publish less by one to stack.
-	 */
 	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
-		dev->attr.max_wqe = max_q_mem / dev->attr.wqe_size;
 		attr->ird = 1;
 		attr->ird_page_size = OCRDMA_MIN_Q_PAGE_SIZE;
 		attr->num_ird_pages = MAX_OCRDMA_IRD_PAGES;
-	} else
-		dev->attr.max_wqe = (max_q_mem / dev->attr.wqe_size) - 1;
-	dev->attr.max_rqe = (max_q_mem / dev->attr.rqe_size) - 1;
+	}
+	dev->attr.max_wqe = rsp->max_wqes_rqes_per_q >>
+		 OCRDMA_MBX_QUERY_CFG_MAX_WQES_PER_WQ_OFFSET;
+	dev->attr.max_rqe = rsp->max_wqes_rqes_per_q &
+		OCRDMA_MBX_QUERY_CFG_MAX_RQES_PER_RQ_MASK;
 }
 
 static int ocrdma_check_fw_config(struct ocrdma_dev *dev,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 7fd80cc..8411441 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -458,7 +458,7 @@ enum {
 				OCRDMA_MBX_QUERY_CFG_MAX_WQES_PER_WQ_OFFSET,
 	OCRDMA_MBX_QUERY_CFG_MAX_RQES_PER_RQ_OFFSET	= 0,
 	OCRDMA_MBX_QUERY_CFG_MAX_RQES_PER_RQ_MASK	= 0xFFFF <<
-				OCRDMA_MBX_QUERY_CFG_MAX_WQES_PER_WQ_OFFSET,
+				OCRDMA_MBX_QUERY_CFG_MAX_RQES_PER_RQ_OFFSET,
 
 	OCRDMA_MBX_QUERY_CFG_MAX_CQ_OFFSET		= 16,
 	OCRDMA_MBX_QUERY_CFG_MAX_CQ_MASK		= 0xFFFF <<
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
