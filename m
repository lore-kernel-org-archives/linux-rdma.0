From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v7 6/8] RDMA/core: Add resource tracking for create and destroy PDs
Date: Sun, 28 Jan 2018 11:17:23 +0200
Message-ID: <20180128091725.13103-7-leon@kernel.org>
References: <20180128091725.13103-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180128091725.13103-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Track create and destroy operations of PD objects.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 ++
 drivers/infiniband/core/verbs.c      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 3e95acd29de7..256934d1f64f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -340,6 +340,8 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	uobj->object = pd;
 	memset(&resp, 0, sizeof resp);
 	resp.pd_handle = uobj->id;
+	pd->res.type = RDMA_RESTRACK_PD;
+	rdma_restrack_add(&pd->res);
 
 	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp)) {
 		ret = -EFAULT;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 983b49ffb8d5..a98a3e8412f8 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -263,6 +263,10 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
 		mr_access_flags |= IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
 	}
 
+	pd->res.type = RDMA_RESTRACK_PD;
+	pd->res.kern_name = caller;
+	rdma_restrack_add(&pd->res);
+
 	if (mr_access_flags) {
 		struct ib_mr *mr;
 
@@ -312,6 +316,7 @@ void ib_dealloc_pd(struct ib_pd *pd)
 	   requires the caller to guarantee we can't race here. */
 	WARN_ON(atomic_read(&pd->usecnt));
 
+	rdma_restrack_del(&pd->res);
 	/* Making delalloc_pd a void return is a WIP, no driver should return
 	   an error here. */
 	ret = pd->device->dealloc_pd(pd);
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
