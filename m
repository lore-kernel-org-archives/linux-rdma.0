From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch] iser: free ib connection resources in the proper place
Date: Sat, 25 Feb 2012 14:36:26 -0500
Message-ID: <35056e0cff3c2ea514095edf5445b9c7fd2fd631.1330198520.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We allocate the login dma buffers in iser_verbs.c as part of
alloc_ib_conn_resources(), however we are freeing them in
iser_initiator.c as part of iser_free_rx_descriptors().  This is
needlessly confusing.  We have an alloc_rx_descriptors() and it doesn't
alloc something that the free_rx_descriptors() frees, and we have an
alloc_ib_conn_resources() that allocs something not freed by
free_ib_conn_resources().  Clean that up.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |   12 ------------
 drivers/infiniband/ulp/iser/iser_verbs.c     |   12 ++++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index a607542..622e985 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -220,18 +220,6 @@ void iser_free_rx_descriptors(struct iser_conn *ib_conn)
 	struct iser_rx_desc *rx_desc;
 	struct iser_device *device = ib_conn->device;
 
-	if (ib_conn->login_buf) {
-		if (ib_conn->login_req_dma)
-			ib_dma_unmap_single(device->ib_device,
-				ib_conn->login_req_dma,
-				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
-		if (ib_conn->login_resp_dma)
-			ib_dma_unmap_single(device->ib_device,
-				ib_conn->login_resp_dma,
-				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
-		kfree(ib_conn->login_buf);
-	}
-
 	if (!ib_conn->rx_descs)
 		return;
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index e28877c..46ba982 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -274,6 +274,18 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn, int can_destroy_id)
 	ib_conn->cma_id   = NULL;
 	kfree(ib_conn->page_vec);
 
+	if (ib_conn->login_buf) {
+		if (ib_conn->login_req_dma)
+			ib_dma_unmap_single(device->ib_device,
+				ib_conn->login_req_dma,
+				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
+		if (ib_conn->login_resp_dma)
+			ib_dma_unmap_single(device->ib_device,
+				ib_conn->login_resp_dma,
+				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+		kfree(ib_conn->login_buf);
+	}
+
 	return 0;
 }
 
-- 
1.7.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
