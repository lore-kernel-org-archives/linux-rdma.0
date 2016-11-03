From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 12/17] IB/mthca: Remove debug prints after allocation failure
Date: Thu,  3 Nov 2016 16:44:20 +0200
Message-ID: <1478184265-9620-13-git-send-email-leon@kernel.org>
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
 drivers/infiniband/hw/mthca/mthca_reset.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_reset.c b/drivers/infiniband/hw/mthca/mthca_reset.c
index 6727af2..2a6979e 100644
--- a/drivers/infiniband/hw/mthca/mthca_reset.c
+++ b/drivers/infiniband/hw/mthca/mthca_reset.c
@@ -96,8 +96,6 @@ int mthca_reset(struct mthca_dev *mdev)
 	hca_header = kmalloc(256, GFP_KERNEL);
 	if (!hca_header) {
 		err = -ENOMEM;
-		mthca_err(mdev, "Couldn't allocate memory to save HCA "
-			  "PCI header, aborting.\n");
 		goto put_dev;
 	}
 
@@ -119,8 +117,6 @@ int mthca_reset(struct mthca_dev *mdev)
 		bridge_header = kmalloc(256, GFP_KERNEL);
 		if (!bridge_header) {
 			err = -ENOMEM;
-			mthca_err(mdev, "Couldn't allocate memory to save HCA "
-				  "bridge PCI header, aborting.\n");
 			goto free_hca;
 		}
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
