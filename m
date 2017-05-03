From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/15] IB/hfi1: Clean up context initialization
Date: Tue, 02 May 2017 17:42:18 -0700
Message-ID: <20170503004217.6965.53739.stgit@scvm10.sc.intel.com>
References: <20170503003734.6965.67405.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170503003734.6965.67405.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Context initialization mixes base context init with sub context init.
This is bad because contexts can be reused, and on reuse, reinit things
that should not re-initialized.

Normalize comments and function names to refer to base context and
sub context (not main, shared or slaves).

Separate the base context initialization from sub context initialization.

hfi1_init_ctxt() cannot return an error so changed to a void and remove
error message.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c         |    3 
 drivers/infiniband/hw/hfi1/chip.h         |    2 
 drivers/infiniband/hw/hfi1/file_ops.c     |  179 +++++++++++++++--------------
 drivers/infiniband/hw/hfi1/hfi.h          |   13 +-
 drivers/infiniband/hw/hfi1/init.c         |   10 --
 drivers/infiniband/hw/hfi1/trace_ctxts.h  |   17 ++-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   83 +++++++------
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |    3 
 8 files changed, 156 insertions(+), 154 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 9f72d55..972da41 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -12662,7 +12662,7 @@ u8 hfi1_ibphys_portstate(struct hfi1_pportdata *ppd)
 #define SET_STATIC_RATE_CONTROL_SMASK(r) \
 (r |= SEND_CTXT_CHECK_ENABLE_DISALLOW_PBC_STATIC_RATE_CONTROL_SMASK)
 
-int hfi1_init_ctxt(struct send_context *sc)
+void hfi1_init_ctxt(struct send_context *sc)
 {
 	if (sc) {
 		struct hfi1_devdata *dd = sc->dd;
@@ -12679,7 +12679,6 @@ int hfi1_init_ctxt(struct send_context *sc)
 		write_kctxt_csr(dd, sc->hw_context,
 				SEND_CTXT_CHECK_ENABLE, reg);
 	}
-	return 0;
 }
 
 int hfi1_tempsense_rd(struct hfi1_devdata *dd, struct hfi1_temp *temp)
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 760aa2e..cbe455d 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -1349,7 +1349,7 @@ enum {
 void hfi1_clear_tids(struct hfi1_ctxtdata *rcd);
 struct ib_header *hfi1_get_msgheader(
 				struct hfi1_devdata *dd, __le32 *rhf_addr);
-int hfi1_init_ctxt(struct send_context *sc);
+void hfi1_init_ctxt(struct send_context *sc);
 void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
 		  u32 type, unsigned long pa, u16 order);
 void hfi1_quiet_serdes(struct hfi1_pportdata *ppd);
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 74c03e8..d748e65 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -80,16 +80,17 @@
 static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo);
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 			 const struct hfi1_user_info *uinfo);
-static int user_init(struct hfi1_filedata *fd);
+static int init_user_ctxt(struct hfi1_filedata *fd);
+static int user_init(struct hfi1_ctxtdata *uctxt);
 static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
 			 __u32 len);
 static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
 			 __u32 len);
-static int setup_ctxt(struct hfi1_filedata *fd);
+static int setup_base_ctxt(struct hfi1_filedata *fd);
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt);
 
-static int find_shared_ctxt(struct hfi1_filedata *fd,
-			    const struct hfi1_user_info *uinfo);
+static int find_sub_ctxt(struct hfi1_filedata *fd,
+			 const struct hfi1_user_info *uinfo);
 static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 			 struct hfi1_user_info *uinfo);
 static unsigned int poll_urgent(struct file *fp, struct poll_table_struct *pt);
@@ -241,12 +242,6 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 			return -EFAULT;
 
 		ret = assign_ctxt(fd, &uinfo);
