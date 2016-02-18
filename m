From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/8] staging/rdma/hfi1: Fix counter read for cp
Date: Thu, 18 Feb 2016 11:13:01 -0800
Message-ID: <20160218191256.20983.6969.stgit@scvm10.sc.intel.com>
References: <20160218191005.20983.64127.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218191005.20983.64127.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A cp or cat of /sys/kernel/debug/hfi1/hfi1_0/port1counters
produces the following message:

hfi1 0000:81:00.0: hfi1_0: index not supported
hfi1 0000:81:00.0: hfi1_0: read_cntrs does not support indexing

Fix by removing the file position logic and the associated messages
and make the file positioning the responsibility of the caller.

The port counter read function argument is changed to the per port
data structure since the counters are relative to the port and not
the device.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c    |   30 +++++-------------------------
 drivers/staging/rdma/hfi1/chip.h    |    6 ++----
 drivers/staging/rdma/hfi1/debugfs.c |   11 ++++-------
 3 files changed, 11 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 483b37a..fe73ebf 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -11407,28 +11407,19 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 				dd->rcvhdrtail_dummy_physaddr);
 }
 
-u32 hfi1_read_cntrs(struct hfi1_devdata *dd, loff_t pos, char **namep,
-		    u64 **cntrp)
+u32 hfi1_read_cntrs(struct hfi1_devdata *dd, char **namep, u64 **cntrp)
 {
 	int ret;
 	u64 val = 0;
 
 	if (namep) {
 		ret = dd->cntrnameslen;
-		if (pos != 0) {
-			dd_dev_err(dd, "read_cntrs does not support indexing");
-			return 0;
-		}
 		*namep = dd->cntrnames;
 	} else {
 		const struct cntr_entry *entry;
 		int i, j;
 
 		ret = (dd->ndevcntrs) * sizeof(u64);
-		if (pos != 0) {
-			dd_dev_err(dd, "read_cntrs does not support indexing");
-			return 0;
-		}
 
 		/* Get the start of the block of counters */
 		*cntrp = dd->cntrs;
@@ -11487,30 +11478,19 @@ u32 hfi1_read_cntrs(struct hfi1_devdata *dd, loff_t pos, char **namep,
 /*
  * Used by sysfs to create files for hfi stats to read
  */
-u32 hfi1_read_portcntrs(struct hfi1_devdata *dd, loff_t pos, u32 port,
-			char **namep, u64 **cntrp)
+u32 hfi1_read_portcntrs(struct hfi1_pportdata *ppd, char **namep, u64 **cntrp)
 {
 	int ret;
 	u64 val = 0;
 
 	if (namep) {
-		ret = dd->portcntrnameslen;
-		if (pos != 0) {
-			dd_dev_err(dd, "index not supported");
-			return 0;
-		}
-		*namep = dd->portcntrnames;
+		ret = ppd->dd->portcntrnameslen;
+		*namep = ppd->dd->portcntrnames;
 	} else {
 		const struct cntr_entry *entry;
-		struct hfi1_pportdata *ppd;
 		int i, j;
 
-		ret = (dd->nportcntrs) * sizeof(u64);
-		if (pos != 0) {
-			dd_dev_err(dd, "indexing not supported");
-			return 0;
-		}
-		ppd = (struct hfi1_pportdata *)(dd + 1 + port);
+		ret = ppd->dd->nportcntrs * sizeof(u64);
 		*cntrp = ppd->cntrs;
 
 		for (i = 0; i < PORT_CNTR_LAST; i++) {
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 8468139..e9a41ed 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -1297,10 +1297,8 @@ void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
 		  u32 type, unsigned long pa, u16 order);
 void hfi1_quiet_serdes(struct hfi1_pportdata *ppd);
 void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt);
-u32 hfi1_read_cntrs(struct hfi1_devdata *dd, loff_t pos, char **namep,
-		    u64 **cntrp);
-u32 hfi1_read_portcntrs(struct hfi1_devdata *dd, loff_t pos, u32 port,
-			char **namep, u64 **cntrp);
+u32 hfi1_read_cntrs(struct hfi1_devdata *dd, char **namep, u64 **cntrp);
+u32 hfi1_read_portcntrs(struct hfi1_pportdata *ppd, char **namep, u64 **cntrp);
 u8 hfi1_ibphys_portstate(struct hfi1_pportdata *ppd);
 int hfi1_get_ib_cfg(struct hfi1_pportdata *ppd, int which);
 int hfi1_set_ib_cfg(struct hfi1_pportdata *ppd, int which, u32 val);
diff --git a/drivers/staging/rdma/hfi1/debugfs.c b/drivers/staging/rdma/hfi1/debugfs.c
index 07c16b3..99845bc 100644
--- a/drivers/staging/rdma/hfi1/debugfs.c
+++ b/drivers/staging/rdma/hfi1/debugfs.c
@@ -336,7 +336,7 @@ static ssize_t dev_counters_read(struct file *file, char __user *buf,
 
 	rcu_read_lock();
 	dd = private2dd(file);
-	avail = hfi1_read_cntrs(dd, *ppos, NULL, &counters);
+	avail = hfi1_read_cntrs(dd, NULL, &counters);
 	rval =  simple_read_from_buffer(buf, count, ppos, counters, avail);
 	rcu_read_unlock();
 	return rval;
@@ -353,7 +353,7 @@ static ssize_t dev_names_read(struct file *file, char __user *buf,
 
 	rcu_read_lock();
 	dd = private2dd(file);
-	avail = hfi1_read_cntrs(dd, *ppos, &names, NULL);
+	avail = hfi1_read_cntrs(dd, &names, NULL);
 	rval =  simple_read_from_buffer(buf, count, ppos, names, avail);
 	rcu_read_unlock();
 	return rval;
@@ -380,8 +380,7 @@ static ssize_t portnames_read(struct file *file, char __user *buf,
 
 	rcu_read_lock();
 	dd = private2dd(file);
-	/* port number n/a here since names are constant */
-	avail = hfi1_read_portcntrs(dd, *ppos, 0, &names, NULL);
+	avail = hfi1_read_portcntrs(dd->pport, &names, NULL);
 	rval = simple_read_from_buffer(buf, count, ppos, names, avail);
 	rcu_read_unlock();
 	return rval;
@@ -393,14 +392,12 @@ static ssize_t portcntrs_debugfs_read(struct file *file, char __user *buf,
 {
 	u64 *counters;
 	size_t avail;
-	struct hfi1_devdata *dd;
 	struct hfi1_pportdata *ppd;
 	ssize_t rval;
 
 	rcu_read_lock();
 	ppd = private2ppd(file);
-	dd = ppd->dd;
-	avail = hfi1_read_portcntrs(dd, *ppos, ppd->port - 1, NULL, &counters);
+	avail = hfi1_read_portcntrs(ppd, NULL, &counters);
 	rval = simple_read_from_buffer(buf, count, ppos, counters, avail);
 	rcu_read_unlock();
 	return rval;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
