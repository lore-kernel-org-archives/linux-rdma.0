From: ira.weiny@intel.com
Subject: [PATCH 1/9] staging/rdma/hfi1: Remove file pointer macros
Date: Fri, 30 Oct 2015 18:41:50 -0400
Message-ID: <1446244918-12089-2-git-send-email-ira.weiny@intel.com>
References: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, dennis.dalessandro@intel.com
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Remove the following macros in favor of explicit use of struct hfi1_filedata and
various sub structures.

ctxt_fp
subctxt_fp
tidcursor_fp
user_sdma_pkt_fp
user_sdma_comp_fp

Reviewed-by: Mitko Haralanov <mitko.haralanov@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/file_ops.c  | 124 ++++++++++++++++++----------------
 drivers/staging/rdma/hfi1/hfi.h       |  12 ----
 drivers/staging/rdma/hfi1/user_sdma.c |  34 ++++++----
 3 files changed, 84 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index aae9826ec62b..f78bcf673252 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -204,7 +204,8 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 			       size_t count, loff_t *offset)
 {
 	const struct hfi1_cmd __user *ucmd;
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_cmd cmd;
 	struct hfi1_user_info uinfo;
 	struct hfi1_tid_info tinfo;
@@ -338,17 +339,17 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 		ret = exp_tid_free(fp, &tinfo);
 		break;
 	case HFI1_CMD_RECV_CTRL:
-		ret = manage_rcvq(uctxt, subctxt_fp(fp), (int)user_val);
+		ret = manage_rcvq(uctxt, fd->subctxt, (int)user_val);
 		break;
 	case HFI1_CMD_POLL_TYPE:
 		uctxt->poll_type = (typeof(uctxt->poll_type))user_val;
 		break;
 	case HFI1_CMD_ACK_EVENT:
-		ret = user_event_ack(uctxt, subctxt_fp(fp), user_val);
+		ret = user_event_ack(uctxt, fd->subctxt, user_val);
 		break;
 	case HFI1_CMD_SET_PKEY:
 		if (HFI1_CAP_IS_USET(PKEY_CHECK))
-			ret = set_ctxt_pkey(uctxt, subctxt_fp(fp), user_val);
+			ret = set_ctxt_pkey(uctxt, fd->subctxt, user_val);
 		else
 			ret = -EPERM;
 		break;
@@ -431,13 +432,13 @@ bail:
 
 static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 {
-	struct hfi1_user_sdma_pkt_q *pq;
-	struct hfi1_user_sdma_comp_q *cq;
+	struct hfi1_filedata *fd = kiocb->ki_filp->private_data;
+	struct hfi1_user_sdma_pkt_q *pq = fd->pq;
+	struct hfi1_user_sdma_comp_q *cq = fd->cq;
 	int ret = 0, done = 0, reqs = 0;
 	unsigned long dim = from->nr_segs;
 
-	if (!user_sdma_comp_fp(kiocb->ki_filp) ||
-	    !user_sdma_pkt_fp(kiocb->ki_filp)) {
+	if (!cq || !pq) {
 		ret = -EIO;
 		goto done;
 	}
@@ -448,10 +449,7 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	}
 
 	hfi1_cdbg(SDMA, "SDMA request from %u:%u (%lu)",
-		  ctxt_fp(kiocb->ki_filp)->ctxt, subctxt_fp(kiocb->ki_filp),
-		  dim);
-	pq = user_sdma_pkt_fp(kiocb->ki_filp);
-	cq = user_sdma_comp_fp(kiocb->ki_filp);
+		  fd->uctxt->ctxt, fd->subctxt, dim);
 
 	if (atomic_read(&pq->n_reqs) == pq->n_max_reqs) {
 		ret = -ENOSPC;
@@ -476,7 +474,8 @@ done:
 
 static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 {
-	struct hfi1_ctxtdata *uctxt;
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd;
 	unsigned long flags, pfn;
 	u64 token = vma->vm_pgoff << PAGE_SHIFT,
@@ -486,7 +485,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	int ret = 0;
 	u16 ctxt;
 
-	uctxt = ctxt_fp(fp);
 	if (!is_valid_mmap(token) || !uctxt ||
 	    !(vma->vm_flags & VM_SHARED)) {
 		ret = -EINVAL;
@@ -496,7 +494,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	ctxt = HFI1_MMAP_TOKEN_GET(CTXT, token);
 	subctxt = HFI1_MMAP_TOKEN_GET(SUBCTXT, token);
 	type = HFI1_MMAP_TOKEN_GET(TYPE, token);
-	if (ctxt != uctxt->ctxt || subctxt != subctxt_fp(fp)) {
+	if (ctxt != uctxt->ctxt || subctxt != fd->subctxt) {
 		ret = -EINVAL;
 		goto done;
 	}
@@ -660,13 +658,12 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		vmf = 1;
 		break;
 	case SDMA_COMP: {
-		struct hfi1_user_sdma_comp_q *cq;
+		struct hfi1_user_sdma_comp_q *cq = fd->cq;
 
-		if (!user_sdma_comp_fp(fp)) {
+		if (!cq) {
 			ret = -EFAULT;
 			goto done;
 		}
-		cq = user_sdma_comp_fp(fp);
 		memaddr = (u64)cq->comps;
 		memlen = ALIGN(sizeof(*cq->comps) * cq->nentries, PAGE_SIZE);
 		flags |= VM_IO | VM_DONTEXPAND;
@@ -680,7 +677,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 
 	if ((vma->vm_end - vma->vm_start) != memlen) {
 		hfi1_cdbg(PROC, "%u:%u Memory size mismatch %lu:%lu",
-			  uctxt->ctxt, subctxt_fp(fp),
+			  uctxt->ctxt, fd->subctxt,
 			  (vma->vm_end - vma->vm_start), memlen);
 		ret = -EINVAL;
 		goto done;
@@ -730,7 +727,7 @@ static unsigned int hfi1_poll(struct file *fp, struct poll_table_struct *pt)
 	struct hfi1_ctxtdata *uctxt;
 	unsigned pollflag;
 
-	uctxt = ctxt_fp(fp);
+	uctxt = ((struct hfi1_filedata *)fp->private_data)->uctxt;
 	if (!uctxt)
 		pollflag = POLLERR;
 	else if (uctxt->poll_type == HFI1_POLL_TYPE_URGENT)
@@ -930,6 +927,7 @@ static int find_shared_ctxt(struct file *fp,
 {
 	int devmax, ndev, i;
 	int ret = 0;
+	struct hfi1_filedata *fd = fp->private_data;
 
 	devmax = hfi1_count_units(NULL, NULL);
 
@@ -959,10 +957,10 @@ static int find_shared_ctxt(struct file *fp,
 				ret = -EINVAL;
 				goto done;
 			}
-			ctxt_fp(fp) = uctxt;
-			subctxt_fp(fp) = uctxt->cnt++;
-			uctxt->subpid[subctxt_fp(fp)] = current->pid;
-			uctxt->active_slaves |= 1 << subctxt_fp(fp);
+			fd->uctxt = uctxt;
+			fd->subctxt  = uctxt->cnt++;
+			uctxt->subpid[fd->subctxt] = current->pid;
+			uctxt->active_slaves |= 1 << fd->subctxt;
 			ret = 1;
 			goto done;
 		}
@@ -975,6 +973,7 @@ done:
 static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 			 struct hfi1_user_info *uinfo)
 {
+	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt;
 	unsigned ctxt;
 	int ret;
@@ -1022,7 +1021,7 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 	 * This has to be done here so the rest of the sub-contexts find the
 	 * proper master.
 	 */
-	if (uinfo->subctxt_cnt && !subctxt_fp(fp)) {
+	if (uinfo->subctxt_cnt && !fd->subctxt) {
 		ret = init_subctxts(uctxt, uinfo);
 		/*
 		 * On error, we don't need to disable and de-allocate the
@@ -1042,7 +1041,7 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 	spin_lock_init(&uctxt->sdma_qlock);
 	hfi1_stats.sps_ctxts++;
 	dd->freectxts--;
-	ctxt_fp(fp) = uctxt;
+	fd->uctxt = uctxt;
 
 	return 0;
 }
@@ -1106,7 +1105,8 @@ static int user_init(struct file *fp)
 {
 	int ret;
 	unsigned int rcvctrl_ops = 0;
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 
 	/* make sure that the context has already been setup */
 	if (!test_bit(HFI1_CTXT_SETUP_DONE, &uctxt->event_flags)) {
@@ -1118,7 +1118,7 @@ static int user_init(struct file *fp)
 	 * Subctxts don't need to initialize anything since master
 	 * has done it.
 	 */
-	if (subctxt_fp(fp)) {
+	if (fd->subctxt) {
 		ret = wait_event_interruptible(uctxt->wait,
 			!test_bit(HFI1_CTXT_MASTER_UNINIT,
 			&uctxt->event_flags));
@@ -1178,8 +1178,8 @@ done:
 static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
 {
 	struct hfi1_ctxt_info cinfo;
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
 	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	int ret = 0;
 
 	memset(&cinfo, 0, sizeof(cinfo));
@@ -1189,7 +1189,7 @@ static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
 	cinfo.num_active = hfi1_count_active_units();
 	cinfo.unit = uctxt->dd->unit;
 	cinfo.ctxt = uctxt->ctxt;
-	cinfo.subctxt = subctxt_fp(fp);
+	cinfo.subctxt = fd->subctxt;
 	cinfo.rcvtids = roundup(uctxt->egrbufs.alloced,
 				uctxt->dd->rcv_entries.group_size) +
 		uctxt->expected_count;
@@ -1201,10 +1201,10 @@ static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
 	cinfo.egrtids = uctxt->egrbufs.alloced;
 	cinfo.rcvhdrq_cnt = uctxt->rcvhdrq_cnt;
 	cinfo.rcvhdrq_entsize = uctxt->rcvhdrqentsize << 2;
-	cinfo.sdma_ring_size = user_sdma_comp_fp(fp)->nentries;
+	cinfo.sdma_ring_size = fd->cq->nentries;
 	cinfo.rcvegr_size = uctxt->egrbufs.rcvtid_size;
 
-	trace_hfi1_ctxt_info(uctxt->dd, uctxt->ctxt, subctxt_fp(fp), cinfo);
+	trace_hfi1_ctxt_info(uctxt->dd, uctxt->ctxt, fd->subctxt, cinfo);
 	if (copy_to_user(ubase, &cinfo, sizeof(cinfo)))
 		ret = -EFAULT;
 done:
@@ -1213,7 +1213,8 @@ done:
 
 static int setup_ctxt(struct file *fp)
 {
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	int ret = 0;
 
@@ -1222,7 +1223,7 @@ static int setup_ctxt(struct file *fp)
 	 * programming of eager buffers. This is done if context sharing
 	 * is not requested or by the master process.
 	 */
-	if (!uctxt->subctxt_cnt || !subctxt_fp(fp)) {
+	if (!uctxt->subctxt_cnt || !fd->subctxt) {
 		ret = hfi1_init_ctxt(uctxt->sc);
 		if (ret)
 			goto done;
@@ -1234,7 +1235,7 @@ static int setup_ctxt(struct file *fp)
 		ret = hfi1_setup_eagerbufs(uctxt);
 		if (ret)
 			goto done;
-		if (uctxt->subctxt_cnt && !subctxt_fp(fp)) {
+		if (uctxt->subctxt_cnt && !fd->subctxt) {
 			ret = setup_subctxt(uctxt);
 			if (ret)
 				goto done;
@@ -1277,7 +1278,7 @@ static int setup_ctxt(struct file *fp)
 			uctxt->tidusemap[uctxt->tidmapcnt - 1] =
 				~((1ULL << (uctxt->numtidgroups %
 					    BITS_PER_LONG)) - 1);
-		trace_hfi1_exp_tid_map(uctxt->ctxt, subctxt_fp(fp), 0,
+		trace_hfi1_exp_tid_map(uctxt->ctxt, fd->subctxt, 0,
 				       uctxt->tidusemap, uctxt->tidmapcnt);
 	}
 	ret = hfi1_user_sdma_alloc_queues(uctxt, fp);
@@ -1292,7 +1293,8 @@ done:
 static int get_base_info(struct file *fp, void __user *ubase, __u32 len)
 {
 	struct hfi1_base_info binfo;
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	ssize_t sz;
 	unsigned offset;
@@ -1314,50 +1316,50 @@ static int get_base_info(struct file *fp, void __user *ubase, __u32 len)
 	offset = ((u64)uctxt->sc->hw_free -
 		  (u64)dd->cr_base[uctxt->numa_id].va) % PAGE_SIZE;
 	binfo.sc_credits_addr = HFI1_MMAP_TOKEN(PIO_CRED, uctxt->ctxt,
-					       subctxt_fp(fp), offset);
+						fd->subctxt, offset);
 	binfo.pio_bufbase = HFI1_MMAP_TOKEN(PIO_BUFS, uctxt->ctxt,
-					    subctxt_fp(fp),
+					    fd->subctxt,
 					    uctxt->sc->base_addr);
 	binfo.pio_bufbase_sop = HFI1_MMAP_TOKEN(PIO_BUFS_SOP,
 						uctxt->ctxt,
-						subctxt_fp(fp),
+						fd->subctxt,
 						uctxt->sc->base_addr);
 	binfo.rcvhdr_bufbase = HFI1_MMAP_TOKEN(RCV_HDRQ, uctxt->ctxt,
-					       subctxt_fp(fp),
+					       fd->subctxt,
 					       uctxt->rcvhdrq);
 	binfo.rcvegr_bufbase = HFI1_MMAP_TOKEN(RCV_EGRBUF, uctxt->ctxt,
-					       subctxt_fp(fp),
+					       fd->subctxt,
 					       uctxt->egrbufs.rcvtids[0].phys);
 	binfo.sdma_comp_bufbase = HFI1_MMAP_TOKEN(SDMA_COMP, uctxt->ctxt,
-						 subctxt_fp(fp), 0);
+						 fd->subctxt, 0);
 	/*
 	 * user regs are at
 	 * (RXE_PER_CONTEXT_USER + (ctxt * RXE_PER_CONTEXT_SIZE))
 	 */
 	binfo.user_regbase = HFI1_MMAP_TOKEN(UREGS, uctxt->ctxt,
-					    subctxt_fp(fp), 0);
+					    fd->subctxt, 0);
 	offset = offset_in_page((((uctxt->ctxt - dd->first_user_ctxt) *
-		    HFI1_MAX_SHARED_CTXTS) + subctxt_fp(fp)) *
+		    HFI1_MAX_SHARED_CTXTS) + fd->subctxt) *
 		  sizeof(*dd->events));
 	binfo.events_bufbase = HFI1_MMAP_TOKEN(EVENTS, uctxt->ctxt,
-					      subctxt_fp(fp),
+					      fd->subctxt,
 					      offset);
 	binfo.status_bufbase = HFI1_MMAP_TOKEN(STATUS, uctxt->ctxt,
-					      subctxt_fp(fp),
+					      fd->subctxt,
 					      dd->status);
 	if (HFI1_CAP_IS_USET(DMA_RTAIL))
 		binfo.rcvhdrtail_base = HFI1_MMAP_TOKEN(RTAIL, uctxt->ctxt,
-						       subctxt_fp(fp), 0);
+						       fd->subctxt, 0);
 	if (uctxt->subctxt_cnt) {
 		binfo.subctxt_uregbase = HFI1_MMAP_TOKEN(SUBCTXT_UREGS,
 							uctxt->ctxt,
-							subctxt_fp(fp), 0);
+							fd->subctxt, 0);
 		binfo.subctxt_rcvhdrbuf = HFI1_MMAP_TOKEN(SUBCTXT_RCV_HDRQ,
 							 uctxt->ctxt,
-							 subctxt_fp(fp), 0);
+							 fd->subctxt, 0);
 		binfo.subctxt_rcvegrbuf = HFI1_MMAP_TOKEN(SUBCTXT_EGRBUF,
 							 uctxt->ctxt,
-							 subctxt_fp(fp), 0);
+							 fd->subctxt, 0);
 	}
 	sz = (len < sizeof(binfo)) ? len : sizeof(binfo);
 	if (copy_to_user(ubase, &binfo, sz))
@@ -1368,7 +1370,8 @@ static int get_base_info(struct file *fp, void __user *ubase, __u32 len)
 static unsigned int poll_urgent(struct file *fp,
 				struct poll_table_struct *pt)
 {
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	unsigned pollflag;
 
@@ -1390,7 +1393,8 @@ static unsigned int poll_urgent(struct file *fp,
 static unsigned int poll_next(struct file *fp,
 			      struct poll_table_struct *pt)
 {
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	unsigned pollflag;
 
@@ -1562,7 +1566,8 @@ static inline unsigned num_free_groups(unsigned long map, u16 *start)
 static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 {
 	int ret = 0;
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	unsigned tid, mapped = 0, npages, ngroups, exp_groups,
 		tidpairs = uctxt->expected_count / 2;
@@ -1718,7 +1723,7 @@ static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 						   pages[pmapped], 0,
 						   tidsize, PCI_DMA_FROMDEVICE);
 				trace_hfi1_exp_rcv_set(uctxt->ctxt,
-						       subctxt_fp(fp),
+						       fd->subctxt,
 						       tid, vaddr,
 						       phys[pmapped],
 						       pages[pmapped]);
@@ -1763,7 +1768,7 @@ static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 			   (((useidx & 0xffffff) << 16) |
 			    ((bitidx + bits_used) & 0xffffff)));
 	}
-	trace_hfi1_exp_tid_map(uctxt->ctxt, subctxt_fp(fp), 0, uctxt->tidusemap,
+	trace_hfi1_exp_tid_map(uctxt->ctxt, fd->subctxt, 0, uctxt->tidusemap,
 			       uctxt->tidmapcnt);
 
 done:
@@ -1792,7 +1797,8 @@ bail:
 
 static int exp_tid_free(struct file *fp, struct hfi1_tid_info *tinfo)
 {
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	unsigned long tidmap[uctxt->tidmapcnt];
 	struct page **pages;
@@ -1828,7 +1834,7 @@ static int exp_tid_free(struct file *fp, struct hfi1_tid_info *tinfo)
 					hfi1_put_tid(dd, tid, PT_INVALID,
 						      0, 0);
 					trace_hfi1_exp_rcv_free(uctxt->ctxt,
-								subctxt_fp(fp),
+								fd->subctxt,
 								tid, phys[i],
 								pages[i]);
 					pci_unmap_page(dd->pcidev, phys[i],
@@ -1845,7 +1851,7 @@ static int exp_tid_free(struct file *fp, struct hfi1_tid_info *tinfo)
 			map &= ~(1ULL<<bitidx);
 		}
 	}
-	trace_hfi1_exp_tid_map(uctxt->ctxt, subctxt_fp(fp), 1, uctxt->tidusemap,
+	trace_hfi1_exp_tid_map(uctxt->ctxt, fd->subctxt, 1, uctxt->tidusemap,
 			       uctxt->tidmapcnt);
 done:
 	return ret;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 190f7a2f6773..755e4d152d41 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1423,18 +1423,6 @@ int snoop_send_pio_handler(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
 void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 			   u64 pbc, const void *from, size_t count);
 
-/* for use in system calls, where we want to know device type, etc. */
-#define ctxt_fp(fp) \
-	(((struct hfi1_filedata *)(fp)->private_data)->uctxt)
-#define subctxt_fp(fp) \
-	(((struct hfi1_filedata *)(fp)->private_data)->subctxt)
-#define tidcursor_fp(fp) \
-	(((struct hfi1_filedata *)(fp)->private_data)->tidcursor)
-#define user_sdma_pkt_fp(fp) \
-	(((struct hfi1_filedata *)(fp)->private_data)->pq)
-#define user_sdma_comp_fp(fp) \
-	(((struct hfi1_filedata *)(fp)->private_data)->cq)
-
 static inline struct hfi1_devdata *dd_from_ppd(struct hfi1_pportdata *ppd)
 {
 	return ppd->dd;
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 36c838dcf023..be7a4e53335f 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -352,6 +352,7 @@ static void sdma_kmem_cache_ctor(void *obj)
 
 int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 {
+	struct hfi1_filedata *fd;
 	int ret = 0;
 	unsigned memsize;
 	char buf[64];
@@ -365,6 +366,8 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 		goto done;
 	}
 
+	fd = fp->private_data;
+
 	if (!hfi1_sdma_comp_ring_size) {
 		ret = -EINVAL;
 		goto done;
@@ -384,7 +387,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	INIT_LIST_HEAD(&pq->list);
 	pq->dd = dd;
 	pq->ctxt = uctxt->ctxt;
-	pq->subctxt = subctxt_fp(fp);
+	pq->subctxt = fd->subctxt;
 	pq->n_max_reqs = hfi1_sdma_comp_ring_size;
 	pq->state = SDMA_PKT_Q_INACTIVE;
 	atomic_set(&pq->n_reqs, 0);
@@ -393,7 +396,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 		    activate_packet_queue);
 	pq->reqidx = 0;
 	snprintf(buf, 64, "txreq-kmem-cache-%u-%u-%u", dd->unit, uctxt->ctxt,
-		 subctxt_fp(fp));
+		 fd->subctxt);
 	pq->txreq_cache = kmem_cache_create(buf,
 			       sizeof(struct user_sdma_txreq),
 					    L1_CACHE_BYTES,
@@ -404,7 +407,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 			   uctxt->ctxt);
 		goto pq_txreq_nomem;
 	}
-	user_sdma_pkt_fp(fp) = pq;
+	fd->pq = pq;
 	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
 	if (!cq)
 		goto cq_nomem;
@@ -416,7 +419,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 		goto cq_comps_nomem;
 
 	cq->nentries = hfi1_sdma_comp_ring_size;
-	user_sdma_comp_fp(fp) = cq;
+	fd->cq = cq;
 
 	spin_lock_irqsave(&uctxt->sdma_qlock, flags);
 	list_add(&pq->list, &uctxt->sdma_queues);
@@ -431,7 +434,7 @@ pq_txreq_nomem:
 	kfree(pq->reqs);
 pq_reqs_nomem:
 	kfree(pq);
-	user_sdma_pkt_fp(fp) = NULL;
+	fd->pq = NULL;
 pq_nomem:
 	ret = -ENOMEM;
 done:
@@ -485,9 +488,10 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 				   unsigned long dim, unsigned long *count)
 {
 	int ret = 0, i = 0, sent;
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
-	struct hfi1_user_sdma_pkt_q *pq = user_sdma_pkt_fp(fp);
-	struct hfi1_user_sdma_comp_q *cq = user_sdma_comp_fp(fp);
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct hfi1_user_sdma_pkt_q *pq = fd->pq;
+	struct hfi1_user_sdma_comp_q *cq = fd->cq;
 	struct hfi1_devdata *dd = pq->dd;
 	unsigned long idx = 0;
 	u8 pcount = initial_pkt_count;
@@ -499,7 +503,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		hfi1_cdbg(
 		   SDMA,
 		   "[%u:%u:%u] First vector not big enough for header %lu/%lu",
-		   dd->unit, uctxt->ctxt, subctxt_fp(fp),
+		   dd->unit, uctxt->ctxt, fd->subctxt,
 		   iovec[idx].iov_len, sizeof(info) + sizeof(req->hdr));
 		ret = -EINVAL;
 		goto done;
@@ -507,15 +511,15 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	ret = copy_from_user(&info, iovec[idx].iov_base, sizeof(info));
 	if (ret) {
 		hfi1_cdbg(SDMA, "[%u:%u:%u] Failed to copy info QW (%d)",
-			  dd->unit, uctxt->ctxt, subctxt_fp(fp), ret);
+			  dd->unit, uctxt->ctxt, fd->subctxt, ret);
 		ret = -EFAULT;
 		goto done;
 	}
-	trace_hfi1_sdma_user_reqinfo(dd, uctxt->ctxt, subctxt_fp(fp),
+	trace_hfi1_sdma_user_reqinfo(dd, uctxt->ctxt, fd->subctxt,
 				     (u16 *)&info);
 	if (cq->comps[info.comp_idx].status == QUEUED) {
 		hfi1_cdbg(SDMA, "[%u:%u:%u] Entry %u is in QUEUED state",
-			  dd->unit, uctxt->ctxt, subctxt_fp(fp),
+			  dd->unit, uctxt->ctxt, fd->subctxt,
 			  info.comp_idx);
 		ret = -EBADSLT;
 		goto done;
@@ -523,7 +527,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	if (!info.fragsize) {
 		hfi1_cdbg(SDMA,
 			  "[%u:%u:%u:%u] Request does not specify fragsize",
-			  dd->unit, uctxt->ctxt, subctxt_fp(fp), info.comp_idx);
+			  dd->unit, uctxt->ctxt, fd->subctxt, info.comp_idx);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -532,7 +536,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	 * "allocate" the request entry.
 	 */
 	hfi1_cdbg(SDMA, "[%u:%u:%u] Using req/comp entry %u\n", dd->unit,
-		  uctxt->ctxt, subctxt_fp(fp), info.comp_idx);
+		  uctxt->ctxt, fd->subctxt, info.comp_idx);
 	req = pq->reqs + info.comp_idx;
 	memset(req, 0, sizeof(*req));
 	/* Mark the request as IN_USE before we start filling it in. */
@@ -659,7 +663,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 
 	/* Have to select the engine */
 	req->sde = sdma_select_engine_vl(dd,
-					 (u32)(uctxt->ctxt + subctxt_fp(fp)),
+					 (u32)(uctxt->ctxt + fd->subctxt),
 					 vl);
 	if (!req->sde || !sdma_running(req->sde)) {
 		ret = -ECOMM;
-- 
1.8.2
