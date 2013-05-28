From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: add optional numa affinity
Date: Tue, 28 May 2013 12:57:33 -0400
Message-ID: <20130528165733.30588.71366.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ramkrishna Vepa <ramkrishna.vepa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds context relative numa affinity conditioned on the
module parameter numa_aware. The qib_ctxtdata has an additional
node_id member and qib_create_ctxtdata() has an addition node_id
parameter.

The allocations within the hdr queue and eager queue setup routines now
take this additional member and adjust allocations as necesary.  PSM
will pass the either current numa node or the node closest to the HCA
depending on numa_aware. Verbs will always use the node closest to
the HCA.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ramkrishna Vepa <ramkrishna.vepa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h          |    7 +++++
 drivers/infiniband/hw/qib/qib_file_ops.c |    6 ++++-
 drivers/infiniband/hw/qib/qib_init.c     |   39 +++++++++++++++++++++++++-----
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 5643ce4..ca740d8 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -154,6 +154,8 @@ struct qib_ctxtdata {
 	 */
 	/* instead of calculating it */
 	unsigned ctxt;
+	/* local node of context */
+	int node_id;
 	/* non-zero if ctxt is being shared. */
 	u16 subctxt_cnt;
 	/* non-zero if ctxt is being shared. */
@@ -1092,6 +1094,8 @@ struct qib_devdata {
 	u16 psxmitwait_check_rate;
 	/* high volume overflow errors defered to tasklet */
 	struct tasklet_struct error_tasklet;
+
+	int assigned_node_id; /* NUMA node closest to HCA */
 };
 
 /* hol_state values */
@@ -1171,7 +1175,7 @@ int qib_create_rcvhdrq(struct qib_devdata *, struct qib_ctxtdata *);
 int qib_setup_eagerbufs(struct qib_ctxtdata *);
 void qib_set_ctxtcnt(struct qib_devdata *);
 int qib_create_ctxts(struct qib_devdata *dd);
-struct qib_ctxtdata *qib_create_ctxtdata(struct qib_pportdata *, u32);
+struct qib_ctxtdata *qib_create_ctxtdata(struct qib_pportdata *, u32, int);
 void qib_init_pportdata(struct qib_pportdata *, struct qib_devdata *, u8, u8);
 void qib_free_ctxtdata(struct qib_devdata *, struct qib_ctxtdata *);
 
@@ -1462,6 +1466,7 @@ extern unsigned qib_n_krcv_queues;
 extern unsigned qib_sdma_fetch_arb;
 extern unsigned qib_compat_ddr_negotiate;
 extern int qib_special_trigger;
+extern unsigned qib_numa_aware;
 
 extern struct mutex qib_mutex;
 
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 4f7aa30..5003440 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1263,8 +1263,12 @@ static int setup_ctxt(struct qib_pportdata *ppd, int ctxt,
 	struct qib_ctxtdata *rcd;
 	void *ptmp = NULL;
 	int ret;
+	int numa_id;
 
-	rcd = qib_create_ctxtdata(ppd, ctxt);
+	numa_id = qib_numa_aware ? numa_node_id() :
+		dd->assigned_node_id;
+
+	rcd = qib_create_ctxtdata(ppd, ctxt, numa_id);
 
 	/*
 	 * Allocate memory for use in qib_tid_update() at open to
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 6176dfa..8f46fb4 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -67,6 +67,11 @@ ushort qib_cfgctxts;
 module_param_named(cfgctxts, qib_cfgctxts, ushort, S_IRUGO);
 MODULE_PARM_DESC(cfgctxts, "Set max number of contexts to use");
 
+unsigned qib_numa_aware;
+module_param_named(numa_aware, qib_numa_aware, uint, S_IRUGO);
+MODULE_PARM_DESC(numa_aware,
+	"0 -> PSM allocation close to HCA, 1 -> PSM allocation local to process");
+
 /*
  * If set, do not write to any regs if avoidable, hack to allow
  * check for deranged default register values.
@@ -124,6 +129,11 @@ int qib_create_ctxts(struct qib_devdata *dd)
 {
 	unsigned i;
 	int ret;
+	int local_node_id = pcibus_to_node(dd->pcidev->bus);
+
+	if (local_node_id < 0)
+		local_node_id = numa_node_id();
+	dd->assigned_node_id = local_node_id;
 
 	/*
 	 * Allocate full ctxtcnt array, rather than just cfgctxts, because
@@ -146,7 +156,8 @@ int qib_create_ctxts(struct qib_devdata *dd)
 			continue;
 
 		ppd = dd->pport + (i % dd->num_pports);
-		rcd = qib_create_ctxtdata(ppd, i);
+
+		rcd = qib_create_ctxtdata(ppd, i, dd->assigned_node_id);
 		if (!rcd) {
 			qib_dev_err(dd,
 				"Unable to allocate ctxtdata for Kernel ctxt, failing\n");
@@ -164,14 +175,16 @@ done:
 /*
  * Common code for user and kernel context setup.
  */
-struct qib_ctxtdata *qib_create_ctxtdata(struct qib_pportdata *ppd, u32 ctxt)
+struct qib_ctxtdata *qib_create_ctxtdata(struct qib_pportdata *ppd, u32 ctxt,
+	int node_id)
 {
 	struct qib_devdata *dd = ppd->dd;
 	struct qib_ctxtdata *rcd;
 
-	rcd = kzalloc(sizeof(*rcd), GFP_KERNEL);
+	rcd = kzalloc_node(sizeof(*rcd), GFP_KERNEL, node_id);
 	if (rcd) {
 		INIT_LIST_HEAD(&rcd->qp_wait_list);
+		rcd->node_id = node_id;
 		rcd->ppd = ppd;
 		rcd->dd = dd;
 		rcd->cnt = 1;
@@ -1521,6 +1534,7 @@ static void qib_remove_one(struct pci_dev *pdev)
 int qib_create_rcvhdrq(struct qib_devdata *dd, struct qib_ctxtdata *rcd)
 {
 	unsigned amt;
+	int old_node_id;
 
 	if (!rcd->rcvhdrq) {
 		dma_addr_t phys_hdrqtail;
@@ -1530,9 +1544,13 @@ int qib_create_rcvhdrq(struct qib_devdata *dd, struct qib_ctxtdata *rcd)
 			    sizeof(u32), PAGE_SIZE);
 		gfp_flags = (rcd->ctxt >= dd->first_user_ctxt) ?
 			GFP_USER : GFP_KERNEL;
+
+		old_node_id = dev_to_node(&dd->pcidev->dev);
+		set_dev_node(&dd->pcidev->dev, rcd->node_id);
 		rcd->rcvhdrq = dma_alloc_coherent(
 			&dd->pcidev->dev, amt, &rcd->rcvhdrq_phys,
 			gfp_flags | __GFP_COMP);
+		set_dev_node(&dd->pcidev->dev, old_node_id);
 
 		if (!rcd->rcvhdrq) {
 			qib_dev_err(dd,
@@ -1548,9 +1566,11 @@ int qib_create_rcvhdrq(struct qib_devdata *dd, struct qib_ctxtdata *rcd)
 		}
 
 		if (!(dd->flags & QIB_NODMA_RTAIL)) {
+			set_dev_node(&dd->pcidev->dev, rcd->node_id);
 			rcd->rcvhdrtail_kvaddr = dma_alloc_coherent(
 				&dd->pcidev->dev, PAGE_SIZE, &phys_hdrqtail,
 				gfp_flags);
+			set_dev_node(&dd->pcidev->dev, old_node_id);
 			if (!rcd->rcvhdrtail_kvaddr)
 				goto bail_free;
 			rcd->rcvhdrqtailaddr_phys = phys_hdrqtail;
@@ -1594,6 +1614,7 @@ int qib_setup_eagerbufs(struct qib_ctxtdata *rcd)
 	unsigned e, egrcnt, egrperchunk, chunk, egrsize, egroff;
 	size_t size;
 	gfp_t gfp_flags;
+	int old_node_id;
 
 	/*
 	 * GFP_USER, but without GFP_FS, so buffer cache can be
@@ -1612,25 +1633,29 @@ int qib_setup_eagerbufs(struct qib_ctxtdata *rcd)
 	size = rcd->rcvegrbuf_size;
 	if (!rcd->rcvegrbuf) {
 		rcd->rcvegrbuf =
-			kzalloc(chunk * sizeof(rcd->rcvegrbuf[0]),
-				GFP_KERNEL);
+			kzalloc_node(chunk * sizeof(rcd->rcvegrbuf[0]),
+				GFP_KERNEL, rcd->node_id);
 		if (!rcd->rcvegrbuf)
 			goto bail;
 	}
 	if (!rcd->rcvegrbuf_phys) {
 		rcd->rcvegrbuf_phys =
-			kmalloc(chunk * sizeof(rcd->rcvegrbuf_phys[0]),
-				GFP_KERNEL);
+			kmalloc_node(chunk * sizeof(rcd->rcvegrbuf_phys[0]),
+				GFP_KERNEL, rcd->node_id);
 		if (!rcd->rcvegrbuf_phys)
 			goto bail_rcvegrbuf;
 	}
 	for (e = 0; e < rcd->rcvegrbuf_chunks; e++) {
 		if (rcd->rcvegrbuf[e])
 			continue;
+
+		old_node_id = dev_to_node(&dd->pcidev->dev);
+		set_dev_node(&dd->pcidev->dev, rcd->node_id);
 		rcd->rcvegrbuf[e] =
 			dma_alloc_coherent(&dd->pcidev->dev, size,
 					   &rcd->rcvegrbuf_phys[e],
 					   gfp_flags);
+		set_dev_node(&dd->pcidev->dev, old_node_id);
 		if (!rcd->rcvegrbuf[e])
 			goto bail_rcvegrbuf_phys;
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
