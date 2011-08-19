From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/20 v2] rdma/core: Add XRC domain
Date: Fri, 19 Aug 2011 02:13:59 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E419D6@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To support XRC, we add a new protection object, an XRC domain.
XRC domains are used to associate XRC target QPs and SRQs.  A
device indicates that they support XRC through a capability bit.

This patch is derived from work by
Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   26 ++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |   22 ++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index af7a8b0..5e03ab7 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -920,3 +920,29 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 	return qp->device->detach_mcast(qp, gid, lid);
 }
 EXPORT_SYMBOL(ib_detach_mcast);
+
+struct ib_xrcd *ib_alloc_xrcd(struct ib_device *device)
+{
+	struct ib_xrcd *xrcd;
+
+	if (!device->alloc_xrcd)
+		return ERR_PTR(-ENOSYS);
+
+	xrcd = device->alloc_xrcd(device, NULL, NULL);
+	if (!IS_ERR(xrcd)) {
+		xrcd->device = device;
+		atomic_set(&xrcd->usecnt, 0);
+	}
+
+	return xrcd;
+}
+EXPORT_SYMBOL(ib_alloc_xrcd);
+
+int ib_dealloc_xrcd(struct ib_xrcd *xrcd)
+{
+	if (atomic_read(&xrcd->usecnt))
+		return -EBUSY;
+
+	return xrcd->device->dealloc_xrcd(xrcd);
+}
+EXPORT_SYMBOL(ib_dealloc_xrcd);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 55cd0a0..760662f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -112,6 +112,7 @@ enum ib_device_cap_flags {
 	 */
 	IB_DEVICE_UD_IP_CSUM		= (1<<18),
 	IB_DEVICE_UD_TSO		= (1<<19),
+	IB_DEVICE_XRC			= (1<<20),
 	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1<<21),
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
 };
@@ -857,6 +858,11 @@ struct ib_pd {
 	atomic_t          	usecnt; /* count all resources */
 };
 
+struct ib_xrcd {
+	struct ib_device       *device;
+	atomic_t          	usecnt; /* count all resources */
+};
+
 struct ib_ah {
 	struct ib_device	*device;
 	struct ib_pd		*pd;
@@ -1148,6 +1154,10 @@ struct ib_device {
 						  struct ib_grh *in_grh,
 						  struct ib_mad *in_mad,
 						  struct ib_mad *out_mad);
+	struct ib_xrcd *	   (*alloc_xrcd)(struct ib_device *device,
+						 struct ib_ucontext *ucontext,
+						 struct ib_udata *udata);
+	int			   (*dealloc_xrcd)(struct ib_xrcd *xrcd);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -2059,4 +2069,16 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid);
  */
 int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid);
 
+/**
+ * ib_alloc_xrcd - Allocates an XRC domain.
+ * @device: The device on which to allocate the XRC domain.
+ */
+struct ib_xrcd *ib_alloc_xrcd(struct ib_device *device);
+
+/**
+ * ib_dealloc_xrcd - Deallocates an XRC domain.
+ * @xrcd: The XRC domain to deallocate.
+ */
+int ib_dealloc_xrcd(struct ib_xrcd *xrcd);
+
 #endif /* IB_VERBS_H */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
