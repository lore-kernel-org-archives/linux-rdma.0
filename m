From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/10] IB/hfi1: Remove multiple device cdev
Date: Thu, 19 May 2016 05:25:50 -0700
Message-ID: <20160519122548.22041.17208.stgit@scvm10.sc.intel.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519122318.22041.58871.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

hfi1 current exports a cdev that can be used to target all of the hfi's
in the system. However there is a problem with this approach in
that the devices could be on different subnets. This is a problem that
user space can figure out and explicitly tell the driver on which device
to create a context.

Remove the multi-purpose cdev leaving a dedicated cdev for each port.
Also remove the striping capability that is dependent upon the user
choosing the multi-purpose cdev. It is now up to user space to determine
how to stripe contexts.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c |  102 ++++++----------------------------
 include/uapi/rdma/hfi/hfi1_user.h    |   19 +-----
 2 files changed, 21 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index c1c5bf8..518cd89 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -86,8 +86,7 @@ static int get_ctxt_info(struct file *, void __user *, __u32);
 static int get_base_info(struct file *, void __user *, __u32);
 static int setup_ctxt(struct file *);
 static int setup_subctxt(struct hfi1_ctxtdata *);
-static int get_user_context(struct file *, struct hfi1_user_info *,
-			    int, unsigned);
+static int get_user_context(struct file *, struct hfi1_user_info *, int);
 static int find_shared_ctxt(struct file *, const struct hfi1_user_info *);
 static int allocate_ctxt(struct file *, struct hfi1_devdata *,
 			 struct hfi1_user_info *);
