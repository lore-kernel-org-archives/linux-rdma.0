From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/12] IB/rdmavt: Clean up comments and add more
 documentation
Date: Sun, 14 Feb 2016 12:10:29 -0800
Message-ID: <20160214201025.1410.71250.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add, remove, and otherwise clean up existing comments that are leftover
from the initial code postings of rdmavt. Many of the comments were added
to provide an idea on the direction we were thinking of going. Now that the
design is solidified make a pass over and clean everything up. Also add
details where lacking.

Ensure all non static functions have nano comments.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/ah.c    |   27 +++++++++++++++
 drivers/infiniband/sw/rdmavt/cq.c    |   30 +++++++++++-----
 drivers/infiniband/sw/rdmavt/mad.c   |   30 +++++++++++-----
 drivers/infiniband/sw/rdmavt/mcast.c |   34 +++++++++++++++++--
 drivers/infiniband/sw/rdmavt/mmap.c  |   28 ++++++++++++---
 drivers/infiniband/sw/rdmavt/mr.c    |   38 ++++++++++++++-------
 drivers/infiniband/sw/rdmavt/pd.c    |   16 +++++++++
 drivers/infiniband/sw/rdmavt/qp.c    |   57 ++++++++++++++++++++++++++++---
 drivers/infiniband/sw/rdmavt/srq.c   |   21 +++++++++++-
 drivers/infiniband/sw/rdmavt/vt.c    |   62 +++++++++++++++++++++++++++-------
 include/rdma/rdma_vt.h               |   15 --------
 11 files changed, 280 insertions(+), 78 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
index 9372c43..16c4461 100644
--- a/drivers/infiniband/sw/rdmavt/ah.c
+++ b/drivers/infiniband/sw/rdmavt/ah.c
@@ -53,6 +53,11 @@
  * rvt_check_ah - validate the attributes of AH
  * @ibdev: the ib device
  * @ah_attr: the attributes of the AH
+ *
+ * If driver supports a more detailed check_ah function call back to it
+ * otherwise just check the basics.
+ *
+ * Return: 0 on success
  */
 int rvt_check_ah(struct ib_device *ibdev,
 		 struct ib_ah_attr *ah_attr)
@@ -95,6 +100,8 @@ EXPORT_SYMBOL(rvt_check_ah);
  * @ah_attr: the attributes of the AH
  *
  * This may be called from interrupt context.
+ *
+ * Return: newly allocated ah
  */
 struct ib_ah *rvt_create_ah(struct ib_pd *pd,
 			    struct ib_ah_attr *ah_attr)
@@ -129,6 +136,12 @@ struct ib_ah *rvt_create_ah(struct ib_pd *pd,
 	return &ah->ibah;
 }
 
+/**
+ * rvt_destory_ah - Destory an address handle
+ * @ibah: address handle
+ *
+ * Return: 0 on success
+ */
 int rvt_destroy_ah(struct ib_ah *ibah)
 {
 	struct rvt_dev_info *dev = ib_to_rvt(ibah->device);
@@ -147,6 +160,13 @@ int rvt_destroy_ah(struct ib_ah *ibah)
 	return 0;
 }
 
+/**
+ * rvt_modify_ah - modify an ah with given attrs
+ * @ibah: address handle to modify
+ * @ah_attr: attrs to apply
+ *
+ * Return: 0 on success
+ */
 int rvt_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
 {
 	struct rvt_ah *ah = ibah_to_rvtah(ibah);
@@ -159,6 +179,13 @@ int rvt_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
 	return 0;
 }
 
