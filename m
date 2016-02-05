From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3 13/13] staging/rdma/hfi1: Enable TID caching feature
Date: Fri,  5 Feb 2016 11:57:58 -0500
Message-ID: <1454691478-15444-14-git-send-email-ira.weiny@intel.com>
References: <1454691478-15444-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454691478-15444-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This commit "flips the switch" on the TID caching feature
implemented in this patch series.

As well as enabling the new feature by tying the new function
with the PSM API, it also cleans up the old unneeded code,
data structure members, and variables.

Due to difference in operation and information, the tracing
functions related to expected receives had to be changed. This
patch include these changes.

The tracing function changes could not be split into a separate
commit without including both tracing variants at the same time.
This would have caused other complications and ugliness.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c     | 448 +++----------------------------
 drivers/staging/rdma/hfi1/hfi.h          |  14 -
 drivers/staging/rdma/hfi1/init.c         |   3 -
 drivers/staging/rdma/hfi1/trace.h        | 132 +++++----
 drivers/staging/rdma/hfi1/user_exp_rcv.c |  12 +
 drivers/staging/rdma/hfi1/user_pages.c   |  14 -
 include/uapi/rdma/hfi/hfi1_user.h        |   7 +-
 7 files changed, 132 insertions(+), 498 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index b0348263b901..d36588934f99 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -96,9 +96,6 @@ static int user_event_ack(struct hfi1_ctxtdata *, int, unsigned long);
 static int set_ctxt_pkey(struct hfi1_ctxtdata *, unsigned, u16);
 static int manage_rcvq(struct hfi1_ctxtdata *, unsigned, int);
 static int vma_fault(struct vm_area_struct *, struct vm_fault *);
-static int exp_tid_setup(struct file *, struct hfi1_tid_info *);
-static int exp_tid_free(struct file *, struct hfi1_tid_info *);
-static void unlock_exp_tids(struct hfi1_ctxtdata *);
 
 static const struct file_operations hfi1_file_ops = {
 	.owner = THIS_MODULE,
@@ -188,6 +185,7 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 	struct hfi1_cmd cmd;
 	struct hfi1_user_info uinfo;
 	struct hfi1_tid_info tinfo;
+	unsigned long addr;
 	ssize_t consumed = 0, copy = 0, ret = 0;
 	void *dest = NULL;
 	__u64 user_val = 0;
@@ -219,6 +217,7 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 		break;
 	case HFI1_CMD_TID_UPDATE:
 	case HFI1_CMD_TID_FREE:
+	case HFI1_CMD_TID_INVAL_READ:
 		copy = sizeof(tinfo);
 		dest = &tinfo;
 		break;
@@ -241,7 +240,6 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 		must_be_root = 1;	/* validate user */
 		copy = 0;
 		break;
-	case HFI1_CMD_TID_INVAL_READ:
 	default:
 		ret = -EINVAL;
 		goto bail;
@@ -295,9 +293,8 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 			sc_return_credits(uctxt->sc);
 		break;
 	case HFI1_CMD_TID_UPDATE:
-		ret = exp_tid_setup(fp, &tinfo);
+		ret = hfi1_user_exp_rcv_setup(fp, &tinfo);
 		if (!ret) {
-			unsigned long addr;
 			/*
 			 * Copy the number of tidlist entries we used
 			 * and the length of the buffer we registered.
@@ -312,8 +309,25 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 				ret = -EFAULT;
 		}
 		break;
+	case HFI1_CMD_TID_INVAL_READ:
+		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
+		if (ret)
+			break;
+		addr = (unsigned long)cmd.addr +
+			offsetof(struct hfi1_tid_info, tidcnt);
+		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
+				 sizeof(tinfo.tidcnt)))
+			ret = -EFAULT;
+		break;
 	case HFI1_CMD_TID_FREE:
-		ret = exp_tid_free(fp, &tinfo);
+		ret = hfi1_user_exp_rcv_clear(fp, &tinfo);
+		if (ret)
+			break;
+		addr = (unsigned long)cmd.addr +
+			offsetof(struct hfi1_tid_info, tidcnt);
+		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
+				 sizeof(tinfo.tidcnt)))
+			ret = -EFAULT;
 		break;
 	case HFI1_CMD_RECV_CTRL:
 		ret = manage_rcvq(uctxt, fd->subctxt, (int)user_val);
@@ -779,12 +793,9 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	uctxt->pionowait = 0;
 	uctxt->event_flags = 0;
 
-	hfi1_clear_tids(uctxt);
+	hfi1_user_exp_rcv_free(fdata);
 	hfi1_clear_ctxt_pkey(dd, uctxt->ctxt);
 
-	if (uctxt->tid_pg_list)
-		unlock_exp_tids(uctxt);
-
 	hfi1_stats.sps_ctxts--;
 	dd->freectxts++;
 	mutex_unlock(&hfi1_mutex);
@@ -1107,7 +1118,7 @@ static int user_init(struct file *fp)
 		ret = wait_event_interruptible(uctxt->wait,
 			!test_bit(HFI1_CTXT_MASTER_UNINIT,
 			&uctxt->event_flags));
-		goto done;
+		goto expected;
 	}
 
 	/* initialize poll variables... */
@@ -1154,8 +1165,18 @@ static int user_init(struct file *fp)
 		clear_bit(HFI1_CTXT_MASTER_UNINIT, &uctxt->event_flags);
 		wake_up(&uctxt->wait);
 	}
-	ret = 0;
 
+expected:
+	/*
+	 * Expected receive has to be setup for all processes (including
+	 * shared contexts). However, it has to be done after the master
+	 * context has been fully configured as it depends on the
+	 * eager/expected split of the RcvArray entries.
+	 * Setting it up here ensures that the subcontexts will be waiting
+	 * (due to the above wait_event_interruptible() until the master
+	 * is setup.
+	 */
+	ret = hfi1_user_exp_rcv_init(fp);
 done:
 	return ret;
 }