-		if (ret < 0)
-			return ret;
-		ret = setup_ctxt(fd);
-		if (ret)
-			return ret;
-		ret = user_init(fd);
 		break;
 	case HFI1_IOCTL_CTXT_INFO:
 		ret = get_ctxt_info(fd, (void __user *)(unsigned long)arg,
@@ -856,40 +851,62 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 	unsigned int swmajor, swminor;
 
 	swmajor = uinfo->userversion >> 16;
-	if (swmajor != HFI1_USER_SWMAJOR) {
-		ret = -ENODEV;
-		goto done;
-	}
+	if (swmajor != HFI1_USER_SWMAJOR)
+		return -ENODEV;
 
 	swminor = uinfo->userversion & 0xffff;
 
 	mutex_lock(&hfi1_mutex);
-	/* First, lets check if we need to setup a shared context? */
+	/* First, lets check if we need to get a sub context? */
 	if (uinfo->subctxt_cnt) {
-		ret = find_shared_ctxt(fd, uinfo);
-		if (ret < 0)
-			goto done_unlock;
-		if (ret) {
+		/* < 0 error, 0 no context, 1 sub-context found */
+		ret = find_sub_ctxt(fd, uinfo);
+		if (ret > 0) {
 			fd->rec_cpu_num =
 				hfi1_get_proc_affinity(fd->uctxt->numa_id);
 		}
 	}
 
 	/*
-	 * We execute the following block if we couldn't find a
-	 * shared context or if context sharing is not required.
+	 * Allocate a base context f context sharing is not required or we
+	 * couldn't find a sub context.
 	 */
 	if (!ret)
 		ret = allocate_ctxt(fd, fd->dd, uinfo);
 
-done_unlock:
 	mutex_unlock(&hfi1_mutex);
-done:
+
+	/* Depending on the context type, do the appropriate init */
+	if (ret > 0) {
+		/*
+		 * sub-context info can only be set up after the base
+		 * context has been completed.
+		 */
+		ret = wait_event_interruptible(fd->uctxt->wait, !test_bit(
+					       HFI1_CTXT_BASE_UNINIT,
+					       &fd->uctxt->event_flags));
+		/* The only thing a sub context needs is the user_xxx stuff */
+		if (!ret)
+			init_user_ctxt(fd);
+	} else if (!ret) {
+		ret = setup_base_ctxt(fd);
+
+		/*
+		 * Base context is done, notify anybody using a sub-context
+		 * that is waiting for this completion
+		 */
+		if (!ret && fd->uctxt->subctxt_cnt) {
+			clear_bit(HFI1_CTXT_BASE_UNINIT,
+				  &fd->uctxt->event_flags);
+			wake_up(&fd->uctxt->wait);
+		}
+	}
+
 	return ret;
 }
 
-static int find_shared_ctxt(struct hfi1_filedata *fd,
-			    const struct hfi1_user_info *uinfo)
+static int find_sub_ctxt(struct hfi1_filedata *fd,
+			 const struct hfi1_user_info *uinfo)
 {
 	int i;
 	struct hfi1_devdata *dd = fd->dd;
@@ -1030,12 +1047,12 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 		goto ctxdata_free;
 
 	/*
-	 * Setup shared context resources if the user-level has requested
-	 * shared contexts and this is the 'master' process.
+	 * Setup sub context resources if the user-level has requested
+	 * sub contexts.
 	 * This has to be done here so the rest of the sub-contexts find the
 	 * proper master.
 	 */
-	if (uinfo->subctxt_cnt && !fd->subctxt) {
+	if (uinfo->subctxt_cnt) {
 		ret = init_subctxts(uctxt, uinfo);
 		/*
 		 * On error, we don't need to disable and de-allocate the
@@ -1082,7 +1099,7 @@ static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 	uctxt->subctxt_id = uinfo->subctxt_id;
 	uctxt->active_slaves = 1;
 	uctxt->redirect_seq_cnt = 1;
-	set_bit(HFI1_CTXT_MASTER_UNINIT, &uctxt->event_flags);
+	set_bit(HFI1_CTXT_BASE_UNINIT, &uctxt->event_flags);
 
 	return 0;
 }
@@ -1093,10 +1110,9 @@ static int setup_subctxt(struct hfi1_ctxtdata *uctxt)
 	unsigned num_subctxts = uctxt->subctxt_cnt;
 
 	uctxt->subctxt_uregbase = vmalloc_user(PAGE_SIZE);
-	if (!uctxt->subctxt_uregbase) {
-		ret = -ENOMEM;
-		goto bail;
-	}
+	if (!uctxt->subctxt_uregbase)
+		return -ENOMEM;
+
 	/* We can take the size of the RcvHdr Queue from the master */
 	uctxt->subctxt_rcvhdr_base = vmalloc_user(uctxt->rcvhdrq_size *
 						  num_subctxts);
@@ -1111,24 +1127,22 @@ static int setup_subctxt(struct hfi1_ctxtdata *uctxt)
 		ret = -ENOMEM;
 		goto bail_rhdr;
 	}
-	goto bail;
+
+	return 0;
+
 bail_rhdr:
 	vfree(uctxt->subctxt_rcvhdr_base);
+	uctxt->subctxt_rcvhdr_base = NULL;
 bail_ureg:
 	vfree(uctxt->subctxt_uregbase);
 	uctxt->subctxt_uregbase = NULL;
-bail:
+
 	return ret;
 }
 
-static int user_init(struct hfi1_filedata *fd)
+static int user_init(struct hfi1_ctxtdata *uctxt)
 {
 	unsigned int rcvctrl_ops = 0;
-	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-
-	/* make sure that the context has already been setup */
-	if (!test_bit(HFI1_CTXT_SETUP_DONE, &uctxt->event_flags))
-		return -EFAULT;
 
 	/* initialize poll variables... */
 	uctxt->urgent = 0;
@@ -1177,12 +1191,6 @@ static int user_init(struct hfi1_filedata *fd)
 		rcvctrl_ops |= HFI1_RCVCTRL_TAILUPD_DIS;
 	hfi1_rcvctrl(uctxt->dd, rcvctrl_ops, uctxt->ctxt);
 
-	/* Notify any waiting slaves */
-	if (uctxt->subctxt_cnt) {
-		clear_bit(HFI1_CTXT_MASTER_UNINIT, &uctxt->event_flags);
-		wake_up(&uctxt->wait);
-	}
-
 	return 0;
 }
 
@@ -1227,59 +1235,52 @@ static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
 	return ret;
 }
 
-static int setup_ctxt(struct hfi1_filedata *fd)
+static int init_user_ctxt(struct hfi1_filedata *fd)
+{
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	int ret;
+
+	ret = hfi1_user_sdma_alloc_queues(uctxt, fd);
+	if (ret)
+		return ret;
+
+	ret = hfi1_user_exp_rcv_init(fd);
+
+	return ret;
+}
+
+static int setup_base_ctxt(struct hfi1_filedata *fd)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	int ret = 0;
 
-	/*
-	 * Context should be set up only once, including allocation and
-	 * programming of eager buffers. This is done if context sharing
-	 * is not requested or by the master process.
-	 */
-	if (!uctxt->subctxt_cnt || !fd->subctxt) {
-		ret = hfi1_init_ctxt(uctxt->sc);
-		if (ret)
-			goto done;
+	hfi1_init_ctxt(uctxt->sc);
 
-		/* Now allocate the RcvHdr queue and eager buffers. */
-		ret = hfi1_create_rcvhdrq(dd, uctxt);
-		if (ret)
-			goto done;
-		ret = hfi1_setup_eagerbufs(uctxt);
-		if (ret)
-			goto done;
-		if (uctxt->subctxt_cnt && !fd->subctxt) {
-			ret = setup_subctxt(uctxt);
-			if (ret)
-				goto done;
-		}
-	} else {
-		ret = wait_event_interruptible(uctxt->wait, !test_bit(
-					       HFI1_CTXT_MASTER_UNINIT,
-					       &uctxt->event_flags));
-		if (ret)
-			goto done;
-	}
+	/* Now allocate the RcvHdr queue and eager buffers. */
+	ret = hfi1_create_rcvhdrq(dd, uctxt);
+	if (ret)
+		goto done;
 
-	ret = hfi1_user_sdma_alloc_queues(uctxt, fd);
+	ret = hfi1_setup_eagerbufs(uctxt);
 	if (ret)
 		goto done;
-	/*
-	 * Expected receive has to be setup for all processes (including
-	 * shared contexts). However, it has to be done after the master
-	 * context has been fully configured as it depends on the
-	 * eager/expected split of the RcvArray entries.
-	 * Setting it up here ensures that the subcontexts will be waiting
-	 * (due to the above wait_event_interruptible() until the master
-	 * is setup.
-	 */
-	ret = hfi1_user_exp_rcv_init(fd);
+
+	/* If sub-contexts are enabled, do the appropriate setup */
+	if (uctxt->subctxt_cnt)
+		ret = setup_subctxt(uctxt);
+	if (ret)
+		goto done;
+
+	ret = hfi1_user_exp_rcv_grp_init(fd);
+	if (ret)
+		goto done;
+
+	ret = init_user_ctxt(fd);
 	if (ret)
 		goto done;
 
-	set_bit(HFI1_CTXT_SETUP_DONE, &uctxt->event_flags);
+	ret = user_init(uctxt);
 done:
 	return ret;
 }
