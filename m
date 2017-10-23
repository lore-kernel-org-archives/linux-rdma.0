From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 4/7] IB/hfi1: Add tx_opcode_stats like the
 opcode_stats
Date: Mon, 23 Oct 2017 06:06:08 -0700
Message-ID: <20171023130605.21191.63445.stgit@scvm10.sc.intel.com>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023125327.21191.31462.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds tx_opcode_stats to parallel the
(rx)opcode_stats in the debugfs.

Reviewed-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c |   56 ++++++++++++++++++++++++++++++----
 drivers/infiniband/hw/hfi1/hfi.h     |    6 ++--
 drivers/infiniband/hw/hfi1/init.c    |    7 ++++
 drivers/infiniband/hw/hfi1/verbs.c   |   24 +++++++++++++++
 4 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 24128f4..76157cc 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -165,6 +165,17 @@ static void _opcode_stats_seq_stop(struct seq_file *s, void *v)
 {
 }
 
+static int opcode_stats_show(struct seq_file *s, u8 i, u64 packets, u64 bytes)
+{
+	if (!packets && !bytes)
+		return SEQ_SKIP;
+	seq_printf(s, "%02x %llu/%llu\n", i,
+		   (unsigned long long)packets,
+		   (unsigned long long)bytes);
+
+	return 0;
+}
+
 static int _opcode_stats_seq_show(struct seq_file *s, void *v)
 {
 	loff_t *spos = v;
@@ -182,19 +193,49 @@ static int _opcode_stats_seq_show(struct seq_file *s, void *v)
 		}
 		hfi1_rcd_put(rcd);
 	}
-	if (!n_packets && !n_bytes)
-		return SEQ_SKIP;
-	seq_printf(s, "%02llx %llu/%llu\n", i,
-		   (unsigned long long)n_packets,
-		   (unsigned long long)n_bytes);
-
-	return 0;
+	return opcode_stats_show(s, i, n_packets, n_bytes);
 }
 
 DEBUGFS_SEQ_FILE_OPS(opcode_stats);
 DEBUGFS_SEQ_FILE_OPEN(opcode_stats)
 DEBUGFS_FILE_OPS(opcode_stats);
 
+static void *_tx_opcode_stats_seq_start(struct seq_file *s, loff_t *pos)
+{
+	return _opcode_stats_seq_start(s, pos);
+}
+
+static void *_tx_opcode_stats_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	return _opcode_stats_seq_next(s, v, pos);
+}
+
+static void _tx_opcode_stats_seq_stop(struct seq_file *s, void *v)
+{
+}
+
+static int _tx_opcode_stats_seq_show(struct seq_file *s, void *v)
+{
+	loff_t *spos = v;
+	loff_t i = *spos;
+	int j;
+	u64 n_packets = 0, n_bytes = 0;
+	struct hfi1_ibdev *ibd = (struct hfi1_ibdev *)s->private;
+	struct hfi1_devdata *dd = dd_from_dev(ibd);
+
+	for_each_possible_cpu(j) {
+		struct hfi1_opcode_stats_perctx *s =
+			per_cpu_ptr(dd->tx_opstats, j);
+		n_packets += s->stats[i].n_packets;
+		n_bytes += s->stats[i].n_bytes;
+	}
+	return opcode_stats_show(s, i, n_packets, n_bytes);
+}
+
+DEBUGFS_SEQ_FILE_OPS(tx_opcode_stats);
+DEBUGFS_SEQ_FILE_OPEN(tx_opcode_stats)
+DEBUGFS_FILE_OPS(tx_opcode_stats);
+
 static void *_ctx_stats_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct hfi1_ibdev *ibd = (struct hfi1_ibdev *)s->private;
@@ -1363,6 +1404,7 @@ void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)
 		return;
 	}
 	DEBUGFS_SEQ_FILE_CREATE(opcode_stats, ibd->hfi1_ibdev_dbg, ibd);