@@ -1225,46 +1246,6 @@ static int setup_ctxt(struct file *fp)
 			if (ret)
 				goto done;
 		}
-		/* Setup Expected Rcv memories */
-		uctxt->tid_pg_list = vzalloc(uctxt->expected_count *
-					     sizeof(struct page **));
-		if (!uctxt->tid_pg_list) {
-			ret = -ENOMEM;
-			goto done;
-		}
-		uctxt->physshadow = vzalloc(uctxt->expected_count *
-					    sizeof(*uctxt->physshadow));
-		if (!uctxt->physshadow) {
-			ret = -ENOMEM;
-			goto done;
-		}
-		/* allocate expected TID map and initialize the cursor */
-		atomic_set(&uctxt->tidcursor, 0);
-		uctxt->numtidgroups = uctxt->expected_count /
-			dd->rcv_entries.group_size;
-		uctxt->tidmapcnt = uctxt->numtidgroups / BITS_PER_LONG +
-			!!(uctxt->numtidgroups % BITS_PER_LONG);
-		uctxt->tidusemap = kzalloc_node(uctxt->tidmapcnt *
-						sizeof(*uctxt->tidusemap),
-						GFP_KERNEL, uctxt->numa_id);
-		if (!uctxt->tidusemap) {
-			ret = -ENOMEM;
-			goto done;
-		}
-		/*
-		 * In case that the number of groups is not a multiple of
-		 * 64 (the number of groups in a tidusemap element), mark
-		 * the extra ones as used. This will effectively make them
-		 * permanently used and should never be assigned. Otherwise,
-		 * the code which checks how many free groups we have will
-		 * get completely confused about the state of the bits.
-		 */
-		if (uctxt->numtidgroups % BITS_PER_LONG)
-			uctxt->tidusemap[uctxt->tidmapcnt - 1] =
-				~((1ULL << (uctxt->numtidgroups %
-					    BITS_PER_LONG)) - 1);
-		trace_hfi1_exp_tid_map(uctxt->ctxt, fd->subctxt, 0,
-				       uctxt->tidusemap, uctxt->tidmapcnt);
 	}
 	ret = hfi1_user_sdma_alloc_queues(uctxt, fp);
 	if (ret)
@@ -1503,367 +1484,6 @@ static int user_event_ack(struct hfi1_ctxtdata *uctxt, int subctxt,
 	return 0;
 }
 