@@ -836,7 +835,7 @@ static u64 kvirt_to_phys(void *addr)
 static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 {
 	int i_minor, ret = 0;
-	unsigned swmajor, swminor, alg = HFI1_ALG_ACROSS;
+	unsigned int swmajor, swminor;
 
 	swmajor = uinfo->userversion >> 16;
 	if (swmajor != HFI1_USER_SWMAJOR) {
@@ -846,9 +845,6 @@ static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 
 	swminor = uinfo->userversion & 0xffff;
 
-	if (uinfo->hfi1_alg < HFI1_ALG_COUNT)
-		alg = uinfo->hfi1_alg;
-
 	mutex_lock(&hfi1_mutex);
 	/* First, lets check if we need to setup a shared context? */
 	if (uinfo->subctxt_cnt) {
@@ -868,7 +864,7 @@ static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 	 */
 	if (!ret) {
 		i_minor = iminor(file_inode(fp)) - HFI1_USER_MINOR_BASE;
-		ret = get_user_context(fp, uinfo, i_minor - 1, alg);
+		ret = get_user_context(fp, uinfo, i_minor);
 	}
 done_unlock:
 	mutex_unlock(&hfi1_mutex);
@@ -876,71 +872,26 @@ done:
 	return ret;
 }
 
-/* return true if the device available for general use */
-static int usable_device(struct hfi1_devdata *dd)
-{
-	struct hfi1_pportdata *ppd = dd->pport;
-
-	return driver_lstate(ppd) == IB_PORT_ACTIVE;
-}
-
 static int get_user_context(struct file *fp, struct hfi1_user_info *uinfo,
-			    int devno, unsigned alg)
+			    int devno)
 {
 	struct hfi1_devdata *dd = NULL;
-	int ret = 0, devmax, npresent, nup, dev;
+	int devmax, npresent, nup;
 
 	devmax = hfi1_count_units(&npresent, &nup);
-	if (!npresent) {
-		ret = -ENXIO;
-		goto done;
-	}
-	if (!nup) {
-		ret = -ENETDOWN;
-		goto done;
-	}
-	if (devno >= 0) {
-		dd = hfi1_lookup(devno);
-		if (!dd)
-			ret = -ENODEV;
-		else if (!dd->freectxts)
-			ret = -EBUSY;
-	} else {
-		struct hfi1_devdata *pdd;
-
-		if (alg == HFI1_ALG_ACROSS) {
-			unsigned free = 0U;
-
-			for (dev = 0; dev < devmax; dev++) {
-				pdd = hfi1_lookup(dev);
-				if (!pdd)
-					continue;
-				if (!usable_device(pdd))
-					continue;
-				if (pdd->freectxts &&
-				    pdd->freectxts > free) {
-					dd = pdd;
-					free = pdd->freectxts;
-				}
-			}
-		} else {
-			for (dev = 0; dev < devmax; dev++) {
-				pdd = hfi1_lookup(dev);
-				if (!pdd)
-					continue;
-				if (!usable_device(pdd))
-					continue;
-				if (pdd->freectxts) {
-					dd = pdd;
-					break;
-				}
-			}
-		}
-		if (!dd)
-			ret = -EBUSY;
-	}
-done:
-	return ret ? ret : allocate_ctxt(fp, dd, uinfo);
+	if (!npresent)
+		return -ENXIO;
+
+	if (!nup)
+		return -ENETDOWN;
+
+	dd = hfi1_lookup(devno);
+	if (!dd)
+		return -ENODEV;
+	else if (!dd->freectxts)
+		return -EBUSY;
+
+	return allocate_ctxt(fp, dd, uinfo);
 }
 
 static int find_shared_ctxt(struct file *fp,
@@ -1698,15 +1649,8 @@ static const struct file_operations ui_file_ops = {
 #define UI_OFFSET 192	/* device minor offset for UI devices */
 static int create_ui = 1;
 
-static struct cdev wildcard_cdev;
-static struct device *wildcard_device;
-
-static atomic_t user_count = ATOMIC_INIT(0);
-
 static void user_remove(struct hfi1_devdata *dd)
 {
-	if (atomic_dec_return(&user_count) == 0)
-		hfi1_cdev_cleanup(&wildcard_cdev, &wildcard_device);
 
 	hfi1_cdev_cleanup(&dd->user_cdev, &dd->user_device);
 	hfi1_cdev_cleanup(&dd->ui_cdev, &dd->ui_device);
@@ -1717,16 +1661,8 @@ static int user_add(struct hfi1_devdata *dd)
 	char name[10];
 	int ret;
 
-	if (atomic_inc_return(&user_count) == 1) {
-		ret = hfi1_cdev_init(0, class_name(), &hfi1_file_ops,
-				     &wildcard_cdev, &wildcard_device,
-				     true);
-		if (ret)
-			goto done;
-	}
-
 	snprintf(name, sizeof(name), "%s_%d", class_name(), dd->unit);
-	ret = hfi1_cdev_init(dd->unit + 1, name, &hfi1_file_ops,
+	ret = hfi1_cdev_init(dd->unit, name, &hfi1_file_ops,
 			     &dd->user_cdev, &dd->user_device,
 			     true);
 	if (ret)
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index a533cec..0955899 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -75,7 +75,7 @@
  * may not be implemented; the user code must deal with this if it
  * cares, or it must abort after initialization reports the difference.
  */
-#define HFI1_USER_SWMINOR 0
+#define HFI1_USER_SWMINOR 1
 
 /*
  * Set of HW and driver capability/feature bits.
@@ -107,19 +107,6 @@
 #define HFI1_RCVHDR_ENTSIZE_16   (1UL << 1)
 #define HFI1_RCVDHR_ENTSIZE_32   (1UL << 2)
 
-/*
- * If the unit is specified via open, HFI choice is fixed.  If port is
- * specified, it's also fixed.  Otherwise we try to spread contexts
- * across ports and HFIs, using different algorithms.  WITHIN is
- * the old default, prior to this mechanism.
- */
-#define HFI1_ALG_ACROSS 0 /* round robin contexts across HFIs, then
-			  * ports; this is the default */
-#define HFI1_ALG_WITHIN 1 /* use all contexts on an HFI (round robin
-			  * active ports within), then next HFI */
-#define HFI1_ALG_COUNT  2 /* number of algorithm choices */
-
-
 /* User commands. */
 #define HFI1_CMD_ASSIGN_CTXT     1	/* allocate HFI and context */
 #define HFI1_CMD_CTXT_INFO       2	/* find out what resources we got */
@@ -199,9 +186,7 @@ struct hfi1_user_info {
 	 * Should be set to HFI1_USER_SWVERSION.
 	 */
 	__u32 userversion;
-	__u16 pad;
-	/* HFI selection algorithm, if unit has not selected */
-	__u16 hfi1_alg;
+	__u32 pad;
 	/*
 	 * If two or more processes wish to share a context, each process
 	 * must set the subcontext_cnt and subcontext_id to the same

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
