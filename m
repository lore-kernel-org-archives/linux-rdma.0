From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 11/15] IB/hfi1: Search shared contexts on the opened
 device, not all devices
Date: Thu, 04 May 2017 05:14:57 -0700
Message-ID: <20170504121456.32747.100.stgit@scvm10.sc.intel.com>
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

The search for available shared contexts walks each registered hfi1
device.  This search is too broad because other devices may not
be on the same fabric, and using its contexts could cause unexpected
behavior.

Removed walking the list of devices, limiting the search to the opened
device.  With the device walk removed, the hfi1_devdata (dd) is not
available. Added it to the hfi1_filedata for reference.

With this change, hfi1_count_units() was rendered obsolete and was
removed.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c   |   36 ----------
 drivers/infiniband/hw/hfi1/file_ops.c |  122 +++++++++++++--------------------
 drivers/infiniband/hw/hfi1/hfi.h      |    2 -
 3 files changed, 49 insertions(+), 111 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index fb319d2..566d152 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -211,42 +211,6 @@ int hfi1_count_active_units(void)
 }
 
 /*
- * Return count of all units, optionally return in arguments
- * the number of usable (present) units, and the number of
- * ports that are up.
- */
-int hfi1_count_units(int *npresentp, int *nupp)
-{
-	int nunits = 0, npresent = 0, nup = 0;
-	struct hfi1_devdata *dd;
-	unsigned long flags;
-	int pidx;
-	struct hfi1_pportdata *ppd;
-
-	spin_lock_irqsave(&hfi1_devs_lock, flags);
-
-	list_for_each_entry(dd, &hfi1_dev_list, list) {
-		nunits++;
-		if ((dd->flags & HFI1_PRESENT) && dd->kregbase)
-			npresent++;
-		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
-			ppd = dd->pport + pidx;
-			if (ppd->lid && ppd->linkup)
-				nup++;
-		}
-	}
-
-	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
-
-	if (npresentp)
-		*npresentp = npresent;
-	if (nupp)
-		*nupp = nup;
-
-	return nunits;
-}
-
-/*
  * Get address of eager buffer from it's index (allocated in chunks, not
  * contiguous).
  */
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index ab798a8..9574fc4 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -77,7 +77,7 @@
 static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma);
 
 static u64 kvirt_to_phys(void *addr);
-static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo);
+static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo);
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 			 const struct hfi1_user_info *uinfo);
 static int user_init(struct hfi1_filedata *fd);
@@ -87,8 +87,7 @@ static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
 			 __u32 len);
 static int setup_ctxt(struct hfi1_filedata *fd);
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt);
-static int get_user_context(struct hfi1_filedata *fd,
-			    struct hfi1_user_info *uinfo, int devno);
+
 static int find_shared_ctxt(struct hfi1_filedata *fd,
 			    const struct hfi1_user_info *uinfo);
 static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
@@ -181,6 +180,9 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
 					       struct hfi1_devdata,
 					       user_cdev);
 
+	if (!((dd->flags & HFI1_PRESENT) && dd->kregbase))
+		return -EINVAL;
+
 	if (!atomic_inc_not_zero(&dd->user_refcount))
 		return -ENXIO;
 
@@ -195,6 +197,7 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
 		fd->rec_cpu_num = -1; /* no cpu affinity by default */
 		fd->mm = current->mm;
 		mmgrab(fd->mm);
+		fd->dd = dd;
 		fp->private_data = fd;
 	} else {
 		fp->private_data = NULL;
@@ -237,7 +240,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 				   sizeof(uinfo)))
 			return -EFAULT;
 
-		ret = assign_ctxt(fp, &uinfo);
+		ret = assign_ctxt(fd, &uinfo);
 		if (ret < 0)
 			return ret;
 		ret = setup_ctxt(fd);
@@ -847,9 +850,9 @@ static u64 kvirt_to_phys(void *addr)
 	return paddr;
 }
 
