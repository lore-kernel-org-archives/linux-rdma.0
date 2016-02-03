From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/7] IB/rdmavt: Clean up distinction between port number and
 index
Date: Wed, 03 Feb 2016 14:15:02 -0800
Message-ID: <20160203221459.1765.71189.stgit@scvm10.sc.intel.com>
References: <20160203221136.1765.8947.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203221136.1765.8947.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IB core uses 1 relative indexing for ports. All of our data structures
use 0 based indexing. Add an inline function that we can use whenever we
need to validate a legal value and try to convert a port number to a
port index at the entrance into rdmavt.

Try to follow the policy that when we are talking about a port from IB
core point of view we refer to it as a port number. When port is an
index into our arrays refer to it as a port index.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mad.c |    8 ++++++--
 drivers/infiniband/sw/rdmavt/mad.h |    2 +-
 drivers/infiniband/sw/rdmavt/qp.c  |   17 +++++++++++------
 drivers/infiniband/sw/rdmavt/vt.c  |   36 ++++++++++++++++++++++--------------
 drivers/infiniband/sw/rdmavt/vt.h  |   12 ++++++++++++
 include/rdma/rdma_vt.h             |    4 ++--
 6 files changed, 54 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mad.c b/drivers/infiniband/sw/rdmavt/mad.c
index 5c720d3..2feae47 100644
--- a/drivers/infiniband/sw/rdmavt/mad.c
+++ b/drivers/infiniband/sw/rdmavt/mad.c
@@ -47,12 +47,13 @@
 
 #include <rdma/ib_mad.h>
 #include "mad.h"
+#include "vt.h"
 
 /**
  * rvt_process_mad - process an incoming MAD packet
  * @ibdev: the infiniband device this packet came in on
  * @mad_flags: MAD flags
- * @port: the port number this packet came in on
+ * @port_num: the port number this packet came in on, 1 based from ib core
  * @in_wc: the work completion entry for this packet
  * @in_grh: the global route header for this packet
  * @in_mad: the incoming MAD
@@ -67,7 +68,7 @@
  *
  * This is called by the ib_mad module.
  */
-int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
+int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		    const struct ib_mad_hdr *in, size_t in_mad_size,
 		    struct ib_mad_hdr *out, size_t *out_mad_size,
@@ -82,6 +83,9 @@ int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 	 *VT-DRIVER-API: ????
 	 *
 	 */
+	if (ibport_num_to_idx(ibdev, port_num) < 0)
+		return -EINVAL;
+
 	return IB_MAD_RESULT_FAILURE;
 }
 
diff --git a/drivers/infiniband/sw/rdmavt/mad.h b/drivers/infiniband/sw/rdmavt/mad.h
index c89faf4..a9d6eec 100644
--- a/drivers/infiniband/sw/rdmavt/mad.h
+++ b/drivers/infiniband/sw/rdmavt/mad.h
@@ -50,7 +50,7 @@
 
 #include <rdma/rdma_vt.h>
 
-int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
+int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		    const struct ib_mad_hdr *in, size_t in_mad_size,
 		    struct ib_mad_hdr *out, size_t *out_mad_size,
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index a2fed05..4eab466 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -286,26 +286,31 @@ static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
 	return (map - qpt->map) * RVT_BITS_PER_PAGE + off;
 }
 
-/*
- * Allocate the next available QPN or
- * zero/one for QP type IB_QPT_SMI/IB_QPT_GSI.
+/**
+ * alloc_qpn - Allocate the next available qpn or zero/one for QP type
+ *	       IB_QPT_SMI/IB_QPT_GSI
+ *@rdi:	rvt device info structure
+ *@qpt: queue pair number table pointer
+ *@port_num: IB port number, 1 based, comes from core
+ *
+ * Return: The queue pair number
  */
 static int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-		     enum ib_qp_type type, u8 port, gfp_t gfp)
