From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 09/10] IB/hfi1: Resolve kernel panics by reference
 counting receive contexts
Date: Fri, 09 Jun 2017 16:00:19 -0700
Message-ID: <20170609230017.26710.10721.stgit@scvm10.sc.intel.com>
References: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170609225424.26710.70167.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Base receive contexts can be used by sub contexts.  Because of this,
resources for the context cannot be completely freed until all sub
contexts are done using the base context.

Introduce a reference count so that the base receive context can be
freed only when all sub contexts are done with it.

Use the provided function call for setting default send context
integrity rather than the manual method.

The cleanup path does not set all variables back to NULL after freeing
resources.  Since the clean up code can get called more than once,
(e.g. during context close and on the error path), it is necessary to
make sure that all the variables are NULLed.

Possible crash are:

BUG: unable to handle kernel paging request at 0000000001908900
IP: read_csr+0x24/0x30 [hfi1]
RIP: 0010:read_csr+0x24/0x30 [hfi1]
Call Trace:
 sc_disable+0x40/0x110 [hfi1]
 hfi1_file_close+0x16f/0x360 [hfi1]
 __fput+0xe7/0x210
 ____fput+0xe/0x10

or

kernel BUG at mm/slub.c:3877!
RIP: 0010:kfree+0x14f/0x170
Call Trace:
 hfi1_free_ctxtdata+0x19a/0x2b0 [hfi1]
 ? hfi1_user_exp_rcv_grp_free+0x73/0x80 [hfi1]
 hfi1_file_close+0x20f/0x360 [hfi1]
 __fput+0xe7/0x210
 ____fput+0xe/0x10

Fixes: Commit 62239fc6e554 ("IB/hfi1: Clean up on context initialization failure")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c  |   39 ++++++++++++++--------
 drivers/infiniband/hw/hfi1/hfi.h       |   11 +++---
 drivers/infiniband/hw/hfi1/init.c      |   58 ++++++++++++++++++++++++++------
 drivers/infiniband/hw/hfi1/vnic_main.c |   11 ++++--
 4 files changed, 85 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 2dd8758..bbf80b1 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -774,6 +774,8 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	*ev = 0;
 
 	__clear_bit(fdata->subctxt, uctxt->in_use_ctxts);
