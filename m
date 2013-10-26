From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 09/10] IB/srp: Introduce srp_alloc_req_data()
Date: Sat, 26 Oct 2013 14:38:47 +0200
Message-ID: <526BB7D7.7070908@acm.org>
References: <526BB5AC.7010601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526BB5AC.7010601-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 64 +++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index da60d11..fdc0bc1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -576,6 +576,42 @@ static void srp_free_req_data(struct srp_target_port *target)
 	}
 }
 
+static int srp_alloc_req_data(struct srp_target_port *target)
+{
+	struct srp_device *srp_dev = target->srp_host->srp_dev;
+	struct ib_device *ibdev = srp_dev->dev;
+	struct srp_request *req;
+	dma_addr_t dma_addr;
+	int i, ret = -ENOMEM;
+
+	INIT_LIST_HEAD(&target->free_reqs);
+
+	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+		req = &target->req_ring[i];
+		req->fmr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
+					GFP_KERNEL);
+		req->map_page = kmalloc(SRP_FMR_SIZE * sizeof(void *),
+					GFP_KERNEL);
+		req->indirect_desc = kmalloc(target->indirect_size, GFP_KERNEL);
+		if (!req->fmr_list || !req->map_page || !req->indirect_desc)
+			goto out;
+
+		dma_addr = ib_dma_map_single(ibdev, req->indirect_desc,
+					     target->indirect_size,
+					     DMA_TO_DEVICE);
+		if (ib_dma_mapping_error(ibdev, dma_addr))
+			goto out;
+
+		req->indirect_dma_addr = dma_addr;
+		req->index = i;
+		list_add_tail(&req->list, &target->free_reqs);
+	}
+	ret = 0;
+
+out:
+	return ret;
+}
+
 /**
  * srp_del_scsi_host_attr() - Remove attributes defined in the host template.
  * @shost: SCSI host whose attributes to remove from sysfs.
@@ -2433,8 +2469,7 @@ static ssize_t srp_create_target(struct device *dev,
 	struct Scsi_Host *target_host;
 	struct srp_target_port *target;
 	struct ib_device *ibdev = host->srp_dev->dev;
-	dma_addr_t dma_addr;
-	int i, ret;
+	int ret;
 
 	target_host = scsi_host_alloc(&srp_template,
 				      sizeof (struct srp_target_port));
@@ -2490,28 +2525,9 @@ static ssize_t srp_create_target(struct device *dev,
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
-	INIT_LIST_HEAD(&target->free_reqs);
-	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
-		struct srp_request *req = &target->req_ring[i];
-
-		req->fmr_list = kmalloc(target->cmd_sg_cnt * sizeof (void *),
-					GFP_KERNEL);
-		req->map_page = kmalloc(SRP_FMR_SIZE * sizeof (void *),
-					GFP_KERNEL);
-		req->indirect_desc = kmalloc(target->indirect_size, GFP_KERNEL);
-		if (!req->fmr_list || !req->map_page || !req->indirect_desc)
-			goto err_free_mem;
-
-		dma_addr = ib_dma_map_single(ibdev, req->indirect_desc,
-					     target->indirect_size,
-					     DMA_TO_DEVICE);
-		if (ib_dma_mapping_error(ibdev, dma_addr))
-			goto err_free_mem;
-
-		req->indirect_dma_addr = dma_addr;
-		req->index = i;
-		list_add_tail(&req->list, &target->free_reqs);
-	}
+	ret = srp_alloc_req_data(target);
+	if (ret)
+		goto err_free_mem;
 
 	ib_query_gid(ibdev, host->port, 0, &target->path.sgid);
 
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
