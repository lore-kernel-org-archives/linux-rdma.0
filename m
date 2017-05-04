From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 09/15] IB/hfi1: Use filedata rather than filepointer
Date: Thu, 04 May 2017 05:14:45 -0700
Message-ID: <20170504121444.32747.97641.stgit@scvm10.sc.intel.com>
References: <20170504120126.32747.45131.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504120126.32747.45131.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Since almost all functions that use the hfi1_filedata get the pointer
from the file pointer, simplify by only passing the hfi1_filedata pointer.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c     |   68 ++++++++++++++---------------
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   45 +++++++++----------
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |   11 +++--
 drivers/infiniband/hw/hfi1/user_sdma.c    |   14 +++---
 drivers/infiniband/hw/hfi1/user_sdma.h    |    9 +++-
 5 files changed, 72 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 0b77283..ab798a8 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -80,16 +80,18 @@
 static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo);
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 			 const struct hfi1_user_info *uinfo);
-static int user_init(struct file *fp);
-static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len);
-static int get_base_info(struct file *fp, void __user *ubase, __u32 len);
-static int setup_ctxt(struct file *fp);
+static int user_init(struct hfi1_filedata *fd);
+static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
+			 __u32 len);
+static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
+			 __u32 len);
+static int setup_ctxt(struct hfi1_filedata *fd);
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt);
-static int get_user_context(struct file *fp, struct hfi1_user_info *uinfo,
-			    int devno);
-static int find_shared_ctxt(struct file *fp,
+static int get_user_context(struct hfi1_filedata *fd,
+			    struct hfi1_user_info *uinfo, int devno);
+static int find_shared_ctxt(struct hfi1_filedata *fd,
 			    const struct hfi1_user_info *uinfo);
-static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
+static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 			 struct hfi1_user_info *uinfo);
 static unsigned int poll_urgent(struct file *fp, struct poll_table_struct *pt);
 static unsigned int poll_next(struct file *fp, struct poll_table_struct *pt);
@@ -238,17 +240,17 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 		ret = assign_ctxt(fp, &uinfo);
 		if (ret < 0)
 			return ret;
-		ret = setup_ctxt(fp);
+		ret = setup_ctxt(fd);
 		if (ret)
 			return ret;
-		ret = user_init(fp);
+		ret = user_init(fd);
 		break;
 	case HFI1_IOCTL_CTXT_INFO:
-		ret = get_ctxt_info(fp, (void __user *)(unsigned long)arg,
+		ret = get_ctxt_info(fd, (void __user *)(unsigned long)arg,
 				    sizeof(struct hfi1_ctxt_info));
 		break;
 	case HFI1_IOCTL_USER_INFO:
-		ret = get_base_info(fp, (void __user *)(unsigned long)arg,
+		ret = get_base_info(fd, (void __user *)(unsigned long)arg,
 				    sizeof(struct hfi1_base_info));
 		break;
 	case HFI1_IOCTL_CREDIT_UPD:
@@ -262,7 +264,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 				   sizeof(tinfo)))
 			return -EFAULT;
 
-		ret = hfi1_user_exp_rcv_setup(fp, &tinfo);
+		ret = hfi1_user_exp_rcv_setup(fd, &tinfo);
 		if (!ret) {
 			/*
 			 * Copy the number of tidlist entries we used
@@ -284,7 +286,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 				   sizeof(tinfo)))
 			return -EFAULT;
 
-		ret = hfi1_user_exp_rcv_clear(fp, &tinfo);
+		ret = hfi1_user_exp_rcv_clear(fd, &tinfo);
 		if (ret)
 			break;
 		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
@@ -299,7 +301,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 				   sizeof(tinfo)))
 			return -EFAULT;
 
-		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
+		ret = hfi1_user_exp_rcv_invalid(fd, &tinfo);
 		if (ret)
 			break;
 		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
@@ -436,7 +438,7 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 		unsigned long count = 0;
 
 		ret = hfi1_user_sdma_process_request(
-			kiocb->ki_filp,	(struct iovec *)(from->iov + done),
+			fd, (struct iovec *)(from->iov + done),
 			dim, &count);
 		if (ret) {
 			reqs = ret;
@@ -863,7 +865,7 @@ static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 	if (uinfo->subctxt_cnt) {
 		struct hfi1_filedata *fd = fp->private_data;
 
-		ret = find_shared_ctxt(fp, uinfo);
+		ret = find_shared_ctxt(fd, uinfo);
 		if (ret < 0)
 			goto done_unlock;
 		if (ret) {
@@ -878,7 +880,7 @@ static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 	 */
 	if (!ret) {
 		i_minor = iminor(file_inode(fp)) - HFI1_USER_MINOR_BASE;
-		ret = get_user_context(fp, uinfo, i_minor);
+		ret = get_user_context(fp->private_data, uinfo, i_minor);
 	}
 done_unlock:
 	mutex_unlock(&hfi1_mutex);
@@ -886,8 +888,8 @@ static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 	return ret;
 }
 