+/**
+ * rvt_query_ah - return attrs for ah
+ * @ibah: address handle to query
+ * @ah_attr: return info in this
+ *
+ * Return: always 0
+ */
 int rvt_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
 {
 	struct rvt_ah *ah = ibah_to_rvtah(ibah);
diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 0e6dbe5..c69c070 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -173,10 +173,10 @@ static void send_complete(struct kthread_work *work)
  * @context: unused by the QLogic_IB driver
  * @udata: user data for libibverbs.so
  *
- * Returns a pointer to the completion queue or negative errno values
- * for failure.
- *
  * Called by ib_create_cq() in the generic verbs code.
+ *
+ * Return: pointer to the completion queue or negative errno values
+ * for failure.
  */
 struct ib_cq *rvt_create_cq(struct ib_device *ibdev,
 			    const struct ib_cq_init_attr *attr,
@@ -286,9 +286,9 @@ done:
  * rvt_destroy_cq - destroy a completion queue
  * @ibcq: the completion queue to destroy.
  *
- * Returns 0 for success.
- *
  * Called by ib_destroy_cq() in the generic verbs code.
+ *
+ * Return: always 0
  */
 int rvt_destroy_cq(struct ib_cq *ibcq)
 {
@@ -313,10 +313,10 @@ int rvt_destroy_cq(struct ib_cq *ibcq)
  * @ibcq: the completion queue
  * @notify_flags: the type of notification to request
  *
- * Returns 0 for success.
- *
  * This may be called from interrupt context.  Also called by
  * ib_req_notify_cq() in the generic verbs code.
+ *
+ * Return: 0 for success.
  */
 int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
 {
@@ -345,7 +345,7 @@ int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
  * rvt_resize_cq - change the size of the CQ
  * @ibcq: the completion queue
  *
- * Returns 0 for success.
+ * Return: 0 for success.
  */
 int rvt_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 {
@@ -456,10 +456,10 @@ bail_free:
  * @num_entries: the maximum number of entries to return
  * @entry: pointer to array where work completions are placed
  *
- * Returns the number of completion entries polled.
- *
  * This may be called from interrupt context.  Also called by ib_poll_cq()
  * in the generic verbs code.
+ *
+ * Return: the number of completion entries polled.
  */
 int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 {
@@ -496,6 +496,12 @@ int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 	return npolled;
 }
 
+/**
+ * rvt_driver_cq_init - Init cq resources on behalf of driver
+ * @rdi: rvt dev structure
+ *
+ * Return: 0 on success
+ */
 int rvt_driver_cq_init(struct rvt_dev_info *rdi)
 {
 	int ret = 0;
@@ -530,6 +536,10 @@ int rvt_driver_cq_init(struct rvt_dev_info *rdi)
 	return ret;
 }
 
+/**
+ * rvt_cq_exit - tear down cq reources
+ * @rdi: rvt dev structure
+ */
 void rvt_cq_exit(struct rvt_dev_info *rdi)
 {
 	struct kthread_worker *worker;
diff --git a/drivers/infiniband/sw/rdmavt/mad.c b/drivers/infiniband/sw/rdmavt/mad.c
index 2feae47..f6e9977 100644
--- a/drivers/infiniband/sw/rdmavt/mad.c
+++ b/drivers/infiniband/sw/rdmavt/mad.c
@@ -59,14 +59,13 @@
  * @in_mad: the incoming MAD
  * @out_mad: any outgoing MAD reply
  *
- * Returns IB_MAD_RESULT_SUCCESS if this is a MAD that we are not
- * interested in processing.
- *
  * Note that the verbs framework has already done the MAD sanity checks,
  * and hop count/pointer updating for IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE
  * MADs.
  *
  * This is called by the ib_mad module.
+ *
+ * Return: IB_MAD_RESULT_SUCCESS or error
  */
 int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
@@ -75,13 +74,10 @@ int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		    u16 *out_mad_pkey_index)
 {
 	/*
-	 * Drivers will need to provide a number of things. For exmaple counters
-	 * will need to be maintained by the driver but shoud live in the rvt
-	 * structure. More study will be needed to finalize the interface
-	 * between drivers and rvt for mad packets.
-	 *
-	 *VT-DRIVER-API: ????
-	 *
+	 * MAD processing is quite different between hfi1 and qib. Therfore this
+	 * is expected to be provided by the driver. Other drivers in the future
+	 * may chose to implement this but it should not be made into a
+	 * requirement.
 	 */
 	if (ibport_num_to_idx(ibdev, port_num) < 0)
 		return -EINVAL;
@@ -95,6 +91,14 @@ static void rvt_send_mad_handler(struct ib_mad_agent *agent,
 	ib_free_send_mad(mad_send_wc->send_buf);
 }
 
+/**
+ * rvt_create_mad_agents - create mad agents
+ * @rdi: rvt dev struct
+ *
+ * If driver needs to be notified of mad agent creation then call back
+ *
+ * Return 0 on success
+ */
 int rvt_create_mad_agents(struct rvt_dev_info *rdi)
 {
 	struct ib_mad_agent *agent;
@@ -136,6 +140,12 @@ err:
 	return ret;
 }
 
+/**
+ * rvt_free_mad_agents - free up mad agents
+ * @rdi: rvt dev struct
+ *
+ * If driver needs notification of mad agent removal make the call back
+ */
 void rvt_free_mad_agents(struct rvt_dev_info *rdi)
 {
 	struct ib_mad_agent *agent;
diff --git a/drivers/infiniband/sw/rdmavt/mcast.c b/drivers/infiniband/sw/rdmavt/mcast.c
index e06a875..983d319 100644
--- a/drivers/infiniband/sw/rdmavt/mcast.c
+++ b/drivers/infiniband/sw/rdmavt/mcast.c
@@ -53,6 +53,12 @@
 
 #include "mcast.h"
 
+/**
+ * rvt_driver_mcast - init resources for multicast
+ * @rdi: rvt dev struct
+ *
+ * This is per device that registers with rdmavt
+ */
 void rvt_driver_mcast_init(struct rvt_dev_info *rdi)
 {
 	/*
@@ -130,9 +136,9 @@ static void rvt_mcast_free(struct rvt_mcast *mcast)
  * @ibp: the IB port structure
  * @mgid: the multicast GID to search for
  *
- * Returns NULL if not found.
- *
  * The caller is responsible for decrementing the reference count if found.
+ *
+ * Return: NULL if not found.
  */
 struct rvt_mcast *rvt_mcast_find(struct rvt_ibport *ibp, union ib_gid *mgid)
 {
@@ -170,7 +176,7 @@ EXPORT_SYMBOL(rvt_mcast_find);
  * @mcast: the mcast GID table
  * @mqp: the QP to attach
  *
- * Return zero if both were added.  Return EEXIST if the GID was already in
+ * Return: zero if both were added.  Return EEXIST if the GID was already in
  * the table but the QP was added.  Return ESRCH if the QP was already
  * attached and neither structure was added.
  */
@@ -247,6 +253,14 @@ bail:
 	return ret;
 }
 
+/**
+ * rvt_attach_mcast - attach a qp to a multicast group
+ * @ibqp: Infiniband qp
+ * @igd: multicast guid
+ * @lid: multicast lid
+ *
+ * Return: 0 on success
+ */
 int rvt_attach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
 	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
@@ -298,6 +312,14 @@ bail_mcast:
 	return ret;
 }
 
+/**
+ * rvt_detach_mcast - remove a qp from a multicast group
+ * @ibqp: Infiniband qp
+ * @igd: multicast guid
+ * @lid: multicast lid
+ *
+ * Return: 0 on success
+ */
 int rvt_detach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
 	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
@@ -377,6 +399,12 @@ int rvt_detach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	return 0;
 }
 
+/**
+ *rvt_mast_tree_empty - determine if any qps are attached to any mcast group
+ *@rdi: rvt dev struct
+ *
+ * Return: in use count
+ */
 int rvt_mcast_tree_empty(struct rvt_dev_info *rdi)
 {
 	int i;
diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index 49180c4..273974f 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -51,6 +51,10 @@
 #include <asm/pgtable.h>
 #include "mmap.h"
 
+/**
+ * rvt_mmap_init - init link list and lock for mem map
+ * @rdi: rvt dev struct
+ */
 void rvt_mmap_init(struct rvt_dev_info *rdi)
 {
 	INIT_LIST_HEAD(&rdi->pending_mmaps);
@@ -78,10 +82,6 @@ void rvt_release_mmap_info(struct kref *ref)
 }
 EXPORT_SYMBOL(rvt_release_mmap_info);
 
-/*
- * open and close keep track of how many times the CQ is mapped,
- * to avoid releasing it.
- */
 static void rvt_vma_open(struct vm_area_struct *vma)
 {
 	struct rvt_mmap_info *ip = vma->vm_private_data;
@@ -105,7 +105,8 @@ static const struct vm_operations_struct rvt_vm_ops = {
  * rvt_mmap - create a new mmap region
  * @context: the IB user context of the process making the mmap() call
  * @vma: the VMA to be initialized
- * Return zero if the mmap is OK. Otherwise, return an errno.
+ *
+ * Return: zero if the mmap is OK. Otherwise, return an errno.
  */
 int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
@@ -147,8 +148,14 @@ done:
 }
 EXPORT_SYMBOL(rvt_mmap);
 
-/*
- * Allocate information for hfi1_mmap
+/**
+ * rvt_create_mmap_info - allocate information for hfi1_mmap
+ * @rdi: rvt dev struct
+ * @size: size in bytes to map
+ * @context: user context
+ * @obj: opaque pointer to a cq, wq etc
+ *
+ * Return: rvt_mmap struct on success
  */
 struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
 					   u32 size,
@@ -180,6 +187,13 @@ struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
 }
 EXPORT_SYMBOL(rvt_create_mmap_info);
 
+/**
+ * rvt_update_mmap_info - update a mem map
+ * @rdi: rvt dev struct
+ * @ip: mmap info pointer
+ * @size: size to grow by
+ * @obj: opaque pointer to cq, wq, etc.
+ */
 void rvt_update_mmap_info(struct rvt_dev_info *rdi, struct rvt_mmap_info *ip,
 			  u32 size, void *obj)
 {
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 8bff6bb..8549652 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -52,8 +52,13 @@
 #include "vt.h"
 #include "mr.h"
 
-/*
+/**
+ * rvt_driver_mr_init - Init MR resources per driver
+ * @rdi: rvt dev struct
+ *
  * Do any intilization needed when a driver registers with rdmavt.
+ *
+ * Return: 0 on success or errno on failure
  */
 int rvt_driver_mr_init(struct rvt_dev_info *rdi)
 {
@@ -98,7 +103,10 @@ int rvt_driver_mr_init(struct rvt_dev_info *rdi)
 	return 0;
 }
 
-/*
+/**
+ *rvt_mr_exit: clean up MR
+ *@rdi: rvt dev structure
+ *
  * called when drivers have unregistered or perhaps failed to register with us
  */
 void rvt_mr_exit(struct rvt_dev_info *rdi)
@@ -297,7 +305,7 @@ static void __rvt_free_mr(struct rvt_mr *mr)
  * @pd: protection domain for this memory region
  * @acc: access flags
  *
- * Returns the memory region on success, otherwise returns an errno.
+ * Return: the memory region on success, otherwise returns an errno.
  * Note that all DMA addresses should be created via the
  * struct ib_dma_mapping_ops functions (see dma.c).
  */
@@ -348,7 +356,7 @@ bail:
  * @mr_access_flags: access flags for this memory region
  * @udata: unused by the driver
  *
- * Returns the memory region on success, otherwise returns an errno.
+ * Return: the memory region on success, otherwise returns an errno.
  */
 struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			      u64 virt_addr, int mr_access_flags,
@@ -418,10 +426,11 @@ bail_umem:
  * rvt_dereg_mr - unregister and free a memory region
  * @ibmr: the memory region to free
  *
- * Returns 0 on success.
  *
  * Note that this is called to free MRs created by rvt_get_dma_mr()
  * or rvt_reg_user_mr().
+ *
+ * Returns 0 on success.
  */
 int rvt_dereg_mr(struct ib_mr *ibmr)
 {
@@ -456,7 +465,7 @@ out:
  * @mr_type: mem region type
  * @max_num_sg: Max number of segments allowed
  *
- * Return the memory region on success, otherwise return an errno.
+ * Return: the memory region on success, otherwise return an errno.
  */
 struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
 			   enum ib_mr_type mr_type,
@@ -480,7 +489,7 @@ struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
  * @mr_access_flags: access flags for this memory region
  * @fmr_attr: fast memory region attributes
  *
- * Returns the memory region on success, otherwise returns an errno.
+ * Return: the memory region on success, otherwise returns an errno.
  */
 struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 			     struct ib_fmr_attr *fmr_attr)
@@ -537,6 +546,8 @@ bail:
  * @iova: the virtual address of the start of the fast memory region
  *
  * This may be called from interrupt context.
+ *
+ * Return: 0 on success
  */
 
 int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
@@ -580,7 +591,7 @@ int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
  * rvt_unmap_fmr - unmap fast memory regions
  * @fmr_list: the list of fast memory regions to unmap
  *
- * Returns 0 on success.
+ * Return: 0 on success.
  */
 int rvt_unmap_fmr(struct list_head *fmr_list)
 {
@@ -605,7 +616,7 @@ int rvt_unmap_fmr(struct list_head *fmr_list)
  * rvt_dealloc_fmr - deallocate a fast memory region
  * @ibfmr: the fast memory region to deallocate
  *
- * Returns 0 on success.
+ * Return: 0 on success.
  */
 int rvt_dealloc_fmr(struct ib_fmr *ibfmr)
 {
@@ -635,12 +646,13 @@ out:
  * @sge: SGE to check
  * @acc: access flags
  *
- * Return 1 if valid and successful, otherwise returns 0.
+ * Check the IB SGE for validity and initialize our internal version
+ * of it.
+ *
+ * Return: 1 if valid and successful, otherwise returns 0.
  *
  * increments the reference count upon success
  *
- * Check the IB SGE for validity and initialize our internal version
- * of it.
  */
 int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		struct rvt_sge *isge, struct ib_sge *sge, int acc)
@@ -733,7 +745,7 @@ EXPORT_SYMBOL(rvt_lkey_ok);
  * @rkey: rkey to check
  * @acc: access flags
  *
- * Return 1 if successful, otherwise 0.
+ * Return: 1 if successful, otherwise 0.
  *
  * increments the reference count upon success
  */
diff --git a/drivers/infiniband/sw/rdmavt/pd.c b/drivers/infiniband/sw/rdmavt/pd.c
index 62fee44..d1292f3 100644
--- a/drivers/infiniband/sw/rdmavt/pd.c
+++ b/drivers/infiniband/sw/rdmavt/pd.c
@@ -48,6 +48,16 @@
 #include <linux/slab.h>
 #include "pd.h"
 
+/**
+ * rvt_alloc_pd - allocate a protection domain
+ * @ibdev: ib device
+ * @context: optional user context
+ * @udata: optional user data
+ *
+ * Allocate and keep track of a PD.
+ *
+ * Return: 0 on success
+ */
 struct ib_pd *rvt_alloc_pd(struct ib_device *ibdev,
 			   struct ib_ucontext *context,
 			   struct ib_udata *udata)
@@ -88,6 +98,12 @@ bail:
 	return ret;
 }
 
+/**
+ * rvt_dealloc_pd - Free PD
+ * @ibpd: Free up PD
+ *
+ * Return: always 0
+ */
 int rvt_dealloc_pd(struct ib_pd *ibpd)
 {
 	struct rvt_pd *pd = ibpd_to_rvtpd(ibpd);
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index d629911..5809562 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -162,6 +162,12 @@ static void free_qpn_table(struct rvt_qpn_table *qpt)
 		free_page((unsigned long)qpt->map[i].page);
 }
 
+/**
+ * rvt_driver_qp_init - Init driver qp resources
+ * @rdi: rvt dev strucutre
+ *
+ * Return: 0 on success
+ */
 int rvt_driver_qp_init(struct rvt_dev_info *rdi)
 {
 	int i;
@@ -262,6 +268,12 @@ static unsigned rvt_free_all_qps(struct rvt_dev_info *rdi)
 	return qp_inuse;
 }
 
+/**
+ * rvt_qp_exit - clean up qps on device exit
+ * @rdi: rvt dev structure
+ *
+ * Check for qp leaks and free resources.
+ */
 void rvt_qp_exit(struct rvt_dev_info *rdi)
 {
 	u32 qps_inuse = rvt_free_all_qps(rdi);
@@ -483,7 +495,7 @@ EXPORT_SYMBOL(rvt_reset_qp);
  * unique idea of what queue pair numbers mean. For instance there is a reserved
  * range for PSM.
  *
- * Returns the queue pair on success, otherwise returns an errno.
+ * Return: the queue pair on success, otherwise returns an errno.
  *
  * Called by the ib_create_qp() core verbs function.
  */
@@ -757,6 +769,11 @@ bail_swq:
 	return ret;
 }
 
+/**
+ * rvt_clear_mr_refs - Drop help mr refs
+ * @qp: rvt qp data structure
+ * @clr_sends: If shoudl clear send side or not
+ */
 void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 {
 	unsigned n;
@@ -812,7 +829,8 @@ EXPORT_SYMBOL(rvt_clear_mr_refs);
  * @err: the receive completion error to signal if a RWQE is active
  *
  * Flushes both send and receive work queues.
- * Returns true if last WQE event should be generated.
+ *
+ * Return: true if last WQE event should be generated.
  * The QP r_lock and s_lock should be held and interrupts disabled.
  * If we are already in error state, just return.
  */
@@ -912,7 +930,11 @@ static void rvt_insert_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 	spin_unlock_irqrestore(&rdi->qp_dev->qpt_lock, flags);
 }
 
-/*
+/**
+ * rvt_remove_qp - remove qp form table
+ * @rdi: rvt dev struct
+ * @qp: qp to remove
+ *
  * Remove the QP from the table so it can't be found asynchronously by
  * the receive routine.
  */
@@ -967,7 +989,7 @@ EXPORT_SYMBOL(rvt_remove_qp);
  * @attr_mask: the mask of attributes to modify
  * @udata: user data for libibverbs.so
  *
- * Returns 0 on success, otherwise returns an errno.
+ * Return: 0 on success, otherwise returns an errno.
  */
 int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		  int attr_mask, struct ib_udata *udata)
@@ -1224,10 +1246,10 @@ inval:
  * rvt_destroy_qp - destroy a queue pair
  * @ibqp: the queue pair to destroy
  *
- * Returns 0 on success.
- *
  * Note that this can be called while the QP is actively sending or
  * receiving!
+ *
+ * Return: 0 on success.
  */
 int rvt_destroy_qp(struct ib_qp *ibqp)
 {
@@ -1263,6 +1285,15 @@ int rvt_destroy_qp(struct ib_qp *ibqp)
 	return 0;
 }
 
+/**
+ * rvt_query_qp - query an ipbq
+ * @ibqp: IB qp to query
+ * @attr: attr struct to fill in
+ * @attr_mask: attr mask ignored
+ * @init_attr: struct to fill in
+ *
+ * Return: always 0
+ */
 int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		 int attr_mask, struct ib_qp_init_attr *init_attr)
 {
@@ -1321,6 +1352,8 @@ int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
  * @bad_wr: the first bad WR is put here
  *
  * This may be called from interrupt context.
+ *
+ * Return: 0 on success otherwise errno
  */
 int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		  struct ib_recv_wr **bad_wr)
@@ -1539,6 +1572,8 @@ bail_inval_free:
  * @bad_wr: the first bad WR is put here
  *
  * This may be called from interrupt context.
+ *
+ * Return: 0 on success else errno
  */
 int rvt_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		  struct ib_send_wr **bad_wr)
@@ -1594,6 +1629,8 @@ bail:
  * @bad_wr: A pointer to the first WR to cause a problem is put here
  *
  * This may be called from interrupt context.
+ *
+ * Return: 0 on success else errno
  */
 int rvt_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 		      struct ib_recv_wr **bad_wr)
@@ -1636,6 +1673,10 @@ int rvt_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 	return 0;
 }
 
+/** rvt_free_qpn - Free a qpn from the bit map
+ * @qpt: QP table
+ * @qpn: queue pair number to free
+ */
 void rvt_free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
 {
 	struct rvt_qpn_map *map;
@@ -1646,6 +1687,10 @@ void rvt_free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
 }
 EXPORT_SYMBOL(rvt_free_qpn);
 
+/**
+ * rvt_dec_qp_cnt - decrement qp count
+ * rdi: rvt dev struct
+ */
 void rvt_dec_qp_cnt(struct rvt_dev_info *rdi)
 {
 	spin_lock(&rdi->n_qps_lock);
diff --git a/drivers/infiniband/sw/rdmavt/srq.c b/drivers/infiniband/sw/rdmavt/srq.c
index 4960a89..98c4927 100644
--- a/drivers/infiniband/sw/rdmavt/srq.c
+++ b/drivers/infiniband/sw/rdmavt/srq.c
@@ -51,7 +51,10 @@
 
 #include "srq.h"
 
-/*
+/**
+ * rvt_driver_srq_init - init srq resources on a per driver basis
+ * @rdi: rvt dev structure
+ *
  * Do any initialization needed when a driver registers with rdmavt.
  */
 void rvt_driver_srq_init(struct rvt_dev_info *rdi)
@@ -65,6 +68,8 @@ void rvt_driver_srq_init(struct rvt_dev_info *rdi)
  * @ibpd: the protection domain of the SRQ to create
  * @srq_init_attr: the attributes of the SRQ
  * @udata: data from libibverbs when creating a user SRQ
+ *
+ * Return: Allocated srq object
  */
 struct ib_srq *rvt_create_srq(struct ib_pd *ibpd,
 			      struct ib_srq_init_attr *srq_init_attr,
@@ -168,6 +173,8 @@ bail_srq:
  * @attr: the new attributes of the SRQ
  * @attr_mask: indicates which attributes to modify
  * @udata: user data for libibverbs.so
+ *
+ * Return: 0 on success
  */
 int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		   enum ib_srq_attr_mask attr_mask,
@@ -305,6 +312,12 @@ bail_free:
 	return ret;
 }
 
+/** rvt_query_srq - query srq data
+ * @ibsrq: srq to query
+ * @attr: return info in attr
+ *
+ * Return: always 0
+ */
 int rvt_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 {
 	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
@@ -315,6 +328,12 @@ int rvt_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 	return 0;
 }
 
+/**
+ * rvt_destroy_srq - destory an srq
+ * @ibsrq: srq object to destroy
+ *
+ * Return always 0
+ */
 int rvt_destroy_srq(struct ib_srq *ibsrq)
 {
 	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 2ccf610..f5cb09b 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -57,16 +57,37 @@ MODULE_DESCRIPTION("RDMA Verbs Transport Library");
 
 static int rvt_init(void)
 {
-	/* Do any work needed prior to drivers calling for registration*/
+	/*
+	 * rdmavt does not need to do anything special when it starts up. All it
+	 * needs to do is sit and wait until a driver attempts registration.
+	 */
 	return 0;
 }
 module_init(rvt_init);
 
 static void rvt_cleanup(void)
 {
+	/*
+	 * Nothing to do at exit time either. The module won't be able to be
+	 * removed until all drivers are gone which means all the dev structs
+	 * are gone so there is really nothing to do.
+	 */
 }
 module_exit(rvt_cleanup);
 
+/**
+ * rvt_alloc_device - allocate rdi
+ * @size: how big of a structure to allocate
+ * @nports: number of ports to allocate array slots for
+ *
+ * Use IB core device alloc to allocate space for the rdi which is assumed to be
+ * inside of the ib_device. Any extra space that drivers require should be
+ * included in size.
+ *
+ * We also allocate a port array based on the number of ports.
+ *
+ * Return: pointer to allocated rdi
+ */
 struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
 {
 	struct rvt_dev_info *rdi = ERR_PTR(-ENOMEM);
@@ -105,15 +126,10 @@ static int rvt_modify_device(struct ib_device *device,
 			     struct ib_device_modify *device_modify)
 {
 	/*
-	 * Change dev props. Planned support is for node desc change and sys
-	 * guid change only. This matches hfi1 and qib behavior. Other drivers
-	 * that support existing modifications will need to add their support.
+	 * There is currently no need to supply this based on qib and hfi1.
+	 * Future drivers may need to implement this though.
 	 */
 
-	/*
-	 * VT-DRIVER-API: node_desc_change()
-	 * VT-DRIVER-API: sys_guid_change()
-	 */
 	return -EOPNOTSUPP;
 }
 
@@ -123,7 +139,7 @@ static int rvt_modify_device(struct ib_device *device,
  * @port_num: port number, 1 based from ib core
  * @props: structure to hold returned properties
  *
- * Returns 0 on success
+ * Return: 0 on success
  */
 static int rvt_query_port(struct ib_device *ibdev, u8 port_num,
 			  struct ib_port_attr *props)
@@ -158,7 +174,7 @@ static int rvt_query_port(struct ib_device *ibdev, u8 port_num,
  * @port_modify_mask: How to change the port
  * @props: Structure to fill in
  *
- * Returns 0 on success
+ * Return: 0 on success
  */
 static int rvt_modify_port(struct ib_device *ibdev, u8 port_num,
 			   int port_modify_mask, struct ib_port_modify *props)
@@ -191,7 +207,7 @@ static int rvt_modify_port(struct ib_device *ibdev, u8 port_num,
  * @port_num: Port number, 1 based from ib core
  * @intex: Index into pkey table
  *
- * Returns 0 on failure pkey otherwise
+ * Return: 0 on failure pkey otherwise
  */
 static int rvt_query_pkey(struct ib_device *ibdev, u8 port_num, u16 index,
 			  u16 *pkey)
@@ -223,7 +239,7 @@ static int rvt_query_pkey(struct ib_device *ibdev, u8 port_num, u16 index,
  * @index: = Index in table
  * @gid: Gid to return
  *
- * Returns 0 on success
+ * Return: 0 on success
  */
 static int rvt_query_gid(struct ib_device *ibdev, u8 port_num,
 			 int guid_index, union ib_gid *gid)
@@ -316,6 +332,15 @@ static int rvt_get_port_immutable(struct ib_device *ibdev, u8 port_num,
 #define CHECK_DRIVER_OVERRIDE(rdi, x) \
 	rdi->ibdev.x = rdi->ibdev.x ? : rvt_ ##x
 
+/**
+ * rvt_register_device - register a driver
+ * @rdi: main dev structure for all of rdmavt operations
+ *
+ * It is up to drivers to allocate the rdi and fill in the appropriate
+ * information.
+ *
+ * Return: 0 on success otherwise an errno.
+ */
 int rvt_register_device(struct rvt_dev_info *rdi)
 {
 	/* Validate that drivers have provided the right information */
@@ -487,6 +512,10 @@ bail_no_mr:
 }
 EXPORT_SYMBOL(rvt_register_device);
 
+/**
+ * rvt_unregister_device - remove a driver
+ * @rdi: rvt dev struct
+ */
 void rvt_unregister_device(struct rvt_dev_info *rdi)
 {
 	trace_rvt_dbg(rdi, "Driver is unregistering.");
@@ -502,9 +531,16 @@ void rvt_unregister_device(struct rvt_dev_info *rdi)
 }
 EXPORT_SYMBOL(rvt_unregister_device);
 
-/*
+/**
+ * rvt_init_port - init internal data for driver port
+ * @rdi: rvt dev strut
+ * @port: rvt port
+ * @port_index: 0 based index of ports, different from IB core port num
+ *
  * Keep track of a list of ports. No need to have a detach port.
  * They persist until the driver goes away.
+ *
+ * Return: always 0
  */
 int rvt_init_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
 		  int port_index, u16 *pkey_table)
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index aabd2e5..57c708d 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -146,21 +146,6 @@ struct rvt_ibport {
  * Things that are driver specific, module parameters in hfi1 and qib
  */
 struct rvt_driver_params {
-	/*
-	 * driver required fields:
-	 *	node_guid
-	 *	phys_port_cnt
-	 *	dma_device
-	 *	owner
-	 * driver optional fields (rvt will provide generic value if blank):
-	 *	name
-	 *	node_desc
-	 * rvt fields, driver value ignored:
-	 *	uverbs_abi_ver
-	 *	node_type
-	 *	num_comp_vectors
-	 *	uverbs_cmd_mask
-	 */
 	struct ib_device_attr props;
 
 	/*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
