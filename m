From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 09/17] IB/i40iw: Remove debug prints after allocation failure
Date: Thu,  3 Nov 2016 16:44:17 +0200
Message-ID: <1478184265-9620-10-git-send-email-leon@kernel.org>
References: <1478184265-9620-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478184265-9620-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c    | 2 --
 drivers/infiniband/hw/i40iw/i40iw_main.c  | 5 ++---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 8563769..47d1bbc 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1675,7 +1675,6 @@ static enum i40iw_status_code i40iw_add_mqh_6(struct i40iw_device *iwdev,
 					    "Allocating child listener %p\n",
 					    child_listen_node);
 				if (!child_listen_node) {
-					i40iw_pr_err("listener memory allocation\n");
 					ret = I40IW_ERR_NO_MEMORY;
 					goto exit;
 				}
@@ -1751,7 +1750,6 @@ static enum i40iw_status_code i40iw_add_mqh_4(
 					    "Allocating child listener %p\n",
 					    child_listen_node);
 				if (!child_listen_node) {
-					i40iw_pr_err("listener memory allocation\n");
 					in_dev_put(idev);
 					ret = I40IW_ERR_NO_MEMORY;
 					goto exit;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index ac2f3cd..a6ad913 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1301,10 +1301,9 @@ static enum i40iw_status_code i40iw_initialize_dev(struct i40iw_device *iwdev,
 	size = sizeof(struct i40iw_hmc_pble_rsrc) + sizeof(struct i40iw_hmc_info) +
 				(sizeof(struct i40iw_hmc_obj_info) * I40IW_HMC_IW_MAX);
 	iwdev->hmc_info_mem = kzalloc(size, GFP_KERNEL);
-	if (!iwdev->hmc_info_mem) {
-		i40iw_pr_err("memory alloc fail\n");
+	if (!iwdev->hmc_info_mem)
 		return I40IW_ERR_NO_MEMORY;
-	}
+
 	iwdev->pble_rsrc = (struct i40iw_hmc_pble_rsrc *)iwdev->hmc_info_mem;
 	dev->hmc_info = &iwdev->hw.hmc;
 	dev->hmc_info->hmc_obj = (struct i40iw_hmc_obj_info *)(iwdev->pble_rsrc + 1);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 6329c97..62e068b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2654,7 +2654,6 @@ static struct i40iw_ib_device *i40iw_init_rdma_device(struct i40iw_device *iwdev
 	iwibdev->ibdev.iwcm = kzalloc(sizeof(*iwibdev->ibdev.iwcm), GFP_KERNEL);
 	if (!iwibdev->ibdev.iwcm) {
 		ib_dealloc_device(&iwibdev->ibdev);
-		i40iw_pr_err("iwcm == NULL\n");
 		return NULL;
 	}
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