+		     enum ib_qp_type type, u8 port_num, gfp_t gfp)
 {
 	u32 i, offset, max_scan, qpn;
 	struct rvt_qpn_map *map;
 	u32 ret;
 
 	if (rdi->driver_f.alloc_qpn)
-		return rdi->driver_f.alloc_qpn(rdi, qpt, type, port,
+		return rdi->driver_f.alloc_qpn(rdi, qpt, type, port_num,
 					       GFP_KERNEL);
 
 	if (type == IB_QPT_SMI || type == IB_QPT_GSI) {
 		unsigned n;
 
 		ret = type == IB_QPT_GSI;
-		n = 1 << (ret + 2 * (port - 1));
+		n = 1 << (ret + 2 * (port_num - 1));
 		spin_lock(&qpt->lock);
 		if (qpt->flags & n)
 			ret = -EINVAL;
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index d45206c..9f9cb9a 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -120,14 +120,17 @@ static int rvt_modify_device(struct ib_device *device,
 /**
  * rvt_query_port: Passes the query port call to the driver
  * @ibdev: Verbs IB dev
- * @port: port number
+ * @port_num: port number, 1 based from ib core
  * @props: structure to hold returned properties
  *
  * Returns 0 on success
  */
-static int rvt_query_port(struct ib_device *ibdev, u8 port,
+static int rvt_query_port(struct ib_device *ibdev, u8 port_num,
 			  struct ib_port_attr *props)
 {
+	if (ibport_num_to_idx(ibdev, port_num) < 0)
+		return -EINVAL;
+
 	/*
 	 * VT-DRIVER-API: query_port_state()
 	 * driver returns pretty much everything in ib_port_attr
@@ -138,13 +141,13 @@ static int rvt_query_port(struct ib_device *ibdev, u8 port,
 /**
  * rvt_modify_port
  * @ibdev: Verbs IB dev
- * @port: Port number
+ * @port_num: Port number, 1 based from ib core
  * @port_modify_mask: How to change the port
  * @props: Structure to fill in
  *
  * Returns 0 on success
  */
-static int rvt_modify_port(struct ib_device *ibdev, u8 port,
+static int rvt_modify_port(struct ib_device *ibdev, u8 port_num,
 			   int port_modify_mask, struct ib_port_modify *props)
 {
 	/*
@@ -160,18 +163,21 @@ static int rvt_modify_port(struct ib_device *ibdev, u8 port,
 	 * TBD: send_trap() and post_mad_send() need examined to see where they
 	 * fit in.
 	 */
+	if (ibport_num_to_idx(ibdev, port_num) < 0)
+		return -EINVAL;
+
 	return -EOPNOTSUPP;
 }
 
 /**
  * rvt_query_pkey - Return a pkey from the table at a given index
  * @ibdev: Verbs IB dev
- * @port: Port number
+ * @port_num: Port number, 1 based from ib core
  * @intex: Index into pkey table
  *
  * Returns 0 on failure pkey otherwise
  */
-static int rvt_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+static int rvt_query_pkey(struct ib_device *ibdev, u8 port_num, u16 index,
 			  u16 *pkey)
 {
 	/*
@@ -183,11 +189,11 @@ static int rvt_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
 	int port_index;
 
-	if (index >= rvt_get_npkeys(rdi))
+	port_index = ibport_num_to_idx(ibdev, port_num);
+	if (port_index < 0)
 		return -EINVAL;
 
-	port_index = port - 1; /* IB ports start at 1 our array at 0 */
-	if ((port_index < 0) || (port_index >= rdi->dparms.nports))
+	if (index >= rvt_get_npkeys(rdi))
 		return -EINVAL;
 
 	*pkey = rvt_get_pkey(rdi, port_index, index);
@@ -197,13 +203,13 @@ static int rvt_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 /**
  * rvt_query_gid - Return a gid from the table
  * @ibdev: Verbs IB dev
- * @port: Port number
+ * @port_num: Port number, 1 based from ib core
  * @index: = Index in table
  * @gid: Gid to return
  *
  * Returns 0 on success
  */
-static int rvt_query_gid(struct ib_device *ibdev, u8 port,
+static int rvt_query_gid(struct ib_device *ibdev, u8 port_num,
 			 int index, union ib_gid *gid)
 {
 	/*
@@ -211,6 +217,8 @@ static int rvt_query_gid(struct ib_device *ibdev, u8 port,
 	 * to craft the return value. This will work similar to how query_pkey()
 	 * is being done.
 	 */
+	if (ibport_num_to_idx(ibdev, port_num) < 0)
+		return -EINVAL;
 
 	return -EOPNOTSUPP;
 }
@@ -455,11 +463,11 @@ EXPORT_SYMBOL(rvt_unregister_device);
  * They persist until the driver goes away.
  */
 int rvt_init_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
-		  int portnum, u16 *pkey_table)
+		  int port_index, u16 *pkey_table)
 {
 
-	rdi->ports[portnum] = port;
-	rdi->ports[portnum]->pkey_table = pkey_table;
+	rdi->ports[port_index] = port;
+	rdi->ports[port_index]->pkey_table = pkey_table;
 
 	return 0;
 }
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index a5c36d3..e26f9e9 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -88,4 +88,16 @@
 #define __rvt_pr_err(pdev, name, fmt, ...) \
 	dev_err(&pdev->dev, "%s: " fmt, name, ##__VA_ARGS__)
 
+static inline int ibport_num_to_idx(struct ib_device *ibdev, u8 port_num)
+{
+	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
+	int port_index;
+
+	port_index = port_num - 1; /* IB ports start at 1 our arrays at 0 */
+	if ((port_index < 0) || (port_index >= rdi->dparms.nports))
+		return -EINVAL;
+
+	return port_index;
+}
+
 #endif          /* DEF_RDMAVT_H */
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 52dfa9c..5d1c694 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -256,7 +256,7 @@ struct rvt_driver_provided {
 	void (*notify_new_ah)(struct ib_device *, struct ib_ah_attr *,
 			      struct rvt_ah *);
 	int (*alloc_qpn)(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-			 enum ib_qp_type type, u8 port, gfp_t gfp);
+			 enum ib_qp_type type, u8 port_num, gfp_t gfp);
 	/**
 	 * Return 0 if modification is valid, -errno otherwise
 	 */
@@ -408,7 +408,7 @@ int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
 int rvt_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
 int rvt_init_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
-		  int portnum, u16 *pkey_table);
+		  int port_index, u16 *pkey_table);
 int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		u32 len, u64 vaddr, u32 rkey, int acc);
 int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