-static int get_user_context(struct file *fp, struct hfi1_user_info *uinfo,
-			    int devno)
+static int get_user_context(struct hfi1_filedata *fd,
+			    struct hfi1_user_info *uinfo, int devno)
 {
 	struct hfi1_devdata *dd = NULL;
 	int devmax, npresent, nup;
@@ -905,15 +907,14 @@ static int get_user_context(struct file *fp, struct hfi1_user_info *uinfo,
 	else if (!dd->freectxts)
 		return -EBUSY;
 
-	return allocate_ctxt(fp, dd, uinfo);
+	return allocate_ctxt(fd, dd, uinfo);
 }
 
-static int find_shared_ctxt(struct file *fp,
+static int find_shared_ctxt(struct hfi1_filedata *fd,
 			    const struct hfi1_user_info *uinfo)
 {
 	int devmax, ndev, i;
 	int ret = 0;
-	struct hfi1_filedata *fd = fp->private_data;
 
 	devmax = hfi1_count_units(NULL, NULL);
 
@@ -960,10 +961,9 @@ static int find_shared_ctxt(struct file *fp,
 	return ret;
 }
 
-static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
+static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 			 struct hfi1_user_info *uinfo)
 {
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt;
 	unsigned ctxt;
 	int ret, numa;
@@ -1113,10 +1113,9 @@ static int setup_subctxt(struct hfi1_ctxtdata *uctxt)
 	return ret;
 }
 
-static int user_init(struct file *fp)
+static int user_init(struct hfi1_filedata *fd)
 {
 	unsigned int rcvctrl_ops = 0;
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 
 	/* make sure that the context has already been setup */
@@ -1179,10 +1178,10 @@ static int user_init(struct file *fp)
 	return 0;
 }
 
-static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
+static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
+			 __u32 len)
 {
 	struct hfi1_ctxt_info cinfo;
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	int ret = 0;
 
@@ -1220,9 +1219,8 @@ static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
 	return ret;
 }
 
-static int setup_ctxt(struct file *fp)
+static int setup_ctxt(struct hfi1_filedata *fd)
 {
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	int ret = 0;
@@ -1257,7 +1255,7 @@ static int setup_ctxt(struct file *fp)
 			goto done;
 	}
 
-	ret = hfi1_user_sdma_alloc_queues(uctxt, fp);
+	ret = hfi1_user_sdma_alloc_queues(uctxt, fd);
 	if (ret)
 		goto done;
 	/*
@@ -1269,7 +1267,7 @@ static int setup_ctxt(struct file *fp)
 	 * (due to the above wait_event_interruptible() until the master
 	 * is setup.
 	 */
-	ret = hfi1_user_exp_rcv_init(fp);
+	ret = hfi1_user_exp_rcv_init(fd);
 	if (ret)
 		goto done;
 
@@ -1278,10 +1276,10 @@ static int setup_ctxt(struct file *fp)
 	return ret;
 }
 
-static int get_base_info(struct file *fp, void __user *ubase, __u32 len)
+static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
+			 __u32 len)
 {
 	struct hfi1_base_info binfo;
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	ssize_t sz;
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 6090933..22ffda8 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -87,7 +87,7 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 			    struct hfi1_filedata *fd);
 static u32 find_phys_blocks(struct page **pages, unsigned npages,
 			    struct tid_pageset *list);
-static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
+static int set_rcvarray_entry(struct hfi1_filedata *fd, unsigned long vaddr,
 			      u32 rcventry, struct tid_group *grp,
 			      struct page **pages, unsigned npages);
 static int tid_rb_insert(void *arg, struct mmu_rb_node *node);
@@ -95,12 +95,11 @@ static void cacheless_tid_rb_remove(struct hfi1_filedata *fdata,
 				    struct tid_rb_node *tnode);
 static void tid_rb_remove(void *arg, struct mmu_rb_node *node);
 static int tid_rb_invalidate(void *arg, struct mmu_rb_node *mnode);
