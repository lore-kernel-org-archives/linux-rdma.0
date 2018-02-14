From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 02/14] RDMA/uverbs: Update sizeof users
Date: Wed, 14 Feb 2018 14:38:32 +0200
Message-ID: <20180214123844.30321-3-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Update sizeof() users to be consistent with coding style.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 1be9a93f628c..06ddb93f9c75 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -468,7 +468,7 @@ void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context)
 		return;
 	}
 
-	entry = kmalloc(sizeof *entry, GFP_ATOMIC);
+	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
 	if (!entry) {
 		spin_unlock_irqrestore(&ev_queue->lock, flags);
 		return;
@@ -501,7 +501,7 @@ static void ib_uverbs_async_handler(struct ib_uverbs_file *file,
 		return;
 	}
 
-	entry = kmalloc(sizeof *entry, GFP_ATOMIC);
+	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
 	if (!entry) {
 		spin_unlock_irqrestore(&file->async_file->ev_queue.lock, flags);
 		return;
@@ -676,10 +676,10 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		return -EACCES;
 	}
 
-	if (count < sizeof hdr)
+	if (count < sizeof(hdr))
 		return -EINVAL;
 
-	if (copy_from_user(&hdr, buf, sizeof hdr))
+	if (copy_from_user(&hdr, buf, sizeof(hdr)))
 		return -EFAULT;
 
 	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
@@ -1032,7 +1032,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	if (!device->alloc_ucontext)
 		return;
 
-	uverbs_dev = kzalloc(sizeof *uverbs_dev, GFP_KERNEL);
+	uverbs_dev = kzalloc(sizeof(*uverbs_dev), GFP_KERNEL);
 	if (!uverbs_dev)
 		return;
 
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
