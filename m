From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Add dual rail NUMA awareness for PSM processes
Date: Sun, 02 Jun 2013 15:16:11 -0400
Message-ID: <20130602191611.32182.42515.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ramkrishna Vepa <ramkrishna.vepa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The driver currently selects a HCA based on the algorithm that
PSM chooses, contexts within a HCA or across. The HCA can also
be chosen by the user. Either way, this patch assigns a CPU on
the NUMA node local to the selected HCA. This patch also tries
to select the HCA closest to the NUMA node of the CPU assigned
via taskset to PSM process. If this HCA is unusable then
another unit is selected based on the algorithm that is
currently enforced or selected by PSM - round robin
context selection 'within' or 'across' HCA's.

Fixed a bug wherein contexts are setup on the NUMA node on
which the processes are opened (setup_ctxt()) and not on the
NUMA node that the driver recommends the CPU on.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ramkrishna Vepa <ramkrishna.vepa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_file_ops.c |  174 ++++++++++++++++++++++--------
 1 file changed, 125 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 5003440..7a965b5 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Intel Corporation. All rights reserved.
+ * Copyright (c) 2012, 2013 Intel Corporation. All rights reserved.
  * Copyright (c) 2006 - 2012 QLogic Corporation. All rights reserved.
  * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
  *
@@ -1155,6 +1155,49 @@ static unsigned int qib_poll(struct file *fp, struct poll_table_struct *pt)
 	return pollflag;
 }
 
+static void assign_ctxt_affinity(struct file *fp, struct qib_devdata *dd)
+{
+	struct qib_filedata *fd = fp->private_data;
+	const unsigned int weight = cpumask_weight(&current->cpus_allowed);
+	const struct cpumask *local_mask = cpumask_of_pcibus(dd->pcidev->bus);
+	int local_cpu;
+
+	/*
+	 * If process has NOT already set it's affinity, select and
+	 * reserve a processor for it on the local NUMA node.
+	 */
+	if ((weight >= qib_cpulist_count) &&
+		(cpumask_weight(local_mask) <= qib_cpulist_count)) {
+		for_each_cpu(local_cpu, local_mask)
+			if (!test_and_set_bit(local_cpu, qib_cpulist)) {
+				fd->rec_cpu_num = local_cpu;
+				return;
+			}
+	}
+
+	/*
+	 * If process has NOT already set it's affinity, select and
+	 * reserve a processor for it, as a rendevous for all
+	 * users of the driver.  If they don't actually later
+	 * set affinity to this cpu, or set it to some other cpu,
+	 * it just means that sooner or later we don't recommend
+	 * a cpu, and let the scheduler do it's best.
+	 */
+	if (weight >= qib_cpulist_count) {
+		int cpu;
+		cpu = find_first_zero_bit(qib_cpulist,
+					  qib_cpulist_count);
+		if (cpu == qib_cpulist_count)
+			qib_dev_err(dd,
+			"no cpus avail for affinity PID %u\n",
+			current->pid);
+		else {
+			__set_bit(cpu, qib_cpulist);
+			fd->rec_cpu_num = cpu;
+		}
+	}
+}
+
 /*
  * Check that userland and driver are compatible for subcontexts.
  */
