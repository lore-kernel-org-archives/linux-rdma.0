From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 15/15] IB/hfi1: Clean up on context initialization failure
Date: Thu, 04 May 2017 05:15:21 -0700
Message-ID: <20170504121520.32747.43674.stgit@scvm10.sc.intel.com>
References: <20170504120126.32747.45131.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504120126.32747.45131.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The error path for context initialization is not consistent. Cleanup all
resources on failure.

Removed unused variable user_event_mask.

Add the _BASE_FAILED bit to the event flags so that a base context can
notify waiting sub contexts that they cannot continue.

Running out of sub contexts is an EBUSY result, not EINVAL.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c     |   62 ++++++++++++++++++-----------
 drivers/infiniband/hw/hfi1/hfi.h          |   16 +++----
 drivers/infiniband/hw/hfi1/init.c         |   10 ++---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   31 ++++++++-------
 drivers/infiniband/hw/hfi1/user_sdma.c    |   61 ++++++++++++++---------------
 5 files changed, 95 insertions(+), 85 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 9c177ef..3158128 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -82,7 +82,7 @@
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 			 const struct hfi1_user_info *uinfo);
 static int init_user_ctxt(struct hfi1_filedata *fd);
-static int user_init(struct hfi1_ctxtdata *uctxt);
+static void user_init(struct hfi1_ctxtdata *uctxt);
 static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
 			 __u32 len);
 static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