-static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
+static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 {
-	int i_minor, ret = 0;
+	int ret = 0;
 	unsigned int swmajor, swminor;
 
 	swmajor = uinfo->userversion >> 16;
@@ -863,8 +866,6 @@ static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 	mutex_lock(&hfi1_mutex);
 	/* First, lets check if we need to setup a shared context? */
 	if (uinfo->subctxt_cnt) {
-		struct hfi1_filedata *fd = fp->private_data;
-
 		ret = find_shared_ctxt(fd, uinfo);
 		if (ret < 0)
 			goto done_unlock;
@@ -878,94 +879,59 @@ static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 	 * We execute the following block if we couldn't find a
 	 * shared context or if context sharing is not required.
 	 */
-	if (!ret) {
-		i_minor = iminor(file_inode(fp)) - HFI1_USER_MINOR_BASE;
-		ret = get_user_context(fp->private_data, uinfo, i_minor);
-	}
+	if (!ret)
+		ret = allocate_ctxt(fd, fd->dd, uinfo);
+
 done_unlock:
 	mutex_unlock(&hfi1_mutex);
 done:
 	return ret;
 }
 
-static int get_user_context(struct hfi1_filedata *fd,
-			    struct hfi1_user_info *uinfo, int devno)
-{
-	struct hfi1_devdata *dd = NULL;
-	int devmax, npresent, nup;
-
-	devmax = hfi1_count_units(&npresent, &nup);
-	if (!npresent)
-		return -ENXIO;
-
-	if (!nup)
-		return -ENETDOWN;
-
-	dd = hfi1_lookup(devno);
-	if (!dd)
-		return -ENODEV;
-	else if (!dd->freectxts)
-		return -EBUSY;
-
-	return allocate_ctxt(fd, dd, uinfo);
-}
-
 static int find_shared_ctxt(struct hfi1_filedata *fd,
 			    const struct hfi1_user_info *uinfo)
 {
-	int devmax, ndev, i;
-	int ret = 0;
+	int i;
+	struct hfi1_devdata *dd = fd->dd;
 
-	devmax = hfi1_count_units(NULL, NULL);
+	for (i = dd->first_dyn_alloc_ctxt; i < dd->num_rcv_contexts; i++) {
+		struct hfi1_ctxtdata *uctxt = dd->rcd[i];
 
-	for (ndev = 0; ndev < devmax; ndev++) {
-		struct hfi1_devdata *dd = hfi1_lookup(ndev);
+		/* Skip ctxts which are not yet open */
+		if (!uctxt || !uctxt->cnt)
+			continue;
 
-		if (!(dd && (dd->flags & HFI1_PRESENT) && dd->kregbase))
+		/* Skip dynamically allocted kernel contexts */
+		if (uctxt->sc && (uctxt->sc->type == SC_KERNEL))
 			continue;
-		for (i = dd->first_dyn_alloc_ctxt;
-		     i < dd->num_rcv_contexts; i++) {
-			struct hfi1_ctxtdata *uctxt = dd->rcd[i];
-
-			/* Skip ctxts which are not yet open */
-			if (!uctxt || !uctxt->cnt)
-				continue;
-
-			/* Skip dynamically allocted kernel contexts */
-			if (uctxt->sc && (uctxt->sc->type == SC_KERNEL))
-				continue;
-
-			/* Skip ctxt if it doesn't match the requested one */
-			if (memcmp(uctxt->uuid, uinfo->uuid,
-				   sizeof(uctxt->uuid)) ||
-			    uctxt->jkey != generate_jkey(current_uid()) ||
-			    uctxt->subctxt_id != uinfo->subctxt_id ||
-			    uctxt->subctxt_cnt != uinfo->subctxt_cnt)
-				continue;
-
-			/* Verify the sharing process matches the master */
-			if (uctxt->userversion != uinfo->userversion ||
-			    uctxt->cnt >= uctxt->subctxt_cnt) {
-				ret = -EINVAL;
-				goto done;
-			}
-			fd->uctxt = uctxt;
-			fd->subctxt  = uctxt->cnt++;
-			uctxt->active_slaves |= 1 << fd->subctxt;
-			ret = 1;
-			goto done;
+
+		/* Skip ctxt if it doesn't match the requested one */
+		if (memcmp(uctxt->uuid, uinfo->uuid,
+			   sizeof(uctxt->uuid)) ||
+		    uctxt->jkey != generate_jkey(current_uid()) ||
+		    uctxt->subctxt_id != uinfo->subctxt_id ||
+		    uctxt->subctxt_cnt != uinfo->subctxt_cnt)
+			continue;
+
+		/* Verify the sharing process matches the master */
+		if (uctxt->userversion != uinfo->userversion ||
+		    uctxt->cnt >= uctxt->subctxt_cnt) {
+			return -EINVAL;
 		}
+		fd->uctxt = uctxt;
+		fd->subctxt  = uctxt->cnt++;
+		uctxt->active_slaves |= 1 << fd->subctxt;
+		return 1;
 	}
 
-done:
-	return ret;
+	return 0;
 }
 
 static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 			 struct hfi1_user_info *uinfo)
 {
 	struct hfi1_ctxtdata *uctxt;
-	unsigned ctxt;
+	unsigned int ctxt;
 	int ret, numa;
 
 	if (dd->flags & HFI1_FROZEN) {
@@ -979,6 +945,14 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 		return -EIO;
 	}
 
+	/*
+	 * This check is sort of redundant to the next EBUSY error. It would
+	 * also indicate an inconsistancy in the driver if this value was
+	 * zero, but there were still contexts available.
+	 */
+	if (!dd->freectxts)
+		return -EBUSY;
+
 	for (ctxt = dd->first_dyn_alloc_ctxt;
 	     ctxt < dd->num_rcv_contexts; ctxt++)
 		if (!dd->rcd[ctxt])
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index a1e9b8b..e0c4c5e 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1238,6 +1238,7 @@ static inline bool hfi1_vnic_is_rsm_full(struct hfi1_devdata *dd, int spare)
 
 /* Private data for file operations */
 struct hfi1_filedata {
+	struct hfi1_devdata *dd;
 	struct hfi1_ctxtdata *uctxt;
 	unsigned subctxt;
 	struct hfi1_user_sdma_comp_q *cq;
@@ -1264,7 +1265,6 @@ struct hfi1_filedata {
 extern unsigned long *hfi1_cpulist;
 
 int hfi1_init(struct hfi1_devdata *dd, int reinit);
-int hfi1_count_units(int *npresentp, int *nupp);
 int hfi1_count_active_units(void);
 
 int hfi1_diag_add(struct hfi1_devdata *dd);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