+	fdata->uctxt = NULL;
+	hfi1_rcd_put(uctxt); /* fdata reference */
 	if (!bitmap_empty(uctxt->in_use_ctxts, HFI1_MAX_SHARED_CTXTS)) {
 		mutex_unlock(&hfi1_mutex);
 		goto done;
@@ -794,16 +796,15 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	/* Clear the context's J_KEY */
 	hfi1_clear_ctxt_jkey(dd, uctxt->ctxt);
 	/*
-	 * Reset context integrity checks to default.
-	 * (writes to CSRs probably belong in chip.c)
+	 * If a send context is allocated, reset context integrity
+	 * checks to default and disable the send context.
 	 */
-	write_kctxt_csr(dd, uctxt->sc->hw_context, SEND_CTXT_CHECK_ENABLE,
-			hfi1_pkt_default_send_ctxt_mask(dd, uctxt->sc->type));
-	sc_disable(uctxt->sc);
+	if (uctxt->sc) {
+		set_pio_integrity(uctxt->sc);
+		sc_disable(uctxt->sc);
+	}
 	spin_unlock_irqrestore(&dd->uctxt_lock, flags);
 
-	dd->rcd[uctxt->ctxt] = NULL;
-
 	hfi1_free_ctxt_rcv_groups(uctxt);
 	hfi1_clear_ctxt_pkey(dd, uctxt);
 
@@ -816,8 +817,11 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	hfi1_stats.sps_ctxts--;
 	if (++dd->freectxts == dd->num_user_contexts)
 		aspm_enable_all(dd);
+
+	/* _rcd_put() should be done after releasing mutex */
+	dd->rcd[uctxt->ctxt] = NULL;
 	mutex_unlock(&hfi1_mutex);
-	hfi1_free_ctxtdata(dd, uctxt);
+	hfi1_rcd_put(uctxt);  /* dd reference */
 done:
 	mmdrop(fdata->mm);
 	kobject_put(&dd->kobj);
@@ -887,16 +891,17 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 		ret = wait_event_interruptible(fd->uctxt->wait, !test_bit(
 					       HFI1_CTXT_BASE_UNINIT,
 					       &fd->uctxt->event_flags));
-		if (test_bit(HFI1_CTXT_BASE_FAILED, &fd->uctxt->event_flags)) {
-			clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
-			return -ENOMEM;
-		}
+		if (test_bit(HFI1_CTXT_BASE_FAILED, &fd->uctxt->event_flags))
+			ret = -ENOMEM;
+
 		/* The only thing a sub context needs is the user_xxx stuff */
 		if (!ret)
 			ret = init_user_ctxt(fd);
 
-		if (ret)
+		if (ret) {
 			clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
+			hfi1_rcd_put(fd->uctxt);
+		}
 	} else if (!ret) {
 		ret = setup_base_ctxt(fd);
 		if (fd->uctxt->subctxt_cnt) {
@@ -961,6 +966,8 @@ static int find_sub_ctxt(struct hfi1_filedata *fd,
 
 		fd->uctxt = uctxt;
 		fd->subctxt = subctxt;
+
+		hfi1_rcd_get(uctxt);
 		__set_bit(fd->subctxt, uctxt->in_use_ctxts);
 
 		return 1;
@@ -1069,11 +1076,14 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 		aspm_disable_all(dd);
 	fd->uctxt = uctxt;
 
+	/* Count the reference for the fd */
+	hfi1_rcd_get(uctxt);
+
 	return 0;
 
 ctxdata_free:
 	dd->rcd[ctxt] = NULL;
-	hfi1_free_ctxtdata(dd, uctxt);
+	hfi1_rcd_put(uctxt);
 	return ret;
 }
 
@@ -1273,6 +1283,7 @@ static int setup_base_ctxt(struct hfi1_filedata *fd)
 	return 0;
 
 setup_failed:
+	/* Call _free_ctxtdata, not _rcd_put().  We still need the context. */
 	hfi1_free_ctxtdata(dd, uctxt);
 	return ret;
 }
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 4242e45..e4daaec 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -213,11 +213,9 @@ struct hfi1_ctxtdata {
 
 	/* dynamic receive available interrupt timeout */
 	u32 rcvavail_timeout;
-	/*
-	 * number of opens (including slave sub-contexts) on this instance
-	 * (ignoring forks, dup, etc. for now)
-	 */
-	int cnt;
+	/* Reference count the base context usage */
+	struct kref kref;
+
 	/* Device context index */
 	unsigned ctxt;
 	/*
@@ -1291,7 +1289,8 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 			 struct hfi1_devdata *dd, u8 hw_pidx, u8 port);
 void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd);
-
+int hfi1_rcd_put(struct hfi1_ctxtdata *rcd);
+void hfi1_rcd_get(struct hfi1_ctxtdata *rcd);
 int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread);
 int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *rcd, int thread);
 int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *rcd, int thread);
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index a00308c..dfdb412 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -191,16 +191,46 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 nomem:
 	ret = -ENOMEM;
 
-	if (dd->rcd) {
-		for (i = 0; i < dd->num_rcv_contexts; ++i)
-			hfi1_free_ctxtdata(dd, dd->rcd[i]);
-	}
+	for (i = 0; dd->rcd && i < dd->first_dyn_alloc_ctxt; ++i)
+		hfi1_rcd_put(dd->rcd[i]);
+
+	/* All the contexts should be freed, free the array */
 	kfree(dd->rcd);
 	dd->rcd = NULL;
 	return ret;
 }
 
 /*
+ * Helper routines for the receive context reference count (rcd and uctxt)
+ */
+static void hfi1_rcd_init(struct hfi1_ctxtdata *rcd)
+{
+	kref_init(&rcd->kref);
+}
+
+static void hfi1_rcd_free(struct kref *kref)
+{
+	struct hfi1_ctxtdata *rcd =
+		container_of(kref, struct hfi1_ctxtdata, kref);
+
+	hfi1_free_ctxtdata(rcd->dd, rcd);
+	kfree(rcd);
+}
+
+int hfi1_rcd_put(struct hfi1_ctxtdata *rcd)
+{
+	if (rcd)
+		return kref_put(&rcd->kref, hfi1_rcd_free);
+
+	return 0;
+}
+
+void hfi1_rcd_get(struct hfi1_ctxtdata *rcd)
+{
+	kref_get(&rcd->kref);
+}
+
+/*
  * Common code for user and kernel context setup.
  */
 struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
@@ -332,6 +362,8 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 			if (!rcd->opstats)
 				goto bail;
 		}
+
+		hfi1_rcd_init(rcd);
 	}
 	return rcd;
 bail:
@@ -931,14 +963,11 @@ static void shutdown_device(struct hfi1_devdata *dd)
  * @rcd: the ctxtdata structure
  *
  * free up any allocated data for a context
