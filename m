From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/21] staging/rdma/hfi1: Remove space after cast
Date: Sun, 14 Feb 2016 20:19:41 -0800
Message-ID: <20160215041937.351.24156.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove the space after a cast to fix checkpatch check:
CHECK: No space is necessary after a cast

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c      |    6 ++--
 drivers/staging/rdma/hfi1/debugfs.c   |    4 +--
 drivers/staging/rdma/hfi1/dma.c       |   12 ++++----
 drivers/staging/rdma/hfi1/driver.c    |    6 ++--
 drivers/staging/rdma/hfi1/firmware.c  |    2 +
 drivers/staging/rdma/hfi1/hfi.h       |    4 +--
 drivers/staging/rdma/hfi1/mad.c       |   48 +++++++++++++++++----------------
 drivers/staging/rdma/hfi1/pcie.c      |    4 +--
 drivers/staging/rdma/hfi1/pio.c       |    2 +
 drivers/staging/rdma/hfi1/rc.c        |   14 +++++-----
 drivers/staging/rdma/hfi1/ruc.c       |    8 +++---
 drivers/staging/rdma/hfi1/sdma.c      |   10 +++----
 drivers/staging/rdma/hfi1/trace.c     |    2 +
 drivers/staging/rdma/hfi1/user_sdma.c |    2 +
 drivers/staging/rdma/hfi1/verbs.h     |    4 +--
 15 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 0a593bd..cf57865 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5436,7 +5436,7 @@ static void update_rcverr_timer(unsigned long opaque)
 			OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN);
 		queue_work(ppd->hfi1_wq, &ppd->link_bounce_work);
 	}
-	dd->rcv_ovfl_cnt = (u32) cur_ovfl_cnt;
+	dd->rcv_ovfl_cnt = (u32)cur_ovfl_cnt;
 
 	mod_timer(&dd->rcverr_timer, jiffies + HZ * RCVERR_CHECK_TIME);
 }
@@ -6366,7 +6366,7 @@ static void lcb_shutdown(struct hfi1_devdata *dd, int abort)
 		reg
 		| (1ull << DCC_CFG_RESET_RESET_LCB_SHIFT)
 		| (1ull << DCC_CFG_RESET_RESET_RX_FPE_SHIFT));