@@ -1259,14 +1302,18 @@ bail:
 static int setup_ctxt(struct qib_pportdata *ppd, int ctxt,
 		      struct file *fp, const struct qib_user_info *uinfo)
 {
+	struct qib_filedata *fd = fp->private_data;
 	struct qib_devdata *dd = ppd->dd;
 	struct qib_ctxtdata *rcd;
 	void *ptmp = NULL;
 	int ret;
 	int numa_id;
 
-	numa_id = qib_numa_aware ? numa_node_id() :
-		dd->assigned_node_id;
+	assign_ctxt_affinity(fp, dd);
+
+	numa_id = qib_numa_aware ? ((fd->rec_cpu_num != -1) ?
+		cpu_to_node(fd->rec_cpu_num) :
+		numa_node_id()) : dd->assigned_node_id;
 
 	rcd = qib_create_ctxtdata(ppd, ctxt, numa_id);
 
@@ -1300,6 +1347,9 @@ static int setup_ctxt(struct qib_pportdata *ppd, int ctxt,
 	goto bail;
 
 bailerr:
+	if (fd->rec_cpu_num != -1)
+		__clear_bit(fd->rec_cpu_num, qib_cpulist);
+
 	dd->rcd[ctxt] = NULL;
 	kfree(rcd);
 	kfree(ptmp);
@@ -1489,6 +1539,57 @@ static int qib_open(struct inode *in, struct file *fp)
 	return fp->private_data ? 0 : -ENOMEM;
 }
 
+static int find_hca(unsigned int cpu, int *unit)
+{
+	int ret = 0, devmax, npresent, nup, ndev;
+
+	*unit = -1;
+
+	devmax = qib_count_units(&npresent, &nup);
+	if (!npresent) {
+		ret = -ENXIO;
+		goto done;
+	}
+	if (!nup) {
+		ret = -ENETDOWN;
+		goto done;
+	}
+	for (ndev = 0; ndev < devmax; ndev++) {
+		struct qib_devdata *dd = qib_lookup(ndev);
+		if (dd) {
+			if (pcibus_to_node(dd->pcidev->bus) < 0) {
+				ret = -EINVAL;
+				goto done;
+			}
+			if (cpu_to_node(cpu) ==
+				pcibus_to_node(dd->pcidev->bus)) {
+				*unit = ndev;
+				goto done;
+			}
+		}
+	}
+done:
+	return ret;
+}
+
+static int do_qib_user_sdma_queue_create(struct file *fp)
+{
+	struct qib_filedata *fd = fp->private_data;
+	struct qib_ctxtdata *rcd = fd->rcd;
+	struct qib_devdata *dd = rcd->dd;
+
+	if (dd->flags & QIB_HAS_SEND_DMA)
+
+		fd->pq = qib_user_sdma_queue_create(&dd->pcidev->dev,
+						    dd->unit,
+						    rcd->ctxt,
+						    fd->subctxt);
+		if (!fd->pq)
+			return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * Get ctxt early, so can set affinity prior to memory allocation.
  */
@@ -1521,61 +1622,36 @@ static int qib_assign_ctxt(struct file *fp, const struct qib_user_info *uinfo)
 	if (qib_compatible_subctxts(swmajor, swminor) &&
 	    uinfo->spu_subctxt_cnt) {
 		ret = find_shared_ctxt(fp, uinfo);
-		if (ret) {
-			if (ret > 0)
-				ret = 0;
-			goto done_chk_sdma;
+		if (ret > 0) {
+			ret = do_qib_user_sdma_queue_create(fp);
+			if (!ret)
+				assign_ctxt_affinity(fp, (ctxt_fp(fp))->dd);
+			goto done_ok;
 		}
 	}
 
 	i_minor = iminor(file_inode(fp)) - QIB_USER_MINOR_BASE;
 	if (i_minor)
 		ret = find_free_ctxt(i_minor - 1, fp, uinfo);
-	else
+	else {
+		int unit;
+		const unsigned int cpu = cpumask_first(&current->cpus_allowed);
+		const unsigned int weight =
+			cpumask_weight(&current->cpus_allowed);
+
+		if (weight == 1 && !test_bit(cpu, qib_cpulist))
+			if (!find_hca(cpu, &unit) && unit >= 0)
+				if (!find_free_ctxt(unit, fp, uinfo)) {
+					ret = 0;
+					goto done_chk_sdma;
+				}
 		ret = get_a_ctxt(fp, uinfo, alg);
-
-done_chk_sdma:
-	if (!ret) {
-		struct qib_filedata *fd = fp->private_data;
-		const struct qib_ctxtdata *rcd = fd->rcd;
-		const struct qib_devdata *dd = rcd->dd;
-		unsigned int weight;
-
-		if (dd->flags & QIB_HAS_SEND_DMA) {
-			fd->pq = qib_user_sdma_queue_create(&dd->pcidev->dev,
-							    dd->unit,
-							    rcd->ctxt,
-							    fd->subctxt);
-			if (!fd->pq)
-				ret = -ENOMEM;
-		}
-
-		/*
-		 * If process has NOT already set it's affinity, select and
-		 * reserve a processor for it, as a rendezvous for all
-		 * users of the driver.  If they don't actually later
-		 * set affinity to this cpu, or set it to some other cpu,
-		 * it just means that sooner or later we don't recommend
-		 * a cpu, and let the scheduler do it's best.
-		 */
-		weight = cpumask_weight(tsk_cpus_allowed(current));
-		if (!ret && weight >= qib_cpulist_count) {
-			int cpu;
-			cpu = find_first_zero_bit(qib_cpulist,
-						  qib_cpulist_count);
-			if (cpu != qib_cpulist_count) {
-				__set_bit(cpu, qib_cpulist);
-				fd->rec_cpu_num = cpu;
-			}
-		} else if (weight == 1 &&
-			test_bit(cpumask_first(tsk_cpus_allowed(current)),
-				 qib_cpulist))
-			qib_devinfo(dd->pcidev,
-				"%s PID %u affinity set to cpu %d; already allocated\n",
-				current->comm, current->pid,
-				cpumask_first(tsk_cpus_allowed(current)));
 	}
 
+done_chk_sdma:
+	if (!ret)
+		ret = do_qib_user_sdma_queue_create(fp);
+done_ok:
 	mutex_unlock(&qib_mutex);
 
 done:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