-static int program_rcvarray(struct file *fp, unsigned long vaddr,
-			    struct tid_group *grp,
-			    struct tid_pageset *sets,
+static int program_rcvarray(struct hfi1_filedata *fd, unsigned long vaddr,
+			    struct tid_group *grp, struct tid_pageset *sets,
 			    unsigned start, u16 count, struct page **pages,
 			    u32 *tidlist, unsigned *tididx, unsigned *pmapped);
-static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
+static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
 			      struct tid_group **grp);
 static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node);
 
@@ -160,9 +159,8 @@ static inline void tid_group_move(struct tid_group *group,
  * receive caching. This needs to be done after the context has
  * been configured with the eager/expected RcvEntry counts.
  */
-int hfi1_user_exp_rcv_init(struct file *fp)
+int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd)
 {
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	unsigned tidbase;
@@ -361,10 +359,10 @@ static inline void rcv_array_wc_fill(struct hfi1_devdata *dd, u32 index)
  *          can fit into the group. If the group becomes fully
  *          used, move it to tid_full_list.
  */
-int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
+int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
+			    struct hfi1_tid_info *tinfo)
 {
 	int ret = 0, need_group = 0, pinned;
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	unsigned npages, ngroups, pageidx = 0, pageset_count, npagesets,
@@ -461,7 +459,7 @@ int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 		struct tid_group *grp =
 			tid_group_pop(&uctxt->tid_group_list);
 
-		ret = program_rcvarray(fp, vaddr, grp, pagesets,
+		ret = program_rcvarray(fd, vaddr, grp, pagesets,
 				       pageidx, dd->rcv_entries.group_size,
 				       pages, tidlist, &tididx, &mapped);
 		/*
@@ -507,7 +505,7 @@ int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 			unsigned use = min_t(unsigned, pageset_count - pageidx,
 					     grp->size - grp->used);
 
-			ret = program_rcvarray(fp, vaddr, grp, pagesets,
+			ret = program_rcvarray(fd, vaddr, grp, pagesets,
 					       pageidx, use, pages, tidlist,
 					       &tididx, &mapped);
 			if (ret < 0) {
@@ -557,7 +555,7 @@ int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 			 * everything done so far so we don't leak resources.
 			 */
 			tinfo->tidlist = (unsigned long)&tidlist;
-			hfi1_user_exp_rcv_clear(fp, tinfo);
+			hfi1_user_exp_rcv_clear(fd, tinfo);
 			tinfo->tidlist = 0;
 			ret = -EFAULT;
 			goto bail;
@@ -581,10 +579,10 @@ int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 	return ret > 0 ? 0 : ret;
 }
 
-int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo)
+int hfi1_user_exp_rcv_clear(struct hfi1_filedata *fd,
+			    struct hfi1_tid_info *tinfo)
 {
 	int ret = 0;
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	u32 *tidinfo;
 	unsigned tididx;
@@ -599,7 +597,7 @@ int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo)
 
 	mutex_lock(&uctxt->exp_lock);
 	for (tididx = 0; tididx < tinfo->tidcnt; tididx++) {
-		ret = unprogram_rcvarray(fp, tidinfo[tididx], NULL);
+		ret = unprogram_rcvarray(fd, tidinfo[tididx], NULL);
 		if (ret) {
 			hfi1_cdbg(TID, "Failed to unprogram rcv array %d",
 				  ret);
@@ -616,9 +614,9 @@ int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo)
 	return ret;
 }
 