+	DEBUGFS_SEQ_FILE_CREATE(tx_opcode_stats, ibd->hfi1_ibdev_dbg, ibd);
 	DEBUGFS_SEQ_FILE_CREATE(ctx_stats, ibd->hfi1_ibdev_dbg, ibd);
 	DEBUGFS_SEQ_FILE_CREATE(qp_stats, ibd->hfi1_ibdev_dbg, ibd);
 	DEBUGFS_SEQ_FILE_CREATE(sdes, ibd->hfi1_ibdev_dbg, ibd);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 2f3c830..ac3c8be 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -164,9 +164,7 @@ struct hfi1_ib_stats {
  * Below contains all data related to a single context (formerly called port).
  */
 
-#ifdef CONFIG_DEBUG_FS
 struct hfi1_opcode_stats_perctx;
-#endif
 
 struct ctxt_eager_bufs {
 	ssize_t size;            /* total size of eager buffers */
@@ -283,7 +281,7 @@ struct hfi1_ctxtdata {
 	u64 imask;	/* clear interrupt mask */
 	int ireg;	/* clear interrupt register */
 	unsigned numa_id; /* numa node of this context */
-	/* verbs stats per CTX */
+	/* verbs rx_stats per rcd */
 	struct hfi1_opcode_stats_perctx *opstats;
 
 	/* Is ASPM interrupt supported for this context */
@@ -1276,6 +1274,8 @@ struct hfi1_devdata {
 	/* receive context data */
 	struct hfi1_ctxtdata **rcd;
 	u64 __percpu *int_counter;
+	/* verbs tx opcode stats */
+	struct hfi1_opcode_stats_perctx __percpu *tx_opstats;
 	/* device (not port) flags, basically device capabilities */
 	u16 flags;
 	/* Number of physical ports available */
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 36c8a4a..8c2c432 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1217,6 +1217,7 @@ static void __hfi1_free_devdata(struct kobject *kobj)
 	free_percpu(dd->int_counter);
 	free_percpu(dd->rcv_limit);
 	free_percpu(dd->send_schedule);
+	free_percpu(dd->tx_opstats);
 	rvt_dealloc_device(&dd->verbs_dev.rdi);
 }
 
@@ -1306,6 +1307,12 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 		goto bail;
 	}
 
+	dd->tx_opstats = alloc_percpu(struct hfi1_opcode_stats_perctx);
+	if (!dd->tx_opstats) {
+		ret = -ENOMEM;
+		goto bail;
+	}
+
 	kobject_init(&dd->kobj, &hfi1_devdata_type);
 	return dd;
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 726c064..60176a5 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -796,6 +796,27 @@ static noinline int build_verbs_ulp_payload(
 	return ret;
 }
 
+/**
+ * update_tx_opstats - record stats by opcode
+ * @qp; the qp
+ * @ps: transmit packet state
+ * @plen: the plen in dwords
+ *
+ * This is a routine to record the tx opstats after a
+ * packet has been presented to the egress mechanism.
+ */
+static void update_tx_opstats(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
+			      u32 plen)
+{
+#ifdef CONFIG_DEBUG_FS
+	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+	struct hfi1_opcode_stats_perctx *s = get_cpu_ptr(dd->tx_opstats);
+
+	inc_opstats(plen * 4, &s->stats[ps->opcode]);
+	put_cpu_ptr(s);
+#endif
+}
+
 /*
  * Build the number of DMA descriptors needed to send length bytes of data.
  *
@@ -940,6 +961,8 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			goto bail_ecomm;
 		return ret;
 	}
+
+	update_tx_opstats(qp, ps, plen);
 	trace_sdma_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
 				&ps->s_txreq->phdr.hdr, ib_is_sc5(sc5));
 	return ret;
@@ -1137,6 +1160,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		seg_pio_copy_end(pbuf);
 	}
 
+	update_tx_opstats(qp, ps, plen);
 	trace_pio_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
 			       &ps->s_txreq->phdr.hdr, ib_is_sc5(sc5));
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
