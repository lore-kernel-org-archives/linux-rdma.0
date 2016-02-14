From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/16] staging/rdma/hfi1: Add qp to send context mapping for
 PIO
Date: Sun, 14 Feb 2016 12:46:10 -0800
Message-ID: <20160214204606.29247.56566.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

PIO send context mapping is changed from per-VL to QPN based.

qp to send context mapping is done using a mapping infrastructure
similar to the current vl to sdma engine mapping.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/hfi.h   |    6 +
 drivers/staging/rdma/hfi1/init.c  |    2 
 drivers/staging/rdma/hfi1/pio.c   |  241 ++++++++++++++++++++++++++++++++++++-
 drivers/staging/rdma/hfi1/pio.h   |  106 ++++++++++++++++
 drivers/staging/rdma/hfi1/qp.c    |   24 ++++
 drivers/staging/rdma/hfi1/qp.h    |    1 
 drivers/staging/rdma/hfi1/verbs.c |   12 --
 drivers/staging/rdma/hfi1/verbs.h |    2 
 8 files changed, 375 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 4ac3de6..e8c4e56 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -842,6 +842,12 @@ struct hfi1_devdata {
 	spinlock_t sc_lock;
 	/* Per VL data. Enough for all VLs but not all elements are set/used. */
 	struct per_vl_data vld[PER_VL_SEND_CONTEXTS];
+	/* lock for pio_map */
+	spinlock_t pio_map_lock;
+	/* array of kernel send contexts */
+	struct send_context **kernel_send_context;
+	/* array of vl maps */
+	struct pio_vl_map __rcu *pio_map;
 	/* seqlock for sc2vl */
 	seqlock_t sc2vl_lock;
 	u64 sc2vl[4];
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 112cb6c..423c699 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -1050,6 +1050,7 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	mutex_init(&dd->qsfp_i2c_mutex);
 	seqlock_init(&dd->sc2vl_lock);
 	spin_lock_init(&dd->sde_map_lock);
+	spin_lock_init(&dd->pio_map_lock);
 	init_waitqueue_head(&dd->event_queue);
 
 	dd->int_counter = alloc_percpu(u64);
@@ -1317,6 +1318,7 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 		}
 	}
 	kfree(tmp);
+	free_pio_map(dd);
 	/* must follow rcv context free - need to remove rcv's hooks */
 	for (ctxt = 0; ctxt < dd->num_send_contexts; ctxt++)
 		sc_free(dd->send_contexts[ctxt].sc);
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index f5aab0e..69bbe22 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -312,7 +312,7 @@ int init_sc_pools_and_sizes(struct hfi1_devdata *dd)
 		if (i == SC_ACK) {
 			count = dd->n_krcv_queues;
 		} else if (i == SC_KERNEL) {
-			count = num_vls + 1 /* VL15 */;
+			count = (INIT_SC_PER_VL * num_vls) + 1 /* VL15 */;
 		} else if (count == SCC_PER_CPU) {
 			count = dd->num_rcv_contexts - dd->n_krcv_queues;
 		} else if (count < 0) {
@@ -1687,11 +1687,217 @@ done:
 	spin_unlock(&dd->sc_lock);
 }
 