-int hfi1_user_exp_rcv_invalid(struct file *fp, struct hfi1_tid_info *tinfo)
+int hfi1_user_exp_rcv_invalid(struct hfi1_filedata *fd,
+			      struct hfi1_tid_info *tinfo)
 {
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	unsigned long *ev = uctxt->dd->events +
 		(((uctxt->ctxt - uctxt->dd->first_dyn_alloc_ctxt) *
@@ -733,7 +731,7 @@ static u32 find_phys_blocks(struct page **pages, unsigned npages,
 
 /**
  * program_rcvarray() - program an RcvArray group with receive buffers
- * @fp: file pointer
+ * @fd: filedata pointer
  * @vaddr: starting user virtual address
  * @grp: RcvArray group
  * @sets: array of struct tid_pageset holding information on physically
@@ -758,13 +756,12 @@ static u32 find_phys_blocks(struct page **pages, unsigned npages,
  * -ENOMEM or -EFAULT on error from set_rcvarray_entry(), or
  * number of RcvArray entries programmed.
  */
-static int program_rcvarray(struct file *fp, unsigned long vaddr,
+static int program_rcvarray(struct hfi1_filedata *fd, unsigned long vaddr,
 			    struct tid_group *grp,
 			    struct tid_pageset *sets,
 			    unsigned start, u16 count, struct page **pages,
 			    u32 *tidlist, unsigned *tididx, unsigned *pmapped)
 {
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	u16 idx;
@@ -805,7 +802,7 @@ static int program_rcvarray(struct file *fp, unsigned long vaddr,
 		npages = sets[setidx].count;
 		pageidx = sets[setidx].idx;
 
-		ret = set_rcvarray_entry(fp, vaddr + (pageidx * PAGE_SIZE),
+		ret = set_rcvarray_entry(fd, vaddr + (pageidx * PAGE_SIZE),
 					 rcventry, grp, pages + pageidx,
 					 npages);
 		if (ret)
@@ -827,12 +824,11 @@ static int program_rcvarray(struct file *fp, unsigned long vaddr,
 	return idx;
 }
 
-static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
+static int set_rcvarray_entry(struct hfi1_filedata *fd, unsigned long vaddr,
 			      u32 rcventry, struct tid_group *grp,
 			      struct page **pages, unsigned npages)
 {
 	int ret;
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct tid_rb_node *node;
 	struct hfi1_devdata *dd = uctxt->dd;
@@ -886,10 +882,9 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 	return 0;
 }
 
-static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
+static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
 			      struct tid_group **grp)
 {
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	struct tid_rb_node *node;
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index 8a33a09..9787511 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -71,10 +71,13 @@
 	} while (0)
 
 void hfi1_user_exp_rcv_grp_free(struct hfi1_ctxtdata *uctxt);
-int hfi1_user_exp_rcv_init(struct file *fp);
+int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd);
 int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd);
-int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo);
-int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo);
-int hfi1_user_exp_rcv_invalid(struct file *fp, struct hfi1_tid_info *tinfo);
+int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
+			    struct hfi1_tid_info *tinfo);
+int hfi1_user_exp_rcv_clear(struct hfi1_filedata *fd,
+			    struct hfi1_tid_info *tinfo);
+int hfi1_user_exp_rcv_invalid(struct hfi1_filedata *fd,
+			      struct hfi1_tid_info *tinfo);
 
 #endif /* _HFI1_USER_EXP_RCV_H */
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 17142c5..4ac4e9d 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -372,9 +372,9 @@ static void sdma_kmem_cache_ctor(void *obj)
 	memset(tx, 0, sizeof(*tx));
 }
 
-int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
+int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
+				struct hfi1_filedata *fd)
 {
-	struct hfi1_filedata *fd;
 	int ret = 0;
 	char buf[64];
 	struct hfi1_devdata *dd;
@@ -382,13 +382,11 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	struct hfi1_user_sdma_pkt_q *pq;
 	unsigned long flags;
 
-	if (!uctxt || !fp) {
+	if (!uctxt || !fd) {
 		ret = -EBADF;
 		goto done;
 	}
 
-	fd = fp->private_data;
-
 	if (!hfi1_sdma_comp_ring_size) {
 		ret = -EINVAL;
 		goto done;
@@ -536,11 +534,11 @@ static u8 dlid_to_selector(u16 dlid)
 	return mapping[hash];
 }
 
-int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
-				   unsigned long dim, unsigned long *count)
+int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
+				   struct iovec *iovec, unsigned long dim,
+				   unsigned long *count)
 {
 	int ret = 0, i;
-	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_user_sdma_pkt_q *pq = fd->pq;
 	struct hfi1_user_sdma_comp_q *cq = fd->cq;
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 95ec783..9181d7c 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -80,8 +80,11 @@ struct hfi1_user_sdma_comp_q {
 	struct hfi1_sdma_comp_entry *comps;
 };
 
-int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp);
+int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
+				struct hfi1_filedata *fd);
 int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd);
-int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
-				   unsigned long dim, unsigned long *count);
+int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
+				   struct iovec *iovec, unsigned long dim,
+				   unsigned long *count);
+
 #endif /* _HFI1_USER_SDMA_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