@@ -1294,7 +1295,7 @@ static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
 	unsigned offset;
 	int ret = 0;
 
-	trace_hfi1_uctxtdata(uctxt->dd, uctxt);
+	trace_hfi1_uctxtdata(uctxt->dd, uctxt, fd->subctxt);
 
 	memset(&binfo, 0, sizeof(binfo));
 	binfo.hw_version = dd->revision;
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index e0c4c5e..1b7203a 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -224,13 +224,12 @@ struct hfi1_ctxtdata {
 	 * (ignoring forks, dup, etc. for now)
 	 */
 	int cnt;
+	/* Device context index */
+	unsigned ctxt;
 	/*
-	 * how much space to leave at start of eager TID entries for
-	 * protocol use, on each TID
+	 * non-zero if ctxt can be shared, and defines the maximum number of
+	 * sub contexts allowed.
 	 */
-	/* instead of calculating it */
-	unsigned ctxt;
-	/* non-zero if ctxt is being shared. */
 	u16 subctxt_cnt;
 	/* non-zero if ctxt is being shared. */
 	u16 subctxt_id;
@@ -1725,12 +1724,10 @@ struct cc_state *get_cc_state_protected(struct hfi1_pportdata *ppd)
 #define HFI1_PBC_LENGTH_MASK                     ((1 << 11) - 1)
 
 /* ctxt_flag bit offsets */
-		/* context has been setup */
-#define HFI1_CTXT_SETUP_DONE 1
 		/* waiting for a packet to arrive */
 #define HFI1_CTXT_WAITING_RCV   2
 		/* master has not finished initializing */
-#define HFI1_CTXT_MASTER_UNINIT 4
+#define HFI1_CTXT_BASE_UNINIT 4
 		/* waiting for an urgent packet to arrive */
 #define HFI1_CTXT_WAITING_URG 5
 
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index e872644..52a6364 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -176,13 +176,7 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 			goto nomem;
 		}
 
