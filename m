From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 01/12] IB/core: Guarantee that a local_dma_lkey is available
Date: Thu, 30 Jul 2015 17:22:15 -0600
Message-ID: <1438298547-21404-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438298547-21404-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Every single ULP requires a local_dma_lkey to do anything with
a QP, so let us ensure one exists for every PD created.

If the driver can supply a global local_dma_lkey then use that, otherwise
ask the driver to create a local use all physical memory MR associated
with the new PD.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Acked-by: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 47 ++++++++++++++++++++++++++++++++++++-----
 include/rdma/ib_verbs.h         |  9 ++------
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index bac3fb406a74..bb561c8e51ad 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -213,24 +213,61 @@ EXPORT_SYMBOL(rdma_port_get_link_layer);
 
 /* Protection domains */
 
+/**
+ * ib_alloc_pd - Allocates an unused protection domain.
+ * @device: The device on which to allocate the protection domain.
+ *
+ * A protection domain object provides an association between QPs, shared
+ * receive queues, address handles, memory regions, and memory windows.
+ *
+ * Every PD has a local_dma_lkey which can be used as the lkey value for local
+ * memory operations.
+ */
 struct ib_pd *ib_alloc_pd(struct ib_device *device)
 {
 	struct ib_pd *pd;
+	struct ib_device_attr devattr;
+	int rc;
+
+	rc = ib_query_device(device, &devattr);
+	if (rc)
+		return ERR_PTR(rc);
 
 	pd = device->alloc_pd(device, NULL, NULL);
+	if (IS_ERR(pd))
+		return pd;
+
+	pd->device = device;
+	pd->uobject = NULL;
+	pd->local_mr = NULL;
+	atomic_set(&pd->usecnt, 0);
+
+	if (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
+		pd->local_dma_lkey = device->local_dma_lkey;
+	else {
+		struct ib_mr *mr;
+
+		mr = ib_get_dma_mr(pd, IB_ACCESS_LOCAL_WRITE);
+		if (IS_ERR(mr)) {
+			ib_dealloc_pd(pd);
+			return (struct ib_pd *)mr;
+		}
 
-	if (!IS_ERR(pd)) {
-		pd->device  = device;
-		pd->uobject = NULL;
-		atomic_set(&pd->usecnt, 0);
+		pd->local_mr = mr;
+		pd->local_dma_lkey = pd->local_mr->lkey;
 	}
-
 	return pd;
 }
 EXPORT_SYMBOL(ib_alloc_pd);
 
 int ib_dealloc_pd(struct ib_pd *pd)
 {
+	if (pd->local_mr) {
+		if (ib_dereg_mr(pd->local_mr))
+			return -EBUSY;
+		pd->local_mr = NULL;
+	}
+
 	if (atomic_read(&pd->usecnt))
 		return -EBUSY;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b0f898e3b2e7..eaec3081fb87 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1252,9 +1252,11 @@ struct ib_udata {
 };
 
 struct ib_pd {
+	u32			local_dma_lkey;
 	struct ib_device       *device;
 	struct ib_uobject      *uobject;
 	atomic_t          	usecnt; /* count all resources */
+	struct ib_mr	       *local_mr;
 };
 
 struct ib_xrcd {
@@ -2135,13 +2137,6 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 int ib_find_pkey(struct ib_device *device,
 		 u8 port_num, u16 pkey, u16 *index);
 
-/**
- * ib_alloc_pd - Allocates an unused protection domain.
- * @device: The device on which to allocate the protection domain.
- *
- * A protection domain object provides an association between QPs, shared
- * receive queues, address handles, memory regions, and memory windows.
- */
 struct ib_pd *ib_alloc_pd(struct ib_device *device);
 
 /**
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