- * This should not touch anything that would affect a simultaneous
- * re-allocation of context data, because it is called after hfi1_mutex
- * is released (and can be called from reinit as well).
  * It should never change any chip state, or global driver state.
  */
 void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 {
-	unsigned e;
+	u32 e;
 
 	if (!rcd)
 		return;
@@ -957,6 +986,7 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 
 	/* all the RcvArray entries should have been cleared by now */
 	kfree(rcd->egrbufs.rcvtids);
+	rcd->egrbufs.rcvtids = NULL;
 
 	for (e = 0; e < rcd->egrbufs.alloced; e++) {
 		if (rcd->egrbufs.buffers[e].dma)
@@ -966,13 +996,21 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 					  rcd->egrbufs.buffers[e].dma);
 	}
 	kfree(rcd->egrbufs.buffers);
+	rcd->egrbufs.alloced = 0;
+	rcd->egrbufs.buffers = NULL;
 
 	sc_free(rcd->sc);
+	rcd->sc = NULL;
+
 	vfree(rcd->subctxt_uregbase);
 	vfree(rcd->subctxt_rcvegrbuf);
 	vfree(rcd->subctxt_rcvhdr_base);
 	kfree(rcd->opstats);
-	kfree(rcd);
+
+	rcd->subctxt_uregbase = NULL;
+	rcd->subctxt_rcvegrbuf = NULL;
+	rcd->subctxt_rcvhdr_base = NULL;
+	rcd->opstats = NULL;
 }
 
 /*
@@ -1366,7 +1404,7 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 		tmp[ctxt] = NULL; /* debugging paranoia */
 		if (rcd) {
 			hfi1_clear_tids(rcd);
-			hfi1_free_ctxtdata(dd, rcd);
+			hfi1_rcd_put(rcd);
 		}
 	}
 	kfree(tmp);
diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index b601c29..950c1b4 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -156,11 +156,11 @@ static int allocate_vnic_ctxt(struct hfi1_devdata *dd,
 	return ret;
 bail:
 	/*
-	 * hfi1_free_ctxtdata() also releases send_context
-	 * structure if uctxt->sc is not null
+	 * hfi1_rcd_put() will call hfi1_free_ctxtdata(), which will
+	 * release send_context structure if uctxt->sc is not null
 	 */
 	dd->rcd[uctxt->ctxt] = NULL;
-	hfi1_free_ctxtdata(dd, uctxt);
+	hfi1_rcd_put(uctxt);
 	dd_dev_dbg(dd, "vnic allocation failed. rc %d\n", ret);
 	return ret;
 }
@@ -208,7 +208,7 @@ static void deallocate_vnic_ctxt(struct hfi1_devdata *dd,
 	hfi1_clear_ctxt_pkey(dd, uctxt);
 
 	hfi1_stats.sps_ctxts--;
-	hfi1_free_ctxtdata(dd, uctxt);
+	hfi1_rcd_put(uctxt);
 }
 
 void hfi1_vnic_setup(struct hfi1_devdata *dd)
@@ -751,6 +751,7 @@ static int hfi1_vnic_init(struct hfi1_vnic_vport_info *vinfo)
 		rc = hfi1_vnic_allot_ctxt(dd, &dd->vnic.ctxt[i]);
 		if (rc)
 			break;
+		hfi1_rcd_get(dd->vnic.ctxt[i]);
 		dd->vnic.ctxt[i]->vnic_q_idx = i;
 	}
 
@@ -762,6 +763,7 @@ static int hfi1_vnic_init(struct hfi1_vnic_vport_info *vinfo)
 		 */
 		while (i-- > dd->vnic.num_ctxt) {
 			deallocate_vnic_ctxt(dd, dd->vnic.ctxt[i]);
+			hfi1_rcd_put(dd->vnic.ctxt[i]);
 			dd->vnic.ctxt[i] = NULL;
 		}
 		goto alloc_fail;
@@ -791,6 +793,7 @@ static void hfi1_vnic_deinit(struct hfi1_vnic_vport_info *vinfo)
 	if (--dd->vnic.num_vports == 0) {
 		for (i = 0; i < dd->vnic.num_ctxt; i++) {
 			deallocate_vnic_ctxt(dd, dd->vnic.ctxt[i]);
+			hfi1_rcd_put(dd->vnic.ctxt[i]);
 			dd->vnic.ctxt[i] = NULL;
 		}
 		hfi1_deinit_vnic_rsm(dd);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
