From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH 01/10] IB/core: Guarantee that a local_dma_lkey is available
Date: Wed, 22 Jul 2015 17:34:34 -0600
Message-ID: <1437608083-22898-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Andy Grover <andy.grover@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, Zach Brown <zach.brown@oracle.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

Every single ULP requires a local_dma_lkey to do anything with
a QP, so let us ensure one exists for every PD created.

If the driver can supply a global local_dma_lkey then use that, otherwise
ask the driver to create a local use all physical memory MR associated
with the new PD.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
Acked-by: Christoph Hellwig <hch@infradead.org>
---
 drivers/infiniband/core/verbs.c | 40 +++++++++++++++++++++++++++++++++++-----
 include/rdma/ib_verbs.h         |  2 ++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index bac3fb406a74..1ddf06314f36 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -213,24 +213,54 @@ EXPORT_SYMBOL(rdma_port_get_link_layer);
 
 /* Protection domains */
 
+/* Return a pd for in-kernel use that has a local_dma_lkey which provides
+   local access to all physical memory. */
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
+
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
index 986fddb08579..cfda95d7b067 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1255,6 +1255,8 @@ struct ib_pd {
 	struct ib_device       *device;
 	struct ib_uobject      *uobject;
 	atomic_t          	usecnt; /* count all resources */
+	struct ib_mr	       *local_mr;
+	u32			local_dma_lkey;
 };
 
 struct ib_xrcd {
-- 
2.1.4