@@ -847,7 +847,7 @@ static u64 kvirt_to_phys(void *addr)
 
 static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 {
-	int ret = 0;
+	int ret;
 	unsigned int swmajor, swminor;
 
 	swmajor = uinfo->userversion >> 16;
@@ -857,14 +857,16 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 	swminor = uinfo->userversion & 0xffff;
 
 	mutex_lock(&hfi1_mutex);
-	/* First, lets check if we need to get a sub context? */
+	/*
+	 * Get a sub context if necessary.
+	 * ret < 0 error, 0 no context, 1 sub-context found
+	 */
+	ret = 0;
 	if (uinfo->subctxt_cnt) {
-		/* < 0 error, 0 no context, 1 sub-context found */
 		ret = find_sub_ctxt(fd, uinfo);
-		if (ret > 0) {
+		if (ret > 0)
 			fd->rec_cpu_num =
 				hfi1_get_proc_affinity(fd->uctxt->numa_id);
-		}
 	}
 
 	/*
@@ -885,17 +887,27 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 		ret = wait_event_interruptible(fd->uctxt->wait, !test_bit(
 					       HFI1_CTXT_BASE_UNINIT,
 					       &fd->uctxt->event_flags));
+		if (test_bit(HFI1_CTXT_BASE_FAILED, &fd->uctxt->event_flags)) {
+			clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
+			return -ENOMEM;
+		}
 		/* The only thing a sub context needs is the user_xxx stuff */
 		if (!ret)
-			init_user_ctxt(fd);
+			ret = init_user_ctxt(fd);
+
+		if (ret)
+			clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
 	} else if (!ret) {
 		ret = setup_base_ctxt(fd);
-
-		/*
-		 * Base context is done, notify anybody using a sub-context
-		 * that is waiting for this completion
-		 */
-		if (!ret && fd->uctxt->subctxt_cnt) {
+		if (fd->uctxt->subctxt_cnt) {
+			/* If there is an error, set the failed bit. */
+			if (ret)
+				set_bit(HFI1_CTXT_BASE_FAILED,
+					&fd->uctxt->event_flags);
+			/*
+			 * Base context is done, notify anybody using a
+			 * sub-context that is waiting for this completion
+			 */
 			clear_bit(HFI1_CTXT_BASE_UNINIT,
 				  &fd->uctxt->event_flags);
 			wake_up(&fd->uctxt->wait);
@@ -945,7 +957,7 @@ static int find_sub_ctxt(struct hfi1_filedata *fd,
 		subctxt = find_first_zero_bit(uctxt->in_use_ctxts,
 					      HFI1_MAX_SHARED_CTXTS);
 		if (subctxt >= uctxt->subctxt_cnt)
-			return -EINVAL;
+			return -EBUSY;
 
 		fd->uctxt = uctxt;
 		fd->subctxt = subctxt;
@@ -1118,7 +1130,7 @@ static int setup_subctxt(struct hfi1_ctxtdata *uctxt)
 	return ret;
 }
 
-static int user_init(struct hfi1_ctxtdata *uctxt)
+static void user_init(struct hfi1_ctxtdata *uctxt)
 {
 	unsigned int rcvctrl_ops = 0;
 
@@ -1168,8 +1180,6 @@ static int user_init(struct hfi1_ctxtdata *uctxt)
 	else
 		rcvctrl_ops |= HFI1_RCVCTRL_TAILUPD_DIS;
 	hfi1_rcvctrl(uctxt->dd, rcvctrl_ops, uctxt->ctxt);
-
-	return 0;
 }
 
 static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
@@ -1238,28 +1248,32 @@ static int setup_base_ctxt(struct hfi1_filedata *fd)
 	/* Now allocate the RcvHdr queue and eager buffers. */
 	ret = hfi1_create_rcvhdrq(dd, uctxt);
 	if (ret)
-		goto done;
+		return ret;
 
 	ret = hfi1_setup_eagerbufs(uctxt);
 	if (ret)
-		goto done;
+		goto setup_failed;
 
 	/* If sub-contexts are enabled, do the appropriate setup */
 	if (uctxt->subctxt_cnt)
 		ret = setup_subctxt(uctxt);
 	if (ret)
-		goto done;
+		goto setup_failed;
 
 	ret = hfi1_user_exp_rcv_grp_init(fd);
 	if (ret)
-		goto done;
+		goto setup_failed;
 
 	ret = init_user_ctxt(fd);
 	if (ret)
-		goto done;
+		goto setup_failed;
 
-	ret = user_init(uctxt);
-done:
+	user_init(uctxt);
+
+	return 0;
+
+setup_failed:
+	hfi1_free_ctxtdata(dd, uctxt);
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index f3d75fc..509df98 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -196,12 +196,6 @@ struct hfi1_ctxtdata {
 	void *rcvhdrq;
 	/* kernel virtual address where hdrqtail is updated */
 	volatile __le64 *rcvhdrtail_kvaddr;
-	/*
-	 * Shared page for kernel to signal user processes that send buffers
-	 * need disarming.  The process should call HFI1_CMD_DISARM_BUFS
-	 * or HFI1_CMD_ACK_EVENT with IPATH_EVENT_DISARM_BUFS set.
-	 */
-	unsigned long *user_event_mask;
 	/* when waiting for rcv or pioavail */
 	wait_queue_head_t wait;
 	/* rcvhdrq size (for freeing) */
@@ -1724,12 +1718,14 @@ struct cc_state *get_cc_state_protected(struct hfi1_pportdata *ppd)
 #define HFI1_PBC_LENGTH_MASK                     ((1 << 11) - 1)
 
 /* ctxt_flag bit offsets */
+		/* base context has not finished initializing */
+#define HFI1_CTXT_BASE_UNINIT 1
+		/* base context initaliation failed */
+#define HFI1_CTXT_BASE_FAILED 2
 		/* waiting for a packet to arrive */
-#define HFI1_CTXT_WAITING_RCV   2
-		/* master has not finished initializing */
-#define HFI1_CTXT_BASE_UNINIT 4
+#define HFI1_CTXT_WAITING_RCV 3
 		/* waiting for an urgent packet to arrive */
-#define HFI1_CTXT_WAITING_URG 5
+#define HFI1_CTXT_WAITING_URG 4
 
 /* free up any allocated data at closes */
 struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 694a8ec..4a11d4d 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -964,7 +964,6 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	kfree(rcd->egrbufs.buffers);
 
 	sc_free(rcd->sc);
-	vfree(rcd->user_event_mask);
 	vfree(rcd->subctxt_uregbase);
 	vfree(rcd->subctxt_rcvegrbuf);
 	vfree(rcd->subctxt_rcvhdr_base);
@@ -1683,8 +1682,6 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	dd_dev_err(dd,
 		   "attempt to allocate 1 page for ctxt %u rcvhdrqtailaddr failed\n",
 		   rcd->ctxt);
-	vfree(rcd->user_event_mask);
-	rcd->user_event_mask = NULL;
 	dma_free_coherent(&dd->pcidev->dev, amt, rcd->rcvhdrq,
 			  rcd->rcvhdrq_dma);
 	rcd->rcvhdrq = NULL;
@@ -1851,7 +1848,7 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 			  "ctxt%u: current Eager buffer size is invalid %u\n",
 			  rcd->ctxt, rcd->egrbufs.rcvtid_size);
 		ret = -EINVAL;
-		goto bail;
+		goto bail_rcvegrbuf_phys;
 	}
 
 	for (idx = 0; idx < rcd->egrbufs.alloced; idx++) {
@@ -1859,7 +1856,8 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 			     rcd->egrbufs.rcvtids[idx].dma, order);
 		cond_resched();
 	}
-	goto bail;
+
+	return 0;
 
 bail_rcvegrbuf_phys:
 	for (idx = 0; idx < rcd->egrbufs.alloced &&
@@ -1873,6 +1871,6 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 		rcd->egrbufs.buffers[idx].dma = 0;
 		rcd->egrbufs.buffers[idx].len = 0;
 	}
-bail:
+
 	return ret;
 }
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 4c66f8d..a8f0aa4 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -160,6 +160,7 @@ int hfi1_user_exp_rcv_grp_init(struct hfi1_filedata *fd)
 	struct hfi1_devdata *dd = fd->dd;
 	u32 tidbase;
 	u32 i;