-#define num_user_pages(vaddr, len)					\
-	(1 + (((((unsigned long)(vaddr) +				\
-		 (unsigned long)(len) - 1) & PAGE_MASK) -		\
-	       ((unsigned long)vaddr & PAGE_MASK)) >> PAGE_SHIFT))
-
-/**
- * tzcnt - count the number of trailing zeros in a 64bit value
- * @value: the value to be examined
- *
- * Returns the number of trailing least significant zeros in the
- * the input value. If the value is zero, return the number of
- * bits of the value.
- */
-static inline u8 tzcnt(u64 value)
-{
-	return value ? __builtin_ctzl(value) : sizeof(value) * 8;
-}
-
-static inline unsigned num_free_groups(unsigned long map, u16 *start)
-{
-	unsigned free;
-	u16 bitidx = *start;
-
-	if (bitidx >= BITS_PER_LONG)
-		return 0;
-	/* "Turn off" any bits set before our bit index */
-	map &= ~((1ULL << bitidx) - 1);
-	free = tzcnt(map) - bitidx;
-	while (!free && bitidx < BITS_PER_LONG) {
-		/* Zero out the last set bit so we look at the rest */
-		map &= ~(1ULL << bitidx);
-		/*
-		 * Account for the previously checked bits and advance
-		 * the bit index. We don't have to check for bitidx
-		 * getting bigger than BITS_PER_LONG here as it would
-		 * mean extra instructions that we don't need. If it
-		 * did happen, it would push free to a negative value
-		 * which will break the loop.
-		 */
-		free = tzcnt(map) - ++bitidx;
-	}
-	*start = bitidx;
-	return free;
-}
-
-static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
-{
-	int ret = 0;
-	struct hfi1_filedata *fd = fp->private_data;
-	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned tid, mapped = 0, npages, ngroups, exp_groups,
-		tidpairs = uctxt->expected_count / 2;
-	struct page **pages;
-	unsigned long vaddr, tidmap[uctxt->tidmapcnt];
-	dma_addr_t *phys;
-	u32 tidlist[tidpairs], pairidx = 0, tidcursor;
-	u16 useidx, idx, bitidx, tidcnt = 0;
-
-	vaddr = tinfo->vaddr;
-
-	if (offset_in_page(vaddr)) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	npages = num_user_pages(vaddr, tinfo->length);
-	if (!npages) {
-		ret = -EINVAL;
-		goto bail;
-	}
-	if (!access_ok(VERIFY_WRITE, (void __user *)vaddr,
-		       npages * PAGE_SIZE)) {
-		dd_dev_err(dd, "Fail vaddr %p, %u pages, !access_ok\n",
-			   (void *)vaddr, npages);
-		ret = -EFAULT;
-		goto bail;
-	}
-
-	memset(tidmap, 0, sizeof(tidmap[0]) * uctxt->tidmapcnt);
-	memset(tidlist, 0, sizeof(tidlist[0]) * tidpairs);
-
-	exp_groups = uctxt->expected_count / dd->rcv_entries.group_size;
-	/* which group set do we look at first? */
-	tidcursor = atomic_read(&uctxt->tidcursor);
-	useidx = (tidcursor >> 16) & 0xffff;
-	bitidx = tidcursor & 0xffff;
-
-	/*
-	 * Keep going until we've mapped all pages or we've exhausted all
-	 * RcvArray entries.
-	 * This iterates over the number of tidmaps + 1
-	 * (idx <= uctxt->tidmapcnt) so we check the bitmap which we
-	 * started from one more time for any free bits before the
-	 * starting point bit.
-	 */
-	for (mapped = 0, idx = 0;
-	     mapped < npages && idx <= uctxt->tidmapcnt;) {
-		u64 i, offset = 0;
-		unsigned free, pinned, pmapped = 0, bits_used;
-		u16 grp;
-
-		/*
-		 * "Reserve" the needed group bits under lock so other
-		 * processes can't step in the middle of it. Once
-		 * reserved, we don't need the lock anymore since we
-		 * are guaranteed the groups.
-		 */
-		mutex_lock(&uctxt->exp_lock);
-		if (uctxt->tidusemap[useidx] == -1ULL ||
-		    bitidx >= BITS_PER_LONG) {
-			/* no free groups in the set, use the next */
-			useidx = (useidx + 1) % uctxt->tidmapcnt;
-			idx++;
-			bitidx = 0;
-			mutex_unlock(&uctxt->exp_lock);
-			continue;
-		}
-		ngroups = ((npages - mapped) / dd->rcv_entries.group_size) +
-			!!((npages - mapped) % dd->rcv_entries.group_size);
-
-		/*
-		 * If we've gotten here, the current set of groups does have
-		 * one or more free groups.
-		 */
-		free = num_free_groups(uctxt->tidusemap[useidx], &bitidx);
-		if (!free) {
-			/*
-			 * Despite the check above, free could still come back
-			 * as 0 because we don't check the entire bitmap but
-			 * we start from bitidx.
-			 */
-			mutex_unlock(&uctxt->exp_lock);
-			continue;
-		}
-		bits_used = min(free, ngroups);
-		tidmap[useidx] |= ((1ULL << bits_used) - 1) << bitidx;
-		uctxt->tidusemap[useidx] |= tidmap[useidx];
-		mutex_unlock(&uctxt->exp_lock);
-
-		/*
-		 * At this point, we know where in the map we have free bits.
-		 * properly offset into the various "shadow" arrays and compute
-		 * the RcvArray entry index.
-		 */
-		offset = ((useidx * BITS_PER_LONG) + bitidx) *
-			dd->rcv_entries.group_size;
-		pages = uctxt->tid_pg_list + offset;
-		phys = uctxt->physshadow + offset;
-		tid = uctxt->expected_base + offset;
-
-		/* Calculate how many pages we can pin based on free bits */
-		pinned = min((bits_used * dd->rcv_entries.group_size),
-			     (npages - mapped));
-		/*
-		 * Now that we know how many free RcvArray entries we have,
-		 * we can pin that many user pages.
-		 */
-		ret = hfi1_acquire_user_pages(vaddr + (mapped * PAGE_SIZE),
-					      pinned, true, pages);
-		if (ret) {
-			/*
-			 * We can't continue because the pages array won't be
-			 * initialized. This should never happen,
-			 * unless perhaps the user has mpin'ed the pages
-			 * themselves.
-			 */
-			dd_dev_info(dd,
-				    "Failed to lock addr %p, %u pages: errno %d\n",
-				    (void *) vaddr, pinned, -ret);
-			/*
-			 * Let go of the bits that we reserved since we are not
-			 * going to use them.
-			 */
-			mutex_lock(&uctxt->exp_lock);
-			uctxt->tidusemap[useidx] &=
-				~(((1ULL << bits_used) - 1) << bitidx);
-			mutex_unlock(&uctxt->exp_lock);
-			goto done;
-		}
-		/*
-		 * How many groups do we need based on how many pages we have
-		 * pinned?
-		 */
-		ngroups = (pinned / dd->rcv_entries.group_size) +
-			!!(pinned % dd->rcv_entries.group_size);
-		/*
-		 * Keep programming RcvArray entries for all the <ngroups> free
-		 * groups.
-		 */
-		for (i = 0, grp = 0; grp < ngroups; i++, grp++) {
-			unsigned j;
-			u32 pair_size = 0, tidsize;
-			/*
-			 * This inner loop will program an entire group or the
-			 * array of pinned pages (which ever limit is hit
-			 * first).
-			 */
-			for (j = 0; j < dd->rcv_entries.group_size &&
-				     pmapped < pinned; j++, pmapped++, tid++) {
-				tidsize = PAGE_SIZE;
-				phys[pmapped] = hfi1_map_page(dd->pcidev,
-						   pages[pmapped], 0,
-						   tidsize, PCI_DMA_FROMDEVICE);
-				trace_hfi1_exp_rcv_set(uctxt->ctxt,
-						       fd->subctxt,
-						       tid, vaddr,
-						       phys[pmapped],
-						       pages[pmapped]);
-				/*
-				 * Each RcvArray entry is programmed with one
-				 * page * worth of memory. This will handle
-				 * the 8K MTU as well as anything smaller
-				 * due to the fact that both entries in the
-				 * RcvTidPair are programmed with a page.
-				 * PSM currently does not handle anything
-				 * bigger than 8K MTU, so should we even worry
-				 * about 10K here?
-				 */
-				hfi1_put_tid(dd, tid, PT_EXPECTED,
-					     phys[pmapped],
-					     ilog2(tidsize >> PAGE_SHIFT) + 1);
-				pair_size += tidsize >> PAGE_SHIFT;
-				EXP_TID_RESET(tidlist[pairidx], LEN, pair_size);
-				if (!(tid % 2)) {
-					tidlist[pairidx] |=
-					   EXP_TID_SET(IDX,
-						(tid - uctxt->expected_base)
-						       / 2);
-					tidlist[pairidx] |=
-						EXP_TID_SET(CTRL, 1);
-					tidcnt++;
-				} else {
-					tidlist[pairidx] |=
-						EXP_TID_SET(CTRL, 2);
-					pair_size = 0;
-					pairidx++;
-				}
-			}
-			/*
-			 * We've programmed the entire group (or as much of the
-			 * group as we'll use. Now, it's time to push it out...
-			 */
-			flush_wc();
-		}
-		mapped += pinned;
-		atomic_set(&uctxt->tidcursor,
-			   (((useidx & 0xffffff) << 16) |
-			    ((bitidx + bits_used) & 0xffffff)));
-	}
-	trace_hfi1_exp_tid_map(uctxt->ctxt, fd->subctxt, 0, uctxt->tidusemap,
-			       uctxt->tidmapcnt);
-
-done:
-	/* If we've mapped anything, copy relevant info to user */
-	if (mapped) {
-		if (copy_to_user((void __user *)(unsigned long)tinfo->tidlist,
-				 tidlist, sizeof(tidlist[0]) * tidcnt)) {
-			ret = -EFAULT;
-			goto done;
-		}
-		/* copy TID info to user */
-		if (copy_to_user((void __user *)(unsigned long)tinfo->tidmap,
-				 tidmap, sizeof(tidmap[0]) * uctxt->tidmapcnt))
-			ret = -EFAULT;
-	}
-bail:
-	/*
-	 * Calculate mapped length. New Exp TID protocol does not "unwind" and
-	 * report an error if it can't map the entire buffer. It just reports
-	 * the length that was mapped.
-	 */
-	tinfo->length = mapped * PAGE_SIZE;
-	tinfo->tidcnt = tidcnt;
-	return ret;
-}
-
-static int exp_tid_free(struct file *fp, struct hfi1_tid_info *tinfo)
-{
-	struct hfi1_filedata *fd = fp->private_data;
-	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned long tidmap[uctxt->tidmapcnt];
-	struct page **pages;
-	dma_addr_t *phys;
-	u16 idx, bitidx, tid;
-	int ret = 0;
-
-	if (copy_from_user(&tidmap, (void __user *)(unsigned long)
-			   tinfo->tidmap,
-			   sizeof(tidmap[0]) * uctxt->tidmapcnt)) {
-		ret = -EFAULT;
-		goto done;
-	}
-	for (idx = 0; idx < uctxt->tidmapcnt; idx++) {
-		unsigned long map;
-
-		bitidx = 0;
-		if (!tidmap[idx])
-			continue;
-		map = tidmap[idx];
-		while ((bitidx = tzcnt(map)) < BITS_PER_LONG) {
-			int i, pcount = 0;
-			struct page *pshadow[dd->rcv_entries.group_size];
-			unsigned offset = ((idx * BITS_PER_LONG) + bitidx) *
-				dd->rcv_entries.group_size;
-
-			pages = uctxt->tid_pg_list + offset;
-			phys = uctxt->physshadow + offset;
-			tid = uctxt->expected_base + offset;
-			for (i = 0; i < dd->rcv_entries.group_size;
-			     i++, tid++) {
-				if (pages[i]) {
-					hfi1_put_tid(dd, tid, PT_INVALID,
-						      0, 0);
-					trace_hfi1_exp_rcv_free(uctxt->ctxt,
-								fd->subctxt,
-								tid, phys[i],
-								pages[i]);
-					pci_unmap_page(dd->pcidev, phys[i],
-					      PAGE_SIZE, PCI_DMA_FROMDEVICE);
-					pshadow[pcount] = pages[i];
-					pages[i] = NULL;
-					pcount++;
-					phys[i] = 0;
-				}
-			}
-			flush_wc();
-			hfi1_release_user_pages(pshadow, pcount, true);
-			clear_bit(bitidx, &uctxt->tidusemap[idx]);
-			map &= ~(1ULL<<bitidx);
-		}
-	}
-	trace_hfi1_exp_tid_map(uctxt->ctxt, fd->subctxt, 1, uctxt->tidusemap,
-			       uctxt->tidmapcnt);
-done:
-	return ret;
-}
-
-static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt)
-{
-	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned tid;
-
-	dd_dev_info(dd, "ctxt %u unlocking any locked expTID pages\n",
-		    uctxt->ctxt);
-	for (tid = 0; tid < uctxt->expected_count; tid++) {
-		struct page *p = uctxt->tid_pg_list[tid];
-		dma_addr_t phys;
-
-		if (!p)
-			continue;
-
-		phys = uctxt->physshadow[tid];
-		uctxt->physshadow[tid] = 0;
-		uctxt->tid_pg_list[tid] = NULL;
-		pci_unmap_page(dd->pcidev, phys, PAGE_SIZE, PCI_DMA_FROMDEVICE);
-		hfi1_release_user_pages(&p, 1, true);
-	}
-}
-
 static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
 			 u16 pkey)
 {
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 53f464cc40ef..62157cc34727 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -240,18 +240,6 @@ struct hfi1_ctxtdata {
 	u32 expected_count;
 	/* index of first expected TID entry. */
 	u32 expected_base;
-	/* cursor into the exp group sets */
-	atomic_t tidcursor;
-	/* number of exp TID groups assigned to the ctxt */
-	u16 numtidgroups;
-	/* size of exp TID group fields in tidusemap */
-	u16 tidmapcnt;
-	/* exp TID group usage bitfield array */
-	unsigned long *tidusemap;
-	/* pinned pages for exp sends, allocated at open */
-	struct page **tid_pg_list;
-	/* dma handles for exp tid pages */
-	dma_addr_t *physshadow;
 
 	struct exp_tid_set tid_group_list;
 	struct exp_tid_set tid_used_list;
@@ -1660,8 +1648,6 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 			enum platform_config_table_type_encoding table_type,
 			int table_index, int field_index, u32 *data, u32 len);
 
-dma_addr_t hfi1_map_page(struct pci_dev *, struct page *, unsigned long,
-			 size_t, int);
 const char *get_unit_name(int unit);
 
 /*
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 72c51431b2bf..00f52e815242 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -962,13 +962,10 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	kfree(rcd->egrbufs.buffers);
 
 	sc_free(rcd->sc);
-	vfree(rcd->physshadow);
-	vfree(rcd->tid_pg_list);
 	vfree(rcd->user_event_mask);
 	vfree(rcd->subctxt_uregbase);
 	vfree(rcd->subctxt_rcvegrbuf);
 	vfree(rcd->subctxt_rcvhdr_base);
-	kfree(rcd->tidusemap);
 	kfree(rcd->opstats);
 	kfree(rcd);
 }
diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/staging/rdma/hfi1/trace.h
index 86c12ebfd4f0..1e435675335f 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -153,92 +153,130 @@ TRACE_EVENT(hfi1_receive_interrupt,
 	)
 );
 
-const char *print_u64_array(struct trace_seq *, u64 *, int);
+TRACE_EVENT(hfi1_exp_tid_reg,
+	    TP_PROTO(unsigned ctxt, u16 subctxt, u32 rarr,
+		     u32 npages, unsigned long va, unsigned long pa,
+		     dma_addr_t dma),
+	    TP_ARGS(ctxt, subctxt, rarr, npages, va, pa, dma),
+	    TP_STRUCT__entry(
+		    __field(unsigned, ctxt)
+		    __field(u16, subctxt)
+		    __field(u32, rarr)
+		    __field(u32, npages)
+		    __field(unsigned long, va)
+		    __field(unsigned long, pa)
+		    __field(dma_addr_t, dma)
+		    ),
+	    TP_fast_assign(
+		    __entry->ctxt = ctxt;
+		    __entry->subctxt = subctxt;
+		    __entry->rarr = rarr;
+		    __entry->npages = npages;
+		    __entry->va = va;
+		    __entry->pa = pa;
+		    __entry->dma = dma;
+		    ),
+	    TP_printk("[%u:%u] entry:%u, %u pages @ 0x%lx, va:0x%lx dma:0x%llx",
+		      __entry->ctxt,
+		      __entry->subctxt,
+		      __entry->rarr,
+		      __entry->npages,
+		      __entry->pa,
+		      __entry->va,
+		      __entry->dma
+		    )
+	);
 
-TRACE_EVENT(hfi1_exp_tid_map,
-	    TP_PROTO(unsigned ctxt, u16 subctxt, int dir,
-		     unsigned long *maps, u16 count),
-	    TP_ARGS(ctxt, subctxt, dir, maps, count),
+TRACE_EVENT(hfi1_exp_tid_unreg,
+	    TP_PROTO(unsigned ctxt, u16 subctxt, u32 rarr, u32 npages,
+		     unsigned long va, unsigned long pa, dma_addr_t dma),
+	    TP_ARGS(ctxt, subctxt, rarr, npages, va, pa, dma),
 	    TP_STRUCT__entry(
 		    __field(unsigned, ctxt)
 		    __field(u16, subctxt)
-		    __field(int, dir)
-		    __field(u16, count)
-		    __dynamic_array(unsigned long, maps, sizeof(*maps) * count)
+		    __field(u32, rarr)
+		    __field(u32, npages)
+		    __field(unsigned long, va)
+		    __field(unsigned long, pa)
+		    __field(dma_addr_t, dma)
 		    ),
 	    TP_fast_assign(
 		    __entry->ctxt = ctxt;
 		    __entry->subctxt = subctxt;
-		    __entry->dir = dir;
-		    __entry->count = count;
-		    memcpy(__get_dynamic_array(maps), maps,
-			   sizeof(*maps) * count);
+		    __entry->rarr = rarr;
+		    __entry->npages = npages;
+		    __entry->va = va;
+		    __entry->pa = pa;
+		    __entry->dma = dma;
 		    ),
-	    TP_printk("[%3u:%02u] %s tidmaps %s",
+	    TP_printk("[%u:%u] entry:%u, %u pages @ 0x%lx, va:0x%lx dma:0x%llx",
 		      __entry->ctxt,
 		      __entry->subctxt,
-		      (__entry->dir ? ">" : "<"),
-		      print_u64_array(p, __get_dynamic_array(maps),
-				      __entry->count)
+		      __entry->rarr,
+		      __entry->npages,
+		      __entry->pa,
+		      __entry->va,
+		      __entry->dma
 		    )
 	);
 
-TRACE_EVENT(hfi1_exp_rcv_set,
-	    TP_PROTO(unsigned ctxt, u16 subctxt, u32 tid,
-		     unsigned long vaddr, u64 phys_addr, void *page),
-	    TP_ARGS(ctxt, subctxt, tid, vaddr, phys_addr, page),
+TRACE_EVENT(hfi1_exp_tid_inval,
+	    TP_PROTO(unsigned ctxt, u16 subctxt, unsigned long va, u32 rarr,
+		     u32 npages, dma_addr_t dma),
+	    TP_ARGS(ctxt, subctxt, va, rarr, npages, dma),
 	    TP_STRUCT__entry(
 		    __field(unsigned, ctxt)
 		    __field(u16, subctxt)
-		    __field(u32, tid)
-		    __field(unsigned long, vaddr)
-		    __field(u64, phys_addr)
-		    __field(void *, page)
+		    __field(unsigned long, va)
+		    __field(u32, rarr)
+		    __field(u32, npages)
+		    __field(dma_addr_t, dma)
 		    ),
 	    TP_fast_assign(
 		    __entry->ctxt = ctxt;
 		    __entry->subctxt = subctxt;
-		    __entry->tid = tid;
-		    __entry->vaddr = vaddr;
-		    __entry->phys_addr = phys_addr;
-		    __entry->page = page;
+		    __entry->va = va;
+		    __entry->rarr = rarr;
+		    __entry->npages = npages;
+		    __entry->dma = dma;
 		    ),
-	    TP_printk("[%u:%u] TID %u, vaddrs 0x%lx, physaddr 0x%llx, pgp %p",
+	    TP_printk("[%u:%u] entry:%u, %u pages @ 0x%lx dma: 0x%llx",
 		      __entry->ctxt,
 		      __entry->subctxt,
-		      __entry->tid,
-		      __entry->vaddr,
-		      __entry->phys_addr,
-		      __entry->page
+		      __entry->rarr,
+		      __entry->npages,
+		      __entry->va,
+		      __entry->dma
 		    )
 	);
 
-TRACE_EVENT(hfi1_exp_rcv_free,
-	    TP_PROTO(unsigned ctxt, u16 subctxt, u32 tid,
-		     unsigned long phys, void *page),
-	    TP_ARGS(ctxt, subctxt, tid, phys, page),
+TRACE_EVENT(hfi1_mmu_invalidate,
+	    TP_PROTO(unsigned ctxt, u16 subctxt, const char *type,
+		     unsigned long start, unsigned long end),
+	    TP_ARGS(ctxt, subctxt, type, start, end),
 	    TP_STRUCT__entry(
 		    __field(unsigned, ctxt)
 		    __field(u16, subctxt)
-		    __field(u32, tid)
-		    __field(unsigned long, phys)
-		    __field(void *, page)
+		    __string(type, type)
+		    __field(unsigned long, start)
+		    __field(unsigned long, end)
 		    ),
 	    TP_fast_assign(
 		    __entry->ctxt = ctxt;
 		    __entry->subctxt = subctxt;
-		    __entry->tid = tid;
-		    __entry->phys = phys;
-		    __entry->page = page;
+		    __assign_str(type, type);
+		    __entry->start = start;
+		    __entry->end = end;
 		    ),
-	    TP_printk("[%u:%u] freeing TID %u, 0x%lx, pgp %p",
+	    TP_printk("[%3u:%02u] MMU Invalidate (%s) 0x%lx - 0x%lx",
 		      __entry->ctxt,
 		      __entry->subctxt,
-		      __entry->tid,
-		      __entry->phys,
-		      __entry->page
+		      __get_str(type),
+		      __entry->start,
+		      __entry->end
 		    )
 	);
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM hfi1_tx
 
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index d33f579675b7..79612a2bd07d 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -902,6 +902,8 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 		return -EFAULT;
 	}
 	hfi1_put_tid(dd, rcventry, PT_EXPECTED, phys, ilog2(npages) + 1);
+	trace_hfi1_exp_tid_reg(uctxt->ctxt, fd->subctxt, rcventry,
+			       npages, node->virt, node->phys, phys);
 	return 0;
 }
 
@@ -947,6 +949,10 @@ static void clear_tid_node(struct hfi1_filedata *fd, u16 subctxt,
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 
+	trace_hfi1_exp_tid_unreg(uctxt->ctxt, fd->subctxt, node->rcventry,
+				 node->npages, node->virt, node->phys,
+				 node->dma_addr);
+
 	hfi1_put_tid(dd, node->rcventry, PT_INVALID, 0, 0);
 	/*
 	 * Make sure device has seen the write before we unpin the
@@ -1023,6 +1029,9 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 	struct mmu_rb_node *node;
 	unsigned long addr = start;
 
+	trace_hfi1_mmu_invalidate(uctxt->ctxt, fd->subctxt, mmu_types[type],
+				  start, end);
+
 	spin_lock(&fd->rb_lock);
 	while (addr < end) {
 		node = mmu_rb_search_by_addr(root, addr);
@@ -1049,6 +1058,9 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 		if (node->freed)
 			continue;
 
+		trace_hfi1_exp_tid_inval(uctxt->ctxt, fd->subctxt, node->virt,
+					 node->rcventry, node->npages,
+					 node->dma_addr);
 		node->freed = true;
 
 		spin_lock(&fd->invalid_lock);
diff --git a/drivers/staging/rdma/hfi1/user_pages.c b/drivers/staging/rdma/hfi1/user_pages.c
index 692de658f0dc..1854c0c7ce7e 100644
--- a/drivers/staging/rdma/hfi1/user_pages.c
+++ b/drivers/staging/rdma/hfi1/user_pages.c
@@ -54,20 +54,6 @@
 
 #include "hfi.h"
 
-/**
- * hfi1_map_page - a safety wrapper around pci_map_page()
- *
- */
-dma_addr_t hfi1_map_page(struct pci_dev *hwdev, struct page *page,
-			 unsigned long offset, size_t size, int direction)
-{
-	dma_addr_t phys;
-
-	phys = pci_map_page(hwdev, page, offset, size, direction);
-
-	return phys;
-}
-
 int hfi1_acquire_user_pages(unsigned long vaddr, size_t npages, bool writable,
 			    struct page **pages)
 {
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 92be2e373019..a533cecab14f 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -66,7 +66,7 @@
  * The major version changes when data structures change in an incompatible
  * way. The driver must be the same for initialization to succeed.
  */
-#define HFI1_USER_SWMAJOR 4
+#define HFI1_USER_SWMAJOR 5
 
 /*
  * Minor version differences are always compatible
@@ -241,11 +241,6 @@ struct hfi1_tid_info {
 	__u32 tidcnt;
 	/* length of transfer buffer programmed by this request */
 	__u32 length;
-	/*
-	 * pointer to bitmap of TIDs used for this call;
-	 * checked for being large enough at open
-	 */
-	__u64 tidmap;
 };
 
 struct hfi1_cmd {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