+/*
+ * pio_select_send_context_vl() - select send context
+ * @dd: devdata
+ * @selector: a spreading factor
+ * @vl: this vl
+ *
+ * This function returns a send context based on the selector and a vl.
+ * The mapping fields are protected by RCU
+ */
+struct send_context *pio_select_send_context_vl(struct hfi1_devdata *dd,
+						u32 selector, u8 vl)
+{
+	struct pio_vl_map *m;
+	struct pio_map_elem *e;
+	struct send_context *rval;
+
+	/*
+	 * NOTE This should only happen if SC->VL changed after the initial
+	 * checks on the QP/AH
+	 * Default will return VL0's send context below
+	 */
+	if (unlikely(vl >= num_vls)) {
+		rval = NULL;
+		goto done;
+	}
+
+	rcu_read_lock();
+	m = rcu_dereference(dd->pio_map);
+	if (unlikely(!m)) {
+		rcu_read_unlock();
+		return dd->vld[0].sc;
+	}
+	e = m->map[vl & m->mask];
+	rval = e->ksc[selector & e->mask];
+	rcu_read_unlock();
+
+done:
+	rval = !rval ? dd->vld[0].sc : rval;
+	return rval;
+}
+
+/*
+ * pio_select_send_context_sc() - select send context
+ * @dd: devdata
+ * @selector: a spreading factor
+ * @sc5: the 5 bit sc
+ *
+ * This function returns an send context based on the selector and an sc
+ */
+struct send_context *pio_select_send_context_sc(struct hfi1_devdata *dd,
+						u32 selector, u8 sc5)
+{
+	u8 vl = sc_to_vlt(dd, sc5);
+
+	return pio_select_send_context_vl(dd, selector, vl);
+}
+
+/*
+ * Free the indicated map struct
+ */
+static void pio_map_free(struct pio_vl_map *m)
+{
+	int i;
+
+	for (i = 0; m && i < m->actual_vls; i++)
+		kfree(m->map[i]);
+	kfree(m);
+}
+
+/*
+ * Handle RCU callback
+ */
+static void pio_map_rcu_callback(struct rcu_head *list)
+{
+	struct pio_vl_map *m = container_of(list, struct pio_vl_map, list);
+
+	pio_map_free(m);
+}
+
+/*
+ * pio_map_init - called when #vls change
+ * @dd: hfi1_devdata
+ * @port: port number
+ * @num_vls: number of vls
+ * @vl_scontexts: per vl send context mapping (optional)
+ *
+ * This routine changes the mapping based on the number of vls.
+ *
+ * vl_scontexts is used to specify a non-uniform vl/send context
+ * loading. NULL implies auto computing the loading and giving each
+ * VL an uniform distribution of send contexts per VL.
+ *
+ * The auto algorithm computers the sc_per_vl and the number of extra
+ * send contexts. Any extra send contexts are added from the last VL
+ * on down
+ *
+ * rcu locking is used here to control access to the mapping fields.
+ *
+ * If either the num_vls or num_send_contexts are non-power of 2, the
+ * array sizes in the struct pio_vl_map and the struct pio_map_elem are
+ * rounded up to the next highest power of 2 and the first entry is
+ * reused in a round robin fashion.
+ *
+ * If an error occurs the map change is not done and the mapping is not
+ * chaged.
+ *
+ */
+int pio_map_init(struct hfi1_devdata *dd, u8 port, u8 num_vls, u8 *vl_scontexts)
+{
+	int i, j;
+	int extra, sc_per_vl;
+	int scontext = 1;
+	int num_kernel_send_contexts = 0;
+	u8 lvl_scontexts[OPA_MAX_VLS];
+	struct pio_vl_map *oldmap, *newmap;
+
+	if (!vl_scontexts) {
+		/* send context 0 reserved for VL15 */
+		for (i = 1; i < dd->num_send_contexts; i++)
+			if (dd->send_contexts[i].type == SC_KERNEL)
+				num_kernel_send_contexts++;
+		/* truncate divide */
+		sc_per_vl = num_kernel_send_contexts / num_vls;
+		/* extras */
+		extra = num_kernel_send_contexts % num_vls;
+		vl_scontexts = lvl_scontexts;
+		/* add extras from last vl down */
+		for (i = num_vls - 1; i >= 0; i--, extra--)
+			vl_scontexts[i] = sc_per_vl + (extra > 0 ? 1 : 0);
+	}
+	/* build new map */
+	newmap = kzalloc(sizeof(*newmap) +
+			 roundup_pow_of_two(num_vls) *
+			 sizeof(struct pio_map_elem *),
+			 GFP_KERNEL);
+	if (!newmap)
+		goto bail;
+	newmap->actual_vls = num_vls;
+	newmap->vls = roundup_pow_of_two(num_vls);
+	newmap->mask = (1 << ilog2(newmap->vls)) - 1;
+	for (i = 0; i < newmap->vls; i++) {
+		/* save for wrap around */
+		int first_scontext = scontext;
+
+		if (i < newmap->actual_vls) {
+			int sz = roundup_pow_of_two(vl_scontexts[i]);
+
+			/* only allocate once */
+			newmap->map[i] = kzalloc(sizeof(*newmap->map[i]) +
+						 sz * sizeof(struct
+							     send_context *),
+						 GFP_KERNEL);
+			if (!newmap->map[i])
+				goto bail;
+			newmap->map[i]->mask = (1 << ilog2(sz)) - 1;
+			/* assign send contexts */
+			for (j = 0; j < sz; j++) {
+				if (dd->kernel_send_context[scontext])
+					newmap->map[i]->ksc[j] =
+					dd->kernel_send_context[scontext];
+				if (++scontext >= first_scontext +
+						  vl_scontexts[i])
+					/* wrap back to first send context */
+					scontext = first_scontext;
+			}
+		} else {
+			/* just re-use entry without allocating */
+			newmap->map[i] = newmap->map[i % num_vls];
+		}
+		scontext = first_scontext + vl_scontexts[i];
+	}
+	/* newmap in hand, save old map */
+	spin_lock_irq(&dd->pio_map_lock);
+	oldmap = rcu_dereference_protected(dd->pio_map,
+					   lockdep_is_held(&dd->pio_map_lock));
+
+	/* publish newmap */
+	rcu_assign_pointer(dd->pio_map, newmap);
+
+	spin_unlock_irq(&dd->pio_map_lock);
+	/* success, free any old map after grace period */
+	if (oldmap)
+		call_rcu(&oldmap->list, pio_map_rcu_callback);
+	return 0;
+bail:
+	/* free any partial allocation */
+	pio_map_free(newmap);
+	return -ENOMEM;
+}
+
+void free_pio_map(struct hfi1_devdata *dd)
+{
+	/* Free PIO map if allocated */
+	if (rcu_access_pointer(dd->pio_map)) {
+		spin_lock_irq(&dd->pio_map_lock);
+		kfree(rcu_access_pointer(dd->pio_map));
+		RCU_INIT_POINTER(dd->pio_map, NULL);
+		spin_unlock_irq(&dd->pio_map_lock);
+		synchronize_rcu();
+	}
+	kfree(dd->kernel_send_context);
+	dd->kernel_send_context = NULL;
+}
+
 int init_pervl_scs(struct hfi1_devdata *dd)
 {
 	int i;
-	u64 mask, all_vl_mask = (u64) 0x80ff; /* VLs 0-7, 15 */
+	u64 mask, all_vl_mask = (u64)0x80ff; /* VLs 0-7, 15 */
+	u64 data_vls_mask = (u64)0x00ff; /* VLs 0-7 */
 	u32 ctxt;
+	struct hfi1_pportdata *ppd = dd->pport;
 
 	dd->vld[15].sc = sc_alloc(dd, SC_KERNEL,
 				  dd->rcd[0]->rcvhdrqentsize, dd->node);
@@ -1699,6 +1905,12 @@ int init_pervl_scs(struct hfi1_devdata *dd)
 		goto nomem;
 	hfi1_init_ctxt(dd->vld[15].sc);
 	dd->vld[15].mtu = enum_to_mtu(OPA_MTU_2048);
+
+	dd->kernel_send_context = kmalloc_node(dd->num_send_contexts *
+					sizeof(struct send_context *),
+					GFP_KERNEL, dd->node);
+	dd->kernel_send_context[0] = dd->vld[15].sc;
+
 	for (i = 0; i < num_vls; i++) {
 		/*
 		 * Since this function does not deal with a specific
@@ -1711,12 +1923,19 @@ int init_pervl_scs(struct hfi1_devdata *dd)
 					 dd->rcd[0]->rcvhdrqentsize, dd->node);
 		if (!dd->vld[i].sc)
 			goto nomem;
-
+		dd->kernel_send_context[i + 1] = dd->vld[i].sc;
 		hfi1_init_ctxt(dd->vld[i].sc);
-
 		/* non VL15 start with the max MTU */
 		dd->vld[i].mtu = hfi1_max_mtu;
 	}
+	for (i = num_vls; i < INIT_SC_PER_VL * num_vls; i++) {
+		dd->kernel_send_context[i + 1] =
+		sc_alloc(dd, SC_KERNEL, dd->rcd[0]->rcvhdrqentsize, dd->node);
+		if (!dd->kernel_send_context[i + 1])
+			goto nomem;
+		hfi1_init_ctxt(dd->kernel_send_context[i + 1]);
+	}
+
 	sc_enable(dd->vld[15].sc);
 	ctxt = dd->vld[15].sc->hw_context;
 	mask = all_vl_mask & ~(1LL << 15);
@@ -1724,17 +1943,29 @@ int init_pervl_scs(struct hfi1_devdata *dd)
 	dd_dev_info(dd,
 		    "Using send context %u(%u) for VL15\n",
 		    dd->vld[15].sc->sw_index, ctxt);
+
 	for (i = 0; i < num_vls; i++) {
 		sc_enable(dd->vld[i].sc);
 		ctxt = dd->vld[i].sc->hw_context;
-		mask = all_vl_mask & ~(1LL << i);
+		mask = all_vl_mask & ~(data_vls_mask);
 		write_kctxt_csr(dd, ctxt, SC(CHECK_VL), mask);
 	}
+	for (i = num_vls; i < INIT_SC_PER_VL * num_vls; i++) {
+		sc_enable(dd->kernel_send_context[i + 1]);
+		ctxt = dd->kernel_send_context[i + 1]->hw_context;
+		mask = all_vl_mask & ~(data_vls_mask);
+		write_kctxt_csr(dd, ctxt, SC(CHECK_VL), mask);
+	}
+
+	if (pio_map_init(dd, ppd->port - 1, num_vls, NULL))
+		goto nomem;
 	return 0;
 nomem:
 	sc_free(dd->vld[15].sc);
 	for (i = 0; i < num_vls; i++)
 		sc_free(dd->vld[i].sc);
+	for (i = num_vls; i < INIT_SC_PER_VL * num_vls; i++)
+		sc_free(dd->kernel_send_context[i + 1]);
 	return -ENOMEM;
 }
 
