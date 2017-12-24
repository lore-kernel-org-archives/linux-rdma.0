From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 5/7] RDMA/core: Add resource tracking for create and destroy PDs
Date: Sun, 24 Dec 2017 16:17:59 +0200
Message-ID: <20171224141801.26443-6-leon@kernel.org>
References: <20171224141801.26443-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224141801.26443-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Track all creation and destroy of PD objects.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 1 +
 drivers/infiniband/core/verbs.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index aeaa46041fc5..cf5c0fad7dc3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -340,6 +340,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	uobj->object = pd;
 	memset(&resp, 0, sizeof resp);
 	resp.pd_handle = uobj->id;
+	rdma_restrack_add(&pd->res, RDMA_RESTRACK_PD, NULL);
 
 	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp)) {
 		ret = -EFAULT;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 9c033b0c788b..c9528a3d2439 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -246,6 +246,7 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
 		pr_warn("%s: enabling unsafe global rkey\n", caller);
 		mr_access_flags |= IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
 	}
+	rdma_restrack_add(&pd->res, RDMA_RESTRACK_PD, NULL);
 
 	if (mr_access_flags) {
 		struct ib_mr *mr;
@@ -296,6 +297,7 @@ void ib_dealloc_pd(struct ib_pd *pd)
 	   requires the caller to guarantee we can't race here. */
 	WARN_ON(atomic_read(&pd->usecnt));
 
+	rdma_restrack_del(&pd->res, RDMA_RESTRACK_PD);
 	/* Making delalloc_pd a void return is a WIP, no driver should return
 	   an error here. */
 	ret = pd->device->dealloc_pd(pd);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