+	struct tid_group *grp, *gptr;
 
 	exp_tid_group_init(&uctxt->tid_group_list);
 	exp_tid_group_init(&uctxt->tid_used_list);
@@ -168,17 +169,10 @@ int hfi1_user_exp_rcv_grp_init(struct hfi1_filedata *fd)
 	tidbase = uctxt->expected_base;
 	for (i = 0; i < uctxt->expected_count /
 		     dd->rcv_entries.group_size; i++) {
-		struct tid_group *grp;
-
 		grp = kzalloc(sizeof(*grp), GFP_KERNEL);
-		if (!grp) {
-			/*
-			 * If we fail here, the groups already
-			 * allocated will be freed by the close
-			 * call.
-			 */
-			return -ENOMEM;
-		}
+		if (!grp)
+			goto grp_failed;
+
 		grp->size = dd->rcv_entries.group_size;
 		grp->base = tidbase;
 		tid_group_add_tail(grp, &uctxt->tid_group_list);
@@ -186,6 +180,15 @@ int hfi1_user_exp_rcv_grp_init(struct hfi1_filedata *fd)
 	}
 
 	return 0;
+
+grp_failed:
+	list_for_each_entry_safe(grp, gptr, &uctxt->tid_group_list.list,
+				 list) {
+		list_del_init(&grp->list);
+		kfree(grp);
+	}
+
+	return -ENOMEM;
 }
 
 /*
@@ -213,11 +216,11 @@ int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd)
 		fd->invalid_tids = kcalloc(uctxt->expected_count,
 					   sizeof(*fd->invalid_tids),
 					   GFP_KERNEL);
-		/*
-		 * NOTE: If this is an error, shouldn't we cleanup enry_to_rb?
-		 */
-		if (!fd->invalid_tids)
+		if (!fd->invalid_tids) {
+			kfree(fd->entry_to_rb);
+			fd->entry_to_rb = NULL;
 			return -ENOMEM;
+		}
 
 		/*
 		 * Register MMU notifier callbacks. If the registration
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 6b72267..d55339f 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -374,40 +374,24 @@ static void sdma_kmem_cache_ctor(void *obj)
 int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 				struct hfi1_filedata *fd)
 {
-	int ret = 0;
+	int ret = -ENOMEM;
 	char buf[64];
 	struct hfi1_devdata *dd;
 	struct hfi1_user_sdma_comp_q *cq;
 	struct hfi1_user_sdma_pkt_q *pq;
 	unsigned long flags;
 
-	if (!uctxt || !fd) {
-		ret = -EBADF;
-		goto done;
-	}
+	if (!uctxt || !fd)
+		return -EBADF;
 
-	if (!hfi1_sdma_comp_ring_size) {
-		ret = -EINVAL;
-		goto done;
-	}
+	if (!hfi1_sdma_comp_ring_size)
+		return -EINVAL;
 
 	dd = uctxt->dd;
 
 	pq = kzalloc(sizeof(*pq), GFP_KERNEL);
 	if (!pq)
-		goto pq_nomem;
-
-	pq->reqs = kcalloc(hfi1_sdma_comp_ring_size,
-			   sizeof(*pq->reqs),
-			   GFP_KERNEL);
-	if (!pq->reqs)
-		goto pq_reqs_nomem;
-
-	pq->req_in_use = kcalloc(BITS_TO_LONGS(hfi1_sdma_comp_ring_size),
-				 sizeof(*pq->req_in_use),
-				 GFP_KERNEL);
-	if (!pq->req_in_use)
-		goto pq_reqs_no_in_use;
+		return -ENOMEM;
 
 	INIT_LIST_HEAD(&pq->list);
 	pq->dd = dd;
@@ -423,10 +407,23 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 	iowait_init(&pq->busy, 0, NULL, defer_packet_queue,
 		    activate_packet_queue, NULL);
 	pq->reqidx = 0;
+
+	pq->reqs = kcalloc(hfi1_sdma_comp_ring_size,
+			   sizeof(*pq->reqs),
+			   GFP_KERNEL);
+	if (!pq->reqs)
+		goto pq_reqs_nomem;
+
+	pq->req_in_use = kcalloc(BITS_TO_LONGS(hfi1_sdma_comp_ring_size),
+				 sizeof(*pq->req_in_use),
+				 GFP_KERNEL);
+	if (!pq->req_in_use)
+		goto pq_reqs_no_in_use;
+
 	snprintf(buf, 64, "txreq-kmem-cache-%u-%u-%u", dd->unit, uctxt->ctxt,
 		 fd->subctxt);
 	pq->txreq_cache = kmem_cache_create(buf,
-			       sizeof(struct user_sdma_txreq),
+					    sizeof(struct user_sdma_txreq),
 					    L1_CACHE_BYTES,
 					    SLAB_HWCACHE_ALIGN,
 					    sdma_kmem_cache_ctor);
@@ -435,7 +432,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 			   uctxt->ctxt);
 		goto pq_txreq_nomem;
 	}
-	fd->pq = pq;
+
 	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
 	if (!cq)
 		goto cq_nomem;
@@ -446,20 +443,25 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 		goto cq_comps_nomem;
 
 	cq->nentries = hfi1_sdma_comp_ring_size;
-	fd->cq = cq;
 
 	ret = hfi1_mmu_rb_register(pq, pq->mm, &sdma_rb_ops, dd->pport->hfi1_wq,
 				   &pq->handler);
 	if (ret) {
 		dd_dev_err(dd, "Failed to register with MMU %d", ret);
-		goto done;
+		goto pq_mmu_fail;
 	}
 
+	fd->pq = pq;
+	fd->cq = cq;
+
 	spin_lock_irqsave(&uctxt->sdma_qlock, flags);
 	list_add(&pq->list, &uctxt->sdma_queues);
 	spin_unlock_irqrestore(&uctxt->sdma_qlock, flags);
-	goto done;
 
+	return 0;
+
+pq_mmu_fail:
+	vfree(cq->comps);
 cq_comps_nomem:
 	kfree(cq);
 cq_nomem:
@@ -470,10 +472,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 	kfree(pq->reqs);
 pq_reqs_nomem:
 	kfree(pq);
-	fd->pq = NULL;
-pq_nomem:
-	ret = -ENOMEM;
-done:
+
 	return ret;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
