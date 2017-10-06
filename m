From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 17/47] IB/hfi1: Remove set-but-not-used variables
Date: Fri,  6 Oct 2017 14:33:03 -0700
Message-ID: <20171006213333.6721-18-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |  4 +---
 drivers/infiniband/hw/hfi1/mad.c      |  2 --
 drivers/infiniband/hw/hfi1/ruc.c      |  9 ---------
 drivers/infiniband/hw/hfi1/sdma.c     |  2 --
 drivers/infiniband/hw/hfi1/ud.c       |  2 --
 drivers/infiniband/hw/hfi1/verbs.c    | 10 ----------
 6 files changed, 1 insertion(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 2b7144e0405e..9a829ae95bc2 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -776,7 +776,7 @@ static int complete_subctxt(struct hfi1_filedata *fd)
 static int assign_ctxt(struct hfi1_filedata *fd, unsigned long arg, u32 len)
 {
 	int ret;
-	unsigned int swmajor, swminor;
+	unsigned int swmajor;
 	struct hfi1_ctxtdata *uctxt = NULL;
 	struct hfi1_user_info uinfo;
 
@@ -796,8 +796,6 @@ static int assign_ctxt(struct hfi1_filedata *fd, unsigned long arg, u32 len)
 	if (uinfo.subctxt_cnt > HFI1_MAX_SHARED_CTXTS)
 		return -EINVAL;
 
-	swminor = uinfo.userversion & 0xffff;
-
 	/*
 	 * Acquire the mutex to protect against multiple creations of what
 	 * could be a shared base context.
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index f57d893df3e0..29da75d89a7c 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2889,7 +2889,6 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	struct _vls_dctrs *vlinfo;
 	size_t response_data_size;
 	u32 num_ports;
-	u8 num_pslm;
 	u8 lq, num_vls;
 	u8 res_lli, res_ler;
 	u64 port_mask;
@@ -2899,7 +2898,6 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	int vfi;
 
 	num_ports = be32_to_cpu(pmp->mad_hdr.attr_mod) >> 24;
-	num_pslm = hweight64(be64_to_cpu(req->port_select_mask[3]));
 	num_vls = hweight32(be32_to_cpu(req->vl_select_mask));
 	vl_select_mask = be32_to_cpu(req->vl_select_mask);
 	res_lli = (u8)(be32_to_cpu(req->resolution) & MSK_LLI) >> MSK_LLI_SFT;
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index b3291f0fde9a..d450d4d4bda3 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -825,11 +825,9 @@ static inline void hfi1_make_ruc_header_9B(struct rvt_qp *qp,
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ibport *ibp = ps->ibp;
-	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	u32 bth1 = 0;
 	u16 pkey = hfi1_get_pkey(ibp, qp->s_pkey_index);
 	u16 lrh0 = HFI1_LRH_BTH;
-	u16 slid;
 	u8 extra_bytes = -ps->s_txreq->s_cur_size & 3;
 	u32 nwords = SIZE_OF_CRC + ((ps->s_txreq->s_cur_size +
 					 extra_bytes) >> 2);
@@ -866,13 +864,6 @@ static inline void hfi1_make_ruc_header_9B(struct rvt_qp *qp,
 		bth1 |= (IB_BECN_MASK << IB_BECN_SHIFT);
 	}
 	hfi1_make_ruc_bth(qp, ohdr, bth0, bth1, bth2);
-
-	if (!ppd->lid)
-		slid = be16_to_cpu(IB_LID_PERMISSIVE);
-	else
-		slid = ppd->lid |
-			(rdma_ah_get_path_bits(&qp->remote_ah_attr) &
-			((1 << ppd->lmc) - 1));
 	hfi1_make_ib_hdr(&ps->s_txreq->phdr.hdr.ibh,
 			 lrh0,
 			 qp->s_hdrwords + nwords,
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 961507bb0391..3ba7f4ea4bc9 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -2144,7 +2144,6 @@ void sdma_dumpstate(struct sdma_engine *sde)
 
 static void dump_sdma_state(struct sdma_engine *sde)
 {
-	struct hw_sdma_desc *descq;
 	struct hw_sdma_desc *descqp;
 	u64 desc[2];
 	u64 addr;
@@ -2155,7 +2154,6 @@ static void dump_sdma_state(struct sdma_engine *sde)
 	head = sde->descq_head & sde->sdma_mask;
 	tail = sde->descq_tail & sde->sdma_mask;
 	cnt = sdma_descq_freecnt(sde);
-	descq = sde->descq;
 
 	dd_dev_err(sde->dd,
 		   "SDMA (%u) descq_head: %u descq_tail: %u freecnt: %u FLE %d\n",
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 2ba74fdd6f15..84c7dbec0c28 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -854,7 +854,6 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	int mgmt_pkey_idx = -1;
 	struct hfi1_ibport *ibp = rcd_to_iport(packet->rcd);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	struct ib_header *hdr = packet->hdr;
 	void *data = packet->payload;
 	u32 tlen = packet->tlen;
 	struct rvt_qp *qp = packet->qp;
@@ -880,7 +879,6 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		dlid_is_permissive = (dlid == permissive_lid);
 		slid_is_permissive = (slid == permissive_lid);
 	} else {
-		hdr = packet->hdr;
 		pkey = ib_bth_get_pkey(ohdr);
 		dlid_is_permissive = (dlid == be16_to_cpu(IB_LID_PERMISSIVE));
 		slid_is_permissive = (slid == be16_to_cpu(IB_LID_PERMISSIVE));
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index e232f3c608b4..8acdb5dded24 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -812,7 +812,6 @@ static int build_verbs_tx_desc(
 	int ret = 0;
 	struct hfi1_sdma_header *phdr = &tx->phdr;
 	u16 hdrbytes = tx->hdr_dwords << 2;
-	u32 *hdr;
 	u8 extra_bytes = 0;
 	static char trail_buf[12]; /* CRC = 4, LT = 1, Pad = 0 to 7 bytes */
 
@@ -823,9 +822,6 @@ static int build_verbs_tx_desc(
 		 */
 		extra_bytes = hfi1_get_16b_padding(hdrbytes - 8, length) +
 			      (SIZE_OF_CRC << 2) + SIZE_OF_LT;
-		hdr = (u32 *)&phdr->hdr.opah;
-	} else {
-		hdr = (u32 *)&phdr->hdr.ibh;
 	}
 	if (!ahg_info->ahgcount) {
 		ret = sdma_txinit_ahg(
@@ -891,14 +887,12 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	u8 sc5 = priv->s_sc;
 	int ret;
 	u32 dwords;
-	bool bypass = false;
 
 	if (ps->s_txreq->phdr.hdr.hdr_type) {
 		u8 extra_bytes = hfi1_get_16b_padding((hdrwords << 2), len);
 
 		dwords = (len + extra_bytes + (SIZE_OF_CRC << 2) +
 			  SIZE_OF_LT) >> 2;
-		bypass = true;
 	} else {
 		dwords = (len + 3) >> 2;
 	}
@@ -1033,8 +1027,6 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	int wc_status = IB_WC_SUCCESS;
 	int ret = 0;
 	pio_release_cb cb = NULL;
-	u32 lrh0_16b;
-	bool bypass = false;
 	u8 extra_bytes = 0;
 
 	if (ps->s_txreq->phdr.hdr.hdr_type) {
@@ -1043,8 +1035,6 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		extra_bytes = pad_size + (SIZE_OF_CRC << 2) + SIZE_OF_LT;
 		dwords = (len + extra_bytes) >> 2;
 		hdr = (u32 *)&ps->s_txreq->phdr.hdr.opah;
-		lrh0_16b = ps->s_txreq->phdr.hdr.opah.lrh[0];
-		bypass = true;
 	} else {
 		dwords = (len + 3) >> 2;
 		hdr = (u32 *)&ps->s_txreq->phdr.hdr.ibh;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