-	(void) read_csr(dd, DCC_CFG_RESET); /* make sure the write completed */
+	(void)read_csr(dd, DCC_CFG_RESET); /* make sure the write completed */
 	if (!abort) {
 		udelay(1);    /* must hold for the longer of 16cclks or 20ns */
 		write_csr(dd, DCC_CFG_RESET, reg);
@@ -13407,7 +13407,7 @@ static void init_chip(struct hfi1_devdata *dd)
 	 * across the clear.
 	 */
 	write_csr(dd, CCE_DC_CTRL, CCE_DC_CTRL_DC_RESET_SMASK);
-	(void) read_csr(dd, CCE_DC_CTRL);
+	(void)read_csr(dd, CCE_DC_CTRL);
 
 	if (use_flr) {
 		/*
diff --git a/drivers/staging/rdma/hfi1/debugfs.c b/drivers/staging/rdma/hfi1/debugfs.c
index 7cb4348..f309c5f 100644
--- a/drivers/staging/rdma/hfi1/debugfs.c
+++ b/drivers/staging/rdma/hfi1/debugfs.c
@@ -149,8 +149,8 @@ static int _opcode_stats_seq_show(struct seq_file *s, void *v)
 	if (!n_packets && !n_bytes)
 		return SEQ_SKIP;
 	seq_printf(s, "%02llx %llu/%llu\n", i,
-		(unsigned long long) n_packets,
-		(unsigned long long) n_bytes);
+		(unsigned long long)n_packets,
+		(unsigned long long)n_bytes);
 
 	return 0;
 }
diff --git a/drivers/staging/rdma/hfi1/dma.c b/drivers/staging/rdma/hfi1/dma.c
index e03bd73..afe572d 100644
--- a/drivers/staging/rdma/hfi1/dma.c
+++ b/drivers/staging/rdma/hfi1/dma.c
@@ -52,7 +52,7 @@
 
 #include "verbs.h"
 
-#define BAD_DMA_ADDRESS ((u64) 0)
+#define BAD_DMA_ADDRESS ((u64)0)
 
 /*
  * The following functions implement driver specific replacements
@@ -74,7 +74,7 @@ static u64 hfi1_dma_map_single(struct ib_device *dev, void *cpu_addr,
 	if (WARN_ON(!valid_dma_direction(direction)))
 		return BAD_DMA_ADDRESS;
 
-	return (u64) cpu_addr;
+	return (u64)cpu_addr;
 }
 
 static void hfi1_dma_unmap_single(struct ib_device *dev, u64 addr, size_t size,
@@ -95,7 +95,7 @@ static u64 hfi1_dma_map_page(struct ib_device *dev, struct page *page,
 	if (offset + size > PAGE_SIZE)
 		return BAD_DMA_ADDRESS;
 
-	addr = (u64) page_address(page);
+	addr = (u64)page_address(page);
 	if (addr)
 		addr += offset;
 
@@ -120,7 +120,7 @@ static int hfi1_map_sg(struct ib_device *dev, struct scatterlist *sgl,
 		return BAD_DMA_ADDRESS;
 
 	for_each_sg(sgl, sg, nents, i) {
-		addr = (u64) page_address(sg_page(sg));
+		addr = (u64)page_address(sg_page(sg));
 		if (!addr) {
 			ret = 0;
 			break;
@@ -161,14 +161,14 @@ static void *hfi1_dma_alloc_coherent(struct ib_device *dev, size_t size,
 	if (p)
 		addr = page_address(p);
 	if (dma_handle)
-		*dma_handle = (u64) addr;
+		*dma_handle = (u64)addr;
 	return addr;
 }
 
 static void hfi1_dma_free_coherent(struct ib_device *dev, size_t size,
 				   void *cpu_addr, u64 dma_handle)
 {
-	free_pages((unsigned long) cpu_addr, get_order(size));
+	free_pages((unsigned long)cpu_addr, get_order(size));
 }
 
 struct ib_dma_mapping_ops hfi1_dma_mapping_ops = {
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index dd5187f..6082935 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -594,7 +594,7 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 	while (1) {
 		struct hfi1_devdata *dd = rcd->dd;
 		struct hfi1_ibport *ibp = &rcd->ppd->ibport_data;
-		__le32 *rhf_addr = (__le32 *) rcd->rcvhdrq + mdata.ps_head +
+		__le32 *rhf_addr = (__le32 *)rcd->rcvhdrq + mdata.ps_head +
 					 dd->rhf_offset;
 		struct rvt_qp *qp;
 		struct hfi1_ib_header *hdr;
@@ -730,7 +730,7 @@ static inline int process_rcv_packet(struct hfi1_packet *packet, int thread)
 		}
 	}
 
-	packet->rhf_addr = (__le32 *) packet->rcd->rcvhdrq + packet->rhqoff +
+	packet->rhf_addr = (__le32 *)packet->rcd->rcvhdrq + packet->rhqoff +
 				      packet->rcd->dd->rhf_offset;
 	packet->rhf = rhf_to_cpu(packet->rhf_addr);
 
@@ -969,7 +969,7 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 
 			/* On to the next packet */
 			packet.rhqoff += packet.rsize;
-			packet.rhf_addr = (__le32 *) rcd->rcvhdrq +
+			packet.rhf_addr = (__le32 *)rcd->rcvhdrq +
 					  packet.rhqoff +
 					  dd->rhf_offset;
 			packet.rhf = rhf_to_cpu(packet.rhf_addr);
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index f87460d..31550a3 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -1838,7 +1838,7 @@ void read_guid(struct hfi1_devdata *dd)
 {
 	/* Take the DC out of reset to get a valid GUID value */
 	write_csr(dd, CCE_DC_CTRL, 0);
-	(void) read_csr(dd, CCE_DC_CTRL);
+	(void)read_csr(dd, CCE_DC_CTRL);
 
 	dd->base_guid = read_csr(dd, DC_DC8051_CFG_LOCAL_GUID);
 	dd_dev_info(dd, "GUID %llx",
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 347ceca..de82f8e 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1668,7 +1668,7 @@ void hfi1_release_user_pages(struct page **, size_t, bool);
 
 static inline void clear_rcvhdrtail(const struct hfi1_ctxtdata *rcd)
 {
-	*((u64 *) rcd->rcvhdrtail_kvaddr) = 0ULL;
+	*((u64 *)rcd->rcvhdrtail_kvaddr) = 0ULL;
 }
 
 static inline u32 get_rcvhdrtail(const struct hfi1_ctxtdata *rcd)
@@ -1677,7 +1677,7 @@ static inline u32 get_rcvhdrtail(const struct hfi1_ctxtdata *rcd)
 	 * volatile because it's a DMA target from the chip, routine is
 	 * inlined, and don't want register caching or reordering.
 	 */
-	return (u32) le64_to_cpu(*rcd->rcvhdrtail_kvaddr);
+	return (u32)le64_to_cpu(*rcd->rcvhdrtail_kvaddr);
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index b687e3f..a56d7dc 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -744,7 +744,7 @@ static int __subn_get_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
 		return reply((struct ib_mad_hdr *)smp);
 	}
 
-	n_blocks_avail = (u16) (npkeys / OPA_PARTITION_TABLE_BLK_SIZE) + 1;
+	n_blocks_avail = (u16)(npkeys / OPA_PARTITION_TABLE_BLK_SIZE) + 1;
 
 	size = (n_blocks_req * OPA_PARTITION_TABLE_BLK_SIZE) * sizeof(u16);
 
@@ -758,7 +758,7 @@ static int __subn_get_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
 		return reply((struct ib_mad_hdr *)smp);
 	}
 
-	p = (__be16 *) data;
+	p = (__be16 *)data;
 	q = (u16 *)data;
 	/* get the real pkeys if we are requesting the first block */
 	if (start_block == 0) {
@@ -1406,7 +1406,7 @@ static int __subn_set_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	u32 n_blocks_sent = OPA_AM_NBLK(am);
 	u32 start_block = am & 0x7ff;
-	u16 *p = (u16 *) data;
+	u16 *p = (u16 *)data;
 	__be16 *q = (__be16 *)data;
 	int i;
 	u16 n_blocks_avail;
@@ -1586,7 +1586,7 @@ static int __subn_get_opa_sc_to_vlt(struct opa_smp *smp, u32 am, u8 *data,
 {
 	u32 n_blocks = OPA_AM_NBLK(am);
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	void *vp = (void *) data;
+	void *vp = (void *)data;
 	size_t size = 4 * sizeof(u64);
 
 	if (n_blocks != 1) {
@@ -1609,7 +1609,7 @@ static int __subn_set_opa_sc_to_vlt(struct opa_smp *smp, u32 am, u8 *data,
 	u32 n_blocks = OPA_AM_NBLK(am);
 	int async_update = OPA_AM_ASYNC(am);
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	void *vp = (void *) data;
+	void *vp = (void *)data;
 	struct hfi1_pportdata *ppd;
 	int lstate;
 
@@ -1641,7 +1641,7 @@ static int __subn_get_opa_sc_to_vlnt(struct opa_smp *smp, u32 am, u8 *data,
 	u32 n_blocks = OPA_AM_NPORT(am);
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	struct hfi1_pportdata *ppd;
-	void *vp = (void *) data;
+	void *vp = (void *)data;
 	int size;
 
 	if (n_blocks != 1) {
@@ -1666,7 +1666,7 @@ static int __subn_set_opa_sc_to_vlnt(struct opa_smp *smp, u32 am, u8 *data,
 	u32 n_blocks = OPA_AM_NPORT(am);
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	struct hfi1_pportdata *ppd;
-	void *vp = (void *) data;
+	void *vp = (void *)data;
 	int lstate;
 
 	if (n_blocks != 1) {
@@ -1699,7 +1699,7 @@ static int __subn_get_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
 	u32 lstate;
 	struct hfi1_ibport *ibp;
 	struct hfi1_pportdata *ppd;
-	struct opa_port_state_info *psi = (struct opa_port_state_info *) data;
+	struct opa_port_state_info *psi = (struct opa_port_state_info *)data;
 
 	if (nports != 1) {
 		smp->status |= IB_SMP_INVALID_FIELD;
@@ -1748,7 +1748,7 @@ static int __subn_set_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
 	u8 ls_new, ps_new;
 	struct hfi1_ibport *ibp;
 	struct hfi1_pportdata *ppd;
-	struct opa_port_state_info *psi = (struct opa_port_state_info *) data;
+	struct opa_port_state_info *psi = (struct opa_port_state_info *)data;
 	int ret, invalid = 0;
 
 	if (nports != 1) {
@@ -1834,7 +1834,7 @@ static int __subn_get_opa_bct(struct opa_smp *smp, u32 am, u8 *data,
 	u32 num_ports = OPA_AM_NPORT(am);
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	struct hfi1_pportdata *ppd;
-	struct buffer_control *p = (struct buffer_control *) data;
+	struct buffer_control *p = (struct buffer_control *)data;
 	int size;
 
 	if (num_ports != 1) {
@@ -1857,7 +1857,7 @@ static int __subn_set_opa_bct(struct opa_smp *smp, u32 am, u8 *data,
 	u32 num_ports = OPA_AM_NPORT(am);
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	struct hfi1_pportdata *ppd;
-	struct buffer_control *p = (struct buffer_control *) data;
+	struct buffer_control *p = (struct buffer_control *)data;
 
 	if (num_ports != 1) {
 		smp->status |= IB_SMP_INVALID_FIELD;
@@ -1930,10 +1930,10 @@ static int __subn_set_opa_vl_arb(struct opa_smp *smp, u32 am, u8 *data,
 
 	switch (section) {
 	case OPA_VLARB_LOW_ELEMENTS:
-		(void) fm_set_table(ppd, FM_TBL_VL_LOW_ARB, p);
+		(void)fm_set_table(ppd, FM_TBL_VL_LOW_ARB, p);
 		break;
 	case OPA_VLARB_HIGH_ELEMENTS:
-		(void) fm_set_table(ppd, FM_TBL_VL_HIGH_ARB, p);
+		(void)fm_set_table(ppd, FM_TBL_VL_HIGH_ARB, p);
 		break;
 	/* neither OPA_VLARB_PREEMPT_ELEMENTS, or OPA_VLARB_PREEMPT_MATRIX
 	 * can be changed from the default values */
@@ -2522,7 +2522,7 @@ static void a0_datacounters(struct hfi1_pportdata *ppd, struct _port_dctrs *rsp,
 						 idx_from_vl(vl));
 			if (tmp < sum_vl_xmit_wait) {
 				/* we wrapped */
-				sum_vl_xmit_wait = (u64) ~0;
+				sum_vl_xmit_wait = (u64)~0;
 				break;
 			}
 			sum_vl_xmit_wait = tmp;
@@ -3287,7 +3287,7 @@ static int __subn_get_opa_cong_setting(struct opa_smp *smp, u32 am,
 {
 	int i;
 	struct opa_congestion_setting_attr *p =
-		(struct opa_congestion_setting_attr *) data;
+		(struct opa_congestion_setting_attr *)data;
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct opa_congestion_setting_entry_shadow *entries;
@@ -3326,7 +3326,7 @@ static int __subn_set_opa_cong_setting(struct opa_smp *smp, u32 am, u8 *data,
 				       u32 *resp_len)
 {
 	struct opa_congestion_setting_attr *p =
-		(struct opa_congestion_setting_attr *) data;
+		(struct opa_congestion_setting_attr *)data;
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct opa_congestion_setting_entry_shadow *entries;
@@ -3418,7 +3418,7 @@ static int __subn_get_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
 				   u32 *resp_len)
 {
 	struct ib_cc_table_attr *cc_table_attr =
-		(struct ib_cc_table_attr *) data;
+		(struct ib_cc_table_attr *)data;
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	u32 start_block = OPA_AM_START_BLK(am);
@@ -3475,7 +3475,7 @@ static int __subn_set_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
 				   struct ib_device *ibdev, u8 port,
 				   u32 *resp_len)
 {
-	struct ib_cc_table_attr *p = (struct ib_cc_table_attr *) data;
+	struct ib_cc_table_attr *p = (struct ib_cc_table_attr *)data;
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	u32 start_block = OPA_AM_START_BLK(am);
@@ -3559,7 +3559,7 @@ static int __subn_get_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 				   u32 *resp_len)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	struct opa_led_info *p = (struct opa_led_info *) data;
+	struct opa_led_info *p = (struct opa_led_info *)data;
 	u32 nport = OPA_AM_NPORT(am);
 	u64 reg;
 
@@ -3584,7 +3584,7 @@ static int __subn_set_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 				   u32 *resp_len)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	struct opa_led_info *p = (struct opa_led_info *) data;
+	struct opa_led_info *p = (struct opa_led_info *)data;
 	u32 nport = OPA_AM_NPORT(am);
 	int on = !!(be32_to_cpu(p->rsvd_led_mask) & OPA_LED_MASK);
 
@@ -3800,7 +3800,7 @@ static int subn_get_opa_aggregate(struct opa_smp *smp,
 		/* zero the payload for this segment */
 		memset(next_smp + sizeof(*agg), 0, agg_data_len);
 
-		(void) subn_get_opa_sma(agg->attr_id, smp, am, agg->data,
+		(void)subn_get_opa_sma(agg->attr_id, smp, am, agg->data,
 					ibdev, port, NULL);
 		if (smp->status & ~IB_SMP_DIRECTION) {
 			set_aggr_error(agg);
@@ -3844,7 +3844,7 @@ static int subn_set_opa_aggregate(struct opa_smp *smp,
 			return reply((struct ib_mad_hdr *)smp);
 		}
 
-		(void) subn_set_opa_sma(agg->attr_id, smp, am, agg->data,
+		(void)subn_set_opa_sma(agg->attr_id, smp, am, agg->data,
 					ibdev, port, NULL);
 		if (smp->status & ~IB_SMP_DIRECTION) {
 			set_aggr_error(agg);
@@ -3989,7 +3989,7 @@ static int process_subn_opa(struct ib_device *ibdev, int mad_flags,
 		     smp->method == IB_MGMT_METHOD_SET) &&
 		    port_num && port_num <= ibdev->phys_port_cnt &&
 		    port != port_num)
-			(void) check_mkey(to_iport(ibdev, port_num),
+			(void)check_mkey(to_iport(ibdev, port_num),
 					  (struct ib_mad_hdr *)smp, 0,
 					  smp->mkey, smp->route.dr.dr_slid,
 					  smp->route.dr.return_path,
@@ -4079,7 +4079,7 @@ static int process_subn(struct ib_device *ibdev, int mad_flags,
 		     smp->method == IB_MGMT_METHOD_SET) &&
 		    port_num && port_num <= ibdev->phys_port_cnt &&
 		    port != port_num)
-			(void) check_mkey(to_iport(ibdev, port_num),
+			(void)check_mkey(to_iport(ibdev, port_num),
 					  (struct ib_mad_hdr *)smp, 0,
 					  smp->mkey,
 					  (__force __be32)smp->dr_slid,
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 26eb610..0368516 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -233,7 +233,7 @@ int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev,
  */
 void hfi1_pcie_ddcleanup(struct hfi1_devdata *dd)
 {
-	u64 __iomem *base = (void __iomem *) dd->kregbase;
+	u64 __iomem *base = (void __iomem *)dd->kregbase;
 
 	dd->flags &= ~HFI1_PRESENT;
 	dd->kregbase = NULL;
@@ -1188,7 +1188,7 @@ retry:
 	/* step 5h: arm gasket logic */
 	/* hold DC in reset across the SBR */
 	write_csr(dd, CCE_DC_CTRL, CCE_DC_CTRL_DC_RESET_SMASK);
-	(void) read_csr(dd, CCE_DC_CTRL); /* DC reset hold */
+	(void)read_csr(dd, CCE_DC_CTRL); /* DC reset hold */
 	/* save firmware control across the SBR */
 	fw_ctrl = read_csr(dd, MISC_CFG_FW_CTRL);
 
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index f1f30b3..3817731 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -130,7 +130,7 @@ void pio_send_control(struct hfi1_devdata *dd, int op)
 	if (write) {
 		write_csr(dd, SEND_CTRL, reg);
 		if (flush)
-			(void) read_csr(dd, SEND_CTRL); /* flush write */
+			(void)read_csr(dd, SEND_CTRL); /* flush write */
 	}
 
 	spin_unlock_irqrestore(&dd->sendctrl_lock, flags);
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 5cdf1d2..24f2b65 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1610,7 +1610,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 		if (opcode == OP(ATOMIC_ACKNOWLEDGE)) {
 			__be32 *p = ohdr->u.at.atomic_ack_eth;
 
-			val = ((u64) be32_to_cpu(p[0]) << 32) |
+			val = ((u64)be32_to_cpu(p[0]) << 32) |
 				be32_to_cpu(p[1]);
 		} else
 			val = 0;
@@ -1708,7 +1708,7 @@ read_last:
 		aeth = be32_to_cpu(ohdr->u.aeth);
 		hfi1_copy_sge(&qp->s_rdma_read_sge, data, tlen, 0, 0);
 		WARN_ON(qp->s_rdma_read_sge.num_sge);
-		(void) do_rc_ack(qp, aeth, psn,
+		(void)do_rc_ack(qp, aeth, psn,
 				 OP(RDMA_READ_RESPONSE_LAST), 0, rcd);
 		goto ack_done;
 	}
@@ -1906,7 +1906,7 @@ static noinline int rc_rcv_error(struct hfi1_other_headers *ohdr, void *data,
 		 * or the send tasklet is already backed up to send an
 		 * earlier entry, we can ignore this request.
 		 */
-		if (!e || e->opcode != (u8) opcode || old_req)
+		if (!e || e->opcode != (u8)opcode || old_req)
 			goto unlock_done;
 		qp->s_tail_ack_queue = prev;
 		break;
@@ -2430,7 +2430,7 @@ send_last:
 			e->rdma_sge.mr = NULL;
 		}
 		ateth = &ohdr->u.atomic_eth;
-		vaddr = ((u64) be32_to_cpu(ateth->vaddr[0]) << 32) |
+		vaddr = ((u64)be32_to_cpu(ateth->vaddr[0]) << 32) |
 			be32_to_cpu(ateth->vaddr[1]);
 		if (unlikely(vaddr & (sizeof(u64) - 1)))
 			goto nack_inv_unlck;
@@ -2441,11 +2441,11 @@ send_last:
 					  IB_ACCESS_REMOTE_ATOMIC)))
 			goto nack_acc_unlck;
 		/* Perform atomic OP and save result. */
-		maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
+		maddr = (atomic64_t *)qp->r_sge.sge.vaddr;
 		sdata = be64_to_cpu(ateth->swap_data);
 		e->atomic_data = (opcode == OP(FETCH_ADD)) ?
-			(u64) atomic64_add_return(sdata, maddr) - sdata :
-			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
+			(u64)atomic64_add_return(sdata, maddr) - sdata :
+			(u64)cmpxchg((u64 *)qp->r_sge.sge.vaddr,
 				      be64_to_cpu(ateth->compare_data),
 				      sdata);
 		rvt_put_mr(qp->r_sge.sge.mr);
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 70f42c9..6f0005a 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -508,12 +508,12 @@ do_write:
 					  IB_ACCESS_REMOTE_ATOMIC)))
 			goto acc_err;
 		/* Perform atomic OP and save result. */
-		maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
+		maddr = (atomic64_t *)qp->r_sge.sge.vaddr;
 		sdata = wqe->atomic_wr.compare_add;
-		*(u64 *) sqp->s_sge.sge.vaddr =
+		*(u64 *)sqp->s_sge.sge.vaddr =
 			(wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD) ?
-			(u64) atomic64_add_return(sdata, maddr) - sdata :
-			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
+			(u64)atomic64_add_return(sdata, maddr) - sdata :
+			(u64)cmpxchg((u64 *)qp->r_sge.sge.vaddr,
 				      sdata, wqe->atomic_wr.swap);
 		rvt_put_mr(qp->r_sge.sge.mr);
 		qp->r_sge.num_sge = 0;
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 122b390..3312324 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -534,7 +534,7 @@ static void sdma_err_progress_check(unsigned long data)
 
 static void sdma_hw_clean_up_task(unsigned long opaque)
 {
-	struct sdma_engine *sde = (struct sdma_engine *) opaque;
+	struct sdma_engine *sde = (struct sdma_engine *)opaque;
 	u64 statuscsr;
 
 	while (1) {
@@ -594,7 +594,7 @@ static void sdma_flush_descq(struct sdma_engine *sde)
 
 static void sdma_sw_clean_up_task(unsigned long opaque)
 {
-	struct sdma_engine *sde = (struct sdma_engine *) opaque;
+	struct sdma_engine *sde = (struct sdma_engine *)opaque;
 	unsigned long flags;
 
 	spin_lock_irqsave(&sde->tail_lock, flags);
@@ -1346,8 +1346,8 @@ retry:
 	use_dmahead = HFI1_CAP_IS_KSET(USE_SDMA_HEAD) && __sdma_running(sde) &&
 					(dd->flags & HFI1_HAS_SDMA_TIMEOUT);
 	hwhead = use_dmahead ?
-		(u16) le64_to_cpu(*sde->head_dma) :
-		(u16) read_sde_csr(sde, SD(HEAD));
+		(u16)le64_to_cpu(*sde->head_dma) :
+		(u16)read_sde_csr(sde, SD(HEAD));
 
 	if (unlikely(HFI1_CAP_IS_KSET(SDMA_HEAD_CHECK))) {
 		u16 cnt;
@@ -3022,7 +3022,7 @@ void sdma_freeze(struct hfi1_devdata *dd)
 	 * software clean will read engine CSRs, so must be completed before
 	 * the next step, which will clear the engine CSRs.
 	 */
-	(void) wait_event_interruptible(dd->sdma_unfreeze_wq,
+	(void)wait_event_interruptible(dd->sdma_unfreeze_wq,
 				atomic_read(&dd->sdma_unfreeze_count) <= 0);
 	/* no need to check results - done no matter what */
 }
diff --git a/drivers/staging/rdma/hfi1/trace.c b/drivers/staging/rdma/hfi1/trace.c
index 9eadec5..923ca55 100644
--- a/drivers/staging/rdma/hfi1/trace.c
+++ b/drivers/staging/rdma/hfi1/trace.c
@@ -158,7 +158,7 @@ const char *parse_everbs_hdrs(
 			eh->atomic_eth.rkey,
 			(unsigned long long)ib_u64_get(
 				(__be32 *)&eh->atomic_eth.swap_data),
-			(unsigned long long) ib_u64_get(
+			(unsigned long long)ib_u64_get(
 				 (__be32 *)&eh->atomic_eth.compare_data));
 		break;
 	/* deth */
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 9fe18b0..03a10c8 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -1030,7 +1030,7 @@ free_tx:
  */
 static inline int num_user_pages(const struct iovec *iov)
 {
-	const unsigned long addr  = (unsigned long) iov->iov_base;
+	const unsigned long addr  = (unsigned long)iov->iov_base;
 	const unsigned long len   = iov->iov_len;
 	const unsigned long spage = addr & PAGE_MASK;
 	const unsigned long epage = (addr + len - 1) & PAGE_MASK;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index c736015..dc623c6 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -346,7 +346,7 @@ int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
  */
 static inline int cmp_msn(u32 a, u32 b)
 {
-	return (((int) a) - ((int) b)) << 8;
+	return (((int)a) - ((int)b)) << 8;
 }
 
 /*
@@ -355,7 +355,7 @@ static inline int cmp_msn(u32 a, u32 b)
  */
 static inline int cmp_psn(u32 a, u32 b)
 {
-	return (((int) a) - ((int) b)) << PSN_SHIFT;
+	return (((int)a) - ((int)b)) << PSN_SHIFT;
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
