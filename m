From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 7/8] IB/srp: Introduce srp_alloc_req_data()
Date: Tue, 20 Aug 2013 14:48:19 +0200
Message-ID: <52136593.1010603@acm.org>
References: <521363EA.8080906@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521363EA.8080906-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   64 ++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index de4c3b7..ece1f2d 100644
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
@@ -2393,8 +2429,7 @@ static ssize_t srp_create_target(struct device *dev,
 	struct Scsi_Host *target_host;
 	struct srp_target_port *target;
 	struct ib_device *ibdev = host->srp_dev->dev;
-	dma_addr_t dma_addr;
-	int i, ret;
+	int ret;
 
 	target_host = scsi_host_alloc(&srp_template,
 				      sizeof (struct srp_target_port));
@@ -2450,28 +2485,9 @@ static ssize_t srp_create_target(struct device *dev,
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
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
