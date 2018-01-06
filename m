From: Randy Dunlap <rd.dunlab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/8] infiniband: fix sw/rdmavt/* kernel-doc notation
Date: Fri, 05 Jan 2018 16:22:32 -0800
Message-ID: <5a5016ce.8230620a.e8470.2abb@mx.google.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use correct parameter names and formatting in function kernel-doc notation
to eliminate warnings from scripts/kernel-doc.

../drivers/infiniband/sw/rdmavt/mr.c:784: warning: Excess function parameter 'ibmfr' description in 'rvt_map_phys_fmr'
../drivers/infiniband/sw/rdmavt/vt.c:234: warning: Excess function parameter 'intex' description in 'rvt_query_pkey'
../drivers/infiniband/sw/rdmavt/vt.c:266: warning: Excess function parameter 'index' description in 'rvt_query_gid'
../drivers/infiniband/sw/rdmavt/vt.c:306: warning: Excess function parameter 'data' description in 'rvt_alloc_ucontext'
../drivers/infiniband/sw/rdmavt/cq.c:65: warning: Excess function parameter 'sig' description in 'rvt_cq_enter'
../drivers/infiniband/sw/rdmavt/qp.c:279: warning: Excess function parameter 'qpt' description in 'rvt_free_all_qps'
../drivers/infiniband/sw/rdmavt/mcast.c:282: warning: Excess function parameter 'igd' description in 'rvt_attach_mcast'
../drivers/infiniband/sw/rdmavt/mcast.c:345: warning: Excess function parameter 'igd' description in 'rvt_detach_mcast'

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/sw/rdmavt/cq.c    |    2 +-
 drivers/infiniband/sw/rdmavt/mcast.c |    4 ++--
 drivers/infiniband/sw/rdmavt/mr.c    |    2 +-
 drivers/infiniband/sw/rdmavt/qp.c    |   18 +++++++++---------
 drivers/infiniband/sw/rdmavt/vt.c    |    9 +++++----
 5 files changed, 18 insertions(+), 17 deletions(-)

--- linux-next-20171222.orig/drivers/infiniband/sw/rdmavt/cq.c
+++ linux-next-20171222/drivers/infiniband/sw/rdmavt/cq.c
@@ -56,7 +56,7 @@
  * rvt_cq_enter - add a new entry to the completion queue
  * @cq: completion queue
  * @entry: work completion entry to add
- * @sig: true if @entry is solicited
+ * @solicited: true if @entry is solicited
  *
  * This may be called with qp->s_lock held.
  */
--- linux-next-20171222.orig/drivers/infiniband/sw/rdmavt/mr.c
+++ linux-next-20171222/drivers/infiniband/sw/rdmavt/mr.c
@@ -768,7 +768,7 @@ bail:
 
 /**
  * rvt_map_phys_fmr - set up a fast memory region
- * @ibmfr: the fast memory region to set up
+ * @ibfmr: the fast memory region to set up
  * @page_list: the list of pages to associate with the fast memory region
  * @list_len: the number of pages to associate with the fast memory region
  * @iova: the virtual address of the start of the fast memory region
--- linux-next-20171222.orig/drivers/infiniband/sw/rdmavt/qp.c
+++ linux-next-20171222/drivers/infiniband/sw/rdmavt/qp.c
@@ -269,7 +269,7 @@ no_qp_table:
 
 /**
  * free_all_qps - check for QPs still in use
- * @qpt: the QP table to empty
+ * @rdi: rvt device info structure
  *
  * There should not be any QPs still in use.
  * Free memory for table.
@@ -335,9 +335,9 @@ static inline unsigned mk_qpn(struct rvt
 /**
  * alloc_qpn - Allocate the next available qpn or zero/one for QP type
  *	       IB_QPT_SMI/IB_QPT_GSI
- *@rdi:	rvt device info structure
- *@qpt: queue pair number table pointer
- *@port_num: IB port number, 1 based, comes from core
+ * @rdi: rvt device info structure
+ * @qpt: queue pair number table pointer
+ * @port_num: IB port number, 1 based, comes from core
  *
  * Return: The queue pair number
  */
@@ -1650,9 +1650,9 @@ static inline int rvt_qp_valid_operation
 
 /**
  * rvt_qp_is_avail - determine queue capacity
- * @qp - the qp
- * @rdi - the rdmavt device
- * @reserved_op - is reserved operation
+ * @qp: the qp
+ * @rdi: the rdmavt device
+ * @reserved_op: is reserved operation
  *
  * This assumes the s_hlock is held but the s_last
  * qp variable is uncontrolled.
@@ -2174,8 +2174,8 @@ EXPORT_SYMBOL(rvt_rc_rnr_retry);
 
 /**
  * rvt_qp_iter_init - initial for QP iteration
- * @rdi - rvt devinfo
- * @v - u64 value
+ * @rdi: rvt devinfo
+ * @v: u64 value
  *
  * This returns an iterator suitable for iterating QPs
  * in the system.
--- linux-next-20171222.orig/drivers/infiniband/sw/rdmavt/vt.c
+++ linux-next-20171222/drivers/infiniband/sw/rdmavt/vt.c
@@ -224,7 +224,8 @@ static int rvt_modify_port(struct ib_dev
  * rvt_query_pkey - Return a pkey from the table at a given index
  * @ibdev: Verbs IB dev
  * @port_num: Port number, 1 based from ib core
- * @intex: Index into pkey table
+ * @index: Index into pkey table
+ * @pkey: returned pkey from the port pkey table
  *
  * Return: 0 on failure pkey otherwise
  */
@@ -255,7 +256,7 @@ static int rvt_query_pkey(struct ib_devi
  * rvt_query_gid - Return a gid from the table
  * @ibdev: Verbs IB dev
  * @port_num: Port number, 1 based from ib core
- * @index: = Index in table
+ * @guid_index: Index in table
  * @gid: Gid to return
  *
  * Return: 0 on success
@@ -297,8 +298,8 @@ static inline struct rvt_ucontext *to_iu
 
 /**
  * rvt_alloc_ucontext - Allocate a user context
- * @ibdev: Vers IB dev
- * @data: User data allocated
+ * @ibdev: Verbs IB dev
+ * @udata: User data allocated
  */
 static struct ib_ucontext *rvt_alloc_ucontext(struct ib_device *ibdev,
 					      struct ib_udata *udata)
--- linux-next-20171222.orig/drivers/infiniband/sw/rdmavt/mcast.c
+++ linux-next-20171222/drivers/infiniband/sw/rdmavt/mcast.c
@@ -272,7 +272,7 @@ bail:
 /**
  * rvt_attach_mcast - attach a qp to a multicast group
  * @ibqp: Infiniband qp
- * @igd: multicast guid
+ * @gid: multicast guid
  * @lid: multicast lid
  *
  * Return: 0 on success
@@ -335,7 +335,7 @@ bail_mcast:
 /**
  * rvt_detach_mcast - remove a qp from a multicast group
  * @ibqp: Infiniband qp
- * @igd: multicast guid
+ * @gid: multicast guid
  * @lid: multicast lid
  *
  * Return: 0 on success


-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
