From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 4/4] nvme-rdma: add support for arbitrary sg lists mapping
Date: Thu, 13 Apr 2017 18:56:17 +0300
Message-ID: <1492098977-5231-5-git-send-email-maxg@mellanox.com>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492098977-5231-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the device support arbitrary sg list mapping (device
cap IB_DEVICE_SG_GAPS_REG set) we allocate the memory regions with
IB_MR_TYPE_SG_GAPS and allow the block layer to send us gappy bio
vectors. We use this functionality in iSER driver as well.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/nvme/host/rdma.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 47a479f..1c6f974 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -294,8 +294,8 @@ static int nvme_rdma_reinit_request(void *data, struct request *rq)
 
 	ib_dereg_mr(req->mr);
 
-	req->mr = ib_alloc_mr(dev->pd, IB_MR_TYPE_MEM_REG,
-			ctrl->max_fr_pages);
+	req->mr = ib_alloc_mr(dev->pd, ib_get_sg_mr_type(dev->dev),
+			      ctrl->max_fr_pages);
 	if (IS_ERR(req->mr)) {
 		ret = PTR_ERR(req->mr);
 		req->mr = NULL;
@@ -348,8 +348,8 @@ static int __nvme_rdma_init_request(struct nvme_rdma_ctrl *ctrl,
 	if (ret)
 		return ret;
 
-	req->mr = ib_alloc_mr(dev->pd, IB_MR_TYPE_MEM_REG,
-			ctrl->max_fr_pages);
+	req->mr = ib_alloc_mr(dev->pd, ib_get_sg_mr_type(ibdev),
+			      ctrl->max_fr_pages);
 	if (IS_ERR(req->mr)) {
 		ret = PTR_ERR(req->mr);
 		goto out_free_qe;
@@ -1608,6 +1608,9 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl)
 	ctrl->ctrl.sqsize =
 		min_t(int, NVME_CAP_MQES(ctrl->cap) + 1, ctrl->ctrl.sqsize);
 
+	if (ctrl->device->dev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
+		ctrl->ctrl.sg_gaps_support = true;
+
 	error = nvme_enable_ctrl(&ctrl->ctrl, ctrl->cap);
 	if (error)
 		goto out_cleanup_queue;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
