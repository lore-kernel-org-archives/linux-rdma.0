From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 11/17] RDMA/ocrdma: Display proper value for max_mw
Date: Tue, 4 Feb 2014 11:57:04 +0530
Message-ID: <bdba0093-b754-4f29-a03f-f4f50d1789eb@CMEXHTCAS2.ad.emulex.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391495230-28021-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, selvin.xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Fixing the max_mw value

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 00b3a29..4ea8496 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -67,6 +67,7 @@ struct ocrdma_dev_attr {
 	int max_mr;
 	u64 max_mr_size;
 	u32 max_num_mr_pbl;
+	int max_mw;
 	int max_fmr;
 	int max_map_per_fmr;
 	int max_pages_per_frmr;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index c25445d..2ed6aa1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1016,6 +1016,7 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->local_ca_ack_delay = (rsp->max_pd_ca_ack_delay &
 				    OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT;
+	attr->max_mw = rsp->max_mw;
 	attr->max_mr = rsp->max_mr;
 	attr->max_mr_size = ~0ull;
 	attr->max_fmr = 0;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 811f660..1582ecb 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -89,7 +89,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	attr->max_cq = dev->attr.max_cq;
 	attr->max_cqe = dev->attr.max_cqe;
 	attr->max_mr = dev->attr.max_mr;
-	attr->max_mw = 0;
+	attr->max_mw = dev->attr.max_mw;
 	attr->max_pd = dev->attr.max_pd;
 	attr->atomic_cap = 0;
 	attr->max_fmr = 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