diff --git a/drivers/staging/rdma/hfi1/pio.h b/drivers/staging/rdma/hfi1/pio.h
index 53d3e0a..1dedeb2 100644
--- a/drivers/staging/rdma/hfi1/pio.h
+++ b/drivers/staging/rdma/hfi1/pio.h
@@ -165,6 +165,112 @@ struct sc_config_sizes {
 	short int count;
 };
 
+/*
+ * The diagram below details the relationship of the mapping structures
+ *
+ * Since the mapping now allows for non-uniform send contexts per vl, the
+ * number of send contexts for a vl is either the vl_scontexts[vl] or
+ * a computation based on num_kernel_send_contexts/num_vls:
+ *
+ * For example:
+ * nactual = vl_scontexts ? vl_scontexts[vl] : num_kernel_send_contexts/num_vls
+ *
+ * n = roundup to next highest power of 2 using nactual
+ *
+ * In the case where there are num_kernel_send_contexts/num_vls doesn't divide
+ * evenly, the extras are added from the last vl downward.
+ *
+ * For the case where n > nactual, the send contexts are assigned
+ * in a round robin fashion wrapping back to the first send context
+ * for a particular vl.
+ *
+ *               dd->pio_map
+ *                    |                                   pio_map_elem[0]
+ *                    |                                +--------------------+
+ *                    v                                |       mask         |
+ *               pio_vl_map                            |--------------------|
+ *      +--------------------------+                   | ksc[0] -> sc 1     |
+ *      |    list (RCU)            |                   |--------------------|
+ *      |--------------------------|                 ->| ksc[1] -> sc 2     |
+ *      |    mask                  |              --/  |--------------------|
+ *      |--------------------------|            -/     |        *           |
+ *      |    actual_vls (max 8)    |          -/       |--------------------|
+ *      |--------------------------|       --/         | ksc[n] -> sc n     |
+ *      |    vls (max 8)           |     -/            +--------------------+
+ *      |--------------------------|  --/
+ *      |    map[0]                |-/
+ *      |--------------------------|                   +--------------------+
+ *      |    map[1]                |---                |       mask         |
+ *      |--------------------------|   \----           |--------------------|
+ *      |           *              |        \--        | ksc[0] -> sc 1+n   |
+ *      |           *              |           \----   |--------------------|
+ *      |           *              |                \->| ksc[1] -> sc 2+n   |
+ *      |--------------------------|                   |--------------------|
+ *      |   map[vls - 1]           |-                  |         *          |
+ *      +--------------------------+ \-                |--------------------|
+ *                                     \-              | ksc[m] -> sc m+n   |
+ *                                       \             +--------------------+
+ *                                        \-
+ *                                          \
+ *                                           \-        +--------------------+
+ *                                             \-      |       mask         |
+ *                                               \     |--------------------|
+ *                                                \-   | ksc[0] -> sc 1+m+n |
+ *                                                  \- |--------------------|
+ *                                                    >| ksc[1] -> sc 2+m+n |
+ *                                                     |--------------------|
+ *                                                     |         *          |
+ *                                                     |--------------------|
+ *                                                     | ksc[o] -> sc o+m+n |
+ *                                                     +--------------------+
+ *
+ */
+
+/* Initial number of send contexts per VL */
+#define INIT_SC_PER_VL 2
+
+/*
+ * struct pio_map_elem - mapping for a vl
+ * @mask - selector mask
+ * @ksc - array of kernel send contexts for this vl
+ *
+ * The mask is used to "mod" the selector to
+ * produce index into the trailing array of
+ * kscs
+ */
+struct pio_map_elem {
+	u32 mask;
+	struct send_context *ksc[0];
+};
+
+/*
+ * struct pio_vl_map - mapping for a vl
+ * @list - rcu head for free callback
+ * @mask - vl mask to "mod" the vl to produce an index to map array
+ * @actual_vls - number of vls
+ * @vls - numbers of vls rounded to next power of 2
+ * @map - array of pio_map_elem entries
+ *
+ * This is the parent mapping structure. The trailing members of the
+ * struct point to pio_map_elem entries, which in turn point to an
+ * array of kscs for that vl.
+ */
+struct pio_vl_map {
+	struct rcu_head list;
+	u32 mask;
+	u8 actual_vls;
+	u8 vls;
+	struct pio_map_elem *map[0];
+};
+
+int pio_map_init(struct hfi1_devdata *dd, u8 port, u8 num_vls,
+		 u8 *vl_scontexts);
+void free_pio_map(struct hfi1_devdata *dd);
+struct send_context *pio_select_send_context_vl(struct hfi1_devdata *dd,
+						u32 selector, u8 vl);
+struct send_context *pio_select_send_context_sc(struct hfi1_devdata *dd,
+						u32 selector, u8 sc5);
+
 /* send context functions */
 int init_credit_return(struct hfi1_devdata *dd);
 void free_credit_return(struct hfi1_devdata *dd);
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index ead7aed..1274172 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -552,6 +552,30 @@ struct sdma_engine *qp_to_sdma_engine(struct rvt_qp *qp, u8 sc5)
 	return sde;
 }
 
