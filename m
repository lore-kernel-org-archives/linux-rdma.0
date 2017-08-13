From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 8/8] IB/hfi1: Add kernel receive context info to
 debugfs
Date: Sun, 13 Aug 2017 08:09:04 -0700
Message-ID: <20170813150903.23208.22136.stgit@scvm10.sc.intel.com>
References: <20170813150659.23208.66243.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813150659.23208.66243.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c |   47 +++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/driver.c  |   59 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/hfi.h     |    1 +
 3 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 550119c..c6a472f 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -368,6 +368,52 @@ static int _sdes_seq_show(struct seq_file *s, void *v)
 DEBUGFS_SEQ_FILE_OPEN(sdes)
 DEBUGFS_FILE_OPS(sdes);
 
+static void *_rcds_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct hfi1_ibdev *ibd;
+	struct hfi1_devdata *dd;
+
+	ibd = (struct hfi1_ibdev *)s->private;
+	dd = dd_from_dev(ibd);
+	if (!dd->rcd || *pos >= dd->n_krcv_queues)
+		return NULL;
+	return pos;
+}
+
+static void *_rcds_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct hfi1_ibdev *ibd = (struct hfi1_ibdev *)s->private;
+	struct hfi1_devdata *dd = dd_from_dev(ibd);
+
+	++*pos;
+	if (!dd->rcd || *pos >= dd->n_krcv_queues)
+		return NULL;
+	return pos;
+}
+
+static void _rcds_seq_stop(struct seq_file *s, void *v)
+{
+}
+
+static int _rcds_seq_show(struct seq_file *s, void *v)
+{
+	struct hfi1_ibdev *ibd = (struct hfi1_ibdev *)s->private;
+	struct hfi1_devdata *dd = dd_from_dev(ibd);
+	struct hfi1_ctxtdata *rcd;
+	loff_t *spos = v;
+	loff_t i = *spos;
+
+	rcd = hfi1_rcd_get_by_index(dd, i);
+	if (rcd)
+		seqfile_dump_rcd(s, rcd);
+	hfi1_rcd_put(rcd);
+	return 0;
+}
+
+DEBUGFS_SEQ_FILE_OPS(rcds);
+DEBUGFS_SEQ_FILE_OPEN(rcds)
+DEBUGFS_FILE_OPS(rcds);
+
 /* read the per-device counters */
 static ssize_t dev_counters_read(struct file *file, char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -1321,6 +1367,7 @@ void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)
 	DEBUGFS_SEQ_FILE_CREATE(ctx_stats, ibd->hfi1_ibdev_dbg, ibd);
 	DEBUGFS_SEQ_FILE_CREATE(qp_stats, ibd->hfi1_ibdev_dbg, ibd);
 	DEBUGFS_SEQ_FILE_CREATE(sdes, ibd->hfi1_ibdev_dbg, ibd);
+	DEBUGFS_SEQ_FILE_CREATE(rcds, ibd->hfi1_ibdev_dbg, ibd);
 	DEBUGFS_SEQ_FILE_CREATE(sdma_cpu_list, ibd->hfi1_ibdev_dbg, ibd);
 	/* dev counter files */
 	for (i = 0; i < ARRAY_SIZE(cntr_ops); i++)
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index fc7085d..7372cc0 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1689,3 +1689,62 @@ int process_receive_invalid(struct hfi1_packet *packet)
 		   rhf_rcv_type(packet->rhf));
 	return RHF_RCV_CONTINUE;
 }
+
+void seqfile_dump_rcd(struct seq_file *s, struct hfi1_ctxtdata *rcd)
+{
+	struct hfi1_packet packet;
+	struct ps_mdata mdata;
+
+	seq_printf(s, "Rcd %u: RcvHdr cnt %u entsize %u %s head %llu tail %llu\n",
+		   rcd->ctxt, rcd->rcvhdrq_cnt, rcd->rcvhdrqentsize,
+		   HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL) ?
+		   "dma_rtail" : "nodma_rtail",
+		   read_uctxt_csr(rcd->dd, rcd->ctxt, RCV_HDR_HEAD) &
+		   RCV_HDR_HEAD_HEAD_MASK,
+		   read_uctxt_csr(rcd->dd, rcd->ctxt, RCV_HDR_TAIL));
+
+	init_packet(rcd, &packet);
+	init_ps_mdata(&mdata, &packet);
+
+	while (1) {
+		struct hfi1_devdata *dd = rcd->dd;
+		__le32 *rhf_addr = (__le32 *)rcd->rcvhdrq + mdata.ps_head +
+					 dd->rhf_offset;
+		struct ib_header *hdr;
+		u64 rhf = rhf_to_cpu(rhf_addr);
+		u32 etype = rhf_rcv_type(rhf), qpn;
+		u8 opcode;
+		u32 psn;
+		u8 lnh;
+
+		if (ps_done(&mdata, rhf, rcd))
+			break;
+
+		if (ps_skip(&mdata, rhf, rcd))
+			goto next;
+
+		if (etype > RHF_RCV_TYPE_IB)
+			goto next;
+
+		packet.hdr = hfi1_get_msgheader(dd, rhf_addr);
+		hdr = packet.hdr;
+
+		lnh = be16_to_cpu(hdr->lrh[0]) & 3;
+
+		if (lnh == HFI1_LRH_BTH)
+			packet.ohdr = &hdr->u.oth;
+		else if (lnh == HFI1_LRH_GRH)
+			packet.ohdr = &hdr->u.l.oth;
+		else
+			goto next; /* just in case */
+
+		opcode = (be32_to_cpu(packet.ohdr->bth[0]) >> 24);
+		qpn = be32_to_cpu(packet.ohdr->bth[1]) & RVT_QPN_MASK;
+		psn = mask_psn(be32_to_cpu(packet.ohdr->bth[2]));
+
+		seq_printf(s, "\tEnt %u: opcode 0x%x, qpn 0x%x, psn 0x%x\n",
+			   mdata.ps_head, opcode, qpn, psn);
+next:
+		update_ps_mdata(&mdata, rcd);
+	}
+}
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index b15749e..eadb735 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1987,6 +1987,7 @@ static inline void flush_wc(void)
 int kdeth_process_expected(struct hfi1_packet *packet);
 int kdeth_process_eager(struct hfi1_packet *packet);
 int process_receive_invalid(struct hfi1_packet *packet);
+void seqfile_dump_rcd(struct seq_file *s, struct hfi1_ctxtdata *rcd);
 
 /* global module parameter variables */
 extern unsigned int hfi1_max_mtu;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
