From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH v4 01/12] IB/core: Guarantee that a local_dma_lkey is
 available
Date: Wed, 5 Aug 2015 14:14:45 -0600
Message-ID: <20150805201445.GA30271@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: Haggai Eran <haggaie@mellanox.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

Every single ULP requires a local_dma_lkey to do anything with
a QP, so let us ensure one exists for every PD created.

If the driver can supply a global local_dma_lkey then use that, otherwise
ask the driver to create a local use all physical memory MR associated
with the new PD.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
Acked-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/infiniband/core/uverbs_cmd.c |  1 +
 drivers/infiniband/core/verbs.c      | 47 ++++++++++++++++++++++++++++++++----
 include/rdma/ib_verbs.h              |  9 ++-----
 3 files changed, 45 insertions(+), 12 deletions(-)

v4 change
 - The order of the atomic_read and mr destruction is swapped.
   The old order was intended to not destroy anything if we still
   have users, but the mr consitutes a user, so that just doesn't
   work. Since nothing should touch the mr pointer we can safely
   destory it.

   This bug means mr using drivers (ie mthca) would silently never
   tear down a pd because we don't check for errors..
   
Tested again by faking no-local_dma_lkey support and using my new
error clean up patch.

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index bbb02ffe87df..258485ee46b2 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -562,6 +562,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 
 	pd->device  = file->device->ib_dev;
 	pd->uobject = uobj;
+	pd->local_mr = NULL;
 	atomic_set(&pd->usecnt, 0);
 
 	uobj->object = pd;
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