+/*
+ * qp_to_send_context - map a qp to a send context
+ * @qp: the QP
+ * @sc5: the 5 bit sc
+ *
+ * Return:
+ * A send context for the qp
+ */
+struct send_context *qp_to_send_context(struct rvt_qp *qp, u8 sc5)
+{
+	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_SMI:
+		/* SMA packets to VL15 */
+		return dd->vld[15].sc;
+	default:
+		break;
+	}
+
+	return pio_select_send_context_sc(dd, qp->ibqp.qp_num >> dd->qos_shift,
+					  sc5);
+}
+
 struct qp_iter {
 	struct hfi1_ibdev *dev;
 	struct rvt_qp *qp;
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index afc2b4d..7b1c57e 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -109,6 +109,7 @@ void hfi1_get_credit(struct rvt_qp *qp, u32 aeth);
 void hfi1_qp_wakeup(struct rvt_qp *qp, u32 flag);
 
 struct sdma_engine *qp_to_sdma_engine(struct rvt_qp *qp, u8 sc5);
+struct send_context *qp_to_send_context(struct rvt_qp *qp, u8 sc5);
 
 struct qp_iter;
 
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 3141966..10b14da 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -783,18 +783,6 @@ static int pio_wait(struct rvt_qp *qp,
 	return ret;
 }
 
-struct send_context *qp_to_send_context(struct rvt_qp *qp, u8 sc5)
-{
-	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
-	struct hfi1_pportdata *ppd = dd->pport + (qp->port_num - 1);
-	u8 vl;
-
-	vl = sc_to_vlt(dd, sc5);
-	if (vl >= ppd->vls_supported && vl != 15)
-		return NULL;
-	return dd->vld[vl].sc;
-}
-
 static void verbs_pio_complete(void *arg, int code)
 {
 	struct rvt_qp *qp = (struct rvt_qp *)arg;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 8f1fde8..c736015 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -478,8 +478,6 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			u64 pbc);
 
-struct send_context *qp_to_send_context(struct rvt_qp *qp, u8 sc5);
-
 extern const enum ib_wc_opcode ib_hfi1_wc_opcode[];
 
 extern const u8 hdr_len_by_opcode[];

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
