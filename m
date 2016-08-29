From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 5/6] nvme-rdma: use IB_PD_UNSAFE_GLOBAL_RKEY
Date: Mon, 29 Aug 2016 12:02:22 +0200
Message-ID: <1472464943-29450-6-git-send-email-hch@lst.de>
References: <1472464943-29450-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472464943-29450-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index a4961ed..1a18547 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -58,7 +58,6 @@
 struct nvme_rdma_device {
 	struct ib_device       *dev;
 	struct ib_pd	       *pd;
-	struct ib_mr	       *mr;
 	struct kref		ref;
 	struct list_head	entry;
 };
@@ -410,10 +409,7 @@ static void nvme_rdma_free_dev(struct kref *ref)
 	list_del(&ndev->entry);
 	mutex_unlock(&device_list_mutex);
 
-	if (!register_always)
-		ib_dereg_mr(ndev->mr);
 	ib_dealloc_pd(ndev->pd);
-
 	kfree(ndev);
 }
 
@@ -446,24 +442,16 @@ nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
 	ndev->dev = cm_id->device;
 	kref_init(&ndev->ref);
 
-	ndev->pd = ib_alloc_pd(ndev->dev, 0);
+	ndev->pd = ib_alloc_pd(ndev->dev,
+		register_always ? 0 : IB_PD_UNSAFE_GLOBAL_RKEY);
 	if (IS_ERR(ndev->pd))
 		goto out_free_dev;
 
-	if (!register_always) {
-		ndev->mr = ib_get_dma_mr(ndev->pd,
-					    IB_ACCESS_LOCAL_WRITE |
-					    IB_ACCESS_REMOTE_READ |
-					    IB_ACCESS_REMOTE_WRITE);
-		if (IS_ERR(ndev->mr))
-			goto out_free_pd;
-	}
-
 	if (!(ndev->dev->attrs.device_cap_flags &
 	      IB_DEVICE_MEM_MGT_EXTENSIONS)) {
 		dev_err(&ndev->dev->dev,
 			"Memory registrations not supported.\n");
-		goto out_free_mr;
+		goto out_free_pd;
 	}
 
 	list_add(&ndev->entry, &device_list);
@@ -471,9 +459,6 @@ out_unlock:
 	mutex_unlock(&device_list_mutex);
 	return ndev;
 
-out_free_mr:
-	if (!register_always)
-		ib_dereg_mr(ndev->mr);
 out_free_pd:
 	ib_dealloc_pd(ndev->pd);
 out_free_dev:
@@ -903,7 +888,7 @@ static int nvme_rdma_map_sg_single(struct nvme_rdma_queue *queue,
 
 	sg->addr = cpu_to_le64(sg_dma_address(req->sg_table.sgl));
 	put_unaligned_le24(sg_dma_len(req->sg_table.sgl), sg->length);
-	put_unaligned_le32(queue->device->mr->rkey, sg->key);
+	put_unaligned_le32(queue->device->pd->unsafe_global_rkey, sg->key);
 	sg->type = NVME_KEY_SGL_FMT_DATA_DESC << 4;
 	return 0;
 }
@@ -988,7 +973,7 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 		    nvme_rdma_queue_idx(queue))
 			return nvme_rdma_map_sg_inline(queue, req, c);
 
-		if (!register_always)
+		if (dev->pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)
 			return nvme_rdma_map_sg_single(queue, req, c);
 	}
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
