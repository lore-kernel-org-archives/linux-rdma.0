From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH V2 4/5] RDMA/iser: support iWARP devices
Date: Mon, 29 Jun 2015 16:36:24 -0500
Message-ID: <20150629213624.4188.94135.stgit@build.ogc.int>
References: <20150629213332.4188.87551.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150629213332.4188.87551.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Limit the sg tablesize based on the device fast reg depth.

Use rdma_get_dma_mr() to allocate the DMA MR.

Use rdma_fast_reg_access_flags() to set the access_flags for fast
register work requests.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c  |    7 +++++++
 drivers/infiniband/ulp/iser/iser_memory.c |    7 +++----
 drivers/infiniband/ulp/iser/iser_verbs.c  |    7 ++++---
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6a594aa..ec692f7 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -640,6 +640,13 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 						   SHOST_DIX_GUARD_CRC);
 		}
 
+		/*
+		 * Limit the sg_tablesize based on the device max fastreg page
+		 * list length.
+		 */
+		shost->sg_tablesize = min_t(u32, shost->sg_tablesize,
+			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
+
 		if (iscsi_host_add(shost,
 				   ib_conn->device->ib_device->dma_device)) {
 			mutex_unlock(&iser_conn->state_mutex);
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index f0cdc96..3a19483 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -757,10 +757,9 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	fastreg_wr.wr.fast_reg.page_shift = SHIFT_4K;
 	fastreg_wr.wr.fast_reg.length = size;
 	fastreg_wr.wr.fast_reg.rkey = mr->rkey;
-	fastreg_wr.wr.fast_reg.access_flags = (IB_ACCESS_LOCAL_WRITE  |
-					       IB_ACCESS_REMOTE_WRITE |
-					       IB_ACCESS_REMOTE_READ);
-
+	fastreg_wr.wr.fast_reg.access_flags =
+		rdma_fast_reg_access_flags(device->pd, RDMA_MRR_WRITE_DEST |
+					   RDMA_MRR_READ_SOURCE, 0);
 	if (!wr)
 		wr = &fastreg_wr;
 	else
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 5c9f565..4da368c 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -80,6 +80,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
 {
 	struct ib_device_attr *dev_attr = &device->dev_attr;
 	int ret, i, max_cqe;
+	int mr_roles;
 
 	ret = ib_query_device(device->ib_device, dev_attr);
 	if (ret) {
@@ -149,9 +150,9 @@ static int iser_create_device_ib_res(struct iser_device *device)
 			     (unsigned long)comp);
 	}
 
-	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE |
-				   IB_ACCESS_REMOTE_WRITE |
-				   IB_ACCESS_REMOTE_READ);
+	mr_roles = RDMA_MRR_SEND | RDMA_MRR_RECV | RDMA_MRR_WRITE_DEST |
+		   RDMA_MRR_READ_SOURCE;
+	device->mr = rdma_get_dma_mr(device->pd, mr_roles, 0);
 	if (IS_ERR(device->mr))
 		goto dma_mr_err;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
