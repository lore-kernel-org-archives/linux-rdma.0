From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/6] IB/iser: use IB_PD_UNSAFE_GLOBAL_RKEY
Date: Mon, 29 Aug 2016 12:02:20 +0200
Message-ID: <1472464943-29450-4-git-send-email-hch@lst.de>
References: <1472464943-29450-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472464943-29450-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |  1 -
 drivers/infiniband/ulp/iser/iser_memory.c |  6 +++++-
 drivers/infiniband/ulp/iser/iser_verbs.c  | 22 +++-------------------
 3 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 0351059..0be6a7c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -374,7 +374,6 @@ struct iser_reg_ops {
 struct iser_device {
 	struct ib_device             *ib_device;
 	struct ib_pd	             *pd;
-	struct ib_mr	             *mr;
 	struct ib_event_handler      event_handler;
 	struct list_head             ig_list;
 	int                          refcount;
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 90be568..9c3e9ab 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -199,7 +199,11 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
 	 * FIXME: rework the registration code path to differentiate
 	 * rkey/lkey use cases
 	 */
-	reg->rkey = device->mr ? device->mr->rkey : 0;
+
+	if (device->pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)
+		reg->rkey = device->pd->unsafe_global_rkey;
+	else
+		reg->rkey = 0;
 	reg->sge.addr = ib_sg_dma_address(device->ib_device, &sg[0]);
 	reg->sge.length = ib_sg_dma_len(device->ib_device, &sg[0]);
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index e9de992..a4b791d 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -88,7 +88,8 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		  device->comps_used, ib_dev->name,
 		  ib_dev->num_comp_vectors, max_cqe);
 
-	device->pd = ib_alloc_pd(ib_dev, 0);
+	device->pd = ib_alloc_pd(ib_dev,
+		iser_always_reg ? 0 : IB_PD_UNSAFE_GLOBAL_RKEY);
 	if (IS_ERR(device->pd))
 		goto pd_err;
 
@@ -103,26 +104,13 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		}
 	}
 
-	if (!iser_always_reg) {
-		int access = IB_ACCESS_LOCAL_WRITE |
-			     IB_ACCESS_REMOTE_WRITE |
-			     IB_ACCESS_REMOTE_READ;
-
-		device->mr = ib_get_dma_mr(device->pd, access);
-		if (IS_ERR(device->mr))
-			goto cq_err;
-	}
-
 	INIT_IB_EVENT_HANDLER(&device->event_handler, ib_dev,
 			      iser_event_handler);
 	if (ib_register_event_handler(&device->event_handler))
-		goto handler_err;
+		goto cq_err;
 
 	return 0;
 
-handler_err:
-	if (device->mr)
-		ib_dereg_mr(device->mr);
 cq_err:
 	for (i = 0; i < device->comps_used; i++) {
 		struct iser_comp *comp = &device->comps[i];
@@ -154,14 +142,10 @@ static void iser_free_device_ib_res(struct iser_device *device)
 	}
 
 	(void)ib_unregister_event_handler(&device->event_handler);
-	if (device->mr)
-		(void)ib_dereg_mr(device->mr);
 	ib_dealloc_pd(device->pd);
 
 	kfree(device->comps);
 	device->comps = NULL;
-
-	device->mr = NULL;
 	device->pd = NULL;
 }
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