-		ret = hfi1_init_ctxt(rcd->sc);
-		if (ret < 0) {
-			dd_dev_err(dd,
-				   "Failed to setup kernel receive context, failing\n");
-			ret = -EFAULT;
-			goto bail;
-		}
+		hfi1_init_ctxt(rcd->sc);
 	}
 
 	/*
@@ -194,7 +188,7 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 	return 0;
 nomem:
 	ret = -ENOMEM;
-bail:
+
 	if (dd->rcd) {
 		for (i = 0; i < dd->num_rcv_contexts; ++i)
 			hfi1_free_ctxtdata(dd, dd->rcd[i]);
diff --git a/drivers/infiniband/hw/hfi1/trace_ctxts.h b/drivers/infiniband/hw/hfi1/trace_ctxts.h
index 26ae789..4eb4cc7 100644
--- a/drivers/infiniband/hw/hfi1/trace_ctxts.h
+++ b/drivers/infiniband/hw/hfi1/trace_ctxts.h
@@ -57,12 +57,14 @@
 
 #define UCTXT_FMT \
 	"cred:%u, credaddr:0x%llx, piobase:0x%p, rcvhdr_cnt:%u, "	\
-	"rcvbase:0x%llx, rcvegrc:%u, rcvegrb:0x%llx"
+	"rcvbase:0x%llx, rcvegrc:%u, rcvegrb:0x%llx, subctxt_cnt:%u"
 TRACE_EVENT(hfi1_uctxtdata,
-	    TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ctxtdata *uctxt),
-	    TP_ARGS(dd, uctxt),
+	    TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ctxtdata *uctxt,
+		     unsigned int subctxt),
+	    TP_ARGS(dd, uctxt, subctxt),
 	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
 			     __field(unsigned int, ctxt)
+			     __field(unsigned int, subctxt)
 			     __field(u32, credits)
 			     __field(u64, hw_free)
 			     __field(void __iomem *, piobase)
@@ -70,9 +72,11 @@
 			     __field(u64, rcvhdrq_dma)
 			     __field(u32, eager_cnt)
 			     __field(u64, rcvegr_dma)
+			     __field(unsigned int, subctxt_cnt)
 			     ),
 	    TP_fast_assign(DD_DEV_ASSIGN(dd);
 			   __entry->ctxt = uctxt->ctxt;
+			   __entry->subctxt = subctxt;
 			   __entry->credits = uctxt->sc->credits;
 			   __entry->hw_free = le64_to_cpu(*uctxt->sc->hw_free);
 			   __entry->piobase = uctxt->sc->base_addr;
@@ -80,17 +84,20 @@
 			   __entry->rcvhdrq_dma = uctxt->rcvhdrq_dma;
 			   __entry->eager_cnt = uctxt->egrbufs.alloced;
 			   __entry->rcvegr_dma = uctxt->egrbufs.rcvtids[0].dma;
+			   __entry->subctxt_cnt = uctxt->subctxt_cnt;
 			   ),
-	    TP_printk("[%s] ctxt %u " UCTXT_FMT,
+	    TP_printk("[%s] ctxt %u:%u " UCTXT_FMT,
 		      __get_str(dev),
 		      __entry->ctxt,
+		      __entry->subctxt,
 		      __entry->credits,
 		      __entry->hw_free,
 		      __entry->piobase,
 		      __entry->rcvhdrq_cnt,
 		      __entry->rcvhdrq_dma,
 		      __entry->eager_cnt,
-		      __entry->rcvegr_dma
+		      __entry->rcvegr_dma,
+		      __entry->subctxt_cnt
 		      )
 );
 
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 22ffda8..bfaf159 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -53,7 +53,7 @@
 
 struct tid_group {
 	struct list_head list;
-	unsigned base;
+	u32 base;
 	u8 size;
 	u8 used;
 	u8 map;
@@ -154,6 +154,40 @@ static inline void tid_group_move(struct tid_group *group,
 	tid_group_add_tail(group, s2);
 }
 
+int hfi1_user_exp_rcv_grp_init(struct hfi1_filedata *fd)
+{
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct hfi1_devdata *dd = fd->dd;
+	u32 tidbase;
+	u32 i;
+
+	exp_tid_group_init(&uctxt->tid_group_list);
+	exp_tid_group_init(&uctxt->tid_used_list);
+	exp_tid_group_init(&uctxt->tid_full_list);
+
+	tidbase = uctxt->expected_base;
+	for (i = 0; i < uctxt->expected_count /
+		     dd->rcv_entries.group_size; i++) {
+		struct tid_group *grp;
+
+		grp = kzalloc(sizeof(*grp), GFP_KERNEL);
+		if (!grp) {
+			/*
+			 * If we fail here, the groups already
+			 * allocated will be freed by the close
+			 * call.
+			 */
+			return -ENOMEM;
+		}
+		grp->size = dd->rcv_entries.group_size;
+		grp->base = tidbase;
+		tid_group_add_tail(grp, &uctxt->tid_group_list);
+		tidbase += dd->rcv_entries.group_size;
+	}
+
+	return 0;
+}
+
 /*
  * Initialize context and file private data needed for Expected
  * receive caching. This needs to be done after the context has
@@ -163,54 +197,24 @@ int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned tidbase;
-	int i, ret = 0;
+	int ret = 0;
 
 	spin_lock_init(&fd->tid_lock);
 	spin_lock_init(&fd->invalid_lock);
 
-	if (!uctxt->subctxt_cnt || !fd->subctxt) {
-		exp_tid_group_init(&uctxt->tid_group_list);
-		exp_tid_group_init(&uctxt->tid_used_list);
-		exp_tid_group_init(&uctxt->tid_full_list);
-
-		tidbase = uctxt->expected_base;
-		for (i = 0; i < uctxt->expected_count /
-			     dd->rcv_entries.group_size; i++) {
-			struct tid_group *grp;
-
-			grp = kzalloc(sizeof(*grp), GFP_KERNEL);
-			if (!grp) {
-				/*
-				 * If we fail here, the groups already
-				 * allocated will be freed by the close
-				 * call.
-				 */
-				ret = -ENOMEM;
-				goto done;
-			}
-			grp->size = dd->rcv_entries.group_size;
-			grp->base = tidbase;
-			tid_group_add_tail(grp, &uctxt->tid_group_list);
-			tidbase += dd->rcv_entries.group_size;
-		}
-	}
-
 	fd->entry_to_rb = kcalloc(uctxt->expected_count,
-				     sizeof(struct rb_node *),
-				     GFP_KERNEL);
+				  sizeof(struct rb_node *),
+				  GFP_KERNEL);
 	if (!fd->entry_to_rb)
 		return -ENOMEM;
 
 	if (!HFI1_CAP_UGET_MASK(uctxt->flags, TID_UNMAP)) {
 		fd->invalid_tid_idx = 0;
 		fd->invalid_tids = kcalloc(uctxt->expected_count,
-					   sizeof(*fd->invalid_tids),
+					   sizeof(u32),
 					   GFP_KERNEL);
-		if (!fd->invalid_tids) {
-			ret = -ENOMEM;
-			goto done;
-		}
+		if (!fd->invalid_tids)
+			return -ENOMEM;
 
 		/*
 		 * Register MMU notifier callbacks. If the registration
@@ -252,7 +256,7 @@ int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd)
 		fd->tid_limit = uctxt->expected_count;
 	}
 	spin_unlock(&fd->tid_lock);
-done:
+
 	return ret;
 }
 
@@ -268,7 +272,7 @@ void hfi1_user_exp_rcv_grp_free(struct hfi1_ctxtdata *uctxt)
 	hfi1_clear_tids(uctxt);
 }
 
-int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
+void hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 
@@ -290,7 +294,6 @@ int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 
 	kfree(fd->entry_to_rb);
 	fd->entry_to_rb = NULL;
-	return 0;
 }
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index 9787511..5250c89 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -71,8 +71,9 @@
 	} while (0)
 
 void hfi1_user_exp_rcv_grp_free(struct hfi1_ctxtdata *uctxt);
+int hfi1_user_exp_rcv_grp_init(struct hfi1_filedata *fd);
 int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd);
-int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd);
+void hfi1_user_exp_rcv_free(struct hfi1_filedata *fd);
 int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 			    struct hfi1_tid_info *tinfo);
 int hfi1_user_exp_rcv_clear(struct hfi1_filedata *fd,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
