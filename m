From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 11/27] IB/hfi1: Remove hfi1 MR and hfi1 specific qp type
Date: Sat, 09 Jan 2016 07:17:39 -0800
Message-ID: <20160109151738.30800.38259.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does the actual removal of the queue pair from the hfi1 driver
along with a number of dependent data structures. These were moved to rvt.

It also removes the MR functions to use those in rdmavt.

These two pieces can not reasonably be split apart becuase they depend on
each other.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Makefile      |    2 
 drivers/staging/rdma/hfi1/cq.c          |    2 
 drivers/staging/rdma/hfi1/diag.c        |   10 -
 drivers/staging/rdma/hfi1/driver.c      |   10 -
 drivers/staging/rdma/hfi1/hfi.h         |   24 +-
 drivers/staging/rdma/hfi1/keys.c        |  356 -----------------------
 drivers/staging/rdma/hfi1/mmap.c        |   24 +-
 drivers/staging/rdma/hfi1/mr.c          |  473 -------------------------------
 drivers/staging/rdma/hfi1/pio.c         |    4 
 drivers/staging/rdma/hfi1/qp.c          |   86 +++---
 drivers/staging/rdma/hfi1/qp.h          |   36 +-
 drivers/staging/rdma/hfi1/rc.c          |  112 ++++---
 drivers/staging/rdma/hfi1/ruc.c         |   92 +++---
 drivers/staging/rdma/hfi1/sdma.h        |    6 
 drivers/staging/rdma/hfi1/srq.c         |   28 +-
 drivers/staging/rdma/hfi1/trace.h       |   22 +
 drivers/staging/rdma/hfi1/uc.c          |   10 -
 drivers/staging/rdma/hfi1/ud.c          |   18 +
 drivers/staging/rdma/hfi1/verbs.c       |  141 ++++-----
 drivers/staging/rdma/hfi1/verbs.h       |  377 +++----------------------
 drivers/staging/rdma/hfi1/verbs_mcast.c |    8 -
 21 files changed, 354 insertions(+), 1487 deletions(-)
 delete mode 100644 drivers/staging/rdma/hfi1/keys.c
 delete mode 100644 drivers/staging/rdma/hfi1/mr.c

diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/staging/rdma/hfi1/Makefile
index 2126b8b..3ba64fe 100644
--- a/drivers/staging/rdma/hfi1/Makefile
+++ b/drivers/staging/rdma/hfi1/Makefile
@@ -8,7 +8,7 @@
 obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 
 hfi1-y := chip.o cq.o device.o diag.o driver.o eprom.o file_ops.o firmware.o \
-	init.o intr.o keys.o mad.o mmap.o mr.o pcie.o pio.o pio_copy.o \
+	init.o intr.o mad.o mmap.o pcie.o pio.o pio_copy.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o srq.o sysfs.o trace.o twsi.o \
 	uc.o ud.o user_pages.o user_sdma.o verbs_mcast.o verbs.o
 hfi1-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/staging/rdma/hfi1/cq.c b/drivers/staging/rdma/hfi1/cq.c
index 4f046ff..ffd0e7a 100644
--- a/drivers/staging/rdma/hfi1/cq.c
+++ b/drivers/staging/rdma/hfi1/cq.c
@@ -479,7 +479,7 @@ int hfi1_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 
 	if (cq->ip) {
 		struct hfi1_ibdev *dev = to_idev(ibcq->device);
-		struct hfi1_mmap_info *ip = cq->ip;
+		struct rvt_mmap_info *ip = cq->ip;
 
 		hfi1_update_mmap_info(dev, ip, sz, wc);
 
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 5548d2a..4622368 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1618,8 +1618,8 @@ int snoop_recv_handler(struct hfi1_packet *packet)
 /*
  * Handle snooping and capturing packets when sdma is being used.
  */
-int snoop_send_dma_handler(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
-			   u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
+int snoop_send_dma_handler(struct rvt_qp *qp, struct ahg_ib_header *ibhdr,
+			   u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			   u32 plen, u32 dwords, u64 pbc)
 {
 	pr_alert("Snooping/Capture of  Send DMA Packets Is Not Supported!\n");
@@ -1633,8 +1633,8 @@ int snoop_send_dma_handler(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
  * bypass packets. The only way to send a bypass packet currently is to use the
  * diagpkt interface. When that interface is enable snoop/capture is not.
  */
-int snoop_send_pio_handler(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
-			   u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
+int snoop_send_pio_handler(struct rvt_qp *qp, struct ahg_ib_header *ahdr,
+			   u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			   u32 plen, u32 dwords, u64 pbc)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
@@ -1642,7 +1642,7 @@ int snoop_send_pio_handler(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
 	struct snoop_packet *s_packet = NULL;
 	u32 *hdr = (u32 *)&ahdr->ibh;
 	u32 length = 0;
-	struct hfi1_sge_state temp_ss;
+	struct rvt_sge_state temp_ss;
 	void *data = NULL;
 	void *data_start = NULL;
 	int ret;
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index d51a273..924b10d 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -318,7 +318,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 		/* Get the destination QP number. */
 		qp_num = be32_to_cpu(ohdr->bth[1]) & HFI1_QPN_MASK;
 		if (lid < be16_to_cpu(IB_MULTICAST_LID_BASE)) {
-			struct hfi1_qp *qp;
+			struct rvt_qp *qp;
 			unsigned long flags;
 
 			rcu_read_lock();
@@ -387,7 +387,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			 * Only in pre-B0 h/w is the CNP_OPCODE handled
 			 * via this code path (errata 291394).
 			 */
-			struct hfi1_qp *qp = NULL;
+			struct rvt_qp *qp = NULL;
 			u32 lqpn, rqpn;
 			u16 rlid;
 			u8 svc_type, sl, sc5;
@@ -456,7 +456,7 @@ static void prescan_rxq(struct hfi1_packet *packet) {}
 #else /* CONFIG_PRESCAN_RXQ */
 static int prescan_receive_queue;
 
-static void process_ecn(struct hfi1_qp *qp, struct hfi1_ib_header *hdr,
+static void process_ecn(struct rvt_qp *qp, struct hfi1_ib_header *hdr,
 			struct hfi1_other_headers *ohdr,
 			u64 rhf, struct ib_grh *grh)
 {
@@ -583,7 +583,7 @@ static void prescan_rxq(struct hfi1_packet *packet)
 		struct hfi1_ibport *ibp = &rcd->ppd->ibport_data;
 		__le32 *rhf_addr = (__le32 *) rcd->rcvhdrq + mdata.ps_head +
 					 dd->rhf_offset;
-		struct hfi1_qp *qp;
+		struct rvt_qp *qp;
 		struct hfi1_ib_header *hdr;
 		struct hfi1_other_headers *ohdr;
 		struct ib_grh *grh = NULL;
@@ -727,7 +727,7 @@ static inline void process_rcv_qp_work(struct hfi1_packet *packet)
 {
 
 	struct hfi1_ctxtdata *rcd;
-	struct hfi1_qp *qp, *nqp;
+	struct rvt_qp *qp, *nqp;
 
 	rcd = packet->rcd;
 	rcd->head = packet->rhqoff;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index c2f7bd0..b340825 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -329,7 +329,7 @@ struct hfi1_packet {
 	void *hdr;
 	struct hfi1_ctxtdata *rcd;
 	__le32 *rhf_addr;
-	struct hfi1_qp *qp;
+	struct rvt_qp *qp;
 	struct hfi1_other_headers *ohdr;
 	u64 rhf;
 	u32 maxcnt;
@@ -369,7 +369,7 @@ struct hfi1_snoop_data {
 #define HFI1_PORT_SNOOP_MODE     1U
 #define HFI1_PORT_CAPTURE_MODE   2U
 
-struct hfi1_sge_state;
+struct rvt_sge_state;
 
 /*
  * Get/Set IB link-level config parameters for f_get/set_ib_cfg()
@@ -1062,11 +1062,11 @@ struct hfi1_devdata {
 	 * Handlers for outgoing data so that snoop/capture does not
 	 * have to have its hooks in the send path
 	 */
-	int (*process_pio_send)(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
-				u32 hdrwords, struct hfi1_sge_state *ss,
+	int (*process_pio_send)(struct rvt_qp *qp, struct ahg_ib_header *ibhdr,
+				u32 hdrwords, struct rvt_sge_state *ss,
 				u32 len, u32 plen, u32 dwords, u64 pbc);
-	int (*process_dma_send)(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
-				u32 hdrwords, struct hfi1_sge_state *ss,
+	int (*process_dma_send)(struct rvt_qp *qp, struct ahg_ib_header *ibhdr,
+				u32 hdrwords, struct rvt_sge_state *ss,
 				u32 len, u32 plen, u32 dwords, u64 pbc);
 	void (*pio_inline_send)(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 				u64 pbc, const void *from, size_t count);
@@ -1223,7 +1223,7 @@ static inline u32 egress_cycles(u32 len, u32 rate)
 void set_link_ipg(struct hfi1_pportdata *ppd);
 void process_becn(struct hfi1_pportdata *ppd, u8 sl,  u16 rlid, u32 lqpn,
 		  u32 rqpn, u8 svc_type);
-void return_cnp(struct hfi1_ibport *ibp, struct hfi1_qp *qp, u32 remote_qpn,
+void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 		u32 pkey, u32 slid, u32 dlid, u8 sc5,
 		const struct ib_grh *old_grh);
 
@@ -1415,11 +1415,11 @@ void reset_link_credits(struct hfi1_devdata *dd);
 void assign_remote_cm_au_table(struct hfi1_devdata *dd, u8 vcu);
 
 int snoop_recv_handler(struct hfi1_packet *packet);
-int snoop_send_dma_handler(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
-			   u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
+int snoop_send_dma_handler(struct rvt_qp *qp, struct ahg_ib_header *ibhdr,
+			   u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			   u32 plen, u32 dwords, u64 pbc);
-int snoop_send_pio_handler(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
-			   u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
+int snoop_send_pio_handler(struct rvt_qp *qp, struct ahg_ib_header *ibhdr,
+			   u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			   u32 plen, u32 dwords, u64 pbc);
 void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 			   u64 pbc, const void *from, size_t count);
@@ -1646,7 +1646,7 @@ int process_receive_invalid(struct hfi1_packet *packet);
 
 extern rhf_rcv_function_ptr snoop_rhf_rcv_functions[8];
 
-void update_sge(struct hfi1_sge_state *ss, u32 length);
+void update_sge(struct rvt_sge_state *ss, u32 length);
 
 /* global module parameter variables */
 extern unsigned int hfi1_max_mtu;
diff --git a/drivers/staging/rdma/hfi1/keys.c b/drivers/staging/rdma/hfi1/keys.c
deleted file mode 100644
index ffaaa6f..0000000
--- a/drivers/staging/rdma/hfi1/keys.c
+++ /dev/null
@@ -1,356 +0,0 @@
-/*
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2015 Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2015 Intel Corporation.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  - Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  - Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  - Neither the name of Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- */
-
-#include "hfi.h"
-
-/**
- * hfi1_alloc_lkey - allocate an lkey
- * @mr: memory region that this lkey protects
- * @dma_region: 0->normal key, 1->restricted DMA key
- *
- * Returns 0 if successful, otherwise returns -errno.
- *
- * Increments mr reference count as required.
- *
- * Sets the lkey field mr for non-dma regions.
- *
- */
-
-int hfi1_alloc_lkey(struct rvt_mregion *mr, int dma_region)
-{
-	unsigned long flags;
-	u32 r;
-	u32 n;
-	int ret = 0;
-	struct hfi1_ibdev *dev = to_idev(mr->pd->device);
-	struct rvt_lkey_table *rkt = &dev->lk_table;
-
-	hfi1_get_mr(mr);
-	spin_lock_irqsave(&rkt->lock, flags);
-
-	/* special case for dma_mr lkey == 0 */
-	if (dma_region) {
-		struct rvt_mregion *tmr;
-
-		tmr = rcu_access_pointer(dev->dma_mr);
-		if (!tmr) {
-			rcu_assign_pointer(dev->dma_mr, mr);
-			mr->lkey_published = 1;
-		} else {
-			hfi1_put_mr(mr);
-		}
-		goto success;
-	}
-
-	/* Find the next available LKEY */
-	r = rkt->next;
-	n = r;
-	for (;;) {
-		if (!rcu_access_pointer(rkt->table[r]))
-			break;
-		r = (r + 1) & (rkt->max - 1);
-		if (r == n)
-			goto bail;
-	}
-	rkt->next = (r + 1) & (rkt->max - 1);
-	/*
-	 * Make sure lkey is never zero which is reserved to indicate an
-	 * unrestricted LKEY.
-	 */
-	rkt->gen++;
-	/*
-	 * bits are capped in verbs.c to ensure enough bits for
-	 * generation number
-	 */
-	mr->lkey = (r << (32 - hfi1_lkey_table_size)) |
-		((((1 << (24 - hfi1_lkey_table_size)) - 1) & rkt->gen)
-		 << 8);
-	if (mr->lkey == 0) {
-		mr->lkey |= 1 << 8;
-		rkt->gen++;
-	}
-	rcu_assign_pointer(rkt->table[r], mr);
-	mr->lkey_published = 1;
-success:
-	spin_unlock_irqrestore(&rkt->lock, flags);
-out:
-	return ret;
-bail:
-	hfi1_put_mr(mr);
-	spin_unlock_irqrestore(&rkt->lock, flags);
-	ret = -ENOMEM;
-	goto out;
-}
-
-/**
- * hfi1_free_lkey - free an lkey
- * @mr: mr to free from tables
- */
-void hfi1_free_lkey(struct rvt_mregion *mr)
-{
-	unsigned long flags;
-	u32 lkey = mr->lkey;
-	u32 r;
-	struct hfi1_ibdev *dev = to_idev(mr->pd->device);
-	struct rvt_lkey_table *rkt = &dev->lk_table;
-	int freed = 0;
-
-	spin_lock_irqsave(&rkt->lock, flags);
-	if (!mr->lkey_published)
-		goto out;
-	if (lkey == 0)
-		RCU_INIT_POINTER(dev->dma_mr, NULL);
-	else {
-		r = lkey >> (32 - hfi1_lkey_table_size);
-		RCU_INIT_POINTER(rkt->table[r], NULL);
-	}
-	mr->lkey_published = 0;
-	freed++;
-out:
-	spin_unlock_irqrestore(&rkt->lock, flags);
-	if (freed) {
-		synchronize_rcu();
-		hfi1_put_mr(mr);
-	}
-}
-
-/**
- * hfi1_lkey_ok - check IB SGE for validity and initialize
- * @rkt: table containing lkey to check SGE against
- * @pd: protection domain
- * @isge: outgoing internal SGE
- * @sge: SGE to check
- * @acc: access flags
- *
- * Return 1 if valid and successful, otherwise returns 0.
- *
- * increments the reference count upon success
- *
- * Check the IB SGE for validity and initialize our internal version
- * of it.
- */
-int hfi1_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
-		 struct hfi1_sge *isge, struct ib_sge *sge, int acc)
-{
-	struct rvt_mregion *mr;
-	unsigned n, m;
-	size_t off;
-
-	/*
-	 * We use LKEY == zero for kernel virtual addresses
-	 * (see hfi1_get_dma_mr and dma.c).
-	 */
-	rcu_read_lock();
-	if (sge->lkey == 0) {
-		struct hfi1_ibdev *dev = to_idev(pd->ibpd.device);
-
-		if (pd->user)
-			goto bail;
-		mr = rcu_dereference(dev->dma_mr);
-		if (!mr)
-			goto bail;
-		atomic_inc(&mr->refcount);
-		rcu_read_unlock();
-
-		isge->mr = mr;
-		isge->vaddr = (void *) sge->addr;
-		isge->length = sge->length;
-		isge->sge_length = sge->length;
-		isge->m = 0;
-		isge->n = 0;
-		goto ok;
-	}
-	mr = rcu_dereference(
-		rkt->table[(sge->lkey >> (32 - hfi1_lkey_table_size))]);
-	if (unlikely(!mr || mr->lkey != sge->lkey || mr->pd != &pd->ibpd))
-		goto bail;
-
-	off = sge->addr - mr->user_base;
-	if (unlikely(sge->addr < mr->user_base ||
-		     off + sge->length > mr->length ||
-		     (mr->access_flags & acc) != acc))
-		goto bail;
-	atomic_inc(&mr->refcount);
-	rcu_read_unlock();
-
-	off += mr->offset;
-	if (mr->page_shift) {
-		/*
-		page sizes are uniform power of 2 so no loop is necessary
-		entries_spanned_by_off is the number of times the loop below
-		would have executed.
-		*/
-		size_t entries_spanned_by_off;
-
-		entries_spanned_by_off = off >> mr->page_shift;
-		off -= (entries_spanned_by_off << mr->page_shift);
-		m = entries_spanned_by_off / RVT_SEGSZ;
-		n = entries_spanned_by_off % RVT_SEGSZ;
-	} else {
-		m = 0;
-		n = 0;
-		while (off >= mr->map[m]->segs[n].length) {
-			off -= mr->map[m]->segs[n].length;
-			n++;
-			if (n >= RVT_SEGSZ) {
-				m++;
-				n = 0;
-			}
-		}
-	}
-	isge->mr = mr;
-	isge->vaddr = mr->map[m]->segs[n].vaddr + off;
-	isge->length = mr->map[m]->segs[n].length - off;
-	isge->sge_length = sge->length;
-	isge->m = m;
-	isge->n = n;
-ok:
-	return 1;
-bail:
-	rcu_read_unlock();
-	return 0;
-}
-
-/**
- * hfi1_rkey_ok - check the IB virtual address, length, and RKEY
- * @qp: qp for validation
- * @sge: SGE state
- * @len: length of data
- * @vaddr: virtual address to place data
- * @rkey: rkey to check
- * @acc: access flags
- *
- * Return 1 if successful, otherwise 0.
- *
- * increments the reference count upon success
- */
-int hfi1_rkey_ok(struct hfi1_qp *qp, struct hfi1_sge *sge,
-		 u32 len, u64 vaddr, u32 rkey, int acc)
-{
-	struct rvt_lkey_table *rkt = &to_idev(qp->ibqp.device)->lk_table;
-	struct rvt_mregion *mr;
-	unsigned n, m;
-	size_t off;
-
-	/*
-	 * We use RKEY == zero for kernel virtual addresses
-	 * (see hfi1_get_dma_mr and dma.c).
-	 */
-	rcu_read_lock();
-	if (rkey == 0) {
-		struct rvt_pd *pd = ibpd_to_rvtpd(qp->ibqp.pd);
-		struct hfi1_ibdev *dev = to_idev(pd->ibpd.device);
-
-		if (pd->user)
-			goto bail;
-		mr = rcu_dereference(dev->dma_mr);
-		if (!mr)
-			goto bail;
-		atomic_inc(&mr->refcount);
-		rcu_read_unlock();
-
-		sge->mr = mr;
-		sge->vaddr = (void *) vaddr;
-		sge->length = len;
-		sge->sge_length = len;
-		sge->m = 0;
-		sge->n = 0;
-		goto ok;
-	}
-
-	mr = rcu_dereference(
-		rkt->table[(rkey >> (32 - hfi1_lkey_table_size))]);
-	if (unlikely(!mr || mr->lkey != rkey || qp->ibqp.pd != mr->pd))
-		goto bail;
-
-	off = vaddr - mr->iova;
-	if (unlikely(vaddr < mr->iova || off + len > mr->length ||
-		     (mr->access_flags & acc) == 0))
-		goto bail;
-	atomic_inc(&mr->refcount);
-	rcu_read_unlock();
-
-	off += mr->offset;
-	if (mr->page_shift) {
-		/*
-		page sizes are uniform power of 2 so no loop is necessary
-		entries_spanned_by_off is the number of times the loop below
-		would have executed.
-		*/
-		size_t entries_spanned_by_off;
-
-		entries_spanned_by_off = off >> mr->page_shift;
-		off -= (entries_spanned_by_off << mr->page_shift);
-		m = entries_spanned_by_off / RVT_SEGSZ;
-		n = entries_spanned_by_off % RVT_SEGSZ;
-	} else {
-		m = 0;
-		n = 0;
-		while (off >= mr->map[m]->segs[n].length) {
-			off -= mr->map[m]->segs[n].length;
-			n++;
-			if (n >= RVT_SEGSZ) {
-				m++;
-				n = 0;
-			}
-		}
-	}
-	sge->mr = mr;
-	sge->vaddr = mr->map[m]->segs[n].vaddr + off;
-	sge->length = mr->map[m]->segs[n].length - off;
-	sge->sge_length = len;
-	sge->m = m;
-	sge->n = n;
-ok:
-	return 1;
-bail:
-	rcu_read_unlock();
-	return 0;
-}
diff --git a/drivers/staging/rdma/hfi1/mmap.c b/drivers/staging/rdma/hfi1/mmap.c
index 5173b1c..4ce6be6 100644
--- a/drivers/staging/rdma/hfi1/mmap.c
+++ b/drivers/staging/rdma/hfi1/mmap.c
@@ -59,12 +59,12 @@
 
 /**
  * hfi1_release_mmap_info - free mmap info structure
- * @ref: a pointer to the kref within struct hfi1_mmap_info
+ * @ref: a pointer to the kref within struct rvt_mmap_info
  */
 void hfi1_release_mmap_info(struct kref *ref)
 {
-	struct hfi1_mmap_info *ip =
-		container_of(ref, struct hfi1_mmap_info, ref);
+	struct rvt_mmap_info *ip =
+		container_of(ref, struct rvt_mmap_info, ref);
 	struct hfi1_ibdev *dev = to_idev(ip->context->device);
 
 	spin_lock_irq(&dev->pending_lock);
@@ -81,14 +81,14 @@ void hfi1_release_mmap_info(struct kref *ref)
  */
 static void hfi1_vma_open(struct vm_area_struct *vma)
 {
-	struct hfi1_mmap_info *ip = vma->vm_private_data;
+	struct rvt_mmap_info *ip = vma->vm_private_data;
 
 	kref_get(&ip->ref);
 }
 
 static void hfi1_vma_close(struct vm_area_struct *vma)
 {
-	struct hfi1_mmap_info *ip = vma->vm_private_data;
+	struct rvt_mmap_info *ip = vma->vm_private_data;
 
 	kref_put(&ip->ref, hfi1_release_mmap_info);
 }
@@ -109,7 +109,7 @@ int hfi1_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	struct hfi1_ibdev *dev = to_idev(context->device);
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long size = vma->vm_end - vma->vm_start;
-	struct hfi1_mmap_info *ip, *pp;
+	struct rvt_mmap_info *ip, *pp;
 	int ret = -EINVAL;
 
 	/*
@@ -146,11 +146,11 @@ done:
 /*
  * Allocate information for hfi1_mmap
  */
-struct hfi1_mmap_info *hfi1_create_mmap_info(struct hfi1_ibdev *dev,
-					     u32 size,
-					     struct ib_ucontext *context,
-					     void *obj) {
-	struct hfi1_mmap_info *ip;
+struct rvt_mmap_info *hfi1_create_mmap_info(struct hfi1_ibdev *dev,
+					    u32 size,
+					    struct ib_ucontext *context,
+					    void *obj) {
+	struct rvt_mmap_info *ip;
 
 	ip = kmalloc(sizeof(*ip), GFP_KERNEL);
 	if (!ip)
@@ -175,7 +175,7 @@ bail:
 	return ip;
 }
 
-void hfi1_update_mmap_info(struct hfi1_ibdev *dev, struct hfi1_mmap_info *ip,
+void hfi1_update_mmap_info(struct hfi1_ibdev *dev, struct rvt_mmap_info *ip,
 			   u32 size, void *obj)
 {
 	size = PAGE_ALIGN(size);
diff --git a/drivers/staging/rdma/hfi1/mr.c b/drivers/staging/rdma/hfi1/mr.c
deleted file mode 100644
index 7e14965..0000000
--- a/drivers/staging/rdma/hfi1/mr.c
+++ /dev/null
@@ -1,473 +0,0 @@
-/*
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2015 Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2015 Intel Corporation.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  - Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  - Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  - Neither the name of Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- */
-
-#include <rdma/ib_umem.h>
-#include <rdma/ib_smi.h>
-
-#include "hfi.h"
-
-/* Fast memory region */
-struct hfi1_fmr {
-	struct ib_fmr ibfmr;
-	struct rvt_mregion mr;        /* must be last */
-};
-
-static inline struct hfi1_fmr *to_ifmr(struct ib_fmr *ibfmr)
-{
-	return container_of(ibfmr, struct hfi1_fmr, ibfmr);
-}
-
-static int init_mregion(struct rvt_mregion *mr, struct ib_pd *pd,
-			int count)
-{
-	int m, i = 0;
-	int rval = 0;
-
-	m = (count + RVT_SEGSZ - 1) / RVT_SEGSZ;
-	for (; i < m; i++) {
-		mr->map[i] = kzalloc(sizeof(*mr->map[0]), GFP_KERNEL);
-		if (!mr->map[i])
-			goto bail;
-	}
-	mr->mapsz = m;
-	init_completion(&mr->comp);
-	/* count returning the ptr to user */
-	atomic_set(&mr->refcount, 1);
-	mr->pd = pd;
-	mr->max_segs = count;
-out:
-	return rval;
-bail:
-	while (i)
-		kfree(mr->map[--i]);
-	rval = -ENOMEM;
-	goto out;
-}
-
-static void deinit_mregion(struct rvt_mregion *mr)
-{
-	int i = mr->mapsz;
-
-	mr->mapsz = 0;
-	while (i)
-		kfree(mr->map[--i]);
-}
-
-
-/**
- * hfi1_get_dma_mr - get a DMA memory region
- * @pd: protection domain for this memory region
- * @acc: access flags
- *
- * Returns the memory region on success, otherwise returns an errno.
- * Note that all DMA addresses should be created via the
- * struct ib_dma_mapping_ops functions (see dma.c).
- */
-struct ib_mr *hfi1_get_dma_mr(struct ib_pd *pd, int acc)
-{
-	struct hfi1_mr *mr = NULL;
-	struct ib_mr *ret;
-	int rval;
-
-	if (ibpd_to_rvtpd(pd)->user) {
-		ret = ERR_PTR(-EPERM);
-		goto bail;
-	}
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr) {
-		ret = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
-	rval = init_mregion(&mr->mr, pd, 0);
-	if (rval) {
-		ret = ERR_PTR(rval);
-		goto bail;
-	}
-
-
-	rval = hfi1_alloc_lkey(&mr->mr, 1);
-	if (rval) {
-		ret = ERR_PTR(rval);
-		goto bail_mregion;
-	}
-
-	mr->mr.access_flags = acc;
-	ret = &mr->ibmr;
-done:
-	return ret;
-
-bail_mregion:
-	deinit_mregion(&mr->mr);
-bail:
-	kfree(mr);
-	goto done;
-}
-
-static struct hfi1_mr *alloc_mr(int count, struct ib_pd *pd)
-{
-	struct hfi1_mr *mr;
-	int rval = -ENOMEM;
-	int m;
-
-	/* Allocate struct plus pointers to first level page tables. */
-	m = (count + RVT_SEGSZ - 1) / RVT_SEGSZ;
-	mr = kzalloc(sizeof(*mr) + m * sizeof(mr->mr.map[0]), GFP_KERNEL);
-	if (!mr)
-		goto bail;
-
-	rval = init_mregion(&mr->mr, pd, count);
-	if (rval)
-		goto bail;
-
-	rval = hfi1_alloc_lkey(&mr->mr, 0);
-	if (rval)
-		goto bail_mregion;
-	mr->ibmr.lkey = mr->mr.lkey;
-	mr->ibmr.rkey = mr->mr.lkey;
-done:
-	return mr;
-
-bail_mregion:
-	deinit_mregion(&mr->mr);
-bail:
-	kfree(mr);
-	mr = ERR_PTR(rval);
-	goto done;
-}
-
-/**
- * hfi1_reg_user_mr - register a userspace memory region
- * @pd: protection domain for this memory region
- * @start: starting userspace address
- * @length: length of region to register
- * @mr_access_flags: access flags for this memory region
- * @udata: unused by the driver
- *
- * Returns the memory region on success, otherwise returns an errno.
- */
-struct ib_mr *hfi1_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
-			       u64 virt_addr, int mr_access_flags,
-			       struct ib_udata *udata)
-{
-	struct hfi1_mr *mr;
-	struct ib_umem *umem;
-	struct scatterlist *sg;
-	int n, m, entry;
-	struct ib_mr *ret;
-
-	if (length == 0) {
-		ret = ERR_PTR(-EINVAL);
-		goto bail;
-	}
-
-	umem = ib_umem_get(pd->uobject->context, start, length,
-			   mr_access_flags, 0);
-	if (IS_ERR(umem))
-		return (void *) umem;
-
-	n = umem->nmap;
-
-	mr = alloc_mr(n, pd);
-	if (IS_ERR(mr)) {
-		ret = (struct ib_mr *)mr;
-		ib_umem_release(umem);
-		goto bail;
-	}
-
-	mr->mr.user_base = start;
-	mr->mr.iova = virt_addr;
-	mr->mr.length = length;
-	mr->mr.offset = ib_umem_offset(umem);
-	mr->mr.access_flags = mr_access_flags;
-	mr->umem = umem;
-
-	if (is_power_of_2(umem->page_size))
-		mr->mr.page_shift = ilog2(umem->page_size);
-	m = 0;
-	n = 0;
-	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
-		void *vaddr;
-
-		vaddr = page_address(sg_page(sg));
-		if (!vaddr) {
-			ret = ERR_PTR(-EINVAL);
-			goto bail;
-		}
-		mr->mr.map[m]->segs[n].vaddr = vaddr;
-		mr->mr.map[m]->segs[n].length = umem->page_size;
-		n++;
-		if (n == RVT_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-	ret = &mr->ibmr;
-
-bail:
-	return ret;
-}
-
-/**
- * hfi1_dereg_mr - unregister and free a memory region
- * @ibmr: the memory region to free
- *
- * Returns 0 on success.
- *
- * Note that this is called to free MRs created by hfi1_get_dma_mr()
- * or hfi1_reg_user_mr().
- */
-int hfi1_dereg_mr(struct ib_mr *ibmr)
-{
-	struct hfi1_mr *mr = to_imr(ibmr);
-	int ret = 0;
-	unsigned long timeout;
-
-	hfi1_free_lkey(&mr->mr);
-
-	hfi1_put_mr(&mr->mr); /* will set completion if last */
-	timeout = wait_for_completion_timeout(&mr->mr.comp,
-		5 * HZ);
-	if (!timeout) {
-		dd_dev_err(
-			dd_from_ibdev(mr->mr.pd->device),
-			"hfi1_dereg_mr timeout mr %p pd %p refcount %u\n",
-			mr, mr->mr.pd, atomic_read(&mr->mr.refcount));
-		hfi1_get_mr(&mr->mr);
-		ret = -EBUSY;
-		goto out;
-	}
-	deinit_mregion(&mr->mr);
-	if (mr->umem)
-		ib_umem_release(mr->umem);
-	kfree(mr);
-out:
-	return ret;
-}
-
-/*
- * Allocate a memory region usable with the
- * IB_WR_REG_MR send work request.
- *
- * Return the memory region on success, otherwise return an errno.
- * FIXME: IB_WR_REG_MR is not supported
- */
-struct ib_mr *hfi1_alloc_mr(struct ib_pd *pd,
-			    enum ib_mr_type mr_type,
-			    u32 max_num_sg)
-{
-	struct hfi1_mr *mr;
-
-	if (mr_type != IB_MR_TYPE_MEM_REG)
-		return ERR_PTR(-EINVAL);
-
-	mr = alloc_mr(max_num_sg, pd);
-	if (IS_ERR(mr))
-		return (struct ib_mr *)mr;
-
-	return &mr->ibmr;
-}
-
-/**
- * hfi1_alloc_fmr - allocate a fast memory region
- * @pd: the protection domain for this memory region
- * @mr_access_flags: access flags for this memory region
- * @fmr_attr: fast memory region attributes
- *
- * Returns the memory region on success, otherwise returns an errno.
- */
-struct ib_fmr *hfi1_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
-			      struct ib_fmr_attr *fmr_attr)
-{
-	struct hfi1_fmr *fmr;
-	int m;
-	struct ib_fmr *ret;
-	int rval = -ENOMEM;
-
-	/* Allocate struct plus pointers to first level page tables. */
-	m = (fmr_attr->max_pages + RVT_SEGSZ - 1) / RVT_SEGSZ;
-	fmr = kzalloc(sizeof(*fmr) + m * sizeof(fmr->mr.map[0]), GFP_KERNEL);
-	if (!fmr)
-		goto bail;
-
-	rval = init_mregion(&fmr->mr, pd, fmr_attr->max_pages);
-	if (rval)
-		goto bail;
-
-	/*
-	 * ib_alloc_fmr() will initialize fmr->ibfmr except for lkey &
-	 * rkey.
-	 */
-	rval = hfi1_alloc_lkey(&fmr->mr, 0);
-	if (rval)
-		goto bail_mregion;
-	fmr->ibfmr.rkey = fmr->mr.lkey;
-	fmr->ibfmr.lkey = fmr->mr.lkey;
-	/*
-	 * Resources are allocated but no valid mapping (RKEY can't be
-	 * used).
-	 */
-	fmr->mr.access_flags = mr_access_flags;
-	fmr->mr.max_segs = fmr_attr->max_pages;
-	fmr->mr.page_shift = fmr_attr->page_shift;
-
-	ret = &fmr->ibfmr;
-done:
-	return ret;
-
-bail_mregion:
-	deinit_mregion(&fmr->mr);
-bail:
-	kfree(fmr);
-	ret = ERR_PTR(rval);
-	goto done;
-}
-
-/**
- * hfi1_map_phys_fmr - set up a fast memory region
- * @ibmfr: the fast memory region to set up
- * @page_list: the list of pages to associate with the fast memory region
- * @list_len: the number of pages to associate with the fast memory region
- * @iova: the virtual address of the start of the fast memory region
- *
- * This may be called from interrupt context.
- */
-
-int hfi1_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-		      int list_len, u64 iova)
-{
-	struct hfi1_fmr *fmr = to_ifmr(ibfmr);
-	struct rvt_lkey_table *rkt;
-	unsigned long flags;
-	int m, n, i;
-	u32 ps;
-	int ret;
-
-	i = atomic_read(&fmr->mr.refcount);
-	if (i > 2)
-		return -EBUSY;
-
-	if (list_len > fmr->mr.max_segs) {
-		ret = -EINVAL;
-		goto bail;
-	}
-	rkt = &to_idev(ibfmr->device)->lk_table;
-	spin_lock_irqsave(&rkt->lock, flags);
-	fmr->mr.user_base = iova;
-	fmr->mr.iova = iova;
-	ps = 1 << fmr->mr.page_shift;
-	fmr->mr.length = list_len * ps;
-	m = 0;
-	n = 0;
-	for (i = 0; i < list_len; i++) {
-		fmr->mr.map[m]->segs[n].vaddr = (void *) page_list[i];
-		fmr->mr.map[m]->segs[n].length = ps;
-		if (++n == RVT_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-	spin_unlock_irqrestore(&rkt->lock, flags);
-	ret = 0;
-
-bail:
-	return ret;
-}
-
-/**
- * hfi1_unmap_fmr - unmap fast memory regions
- * @fmr_list: the list of fast memory regions to unmap
- *
- * Returns 0 on success.
- */
-int hfi1_unmap_fmr(struct list_head *fmr_list)
-{
-	struct hfi1_fmr *fmr;
-	struct rvt_lkey_table *rkt;
-	unsigned long flags;
-
-	list_for_each_entry(fmr, fmr_list, ibfmr.list) {
-		rkt = &to_idev(fmr->ibfmr.device)->lk_table;
-		spin_lock_irqsave(&rkt->lock, flags);
-		fmr->mr.user_base = 0;
-		fmr->mr.iova = 0;
-		fmr->mr.length = 0;
-		spin_unlock_irqrestore(&rkt->lock, flags);
-	}
-	return 0;
-}
-
-/**
- * hfi1_dealloc_fmr - deallocate a fast memory region
- * @ibfmr: the fast memory region to deallocate
- *
- * Returns 0 on success.
- */
-int hfi1_dealloc_fmr(struct ib_fmr *ibfmr)
-{
-	struct hfi1_fmr *fmr = to_ifmr(ibfmr);
-	int ret = 0;
-	unsigned long timeout;
-
-	hfi1_free_lkey(&fmr->mr);
-	hfi1_put_mr(&fmr->mr); /* will set completion if last */
-	timeout = wait_for_completion_timeout(&fmr->mr.comp,
-		5 * HZ);
-	if (!timeout) {
-		hfi1_get_mr(&fmr->mr);
-		ret = -EBUSY;
-		goto out;
-	}
-	deinit_mregion(&fmr->mr);
-	kfree(fmr);
-out:
-	return ret;
-}
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index a661164..a78909e 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -1495,8 +1495,8 @@ static void sc_piobufavail(struct send_context *sc)
 	struct hfi1_devdata *dd = sc->dd;
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
 	struct list_head *list;
-	struct hfi1_qp *qps[PIO_WAIT_BATCH_SIZE];
-	struct hfi1_qp *qp;
+	struct rvt_qp *qps[PIO_WAIT_BATCH_SIZE];
+	struct rvt_qp *qp;
 	struct hfi1_qp_priv *priv;
 	unsigned long flags;
 	unsigned i, n = 0;
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 83786d2..9aec9f5 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -67,7 +67,7 @@ static unsigned int hfi1_qp_table_size = 256;
 module_param_named(qp_table_size, hfi1_qp_table_size, uint, S_IRUGO);
 MODULE_PARM_DESC(qp_table_size, "QP table size");
 
-static void flush_tx_list(struct hfi1_qp *qp);
+static void flush_tx_list(struct rvt_qp *qp);
 static int iowait_sleep(
 	struct sdma_engine *sde,
 	struct iowait *wait,
@@ -229,7 +229,7 @@ static void free_qpn(struct hfi1_qpn_table *qpt, u32 qpn)
  * Put the QP into the hash table.
  * The hash table holds a reference to the QP.
  */
-static void insert_qp(struct hfi1_ibdev *dev, struct hfi1_qp *qp)
+static void insert_qp(struct hfi1_ibdev *dev, struct rvt_qp *qp)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	unsigned long flags;
@@ -254,7 +254,7 @@ static void insert_qp(struct hfi1_ibdev *dev, struct hfi1_qp *qp)
  * Remove the QP from the table so it can't be found asynchronously by
  * the receive interrupt routine.
  */
-static void remove_qp(struct hfi1_ibdev *dev, struct hfi1_qp *qp)
+static void remove_qp(struct hfi1_ibdev *dev, struct rvt_qp *qp)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	u32 n = qpn_hash(dev->qp_dev, qp->ibqp.qp_num);
@@ -270,8 +270,8 @@ static void remove_qp(struct hfi1_ibdev *dev, struct hfi1_qp *qp)
 			lockdep_is_held(&dev->qp_dev->qpt_lock)) == qp) {
 		RCU_INIT_POINTER(ibp->qp[1], NULL);
 	} else {
-		struct hfi1_qp *q;
-		struct hfi1_qp __rcu **qpp;
+		struct rvt_qp *q;
+		struct rvt_qp __rcu **qpp;
 
 		removed = 0;
 		qpp = &dev->qp_dev->qp_table[n];
@@ -308,7 +308,7 @@ static unsigned free_all_qps(struct hfi1_devdata *dd)
 {
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
 	unsigned long flags;
-	struct hfi1_qp *qp;
+	struct rvt_qp *qp;
 	unsigned n, qp_inuse = 0;
 
 	for (n = 0; n < dd->num_pports; n++) {
@@ -347,7 +347,7 @@ bail:
  * @qp: the QP to reset
  * @type: the QP type
  */
-static void reset_qp(struct hfi1_qp *qp, enum ib_qp_type type)
+static void reset_qp(struct rvt_qp *qp, enum ib_qp_type type)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	qp->remote_qpn = 0;
@@ -401,7 +401,7 @@ static void reset_qp(struct hfi1_qp *qp, enum ib_qp_type type)
 	qp->r_sge.num_sge = 0;
 }
 
-static void clear_mr_refs(struct hfi1_qp *qp, int clr_sends)
+static void clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 {
 	unsigned n;
 
@@ -412,13 +412,13 @@ static void clear_mr_refs(struct hfi1_qp *qp, int clr_sends)
 
 	if (clr_sends) {
 		while (qp->s_last != qp->s_head) {
-			struct hfi1_swqe *wqe = get_swqe_ptr(qp, qp->s_last);
+			struct rvt_swqe *wqe = get_swqe_ptr(qp, qp->s_last);
 			unsigned i;
 
 			for (i = 0; i < wqe->wr.num_sge; i++) {
-				struct hfi1_sge *sge = &wqe->sg_list[i];
+				struct rvt_sge *sge = &wqe->sg_list[i];
 
-				hfi1_put_mr(sge->mr);
+				rvt_put_mr(sge->mr);
 			}
 			if (qp->ibqp.qp_type == IB_QPT_UD ||
 			    qp->ibqp.qp_type == IB_QPT_SMI ||
@@ -428,7 +428,7 @@ static void clear_mr_refs(struct hfi1_qp *qp, int clr_sends)
 				qp->s_last = 0;
 		}
 		if (qp->s_rdma_mr) {
-			hfi1_put_mr(qp->s_rdma_mr);
+			rvt_put_mr(qp->s_rdma_mr);
 			qp->s_rdma_mr = NULL;
 		}
 	}
@@ -437,11 +437,11 @@ static void clear_mr_refs(struct hfi1_qp *qp, int clr_sends)
 		return;
 
 	for (n = 0; n < ARRAY_SIZE(qp->s_ack_queue); n++) {
-		struct hfi1_ack_entry *e = &qp->s_ack_queue[n];
+		struct rvt_ack_entry *e = &qp->s_ack_queue[n];
 
 		if (e->opcode == IB_OPCODE_RC_RDMA_READ_REQUEST &&
 		    e->rdma_sge.mr) {
-			hfi1_put_mr(e->rdma_sge.mr);
+			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
 	}
@@ -457,7 +457,7 @@ static void clear_mr_refs(struct hfi1_qp *qp, int clr_sends)
  * The QP r_lock and s_lock should be held and interrupts disabled.
  * If we are already in error state, just return.
  */
-int hfi1_error_qp(struct hfi1_qp *qp, enum ib_wc_status err)
+int hfi1_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 {
 	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
 	struct hfi1_qp_priv *priv = qp->priv;
@@ -489,7 +489,7 @@ int hfi1_error_qp(struct hfi1_qp *qp, enum ib_wc_status err)
 	if (!(qp->s_flags & HFI1_S_BUSY)) {
 		qp->s_hdrwords = 0;
 		if (qp->s_rdma_mr) {
-			hfi1_put_mr(qp->s_rdma_mr);
+			rvt_put_mr(qp->s_rdma_mr);
 			qp->s_rdma_mr = NULL;
 		}
 		flush_tx_list(qp);
@@ -513,7 +513,7 @@ int hfi1_error_qp(struct hfi1_qp *qp, enum ib_wc_status err)
 	wc.status = IB_WC_WR_FLUSH_ERR;
 
 	if (qp->r_rq.wq) {
-		struct hfi1_rwq *wq;
+		struct rvt_rwq *wq;
 		u32 head;
 		u32 tail;
 
@@ -543,7 +543,7 @@ bail:
 	return ret;
 }
 
-static void flush_tx_list(struct hfi1_qp *qp)
+static void flush_tx_list(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 
@@ -560,7 +560,7 @@ static void flush_tx_list(struct hfi1_qp *qp)
 	}
 }
 
-static void flush_iowait(struct hfi1_qp *qp)
+static void flush_iowait(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
@@ -615,7 +615,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		   int attr_mask, struct ib_udata *udata)
 {
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
-	struct hfi1_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 	struct hfi1_qp_priv *priv = qp->priv;
 	enum ib_qp_state cur_state, new_state;
 	struct ib_event ev;
@@ -898,7 +898,7 @@ bail:
 int hfi1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		  int attr_mask, struct ib_qp_init_attr *init_attr)
 {
-	struct hfi1_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 
 	attr->qp_state = qp->state;
 	attr->cur_qp_state = attr->qp_state;
@@ -951,7 +951,7 @@ int hfi1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
  *
  * Returns the AETH.
  */
-__be32 hfi1_compute_aeth(struct hfi1_qp *qp)
+__be32 hfi1_compute_aeth(struct rvt_qp *qp)
 {
 	u32 aeth = qp->r_msn & HFI1_MSN_MASK;
 
@@ -964,7 +964,7 @@ __be32 hfi1_compute_aeth(struct hfi1_qp *qp)
 	} else {
 		u32 min, max, x;
 		u32 credits;
-		struct hfi1_rwq *wq = qp->r_rq.wq;
+		struct rvt_rwq *wq = qp->r_rq.wq;
 		u32 head;
 		u32 tail;
 
@@ -1020,10 +1020,10 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 			     struct ib_qp_init_attr *init_attr,
 			     struct ib_udata *udata)
 {
-	struct hfi1_qp *qp;
+	struct rvt_qp *qp;
 	struct hfi1_qp_priv *priv;
 	int err;
-	struct hfi1_swqe *swq = NULL;
+	struct rvt_swqe *swq = NULL;
 	struct hfi1_ibdev *dev;
 	struct hfi1_devdata *dd;
 	size_t sz;
@@ -1064,9 +1064,9 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 	case IB_QPT_UC:
 	case IB_QPT_RC:
 	case IB_QPT_UD:
-		sz = sizeof(struct hfi1_sge) *
+		sz = sizeof(struct rvt_sge) *
 			init_attr->cap.max_send_sge +
-			sizeof(struct hfi1_swqe);
+			sizeof(struct rvt_swqe);
 		swq = vmalloc((init_attr->cap.max_send_wr + 1) * sz);
 		if (swq == NULL) {
 			ret = ERR_PTR(-ENOMEM);
@@ -1110,8 +1110,8 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 			qp->r_rq.size = init_attr->cap.max_recv_wr + 1;
 			qp->r_rq.max_sge = init_attr->cap.max_recv_sge;
 			sz = (sizeof(struct ib_sge) * qp->r_rq.max_sge) +
-				sizeof(struct hfi1_rwqe);
-			qp->r_rq.wq = vmalloc_user(sizeof(struct hfi1_rwq) +
+				sizeof(struct rvt_rwqe);
+			qp->r_rq.wq = vmalloc_user(sizeof(struct rvt_rwq) +
 						   qp->r_rq.size * sz);
 			if (!qp->r_rq.wq) {
 				ret = ERR_PTR(-ENOMEM);
@@ -1175,7 +1175,7 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 				goto bail_ip;
 			}
 		} else {
-			u32 s = sizeof(struct hfi1_rwq) + qp->r_rq.size * sz;
+			u32 s = sizeof(struct rvt_rwq) + qp->r_rq.size * sz;
 
 			qp->ip = hfi1_create_mmap_info(dev, s,
 						      ibpd->uobject->context,
@@ -1264,7 +1264,7 @@ bail:
  */
 int hfi1_destroy_qp(struct ib_qp *ibqp)
 {
-	struct hfi1_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
 	struct hfi1_qp_priv *priv = qp->priv;
 
@@ -1370,7 +1370,7 @@ static void free_qpn_table(struct hfi1_qpn_table *qpt)
  *
  * The QP s_lock should be held.
  */
-void hfi1_get_credit(struct hfi1_qp *qp, u32 aeth)
+void hfi1_get_credit(struct rvt_qp *qp, u32 aeth)
 {
 	u32 credit = (aeth >> HFI1_AETH_CREDIT_SHIFT) & HFI1_AETH_CREDIT_MASK;
 
@@ -1400,7 +1400,7 @@ void hfi1_get_credit(struct hfi1_qp *qp, u32 aeth)
 	}
 }
 
-void hfi1_qp_wakeup(struct hfi1_qp *qp, u32 flag)
+void hfi1_qp_wakeup(struct rvt_qp *qp, u32 flag)
 {
 	unsigned long flags;
 
@@ -1423,7 +1423,7 @@ static int iowait_sleep(
 	unsigned seq)
 {
 	struct verbs_txreq *tx = container_of(stx, struct verbs_txreq, txreq);
-	struct hfi1_qp *qp;
+	struct rvt_qp *qp;
 	struct hfi1_qp_priv *priv;
 	unsigned long flags;
 	int ret = 0;
@@ -1474,7 +1474,7 @@ eagain:
 
 static void iowait_wakeup(struct iowait *wait, int reason)
 {
-	struct hfi1_qp *qp = iowait_to_qp(wait);
+	struct rvt_qp *qp = iowait_to_qp(wait);
 
 	WARN_ON(reason != SDMA_AVAIL_REASON);
 	hfi1_qp_wakeup(qp, HFI1_S_WAIT_DMA_DESC);
@@ -1541,7 +1541,7 @@ void hfi1_qp_exit(struct hfi1_ibdev *dev)
  * Return:
  * A send engine for the qp or NULL for SMI type qp.
  */
-struct sdma_engine *qp_to_sdma_engine(struct hfi1_qp *qp, u8 sc5)
+struct sdma_engine *qp_to_sdma_engine(struct rvt_qp *qp, u8 sc5)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	struct sdma_engine *sde;
@@ -1563,7 +1563,7 @@ struct sdma_engine *qp_to_sdma_engine(struct hfi1_qp *qp, u8 sc5)
 
 struct qp_iter {
 	struct hfi1_ibdev *dev;
-	struct hfi1_qp *qp;
+	struct rvt_qp *qp;
 	int specials;
 	int n;
 };
@@ -1591,8 +1591,8 @@ int qp_iter_next(struct qp_iter *iter)
 	struct hfi1_ibdev *dev = iter->dev;
 	int n = iter->n;
 	int ret = 1;
-	struct hfi1_qp *pqp = iter->qp;
-	struct hfi1_qp *qp;
+	struct rvt_qp *pqp = iter->qp;
+	struct rvt_qp *qp;
 
 	/*
 	 * The approach is to consider the special qps
@@ -1645,7 +1645,7 @@ static const char * const qp_type_str[] = {
 	"SMI", "GSI", "RC", "UC", "UD",
 };
 
-static int qp_idle(struct hfi1_qp *qp)
+static int qp_idle(struct rvt_qp *qp)
 {
 	return
 		qp->s_last == qp->s_acked &&
@@ -1656,8 +1656,8 @@ static int qp_idle(struct hfi1_qp *qp)
 
 void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 {
-	struct hfi1_swqe *wqe;
-	struct hfi1_qp *qp = iter->qp;
+	struct rvt_swqe *wqe;
+	struct rvt_qp *qp = iter->qp;
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct sdma_engine *sde;
 
@@ -1695,7 +1695,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   sde ? sde->this_idx : 0);
 }
 
-void qp_comm_est(struct hfi1_qp *qp)
+void qp_comm_est(struct rvt_qp *qp)
 {
 	qp->r_flags |= HFI1_R_COMM_EST;
 	if (qp->ibqp.event_handler) {
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 7e98969..718846e 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -80,7 +80,7 @@ struct hfi1_qpn_table {
 struct hfi1_qp_ibdev {
 	u32 qp_table_size;
 	u32 qp_table_bits;
-	struct hfi1_qp __rcu **qp_table;
+	struct rvt_qp __rcu **qp_table;
 	spinlock_t qpt_lock;
 	struct hfi1_qpn_table qpn_table;
 };
@@ -98,10 +98,10 @@ static inline u32 qpn_hash(struct hfi1_qp_ibdev *dev, u32 qpn)
  * The caller must hold the rcu_read_lock(), and keep the lock until
  * the returned qp is no longer in use.
  */
-static inline struct hfi1_qp *hfi1_lookup_qpn(struct hfi1_ibport *ibp,
-				u32 qpn) __must_hold(RCU)
+static inline struct rvt_qp *hfi1_lookup_qpn(struct hfi1_ibport *ibp,
+					     u32 qpn) __must_hold(RCU)
 {
-	struct hfi1_qp *qp = NULL;
+	struct rvt_qp *qp = NULL;
 
 	if (unlikely(qpn <= 1)) {
 		qp = rcu_dereference(ibp->qp[qpn]);
@@ -118,22 +118,6 @@ static inline struct hfi1_qp *hfi1_lookup_qpn(struct hfi1_ibport *ibp,
 }
 
 /**
- * clear_ahg - reset ahg status in qp
- * @qp - qp pointer
- */
-static inline void clear_ahg(struct hfi1_qp *qp)
-{
-	struct hfi1_qp_priv *priv = qp->priv;
-
-	priv->s_hdr->ahgcount = 0;
-	qp->s_flags &= ~(HFI1_S_AHG_VALID | HFI1_S_AHG_CLEAR);
-	if (qp->s_sde)
-		sdma_ahg_free(qp->s_sde, qp->s_ahgidx);
-	qp->s_ahgidx = -1;
-	qp->s_sde = NULL;
-}
-
-/**
  * hfi1_error_qp - put a QP into the error state
  * @qp: the QP to put into the error state
  * @err: the receive completion error to signal if a RWQE is active
@@ -143,7 +127,7 @@ static inline void clear_ahg(struct hfi1_qp *qp)
  * The QP r_lock and s_lock should be held and interrupts disabled.
  * If we are already in error state, just return.
  */
-int hfi1_error_qp(struct hfi1_qp *qp, enum ib_wc_status err);
+int hfi1_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
 
 /**
  * hfi1_modify_qp - modify the attributes of a queue pair
@@ -166,7 +150,7 @@ int hfi1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
  *
  * Returns the AETH.
  */
-__be32 hfi1_compute_aeth(struct hfi1_qp *qp);
+__be32 hfi1_compute_aeth(struct rvt_qp *qp);
 
 /**
  * hfi1_create_qp - create a queue pair for a device
@@ -199,7 +183,7 @@ int hfi1_destroy_qp(struct ib_qp *ibqp);
  *
  * The QP s_lock should be held.
  */
-void hfi1_get_credit(struct hfi1_qp *qp, u32 aeth);
+void hfi1_get_credit(struct rvt_qp *qp, u32 aeth);
 
 /**
  * hfi1_qp_init - allocate QP tables
@@ -218,9 +202,9 @@ void hfi1_qp_exit(struct hfi1_ibdev *dev);
  * @qp: the QP
  * @flag: flag the qp on which the qp is stalled
  */
-void hfi1_qp_wakeup(struct hfi1_qp *qp, u32 flag);
+void hfi1_qp_wakeup(struct rvt_qp *qp, u32 flag);
 
-struct sdma_engine *qp_to_sdma_engine(struct hfi1_qp *qp, u8 sc5);
+struct sdma_engine *qp_to_sdma_engine(struct rvt_qp *qp, u8 sc5);
 
 struct qp_iter;
 
@@ -247,6 +231,6 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter);
  * qp_comm_est - handle trap with QP established
  * @qp: the QP
  */
-void qp_comm_est(struct hfi1_qp *qp);
+void qp_comm_est(struct rvt_qp *qp);
 
 #endif /* _QP_H */
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 93c0e68..f59826a 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -60,7 +60,7 @@
 
 static void rc_timeout(unsigned long arg);
 
-static u32 restart_sge(struct hfi1_sge_state *ss, struct hfi1_swqe *wqe,
+static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 		       u32 psn, u32 pmtu)
 {
 	u32 len;
@@ -74,7 +74,7 @@ static u32 restart_sge(struct hfi1_sge_state *ss, struct hfi1_swqe *wqe,
 	return wqe->length - len;
 }
 
-static void start_timer(struct hfi1_qp *qp)
+static void start_timer(struct rvt_qp *qp)
 {
 	qp->s_flags |= HFI1_S_TIMER;
 	qp->s_timer.function = rc_timeout;
@@ -94,10 +94,10 @@ static void start_timer(struct hfi1_qp *qp)
  * Note that we are in the responder's side of the QP context.
  * Note the QP s_lock must be held.
  */
-static int make_rc_ack(struct hfi1_ibdev *dev, struct hfi1_qp *qp,
+static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 		       struct hfi1_other_headers *ohdr, u32 pmtu)
 {
-	struct hfi1_ack_entry *e;
+	struct rvt_ack_entry *e;
 	u32 hwords;
 	u32 len;
 	u32 bth0;
@@ -116,7 +116,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct hfi1_qp *qp,
 	case OP(RDMA_READ_RESPONSE_ONLY):
 		e = &qp->s_ack_queue[qp->s_tail_ack_queue];
 		if (e->rdma_sge.mr) {
-			hfi1_put_mr(e->rdma_sge.mr);
+			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
 		/* FALLTHROUGH */
@@ -154,7 +154,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct hfi1_qp *qp,
 			/* Copy SGE state in case we need to resend */
 			qp->s_rdma_mr = e->rdma_sge.mr;
 			if (qp->s_rdma_mr)
-				hfi1_get_mr(qp->s_rdma_mr);
+				rvt_get_mr(qp->s_rdma_mr);
 			qp->s_ack_rdma_sge.sge = e->rdma_sge;
 			qp->s_ack_rdma_sge.num_sge = 1;
 			qp->s_cur_sge = &qp->s_ack_rdma_sge;
@@ -193,7 +193,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct hfi1_qp *qp,
 		qp->s_cur_sge = &qp->s_ack_rdma_sge;
 		qp->s_rdma_mr = qp->s_ack_rdma_sge.sge.mr;
 		if (qp->s_rdma_mr)
-			hfi1_get_mr(qp->s_rdma_mr);
+			rvt_get_mr(qp->s_rdma_mr);
 		len = qp->s_ack_rdma_sge.sge.sge_length;
 		if (len > pmtu) {
 			len = pmtu;
@@ -257,13 +257,13 @@ bail:
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int hfi1_make_rc_req(struct hfi1_qp *qp)
+int hfi1_make_rc_req(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
 	struct hfi1_other_headers *ohdr;
-	struct hfi1_sge_state *ss;
-	struct hfi1_swqe *wqe;
+	struct rvt_sge_state *ss;
+	struct rvt_swqe *wqe;
 	/* header size in 32-bit words LRH+BTH = (8+12)/4. */
 	u32 hwords = 5;
 	u32 len;
@@ -683,7 +683,7 @@ unlock:
  * Note that RDMA reads and atomics are handled in the
  * send side QP state and tasklet.
  */
-void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct hfi1_qp *qp,
+void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 		      int is_fecn)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
@@ -794,10 +794,10 @@ queue_ack:
  * for the given QP.
  * Called at interrupt level with the QP s_lock held.
  */
-static void reset_psn(struct hfi1_qp *qp, u32 psn)
+static void reset_psn(struct rvt_qp *qp, u32 psn)
 {
 	u32 n = qp->s_acked;
-	struct hfi1_swqe *wqe = get_swqe_ptr(qp, n);
+	struct rvt_swqe *wqe = get_swqe_ptr(qp, n);
 	u32 opcode;
 
 	qp->s_cur = n;
@@ -880,9 +880,9 @@ done:
  * Back up requester to resend the last un-ACKed request.
  * The QP r_lock and s_lock should be held and interrupts disabled.
  */
-static void restart_rc(struct hfi1_qp *qp, u32 psn, int wait)
+static void restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 {
-	struct hfi1_swqe *wqe = get_swqe_ptr(qp, qp->s_acked);
+	struct rvt_swqe *wqe = get_swqe_ptr(qp, qp->s_acked);
 	struct hfi1_ibport *ibp;
 
 	if (qp->s_retry == 0) {
@@ -917,7 +917,7 @@ static void restart_rc(struct hfi1_qp *qp, u32 psn, int wait)
  */
 static void rc_timeout(unsigned long arg)
 {
-	struct hfi1_qp *qp = (struct hfi1_qp *)arg;
+	struct rvt_qp *qp = (struct rvt_qp *)arg;
 	struct hfi1_ibport *ibp;
 	unsigned long flags;
 
@@ -941,7 +941,7 @@ static void rc_timeout(unsigned long arg)
  */
 void hfi1_rc_rnr_retry(unsigned long arg)
 {
-	struct hfi1_qp *qp = (struct hfi1_qp *)arg;
+	struct rvt_qp *qp = (struct rvt_qp *)arg;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
@@ -957,9 +957,9 @@ void hfi1_rc_rnr_retry(unsigned long arg)
  * Set qp->s_sending_psn to the next PSN after the given one.
  * This would be psn+1 except when RDMA reads are present.
  */
-static void reset_sending_psn(struct hfi1_qp *qp, u32 psn)
+static void reset_sending_psn(struct rvt_qp *qp, u32 psn)
 {
-	struct hfi1_swqe *wqe;
+	struct rvt_swqe *wqe;
 	u32 n = qp->s_last;
 
 	/* Find the work request corresponding to the given PSN. */
@@ -982,10 +982,10 @@ static void reset_sending_psn(struct hfi1_qp *qp, u32 psn)
 /*
  * This should be called with the QP s_lock held and interrupts disabled.
  */
-void hfi1_rc_send_complete(struct hfi1_qp *qp, struct hfi1_ib_header *hdr)
+void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
 {
 	struct hfi1_other_headers *ohdr;
-	struct hfi1_swqe *wqe;
+	struct rvt_swqe *wqe;
 	struct ib_wc wc;
 	unsigned i;
 	u32 opcode;
@@ -1027,9 +1027,9 @@ void hfi1_rc_send_complete(struct hfi1_qp *qp, struct hfi1_ib_header *hdr)
 		    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
 		for (i = 0; i < wqe->wr.num_sge; i++) {
-			struct hfi1_sge *sge = &wqe->sg_list[i];
+			struct rvt_sge *sge = &wqe->sg_list[i];
 
-			hfi1_put_mr(sge->mr);
+			rvt_put_mr(sge->mr);
 		}
 		/* Post a send completion queue entry if requested. */
 		if (!(qp->s_flags & HFI1_S_SIGNAL_REQ_WR) ||
@@ -1059,7 +1059,7 @@ void hfi1_rc_send_complete(struct hfi1_qp *qp, struct hfi1_ib_header *hdr)
 	}
 }
 
-static inline void update_last_psn(struct hfi1_qp *qp, u32 psn)
+static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 {
 	qp->s_last_psn = psn;
 }
@@ -1069,9 +1069,9 @@ static inline void update_last_psn(struct hfi1_qp *qp, u32 psn)
  * This is similar to hfi1_send_complete but has to check to be sure
  * that the SGEs are not being referenced if the SWQE is being resent.
  */
-static struct hfi1_swqe *do_rc_completion(struct hfi1_qp *qp,
-					  struct hfi1_swqe *wqe,
-					  struct hfi1_ibport *ibp)
+static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
+					 struct rvt_swqe *wqe,
+					 struct hfi1_ibport *ibp)
 {
 	struct ib_wc wc;
 	unsigned i;
@@ -1084,9 +1084,9 @@ static struct hfi1_swqe *do_rc_completion(struct hfi1_qp *qp,
 	if (cmp_psn(wqe->lpsn, qp->s_sending_psn) < 0 ||
 	    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
 		for (i = 0; i < wqe->wr.num_sge; i++) {
-			struct hfi1_sge *sge = &wqe->sg_list[i];
+			struct rvt_sge *sge = &wqe->sg_list[i];
 
-			hfi1_put_mr(sge->mr);
+			rvt_put_mr(sge->mr);
 		}
 		/* Post a send completion queue entry if requested. */
 		if (!(qp->s_flags & HFI1_S_SIGNAL_REQ_WR) ||
@@ -1158,12 +1158,12 @@ static struct hfi1_swqe *do_rc_completion(struct hfi1_qp *qp,
  * May be called at interrupt level, with the QP s_lock held.
  * Returns 1 if OK, 0 if current operation should be aborted (NAK).
  */
-static int do_rc_ack(struct hfi1_qp *qp, u32 aeth, u32 psn, int opcode,
+static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		     u64 val, struct hfi1_ctxtdata *rcd)
 {
 	struct hfi1_ibport *ibp;
 	enum ib_wc_status status;
-	struct hfi1_swqe *wqe;
+	struct rvt_swqe *wqe;
 	int ret = 0;
 	u32 ack_psn;
 	int diff;
@@ -1381,10 +1381,10 @@ bail:
  * We have seen an out of sequence RDMA read middle or last packet.
  * This ACKs SENDs and RDMA writes up to the first RDMA read or atomic SWQE.
  */
-static void rdma_seq_err(struct hfi1_qp *qp, struct hfi1_ibport *ibp, u32 psn,
+static void rdma_seq_err(struct rvt_qp *qp, struct hfi1_ibport *ibp, u32 psn,
 			 struct hfi1_ctxtdata *rcd)
 {
-	struct hfi1_swqe *wqe;
+	struct rvt_swqe *wqe;
 
 	/* Remove QP from retry timer */
 	if (qp->s_flags & (HFI1_S_TIMER | HFI1_S_WAIT_RNR)) {
@@ -1430,11 +1430,11 @@ static void rdma_seq_err(struct hfi1_qp *qp, struct hfi1_ibport *ibp, u32 psn,
  */
 static void rc_rcv_resp(struct hfi1_ibport *ibp,
 			struct hfi1_other_headers *ohdr,
-			void *data, u32 tlen, struct hfi1_qp *qp,
+			void *data, u32 tlen, struct rvt_qp *qp,
 			u32 opcode, u32 psn, u32 hdrsize, u32 pmtu,
 			struct hfi1_ctxtdata *rcd)
 {
-	struct hfi1_swqe *wqe;
+	struct rvt_swqe *wqe;
 	enum ib_wc_status status;
 	unsigned long flags;
 	int diff;
@@ -1625,11 +1625,11 @@ bail:
  * schedule a response to be sent.
  */
 static noinline int rc_rcv_error(struct hfi1_other_headers *ohdr, void *data,
-			struct hfi1_qp *qp, u32 opcode, u32 psn, int diff,
+			struct rvt_qp *qp, u32 opcode, u32 psn, int diff,
 			struct hfi1_ctxtdata *rcd)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct hfi1_ack_entry *e;
+	struct rvt_ack_entry *e;
 	unsigned long flags;
 	u8 i, prev;
 	int old_req;
@@ -1731,7 +1731,7 @@ static noinline int rc_rcv_error(struct hfi1_other_headers *ohdr, void *data,
 		if (unlikely(offset + len != e->rdma_sge.sge_length))
 			goto unlock_done;
 		if (e->rdma_sge.mr) {
-			hfi1_put_mr(e->rdma_sge.mr);
+			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
 		if (len != 0) {
@@ -1739,8 +1739,8 @@ static noinline int rc_rcv_error(struct hfi1_other_headers *ohdr, void *data,
 			u64 vaddr = be64_to_cpu(reth->vaddr);
 			int ok;
 
-			ok = hfi1_rkey_ok(qp, &e->rdma_sge, len, vaddr, rkey,
-					  IB_ACCESS_REMOTE_READ);
+			ok = rvt_rkey_ok(qp, &e->rdma_sge, len, vaddr, rkey,
+					 IB_ACCESS_REMOTE_READ);
 			if (unlikely(!ok))
 				goto unlock_done;
 		} else {
@@ -1807,7 +1807,7 @@ send_ack:
 	return 0;
 }
 
-void hfi1_rc_error(struct hfi1_qp *qp, enum ib_wc_status err)
+void hfi1_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
 {
 	unsigned long flags;
 	int lastwqe;
@@ -1826,7 +1826,7 @@ void hfi1_rc_error(struct hfi1_qp *qp, enum ib_wc_status err)
 	}
 }
 
-static inline void update_ack_queue(struct hfi1_qp *qp, unsigned n)
+static inline void update_ack_queue(struct rvt_qp *qp, unsigned n)
 {
 	unsigned next;
 
@@ -1941,7 +1941,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	u32 rcv_flags = packet->rcv_flags;
 	void *data = packet->ebuf;
 	u32 tlen = packet->tlen;
-	struct hfi1_qp *qp = packet->qp;
+	struct rvt_qp *qp = packet->qp;
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct hfi1_other_headers *ohdr = packet->ohdr;
@@ -2158,8 +2158,8 @@ send_last:
 			int ok;
 
 			/* Check rkey & NAK */
-			ok = hfi1_rkey_ok(qp, &qp->r_sge.sge, qp->r_len, vaddr,
-					  rkey, IB_ACCESS_REMOTE_WRITE);
+			ok = rvt_rkey_ok(qp, &qp->r_sge.sge, qp->r_len, vaddr,
+					 rkey, IB_ACCESS_REMOTE_WRITE);
 			if (unlikely(!ok))
 				goto nack_acc;
 			qp->r_sge.num_sge = 1;
@@ -2184,7 +2184,7 @@ send_last:
 		goto send_last;
 
 	case OP(RDMA_READ_REQUEST): {
-		struct hfi1_ack_entry *e;
+		struct rvt_ack_entry *e;
 		u32 len;
 		u8 next;
 
@@ -2202,7 +2202,7 @@ send_last:
 		}
 		e = &qp->s_ack_queue[qp->r_head_ack_queue];
 		if (e->opcode == OP(RDMA_READ_REQUEST) && e->rdma_sge.mr) {
-			hfi1_put_mr(e->rdma_sge.mr);
+			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
 		reth = &ohdr->u.rc.reth;
@@ -2213,8 +2213,8 @@ send_last:
 			int ok;
 
 			/* Check rkey & NAK */
-			ok = hfi1_rkey_ok(qp, &e->rdma_sge, len, vaddr,
-					  rkey, IB_ACCESS_REMOTE_READ);
+			ok = rvt_rkey_ok(qp, &e->rdma_sge, len, vaddr,
+					 rkey, IB_ACCESS_REMOTE_READ);
 			if (unlikely(!ok))
 				goto nack_acc_unlck;
 			/*
@@ -2257,7 +2257,7 @@ send_last:
 	case OP(COMPARE_SWAP):
 	case OP(FETCH_ADD): {
 		struct ib_atomic_eth *ateth;
-		struct hfi1_ack_entry *e;
+		struct rvt_ack_entry *e;
 		u64 vaddr;
 		atomic64_t *maddr;
 		u64 sdata;
@@ -2277,7 +2277,7 @@ send_last:
 		}
 		e = &qp->s_ack_queue[qp->r_head_ack_queue];
 		if (e->opcode == OP(RDMA_READ_REQUEST) && e->rdma_sge.mr) {
-			hfi1_put_mr(e->rdma_sge.mr);
+			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
 		ateth = &ohdr->u.atomic_eth;
@@ -2287,9 +2287,9 @@ send_last:
 			goto nack_inv_unlck;
 		rkey = be32_to_cpu(ateth->rkey);
 		/* Check rkey & NAK */
-		if (unlikely(!hfi1_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
-					   vaddr, rkey,
-					   IB_ACCESS_REMOTE_ATOMIC)))
+		if (unlikely(!rvt_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
+					  vaddr, rkey,
+					  IB_ACCESS_REMOTE_ATOMIC)))
 			goto nack_acc_unlck;
 		/* Perform atomic OP and save result. */
 		maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
@@ -2299,7 +2299,7 @@ send_last:
 			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
 				      be64_to_cpu(ateth->compare_data),
 				      sdata);
-		hfi1_put_mr(qp->r_sge.sge.mr);
+		rvt_put_mr(qp->r_sge.sge.mr);
 		qp->r_sge.num_sge = 0;
 		e->opcode = opcode;
 		e->sent = 0;
@@ -2385,7 +2385,7 @@ void hfi1_rc_hdrerr(
 	struct hfi1_ctxtdata *rcd,
 	struct hfi1_ib_header *hdr,
 	u32 rcv_flags,
-	struct hfi1_qp *qp)
+	struct rvt_qp *qp)
 {
 	int has_grh = rcv_flags & HFI1_HAS_GRH;
 	struct hfi1_other_headers *ohdr;
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 0313c20..10ff5e8 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -97,15 +97,15 @@ const u32 ib_hfi1_rnr_table[32] = {
  * Validate a RWQE and fill in the SGE state.
  * Return 1 if OK.
  */
-static int init_sge(struct hfi1_qp *qp, struct hfi1_rwqe *wqe)
+static int init_sge(struct rvt_qp *qp, struct rvt_rwqe *wqe)
 {
 	int i, j, ret;
 	struct ib_wc wc;
 	struct rvt_lkey_table *rkt;
 	struct rvt_pd *pd;
-	struct hfi1_sge_state *ss;
+	struct rvt_sge_state *ss;
 
-	rkt = &to_idev(qp->ibqp.device)->lk_table;
+	rkt = &to_idev(qp->ibqp.device)->rdi.lkey_table;
 	pd = ibpd_to_rvtpd(qp->ibqp.srq ? qp->ibqp.srq->pd : qp->ibqp.pd);
 	ss = &qp->r_sge;
 	ss->sg_list = qp->r_sg_list;
@@ -114,8 +114,8 @@ static int init_sge(struct hfi1_qp *qp, struct hfi1_rwqe *wqe)
 		if (wqe->sg_list[i].length == 0)
 			continue;
 		/* Check LKEY */
-		if (!hfi1_lkey_ok(rkt, pd, j ? &ss->sg_list[j - 1] : &ss->sge,
-				  &wqe->sg_list[i], IB_ACCESS_LOCAL_WRITE))
+		if (!rvt_lkey_ok(rkt, pd, j ? &ss->sg_list[j - 1] : &ss->sge,
+				 &wqe->sg_list[i], IB_ACCESS_LOCAL_WRITE))
 			goto bad_lkey;
 		qp->r_len += wqe->sg_list[i].length;
 		j++;
@@ -127,9 +127,9 @@ static int init_sge(struct hfi1_qp *qp, struct hfi1_rwqe *wqe)
 
 bad_lkey:
 	while (j) {
-		struct hfi1_sge *sge = --j ? &ss->sg_list[j - 1] : &ss->sge;
+		struct rvt_sge *sge = --j ? &ss->sg_list[j - 1] : &ss->sge;
 
-		hfi1_put_mr(sge->mr);
+		rvt_put_mr(sge->mr);
 	}
 	ss->num_sge = 0;
 	memset(&wc, 0, sizeof(wc));
@@ -154,13 +154,13 @@ bail:
  *
  * Can be called from interrupt level.
  */
-int hfi1_get_rwqe(struct hfi1_qp *qp, int wr_id_only)
+int hfi1_get_rwqe(struct rvt_qp *qp, int wr_id_only)
 {
 	unsigned long flags;
-	struct hfi1_rq *rq;
-	struct hfi1_rwq *wq;
+	struct rvt_rq *rq;
+	struct rvt_rwq *wq;
 	struct hfi1_srq *srq;
-	struct hfi1_rwqe *wqe;
+	struct rvt_rwqe *wqe;
 	void (*handler)(struct ib_event *, void *);
 	u32 tail;
 	int ret;
@@ -245,7 +245,7 @@ bail:
  * Switch to alternate path.
  * The QP s_lock should be held and interrupts disabled.
  */
-void hfi1_migrate_qp(struct hfi1_qp *qp)
+void hfi1_migrate_qp(struct rvt_qp *qp)
 {
 	struct ib_event ev;
 
@@ -285,7 +285,7 @@ static int gid_ok(union ib_gid *gid, __be64 gid_prefix, __be64 id)
  * The s_lock will be acquired around the hfi1_migrate_qp() call.
  */
 int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
-		       int has_grh, struct hfi1_qp *qp, u32 bth0)
+		       int has_grh, struct rvt_qp *qp, u32 bth0)
 {
 	__be64 guid;
 	unsigned long flags;
@@ -373,12 +373,12 @@ err:
  * receive interrupts since this is a connected protocol and all packets
  * will pass through here.
  */
-static void ruc_loopback(struct hfi1_qp *sqp)
+static void ruc_loopback(struct rvt_qp *sqp)
 {
 	struct hfi1_ibport *ibp = to_iport(sqp->ibqp.device, sqp->port_num);
-	struct hfi1_qp *qp;
-	struct hfi1_swqe *wqe;
-	struct hfi1_sge *sge;
+	struct rvt_qp *qp;
+	struct rvt_swqe *wqe;
+	struct rvt_sge *sge;
 	unsigned long flags;
 	struct ib_wc wc;
 	u64 sdata;
@@ -479,11 +479,10 @@ again:
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_WRITE)))
 			goto inv_err;
 		if (wqe->length == 0)
-			break;
-		if (unlikely(!hfi1_rkey_ok(qp, &qp->r_sge.sge, wqe->length,
-					   wqe->rdma_wr.remote_addr,
-					   wqe->rdma_wr.rkey,
-					   IB_ACCESS_REMOTE_WRITE)))
+		if (unlikely(!rvt_rkey_ok(qp, &qp->r_sge.sge, wqe->length,
+					  wqe->rdma_wr.remote_addr,
+					  wqe->rdma_wr.rkey,
+					  IB_ACCESS_REMOTE_WRITE)))
 			goto acc_err;
 		qp->r_sge.sg_list = NULL;
 		qp->r_sge.num_sge = 1;
@@ -493,10 +492,10 @@ again:
 	case IB_WR_RDMA_READ:
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_READ)))
 			goto inv_err;
-		if (unlikely(!hfi1_rkey_ok(qp, &sqp->s_sge.sge, wqe->length,
-					   wqe->rdma_wr.remote_addr,
-					   wqe->rdma_wr.rkey,
-					   IB_ACCESS_REMOTE_READ)))
+		if (unlikely(!rvt_rkey_ok(qp, &sqp->s_sge.sge, wqe->length,
+					  wqe->rdma_wr.remote_addr,
+					  wqe->rdma_wr.rkey,
+					  IB_ACCESS_REMOTE_READ)))
 			goto acc_err;
 		release = 0;
 		sqp->s_sge.sg_list = NULL;
@@ -511,10 +510,10 @@ again:
 	case IB_WR_ATOMIC_FETCH_AND_ADD:
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_ATOMIC)))
 			goto inv_err;
-		if (unlikely(!hfi1_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
-					   wqe->atomic_wr.remote_addr,
-					   wqe->atomic_wr.rkey,
-					   IB_ACCESS_REMOTE_ATOMIC)))
+		if (unlikely(!rvt_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
+					  wqe->atomic_wr.remote_addr,
+					  wqe->atomic_wr.rkey,
+					  IB_ACCESS_REMOTE_ATOMIC)))
 			goto acc_err;
 		/* Perform atomic OP and save result. */
 		maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
@@ -524,7 +523,7 @@ again:
 			(u64) atomic64_add_return(sdata, maddr) - sdata :
 			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
 				      sdata, wqe->atomic_wr.swap);
-		hfi1_put_mr(qp->r_sge.sge.mr);
+		rvt_put_mr(qp->r_sge.sge.mr);
 		qp->r_sge.num_sge = 0;
 		goto send_comp;
 
@@ -548,7 +547,7 @@ again:
 		sge->sge_length -= len;
 		if (sge->sge_length == 0) {
 			if (!release)
-				hfi1_put_mr(sge->mr);
+				rvt_put_mr(sge->mr);
 			if (--sqp->s_sge.num_sge)
 				*sge = *sqp->s_sge.sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
@@ -695,6 +694,21 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 	return sizeof(struct ib_grh) / sizeof(u32);
 }
 
+/*
+ * free_ahg - clear ahg from QP
+ */
+void clear_ahg(struct rvt_qp *qp)
+{
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	priv->s_hdr->ahgcount = 0;
+	qp->s_flags &= ~(HFI1_S_AHG_VALID | HFI1_S_AHG_CLEAR);
+	if (qp->s_sde)
+		sdma_ahg_free(qp->s_sde, qp->s_ahgidx);
+	qp->s_ahgidx = -1;
+	qp->s_sde = NULL;
+}
+
 #define BTH2_OFFSET (offsetof(struct hfi1_pio_header, hdr.u.oth.bth[2]) / 4)
 
 /**
@@ -708,7 +722,7 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
  * Subsequent middles use the copied entry, editing the
  * PSN with 1 or 2 edits.
  */
-static inline void build_ahg(struct hfi1_qp *qp, u32 npsn)
+static inline void build_ahg(struct rvt_qp *qp, u32 npsn)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	if (unlikely(qp->s_flags & HFI1_S_AHG_CLEAR))
@@ -755,7 +769,7 @@ static inline void build_ahg(struct hfi1_qp *qp, u32 npsn)
 	}
 }
 
-void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
+void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 			  u32 bth0, u32 bth2, int middle)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
@@ -836,11 +850,11 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 void hfi1_do_send(struct work_struct *work)
 {
 	struct iowait *wait = container_of(work, struct iowait, iowork);
-	struct hfi1_qp *qp = iowait_to_qp(wait);
+	struct rvt_qp *qp = iowait_to_qp(wait);
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	int (*make_req)(struct hfi1_qp *qp);
+	int (*make_req)(struct rvt_qp *qp);
 	unsigned long flags;
 	unsigned long timeout;
 
@@ -899,7 +913,7 @@ void hfi1_do_send(struct work_struct *work)
 /*
  * This should be called with s_lock held.
  */
-void hfi1_send_complete(struct hfi1_qp *qp, struct hfi1_swqe *wqe,
+void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 			enum ib_wc_status status)
 {
 	u32 old_last, last;
@@ -909,9 +923,9 @@ void hfi1_send_complete(struct hfi1_qp *qp, struct hfi1_swqe *wqe,
 		return;
 
 	for (i = 0; i < wqe->wr.num_sge; i++) {
-		struct hfi1_sge *sge = &wqe->sg_list[i];
+		struct rvt_sge *sge = &wqe->sg_list[i];
 
-		hfi1_put_mr(sge->mr);
+		rvt_put_mr(sge->mr);
 	}
 	if (qp->ibqp.qp_type == IB_QPT_UD ||
 	    qp->ibqp.qp_type == IB_QPT_SMI ||
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 1a7a89d..ae84b31 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -379,10 +379,10 @@ struct sdma_txreq {
 struct verbs_txreq {
 	struct hfi1_pio_header	phdr;
 	struct sdma_txreq       txreq;
-	struct hfi1_qp           *qp;
-	struct hfi1_swqe         *wqe;
+	struct rvt_qp           *qp;
+	struct rvt_swqe         *wqe;
 	struct rvt_mregion	*mr;
-	struct hfi1_sge_state    *ss;
+	struct rvt_sge_state    *ss;
 	struct sdma_engine     *sde;
 	u16                     hdr_dwords;
 	u16                     hdr_inx;
diff --git a/drivers/staging/rdma/hfi1/srq.c b/drivers/staging/rdma/hfi1/srq.c
index 67786d4..932bd96 100644
--- a/drivers/staging/rdma/hfi1/srq.c
+++ b/drivers/staging/rdma/hfi1/srq.c
@@ -66,12 +66,12 @@ int hfi1_post_srq_receive(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 			  struct ib_recv_wr **bad_wr)
 {
 	struct hfi1_srq *srq = to_isrq(ibsrq);
-	struct hfi1_rwq *wq;
+	struct rvt_rwq *wq;
 	unsigned long flags;
 	int ret;
 
 	for (; wr; wr = wr->next) {
-		struct hfi1_rwqe *wqe;
+		struct rvt_rwqe *wqe;
 		u32 next;
 		int i;
 
@@ -149,8 +149,8 @@ struct ib_srq *hfi1_create_srq(struct ib_pd *ibpd,
 	srq->rq.size = srq_init_attr->attr.max_wr + 1;
 	srq->rq.max_sge = srq_init_attr->attr.max_sge;
 	sz = sizeof(struct ib_sge) * srq->rq.max_sge +
-		sizeof(struct hfi1_rwqe);
-	srq->rq.wq = vmalloc_user(sizeof(struct hfi1_rwq) + srq->rq.size * sz);
+		sizeof(struct rvt_rwqe);
+	srq->rq.wq = vmalloc_user(sizeof(struct rvt_rwq) + srq->rq.size * sz);
 	if (!srq->rq.wq) {
 		ret = ERR_PTR(-ENOMEM);
 		goto bail_srq;
@@ -162,7 +162,7 @@ struct ib_srq *hfi1_create_srq(struct ib_pd *ibpd,
 	 */
 	if (udata && udata->outlen >= sizeof(__u64)) {
 		int err;
-		u32 s = sizeof(struct hfi1_rwq) + srq->rq.size * sz;
+		u32 s = sizeof(struct rvt_rwq) + srq->rq.size * sz;
 
 		srq->ip =
 		    hfi1_create_mmap_info(dev, s, ibpd->uobject->context,
@@ -230,12 +230,12 @@ int hfi1_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		    struct ib_udata *udata)
 {
 	struct hfi1_srq *srq = to_isrq(ibsrq);
-	struct hfi1_rwq *wq;
+	struct rvt_rwq *wq;
 	int ret = 0;
 
 	if (attr_mask & IB_SRQ_MAX_WR) {
-		struct hfi1_rwq *owq;
-		struct hfi1_rwqe *p;
+		struct rvt_rwq *owq;
+		struct rvt_rwqe *p;
 		u32 sz, size, n, head, tail;
 
 		/* Check that the requested sizes are below the limits. */
@@ -246,10 +246,10 @@ int hfi1_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			goto bail;
 		}
 
-		sz = sizeof(struct hfi1_rwqe) +
+		sz = sizeof(struct rvt_rwqe) +
 			srq->rq.max_sge * sizeof(struct ib_sge);
 		size = attr->max_wr + 1;
-		wq = vmalloc_user(sizeof(struct hfi1_rwq) + size * sz);
+		wq = vmalloc_user(sizeof(struct rvt_rwq) + size * sz);
 		if (!wq) {
 			ret = -ENOMEM;
 			goto bail;
@@ -296,7 +296,7 @@ int hfi1_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		n = 0;
 		p = wq->wq;
 		while (tail != head) {
-			struct hfi1_rwqe *wqe;
+			struct rvt_rwqe *wqe;
 			int i;
 
 			wqe = get_rwqe_ptr(&srq->rq, tail);
@@ -305,7 +305,7 @@ int hfi1_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			for (i = 0; i < wqe->num_sge; i++)
 				p->sg_list[i] = wqe->sg_list[i];
 			n++;
-			p = (struct hfi1_rwqe *)((char *)p + sz);
+			p = (struct rvt_rwqe *)((char *)p + sz);
 			if (++tail >= srq->rq.size)
 				tail = 0;
 		}
@@ -320,9 +320,9 @@ int hfi1_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		vfree(owq);
 
 		if (srq->ip) {
-			struct hfi1_mmap_info *ip = srq->ip;
+			struct rvt_mmap_info *ip = srq->ip;
 			struct hfi1_ibdev *dev = to_idev(srq->ibsrq.device);
-			u32 s = sizeof(struct hfi1_rwq) + size * sz;
+			u32 s = sizeof(struct rvt_rwq) + size * sz;
 
 			hfi1_update_mmap_info(dev, ip, s, wq);
 
diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/staging/rdma/hfi1/trace.h
index 5743029..570ad4c 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -294,7 +294,7 @@ TRACE_EVENT(hfi1_wantpiointr,
 );
 
 DECLARE_EVENT_CLASS(hfi1_qpsleepwakeup_template,
-	TP_PROTO(struct hfi1_qp *qp, u32 flags),
+	TP_PROTO(struct rvt_qp *qp, u32 flags),
 	TP_ARGS(qp, flags),
 	TP_STRUCT__entry(
 		DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
@@ -318,17 +318,17 @@ DECLARE_EVENT_CLASS(hfi1_qpsleepwakeup_template,
 );
 
 DEFINE_EVENT(hfi1_qpsleepwakeup_template, hfi1_qpwakeup,
-	     TP_PROTO(struct hfi1_qp *qp, u32 flags),
+	     TP_PROTO(struct rvt_qp *qp, u32 flags),
 	     TP_ARGS(qp, flags));
 
 DEFINE_EVENT(hfi1_qpsleepwakeup_template, hfi1_qpsleep,
-	     TP_PROTO(struct hfi1_qp *qp, u32 flags),
+	     TP_PROTO(struct rvt_qp *qp, u32 flags),
 	     TP_ARGS(qp, flags));
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM hfi1_qphash
 DECLARE_EVENT_CLASS(hfi1_qphash_template,
-	TP_PROTO(struct hfi1_qp *qp, u32 bucket),
+	TP_PROTO(struct rvt_qp *qp, u32 bucket),
 	TP_ARGS(qp, bucket),
 	TP_STRUCT__entry(
 		DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
@@ -349,11 +349,11 @@ DECLARE_EVENT_CLASS(hfi1_qphash_template,
 );
 
 DEFINE_EVENT(hfi1_qphash_template, hfi1_qpinsert,
-	TP_PROTO(struct hfi1_qp *qp, u32 bucket),
+	TP_PROTO(struct rvt_qp *qp, u32 bucket),
 	TP_ARGS(qp, bucket));
 
 DEFINE_EVENT(hfi1_qphash_template, hfi1_qpremove,
-	TP_PROTO(struct hfi1_qp *qp, u32 bucket),
+	TP_PROTO(struct rvt_qp *qp, u32 bucket),
 	TP_ARGS(qp, bucket));
 
 #undef TRACE_SYSTEM
@@ -1253,7 +1253,7 @@ TRACE_EVENT(hfi1_sdma_state,
 #define TRACE_SYSTEM hfi1_rc
 
 DECLARE_EVENT_CLASS(hfi1_rc_template,
-	TP_PROTO(struct hfi1_qp *qp, u32 psn),
+	TP_PROTO(struct rvt_qp *qp, u32 psn),
 	TP_ARGS(qp, psn),
 	TP_STRUCT__entry(
 		DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
@@ -1292,22 +1292,22 @@ DECLARE_EVENT_CLASS(hfi1_rc_template,
 );
 
 DEFINE_EVENT(hfi1_rc_template, hfi1_rc_sendcomplete,
-	     TP_PROTO(struct hfi1_qp *qp, u32 psn),
+	     TP_PROTO(struct rvt_qp *qp, u32 psn),
 	     TP_ARGS(qp, psn)
 );
 
 DEFINE_EVENT(hfi1_rc_template, hfi1_rc_ack,
-	     TP_PROTO(struct hfi1_qp *qp, u32 psn),
+	     TP_PROTO(struct rvt_qp *qp, u32 psn),
 	     TP_ARGS(qp, psn)
 );
 
 DEFINE_EVENT(hfi1_rc_template, hfi1_rc_timeout,
-	     TP_PROTO(struct hfi1_qp *qp, u32 psn),
+	     TP_PROTO(struct rvt_qp *qp, u32 psn),
 	     TP_ARGS(qp, psn)
 );
 
 DEFINE_EVENT(hfi1_rc_template, hfi1_rc_rcv_error,
-	     TP_PROTO(struct hfi1_qp *qp, u32 psn),
+	     TP_PROTO(struct rvt_qp *qp, u32 psn),
 	     TP_ARGS(qp, psn)
 );
 
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index c0170ac..f4e8ad2 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -61,11 +61,11 @@
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int hfi1_make_uc_req(struct hfi1_qp *qp)
+int hfi1_make_uc_req(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_other_headers *ohdr;
-	struct hfi1_swqe *wqe;
+	struct rvt_swqe *wqe;
 	unsigned long flags;
 	u32 hwords = 5;
 	u32 bth0 = 0;
@@ -267,7 +267,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 	u32 rcv_flags = packet->rcv_flags;
 	void *data = packet->ebuf;
 	u32 tlen = packet->tlen;
-	struct hfi1_qp *qp = packet->qp;
+	struct rvt_qp *qp = packet->qp;
 	struct hfi1_other_headers *ohdr = packet->ohdr;
 	u32 opcode;
 	u32 hdrsize = packet->hlen;
@@ -489,8 +489,8 @@ rdma_first:
 			int ok;
 
 			/* Check rkey */
-			ok = hfi1_rkey_ok(qp, &qp->r_sge.sge, qp->r_len,
-					  vaddr, rkey, IB_ACCESS_REMOTE_WRITE);
+			ok = rvt_rkey_ok(qp, &qp->r_sge.sge, qp->r_len,
+					 vaddr, rkey, IB_ACCESS_REMOTE_WRITE);
 			if (unlikely(!ok))
 				goto drop;
 			qp->r_sge.num_sge = 1;
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index b8a645b..525fd74 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -65,15 +65,15 @@
  * Note that the receive interrupt handler may be calling hfi1_ud_rcv()
  * while this is being called.
  */
-static void ud_loopback(struct hfi1_qp *sqp, struct hfi1_swqe *swqe)
+static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 {
 	struct hfi1_ibport *ibp = to_iport(sqp->ibqp.device, sqp->port_num);
 	struct hfi1_pportdata *ppd;
-	struct hfi1_qp *qp;
+	struct rvt_qp *qp;
 	struct ib_ah_attr *ah_attr;
 	unsigned long flags;
-	struct hfi1_sge_state ssge;
-	struct hfi1_sge *sge;
+	struct rvt_sge_state ssge;
+	struct rvt_sge *sge;
 	struct ib_wc wc;
 	u32 length;
 	enum ib_qp_type sqptype, dqptype;
@@ -263,14 +263,14 @@ drop:
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int hfi1_make_ud_req(struct hfi1_qp *qp)
+int hfi1_make_ud_req(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_other_headers *ohdr;
 	struct ib_ah_attr *ah_attr;
 	struct hfi1_pportdata *ppd;
 	struct hfi1_ibport *ibp;
-	struct hfi1_swqe *wqe;
+	struct rvt_swqe *wqe;
 	unsigned long flags;
 	u32 nwords;
 	u32 extra_bytes;
@@ -477,7 +477,7 @@ int hfi1_lookup_pkey_idx(struct hfi1_ibport *ibp, u16 pkey)
 	return -1;
 }
 
-void return_cnp(struct hfi1_ibport *ibp, struct hfi1_qp *qp, u32 remote_qpn,
+void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 		u32 pkey, u32 slid, u32 dlid, u8 sc5,
 		const struct ib_grh *old_grh)
 {
@@ -551,7 +551,7 @@ void return_cnp(struct hfi1_ibport *ibp, struct hfi1_qp *qp, u32 remote_qpn,
  * opa_smp_check() returns 0 if all checks succeed, 1 otherwise.
  */
 static int opa_smp_check(struct hfi1_ibport *ibp, u16 pkey, u8 sc5,
-			 struct hfi1_qp *qp, u16 slid, struct opa_smp *smp)
+			 struct rvt_qp *qp, u16 slid, struct opa_smp *smp)
 {
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 
@@ -655,7 +655,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	u32 rcv_flags = packet->rcv_flags;
 	void *data = packet->ebuf;
 	u32 tlen = packet->tlen;
-	struct hfi1_qp *qp = packet->qp;
+	struct rvt_qp *qp = packet->qp;
 	bool has_grh = rcv_flags & HFI1_HAS_GRH;
 	bool sc4_bit = has_sc4_bit(packet);
 	u8 sc;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 0ac39e1..e23c5da 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -65,7 +65,7 @@
 #include "qp.h"
 #include "sdma.h"
 
-unsigned int hfi1_lkey_table_size = 16;
+static unsigned int hfi1_lkey_table_size = 16;
 module_param_named(lkey_table_size, hfi1_lkey_table_size, uint,
 		   S_IRUGO);
 MODULE_PARM_DESC(lkey_table_size,
@@ -274,11 +274,11 @@ __be64 ib_hfi1_sys_image_guid;
  * @length: the length of the data
  */
 void hfi1_copy_sge(
-	struct hfi1_sge_state *ss,
+	struct rvt_sge_state *ss,
 	void *data, u32 length,
 	int release)
 {
-	struct hfi1_sge *sge = &ss->sge;
+	struct rvt_sge *sge = &ss->sge;
 
 	while (length) {
 		u32 len = sge->length;
@@ -294,7 +294,7 @@ void hfi1_copy_sge(
 		sge->sge_length -= len;
 		if (sge->sge_length == 0) {
 			if (release)
-				hfi1_put_mr(sge->mr);
+				rvt_put_mr(sge->mr);
 			if (--ss->num_sge)
 				*sge = *ss->sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
@@ -318,9 +318,9 @@ void hfi1_copy_sge(
  * @ss: the SGE state
  * @length: the number of bytes to skip
  */
-void hfi1_skip_sge(struct hfi1_sge_state *ss, u32 length, int release)
+void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, int release)
 {
-	struct hfi1_sge *sge = &ss->sge;
+	struct rvt_sge *sge = &ss->sge;
 
 	while (length) {
 		u32 len = sge->length;
@@ -335,7 +335,7 @@ void hfi1_skip_sge(struct hfi1_sge_state *ss, u32 length, int release)
 		sge->sge_length -= len;
 		if (sge->sge_length == 0) {
 			if (release)
-				hfi1_put_mr(sge->mr);
+				rvt_put_mr(sge->mr);
 			if (--ss->num_sge)
 				*sge = *ss->sg_list++;
 		} else if (sge->length == 0 && sge->mr->lkey) {
@@ -358,9 +358,9 @@ void hfi1_skip_sge(struct hfi1_sge_state *ss, u32 length, int release)
  * @qp: the QP to post on
  * @wr: the work request to send
  */
-static int post_one_send(struct hfi1_qp *qp, struct ib_send_wr *wr)
+static int post_one_send(struct rvt_qp *qp, struct ib_send_wr *wr)
 {
-	struct hfi1_swqe *wqe;
+	struct rvt_swqe *wqe;
 	u32 next;
 	int i;
 	int j;
@@ -410,7 +410,7 @@ static int post_one_send(struct hfi1_qp *qp, struct ib_send_wr *wr)
 	if (next == qp->s_last)
 		return -ENOMEM;
 
-	rkt = &to_idev(qp->ibqp.device)->lk_table;
+	rkt = &to_idev(qp->ibqp.device)->rdi.lkey_table;
 	pd = ibpd_to_rvtpd(qp->ibqp.pd);
 	wqe = get_swqe_ptr(qp, qp->s_head);
 
@@ -439,8 +439,8 @@ static int post_one_send(struct hfi1_qp *qp, struct ib_send_wr *wr)
 
 			if (length == 0)
 				continue;
-			ok = hfi1_lkey_ok(rkt, pd, &wqe->sg_list[j],
-					  &wr->sg_list[i], acc);
+			ok = rvt_lkey_ok(rkt, pd, &wqe->sg_list[j],
+					 &wr->sg_list[i], acc);
 			if (!ok)
 				goto bail_inval_free;
 			wqe->length += length;
@@ -463,9 +463,9 @@ static int post_one_send(struct hfi1_qp *qp, struct ib_send_wr *wr)
 bail_inval_free:
 	/* release mr holds */
 	while (j) {
-		struct hfi1_sge *sge = &wqe->sg_list[--j];
+		struct rvt_sge *sge = &wqe->sg_list[--j];
 
-		hfi1_put_mr(sge->mr);
+		rvt_put_mr(sge->mr);
 	}
 	return -EINVAL;
 }
@@ -481,7 +481,7 @@ bail_inval_free:
 static int post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		     struct ib_send_wr **bad_wr)
 {
-	struct hfi1_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 	struct hfi1_qp_priv *priv = qp->priv;
 	int err = 0;
 	int call_send;
@@ -527,8 +527,8 @@ bail:
 static int post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			struct ib_recv_wr **bad_wr)
 {
-	struct hfi1_qp *qp = to_iqp(ibqp);
-	struct hfi1_rwq *wq = qp->r_rq.wq;
+	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_rwq *wq = qp->r_rq.wq;
 	unsigned long flags;
 	int ret;
 
@@ -540,7 +540,7 @@ static int post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	}
 
 	for (; wr; wr = wr->next) {
-		struct hfi1_rwqe *wqe;
+		struct rvt_rwqe *wqe;
 		u32 next;
 		int i;
 
@@ -692,7 +692,7 @@ static void mem_timer(unsigned long data)
 {
 	struct hfi1_ibdev *dev = (struct hfi1_ibdev *)data;
 	struct list_head *list = &dev->memwait;
-	struct hfi1_qp *qp = NULL;
+	struct rvt_qp *qp = NULL;
 	struct iowait *wait;
 	unsigned long flags;
 	struct hfi1_qp_priv *priv;
@@ -713,9 +713,9 @@ static void mem_timer(unsigned long data)
 		hfi1_qp_wakeup(qp, HFI1_S_WAIT_KMEM);
 }
 
-void update_sge(struct hfi1_sge_state *ss, u32 length)
+void update_sge(struct rvt_sge_state *ss, u32 length)
 {
-	struct hfi1_sge *sge = &ss->sge;
+	struct rvt_sge *sge = &ss->sge;
 
 	sge->vaddr += length;
 	sge->length -= length;
@@ -735,7 +735,7 @@ void update_sge(struct hfi1_sge_state *ss, u32 length)
 }
 
 static noinline struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
-						struct hfi1_qp *qp)
+						struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct verbs_txreq *tx;
@@ -762,7 +762,7 @@ static noinline struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 }
 
 static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
-					    struct hfi1_qp *qp)
+					    struct rvt_qp *qp)
 {
 	struct verbs_txreq *tx;
 
@@ -780,7 +780,7 @@ static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
 void hfi1_put_txreq(struct verbs_txreq *tx)
 {
 	struct hfi1_ibdev *dev;
-	struct hfi1_qp *qp;
+	struct rvt_qp *qp;
 	unsigned long flags;
 	unsigned int seq;
 	struct hfi1_qp_priv *priv;
@@ -789,7 +789,7 @@ void hfi1_put_txreq(struct verbs_txreq *tx)
 	dev = to_idev(qp->ibqp.device);
 
 	if (tx->mr) {
-		hfi1_put_mr(tx->mr);
+		rvt_put_mr(tx->mr);
 		tx->mr = NULL;
 	}
 	sdma_txclean(dd_from_dev(dev), &tx->txreq);
@@ -828,7 +828,7 @@ static void verbs_sdma_complete(
 {
 	struct verbs_txreq *tx =
 		container_of(cookie, struct verbs_txreq, txreq);
-	struct hfi1_qp *qp = tx->qp;
+	struct rvt_qp *qp = tx->qp;
 
 	spin_lock(&qp->s_lock);
 	if (tx->wqe)
@@ -856,7 +856,7 @@ static void verbs_sdma_complete(
 	hfi1_put_txreq(tx);
 }
 
-static int wait_kmem(struct hfi1_ibdev *dev, struct hfi1_qp *qp)
+static int wait_kmem(struct hfi1_ibdev *dev, struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	unsigned long flags;
@@ -889,12 +889,12 @@ static int wait_kmem(struct hfi1_ibdev *dev, struct hfi1_qp *qp)
  */
 static int build_verbs_ulp_payload(
 	struct sdma_engine *sde,
-	struct hfi1_sge_state *ss,
+	struct rvt_sge_state *ss,
 	u32 length,
 	struct verbs_txreq *tx)
 {
-	struct hfi1_sge *sg_list = ss->sg_list;
-	struct hfi1_sge sge = ss->sge;
+	struct rvt_sge *sg_list = ss->sg_list;
+	struct rvt_sge sge = ss->sge;
 	u8 num_sge = ss->num_sge;
 	u32 len;
 	int ret = 0;
@@ -937,7 +937,7 @@ bail_txadd:
 /* New API */
 static int build_verbs_tx_desc(
 	struct sdma_engine *sde,
-	struct hfi1_sge_state *ss,
+	struct rvt_sge_state *ss,
 	u32 length,
 	struct verbs_txreq *tx,
 	struct ahg_ib_header *ahdr,
@@ -1004,8 +1004,8 @@ bail_txadd:
 	return ret;
 }
 
-int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
-			u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
+int hfi1_verbs_send_dma(struct rvt_qp *qp, struct ahg_ib_header *ahdr,
+			u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			u32 plen, u32 dwords, u64 pbc)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
@@ -1084,7 +1084,7 @@ bail_tx:
  * If we are now in the error state, return zero to flush the
  * send work request.
  */
-static int no_bufs_available(struct hfi1_qp *qp, struct send_context *sc)
+static int no_bufs_available(struct rvt_qp *qp, struct send_context *sc)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_devdata *dd = sc->dd;
@@ -1123,7 +1123,7 @@ static int no_bufs_available(struct hfi1_qp *qp, struct send_context *sc)
 	return ret;
 }
 
-struct send_context *qp_to_send_context(struct hfi1_qp *qp, u8 sc5)
+struct send_context *qp_to_send_context(struct rvt_qp *qp, u8 sc5)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	struct hfi1_pportdata *ppd = dd->pport + (qp->port_num - 1);
@@ -1135,8 +1135,8 @@ struct send_context *qp_to_send_context(struct hfi1_qp *qp, u8 sc5)
 	return dd->vld[vl].sc;
 }
 
-int hfi1_verbs_send_pio(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
-			u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
+int hfi1_verbs_send_pio(struct rvt_qp *qp, struct ahg_ib_header *ahdr,
+			u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			u32 plen, u32 dwords, u64 pbc)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
@@ -1209,7 +1209,7 @@ int hfi1_verbs_send_pio(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
 	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device), &ahdr->ibh);
 
 	if (qp->s_rdma_mr) {
-		hfi1_put_mr(qp->s_rdma_mr);
+		rvt_put_mr(qp->s_rdma_mr);
 		qp->s_rdma_mr = NULL;
 	}
 
@@ -1256,7 +1256,7 @@ static inline int egress_pkey_matches_entry(u16 pkey, u16 ent)
  */
 static inline int egress_pkey_check(struct hfi1_pportdata *ppd,
 				    struct hfi1_ib_header *hdr,
-				    struct hfi1_qp *qp)
+				    struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_other_headers *ohdr;
@@ -1322,8 +1322,8 @@ bad:
  * Return zero if packet is sent or queued OK.
  * Return non-zero and clear qp->s_flags HFI1_S_BUSY otherwise.
  */
-int hfi1_verbs_send(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
-		    u32 hdrwords, struct hfi1_sge_state *ss, u32 len)
+int hfi1_verbs_send(struct rvt_qp *qp, struct ahg_ib_header *ahdr,
+		    u32 hdrwords, struct rvt_sge_state *ss, u32 len)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	u32 plen;
@@ -1413,8 +1413,8 @@ static int query_device(struct ib_device *ibdev,
 	props->max_cq = hfi1_max_cqs;
 	props->max_ah = hfi1_max_ahs;
 	props->max_cqe = hfi1_max_cqes;
-	props->max_mr = dev->lk_table.max;
-	props->max_fmr = dev->lk_table.max;
+	props->max_mr = dev->rdi.lkey_table.max;
+	props->max_fmr = dev->rdi.lkey_table.max;
 	props->max_map_per_fmr = 32767;
 	props->max_pd = dev->rdi.dparms.props.max_pd;
 	props->max_qp_rd_atom = HFI1_MAX_RDMA_ATOMIC;
@@ -1668,7 +1668,7 @@ struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid)
 {
 	struct ib_ah_attr attr;
 	struct ib_ah *ah = ERR_PTR(-EINVAL);
-	struct hfi1_qp *qp0;
+	struct rvt_qp *qp0;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.dlid = dlid;
@@ -1783,7 +1783,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
 	struct ib_device *ibdev = &dev->rdi.ibdev;
 	struct hfi1_pportdata *ppd = dd->pport;
-	unsigned i, lk_tab_size;
+	unsigned i;
 	int ret;
 	size_t lcpysz = IB_DEVICE_NAME_MAX;
 	u16 descq_cnt;
@@ -1807,29 +1807,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dev->mem_timer.function = mem_timer;
 	dev->mem_timer.data = (unsigned long) dev;
 
-	/*
-	 * The top hfi1_lkey_table_size bits are used to index the
-	 * table.  The lower 8 bits can be owned by the user (copied from
-	 * the LKEY).  The remaining bits act as a generation number or tag.
-	 */
-	spin_lock_init(&dev->lk_table.lock);
-	dev->lk_table.max = 1 << hfi1_lkey_table_size;
-	/* ensure generation is at least 4 bits (keys.c) */
-	if (hfi1_lkey_table_size > RVT_MAX_LKEY_TABLE_BITS) {
-		dd_dev_warn(dd, "lkey bits %u too large, reduced to %u\n",
-			      hfi1_lkey_table_size, RVT_MAX_LKEY_TABLE_BITS);
-		hfi1_lkey_table_size = RVT_MAX_LKEY_TABLE_BITS;
-	}
-	lk_tab_size = dev->lk_table.max * sizeof(*dev->lk_table.table);
-	dev->lk_table.table = (struct rvt_mregion __rcu **)
-		vmalloc(lk_tab_size);
-	if (dev->lk_table.table == NULL) {
-		ret = -ENOMEM;
-		goto err_lk;
-	}
-	RCU_INIT_POINTER(dev->dma_mr, NULL);
-	for (i = 0; i < dev->lk_table.max; i++)
-		RCU_INIT_POINTER(dev->lk_table.table[i], NULL);
 	INIT_LIST_HEAD(&dev->pending_mmaps);
 	spin_lock_init(&dev->pending_lock);
 	seqlock_init(&dev->iowait_lock);
@@ -1928,14 +1905,15 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->resize_cq = hfi1_resize_cq;
 	ibdev->poll_cq = hfi1_poll_cq;
 	ibdev->req_notify_cq = hfi1_req_notify_cq;
-	ibdev->get_dma_mr = hfi1_get_dma_mr;
-	ibdev->reg_user_mr = hfi1_reg_user_mr;
-	ibdev->dereg_mr = hfi1_dereg_mr;
-	ibdev->alloc_mr = hfi1_alloc_mr;
-	ibdev->alloc_fmr = hfi1_alloc_fmr;
-	ibdev->map_phys_fmr = hfi1_map_phys_fmr;
-	ibdev->unmap_fmr = hfi1_unmap_fmr;
-	ibdev->dealloc_fmr = hfi1_dealloc_fmr;
+	ibdev->get_dma_mr = NULL;
+	ibdev->reg_user_mr = NULL;
+	ibdev->dereg_mr = NULL;
+	ibdev->alloc_mr = NULL;
+	ibdev->map_mr_sg = NULL;
+	ibdev->alloc_fmr = NULL;
+	ibdev->map_phys_fmr = NULL;
+	ibdev->unmap_fmr = NULL;
+	ibdev->dealloc_fmr = NULL;
 	ibdev->attach_mcast = hfi1_multicast_attach;
 	ibdev->detach_mcast = hfi1_multicast_detach;
 	ibdev->process_mad = hfi1_process_mad;
@@ -1956,9 +1934,9 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.notify_new_ah = hfi1_notify_new_ah;
 	dd->verbs_dev.rdi.dparms.props.max_ah = hfi1_max_ahs;
 	dd->verbs_dev.rdi.dparms.props.max_pd = hfi1_max_pds;
-	dd->verbs_dev.rdi.flags = (RVT_FLAG_MR_INIT_DRIVER |
-				   RVT_FLAG_QP_INIT_DRIVER |
+	dd->verbs_dev.rdi.flags = (RVT_FLAG_QP_INIT_DRIVER |
 				   RVT_FLAG_CQ_INIT_DRIVER);
+	dd->verbs_dev.rdi.dparms.lkey_table_size = hfi1_lkey_table_size;
 
 	ret = rvt_register_device(&dd->verbs_dev.rdi);
 	if (ret)
@@ -1981,8 +1959,6 @@ err_agents:
 err_reg:
 err_verbs_txreq:
 	kmem_cache_destroy(dev->verbs_txreq_cache);
-	vfree(dev->lk_table.table);
-err_lk:
 	hfi1_qp_exit(dev);
 err_qp_init:
 	dd_dev_err(dd, "cannot register verbs: %d!\n", -ret);
@@ -2004,19 +1980,16 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 		dd_dev_err(dd, "txwait list not empty!\n");
 	if (!list_empty(&dev->memwait))
 		dd_dev_err(dd, "memwait list not empty!\n");
-	if (dev->dma_mr)
-		dd_dev_err(dd, "DMA MR not NULL!\n");
 
 	hfi1_qp_exit(dev);
 	del_timer_sync(&dev->mem_timer);
 	kmem_cache_destroy(dev->verbs_txreq_cache);
-	vfree(dev->lk_table.table);
 }
 
 /*
  * This must be called with s_lock held.
  */
-void hfi1_schedule_send(struct hfi1_qp *qp)
+void hfi1_schedule_send(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	if (hfi1_send_ok(qp)) {
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 5116e51..afd6673 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -222,7 +222,7 @@ struct tx_pio_header {
  */
 struct hfi1_mcast_qp {
 	struct list_head list;
-	struct hfi1_qp *qp;
+	struct rvt_qp *qp;
 };
 
 struct hfi1_mcast {
@@ -235,20 +235,6 @@ struct hfi1_mcast {
 };
 
 /*
- * This structure is used by hfi1_mmap() to validate an offset
- * when an mmap() request is made.  The vm_area_struct then uses
- * this as its vm_private_data.
- */
-struct hfi1_mmap_info {
-	struct list_head pending_mmaps;
-	struct ib_ucontext *context;
-	void *obj;
-	__u64 offset;
-	struct kref ref;
-	unsigned size;
-};
-
-/*
  * This structure is used to contain the head pointer, tail pointer,
  * and completion queue entries as a single memory allocation so
  * it can be mmap'ed into user space.
@@ -274,237 +260,26 @@ struct hfi1_cq {
 	u8 notify;
 	u8 triggered;
 	struct hfi1_cq_wc *queue;
-	struct hfi1_mmap_info *ip;
-};
-
-/*
- * These keep track of the copy progress within a memory region.
- * Used by the verbs layer.
- */
-struct hfi1_sge {
-	struct rvt_mregion *mr;
-	void *vaddr;            /* kernel virtual address of segment */
-	u32 sge_length;         /* length of the SGE */
-	u32 length;             /* remaining length of the segment */
-	u16 m;                  /* current index: mr->map[m] */
-	u16 n;                  /* current index: mr->map[m]->segs[n] */
-};
-
-/* Memory region */
-struct hfi1_mr {
-	struct ib_mr ibmr;
-	struct ib_umem *umem;
-	struct rvt_mregion mr;  /* must be last */
-};
-
-/*
- * Send work request queue entry.
- * The size of the sg_list is determined when the QP is created and stored
- * in qp->s_max_sge.
- */
-struct hfi1_swqe {
-	union {
-		struct ib_send_wr wr;   /* don't use wr.sg_list */
-		struct ib_rdma_wr rdma_wr;
-		struct ib_atomic_wr atomic_wr;
-		struct ib_ud_wr ud_wr;
-	};
-	u32 psn;                /* first packet sequence number */
-	u32 lpsn;               /* last packet sequence number */
-	u32 ssn;                /* send sequence number */
-	u32 length;             /* total length of data in sg_list */
-	struct hfi1_sge sg_list[0];
-};
-
-/*
- * Receive work request queue entry.
- * The size of the sg_list is determined when the QP (or SRQ) is created
- * and stored in qp->r_rq.max_sge (or srq->rq.max_sge).
- */
-struct hfi1_rwqe {
-	u64 wr_id;
-	u8 num_sge;
-	struct ib_sge sg_list[0];
-};
-
-/*
- * This structure is used to contain the head pointer, tail pointer,
- * and receive work queue entries as a single memory allocation so
- * it can be mmap'ed into user space.
- * Note that the wq array elements are variable size so you can't
- * just index into the array to get the N'th element;
- * use get_rwqe_ptr() instead.
- */
-struct hfi1_rwq {
-	u32 head;               /* new work requests posted to the head */
-	u32 tail;               /* receives pull requests from here. */
-	struct hfi1_rwqe wq[0];
-};
-
-struct hfi1_rq {
-	struct hfi1_rwq *wq;
-	u32 size;               /* size of RWQE array */
-	u8 max_sge;
-	/* protect changes in this struct */
-	spinlock_t lock ____cacheline_aligned_in_smp;
+	struct rvt_mmap_info *ip;
 };
 
 struct hfi1_srq {
 	struct ib_srq ibsrq;
-	struct hfi1_rq rq;
-	struct hfi1_mmap_info *ip;
+	struct rvt_rq rq;
+	struct rvt_mmap_info *ip;
 	/* send signal when number of RWQEs < limit */
 	u32 limit;
 };
 
-struct hfi1_sge_state {
-	struct hfi1_sge *sg_list;      /* next SGE to be used if any */
-	struct hfi1_sge sge;   /* progress state for the current SGE */
-	u32 total_len;
-	u8 num_sge;
-};
-
-/*
- * This structure holds the information that the send tasklet needs
- * to send a RDMA read response or atomic operation.
- */
-struct hfi1_ack_entry {
-	u8 opcode;
-	u8 sent;
-	u32 psn;
-	u32 lpsn;
-	union {
-		struct hfi1_sge rdma_sge;
-		u64 atomic_data;
-	};
-};
-
 /*
  * hfi1 specific data structures that will be hidden from rvt after the queue
  * pair is made common
  */
-struct hfi1_qp;
 struct hfi1_qp_priv {
 	struct ahg_ib_header *s_hdr; /* next packet header to send */
 	u8 s_sc;		     /* SC[0..4] for next packet */
 	struct iowait s_iowait;
-	struct hfi1_qp *owner;
-};
-
-/*
- * Variables prefixed with s_ are for the requester (sender).
- * Variables prefixed with r_ are for the responder (receiver).
- * Variables prefixed with ack_ are for responder replies.
- *
- * Common variables are protected by both r_rq.lock and s_lock in that order
- * which only happens in modify_qp() or changing the QP 'state'.
- */
-struct hfi1_qp {
-	struct ib_qp ibqp;
-	void *priv;
-	/* read mostly fields above and below */
-	struct ib_ah_attr remote_ah_attr;
-	struct ib_ah_attr alt_ah_attr;
-	struct hfi1_qp __rcu *next;           /* link list for QPN hash table */
-	struct hfi1_swqe *s_wq;  /* send work queue */
-	struct hfi1_mmap_info *ip;
-	unsigned long timeout_jiffies;  /* computed from timeout */
-
-	enum ib_mtu path_mtu;
-	int srate_mbps;		/* s_srate (below) converted to Mbit/s */
-	u32 remote_qpn;
-	u32 pmtu;		/* decoded from path_mtu */
-	u32 qkey;               /* QKEY for this QP (for UD or RD) */
-	u32 s_size;             /* send work queue size */
-	u32 s_rnr_timeout;      /* number of milliseconds for RNR timeout */
-	u32 s_ahgpsn;           /* set to the psn in the copy of the header */
-
-	u8 state;               /* QP state */
-	u8 allowed_ops;		/* high order bits of allowed opcodes */
-	u8 qp_access_flags;
-	u8 alt_timeout;         /* Alternate path timeout for this QP */
-	u8 timeout;             /* Timeout for this QP */
-	u8 s_srate;
-	u8 s_mig_state;
-	u8 port_num;
-	u8 s_pkey_index;        /* PKEY index to use */
-	u8 s_alt_pkey_index;    /* Alternate path PKEY index to use */
-	u8 r_max_rd_atomic;     /* max number of RDMA read/atomic to receive */
-	u8 s_max_rd_atomic;     /* max number of RDMA read/atomic to send */
-	u8 s_retry_cnt;         /* number of times to retry */
-	u8 s_rnr_retry_cnt;
-	u8 r_min_rnr_timer;     /* retry timeout value for RNR NAKs */
-	u8 s_max_sge;           /* size of s_wq->sg_list */
-	u8 s_draining;
-
-	/* start of read/write fields */
-	atomic_t refcount ____cacheline_aligned_in_smp;
-	wait_queue_head_t wait;
-
-
-	struct hfi1_ack_entry s_ack_queue[HFI1_MAX_RDMA_ATOMIC + 1]
-		____cacheline_aligned_in_smp;
-	struct hfi1_sge_state s_rdma_read_sge;
-
-	spinlock_t r_lock ____cacheline_aligned_in_smp;      /* used for APM */
-	unsigned long r_aflags;
-	u64 r_wr_id;            /* ID for current receive WQE */
-	u32 r_ack_psn;          /* PSN for next ACK or atomic ACK */
-	u32 r_len;              /* total length of r_sge */
-	u32 r_rcv_len;          /* receive data len processed */
-	u32 r_psn;              /* expected rcv packet sequence number */
-	u32 r_msn;              /* message sequence number */
-
-	u8 r_state;             /* opcode of last packet received */
-	u8 r_flags;
-	u8 r_head_ack_queue;    /* index into s_ack_queue[] */
-
-	struct list_head rspwait;       /* link for waiting to respond */
-
-	struct hfi1_sge_state r_sge;     /* current receive data */
-	struct hfi1_rq r_rq;             /* receive work queue */
-
-	spinlock_t s_lock ____cacheline_aligned_in_smp;
-	struct hfi1_sge_state *s_cur_sge;
-	u32 s_flags;
-	struct hfi1_swqe *s_wqe;
-	struct hfi1_sge_state s_sge;     /* current send request data */
-	struct rvt_mregion *s_rdma_mr;
-	struct sdma_engine *s_sde; /* current sde */
-	u32 s_cur_size;         /* size of send packet in bytes */
-	u32 s_len;              /* total length of s_sge */
-	u32 s_rdma_read_len;    /* total length of s_rdma_read_sge */
-	u32 s_next_psn;         /* PSN for next request */
-	u32 s_last_psn;         /* last response PSN processed */
-	u32 s_sending_psn;      /* lowest PSN that is being sent */
-	u32 s_sending_hpsn;     /* highest PSN that is being sent */
-	u32 s_psn;              /* current packet sequence number */
-	u32 s_ack_rdma_psn;     /* PSN for sending RDMA read responses */
-	u32 s_ack_psn;          /* PSN for acking sends and RDMA writes */
-	u32 s_head;             /* new entries added here */
-	u32 s_tail;             /* next entry to process */
-	u32 s_cur;              /* current work queue entry */
-	u32 s_acked;            /* last un-ACK'ed entry */
-	u32 s_last;             /* last completed entry */
-	u32 s_ssn;              /* SSN of tail entry */
-	u32 s_lsn;              /* limit sequence number (credit) */
-	u16 s_hdrwords;         /* size of s_hdr in 32 bit words */
-	u16 s_rdma_ack_cnt;
-	s8 s_ahgidx;
-	u8 s_state;             /* opcode of last packet sent */
-	u8 s_ack_state;         /* opcode of packet to ACK */
-	u8 s_nak_state;         /* non-zero if NAK is pending */
-	u8 r_nak_state;         /* non-zero if NAK is pending */
-	u8 s_retry;             /* requester retry counter */
-	u8 s_rnr_retry;         /* requester RNR retry counter */
-	u8 s_num_rd_atomic;     /* number of RDMA read/atomic pending */
-	u8 s_tail_ack_queue;    /* index into s_ack_queue[] */
-
-	struct hfi1_sge_state s_ack_rdma_sge;
-	struct timer_list s_timer;
-
-	struct hfi1_sge r_sg_list[0] /* verified SGEs */
-		____cacheline_aligned_in_smp;
+	struct rvt_qp *owner;
 };
 
 /*
@@ -586,27 +361,27 @@ struct hfi1_qp {
 #define HFI1_PSN_CREDIT  16
 
 /*
- * Since struct hfi1_swqe is not a fixed size, we can't simply index into
+ * Since struct rvt_swqe is not a fixed size, we can't simply index into
  * struct hfi1_qp.s_wq.  This function does the array index computation.
  */
-static inline struct hfi1_swqe *get_swqe_ptr(struct hfi1_qp *qp,
-					     unsigned n)
+static inline struct rvt_swqe *get_swqe_ptr(struct rvt_qp *qp,
+					    unsigned n)
 {
-	return (struct hfi1_swqe *)((char *)qp->s_wq +
-				     (sizeof(struct hfi1_swqe) +
+	return (struct rvt_swqe *)((char *)qp->s_wq +
+				     (sizeof(struct rvt_swqe) +
 				      qp->s_max_sge *
-				      sizeof(struct hfi1_sge)) * n);
+				      sizeof(struct rvt_sge)) * n);
 }
 
 /*
- * Since struct hfi1_rwqe is not a fixed size, we can't simply index into
- * struct hfi1_rwq.wq.  This function does the array index computation.
+ * Since struct rvt_rwqe is not a fixed size, we can't simply index into
+ * struct rvt_rwq.wq.  This function does the array index computation.
  */
-static inline struct hfi1_rwqe *get_rwqe_ptr(struct hfi1_rq *rq, unsigned n)
+static inline struct rvt_rwqe *get_rwqe_ptr(struct rvt_rq *rq, unsigned n)
 {
-	return (struct hfi1_rwqe *)
+	return (struct rvt_rwqe *)
 		((char *) rq->wq->wq +
-		 (sizeof(struct hfi1_rwqe) +
+		 (sizeof(struct rvt_rwqe) +
 		  rq->max_sge * sizeof(struct ib_sge)) * n);
 }
 
@@ -630,7 +405,7 @@ static inline void inc_opstats(
 }
 
 struct hfi1_ibport {
-	struct hfi1_qp __rcu *qp[2];
+	struct rvt_qp __rcu *qp[2];
 	struct ib_mad_agent *send_agent;	/* agent for SMI (traps) */
 	struct rvt_ah *sm_ah;
 	struct rvt_ah *smi_ah;
@@ -693,12 +468,10 @@ struct hfi1_ibdev {
 	struct list_head pending_mmaps;
 	spinlock_t mmap_offset_lock; /* protect mmap_offset */
 	u32 mmap_offset;
-	struct rvt_mregion __rcu *dma_mr;
 
 	struct hfi1_qp_ibdev *qp_dev;
 
 	/* QP numbers are shared by all IB ports */
-	struct rvt_lkey_table lk_table;
 	/* protect wait lists */
 	seqlock_t iowait_lock;
 	struct list_head txwait;        /* list for wait verbs_txreq */
@@ -747,11 +520,6 @@ struct hfi1_verbs_counters {
 	u32 vl15_dropped;
 };
 
-static inline struct hfi1_mr *to_imr(struct ib_mr *ibmr)
-{
-	return container_of(ibmr, struct hfi1_mr, ibmr);
-}
-
 static inline struct hfi1_cq *to_icq(struct ib_cq *ibcq)
 {
 	return container_of(ibcq, struct hfi1_cq, ibcq);
@@ -762,9 +530,9 @@ static inline struct hfi1_srq *to_isrq(struct ib_srq *ibsrq)
 	return container_of(ibsrq, struct hfi1_srq, ibsrq);
 }
 
-static inline struct hfi1_qp *to_iqp(struct ib_qp *ibqp)
+static inline struct rvt_qp *to_iqp(struct ib_qp *ibqp)
 {
-	return container_of(ibqp, struct hfi1_qp, ibqp);
+	return container_of(ibqp, struct rvt_qp, ibqp);
 }
 
 static inline struct hfi1_ibdev *to_idev(struct ib_device *ibdev)
@@ -775,7 +543,7 @@ static inline struct hfi1_ibdev *to_idev(struct ib_device *ibdev)
 	return container_of(rdi, struct hfi1_ibdev, rdi);
 }
 
-static inline struct hfi1_qp *iowait_to_qp(struct  iowait *s_iowait)
+static inline struct rvt_qp *iowait_to_qp(struct  iowait *s_iowait)
 {
 	struct hfi1_qp_priv *priv;
 
@@ -787,7 +555,7 @@ static inline struct hfi1_qp *iowait_to_qp(struct  iowait *s_iowait)
  * Send if not busy or waiting for I/O and either
  * a RC response is pending or we can process send work requests.
  */
-static inline int hfi1_send_ok(struct hfi1_qp *qp)
+static inline int hfi1_send_ok(struct rvt_qp *qp)
 {
 	return !(qp->s_flags & (HFI1_S_BUSY | HFI1_S_ANY_WAIT_IO)) &&
 		(qp->s_hdrwords || (qp->s_flags & HFI1_S_RESP_PENDING) ||
@@ -797,7 +565,7 @@ static inline int hfi1_send_ok(struct hfi1_qp *qp)
 /*
  * This must be called with s_lock held.
  */
-void hfi1_schedule_send(struct hfi1_qp *qp);
+void hfi1_schedule_send(struct rvt_qp *qp);
 void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
 		    u32 qp1, u32 qp2, __be16 lid1, __be16 lid2);
 void hfi1_cap_mask_chg(struct hfi1_ibport *ibp);
@@ -878,13 +646,13 @@ int hfi1_mcast_tree_empty(struct hfi1_ibport *ibp);
 struct verbs_txreq;
 void hfi1_put_txreq(struct verbs_txreq *tx);
 
-int hfi1_verbs_send(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
-		    u32 hdrwords, struct hfi1_sge_state *ss, u32 len);
+int hfi1_verbs_send(struct rvt_qp *qp, struct ahg_ib_header *ahdr,
+		    u32 hdrwords, struct rvt_sge_state *ss, u32 len);
 
-void hfi1_copy_sge(struct hfi1_sge_state *ss, void *data, u32 length,
+void hfi1_copy_sge(struct rvt_sge_state *ss, void *data, u32 length,
 		   int release);
 
-void hfi1_skip_sge(struct hfi1_sge_state *ss, u32 length, int release);
+void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, int release);
 
 void hfi1_cnp_rcv(struct hfi1_packet *packet);
 
@@ -896,7 +664,7 @@ void hfi1_rc_hdrerr(
 	struct hfi1_ctxtdata *rcd,
 	struct hfi1_ib_header *hdr,
 	u32 rcv_flags,
-	struct hfi1_qp *qp);
+	struct rvt_qp *qp);
 
 u8 ah_to_sc(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
 
@@ -904,24 +672,14 @@ struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid);
 
 void hfi1_rc_rnr_retry(unsigned long arg);
 
-void hfi1_rc_send_complete(struct hfi1_qp *qp, struct hfi1_ib_header *hdr);
+void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr);
 
-void hfi1_rc_error(struct hfi1_qp *qp, enum ib_wc_status err);
+void hfi1_rc_error(struct rvt_qp *qp, enum ib_wc_status err);
 
 void hfi1_ud_rcv(struct hfi1_packet *packet);
 
 int hfi1_lookup_pkey_idx(struct hfi1_ibport *ibp, u16 pkey);
 
-int hfi1_alloc_lkey(struct rvt_mregion *mr, int dma_region);
-
-void hfi1_free_lkey(struct rvt_mregion *mr);
-
-int hfi1_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
-		 struct hfi1_sge *isge, struct ib_sge *sge, int acc);
-
-int hfi1_rkey_ok(struct hfi1_qp *qp, struct hfi1_sge *sge,
-		 u32 len, u64 vaddr, u32 rkey, int acc);
-
 int hfi1_post_srq_receive(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 			  struct ib_recv_wr **bad_wr);
 
@@ -959,43 +717,10 @@ int hfi1_req_notify_cq(
 
 int hfi1_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
 
-struct ib_mr *hfi1_get_dma_mr(struct ib_pd *pd, int acc);
-
-struct ib_mr *hfi1_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
-			       u64 virt_addr, int mr_access_flags,
-			       struct ib_udata *udata);
-
-int hfi1_dereg_mr(struct ib_mr *ibmr);
-
-struct ib_mr *hfi1_alloc_mr(struct ib_pd *pd,
-			    enum ib_mr_type mr_type,
-			    u32 max_entries);
-
-struct ib_fmr *hfi1_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
-			      struct ib_fmr_attr *fmr_attr);
-
-int hfi1_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-		      int list_len, u64 iova);
-
-int hfi1_unmap_fmr(struct list_head *fmr_list);
-
-int hfi1_dealloc_fmr(struct ib_fmr *ibfmr);
-
-static inline void hfi1_get_mr(struct rvt_mregion *mr)
-{
-	atomic_inc(&mr->refcount);
-}
-
-static inline void hfi1_put_mr(struct rvt_mregion *mr)
-{
-	if (unlikely(atomic_dec_and_test(&mr->refcount)))
-		complete(&mr->comp);
-}
-
-static inline void hfi1_put_ss(struct hfi1_sge_state *ss)
+static inline void hfi1_put_ss(struct rvt_sge_state *ss)
 {
 	while (ss->num_sge) {
-		hfi1_put_mr(ss->sge.mr);
+		rvt_put_mr(ss->sge.mr);
 		if (--ss->num_sge)
 			ss->sge = *ss->sg_list++;
 	}
@@ -1003,40 +728,42 @@ static inline void hfi1_put_ss(struct hfi1_sge_state *ss)
 
 void hfi1_release_mmap_info(struct kref *ref);
 
-struct hfi1_mmap_info *hfi1_create_mmap_info(struct hfi1_ibdev *dev, u32 size,
-					     struct ib_ucontext *context,
-					     void *obj);
+struct rvt_mmap_info *hfi1_create_mmap_info(struct hfi1_ibdev *dev, u32 size,
+					    struct ib_ucontext *context,
+					    void *obj);
 
-void hfi1_update_mmap_info(struct hfi1_ibdev *dev, struct hfi1_mmap_info *ip,
+void hfi1_update_mmap_info(struct hfi1_ibdev *dev, struct rvt_mmap_info *ip,
 			   u32 size, void *obj);
 
 int hfi1_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
-int hfi1_get_rwqe(struct hfi1_qp *qp, int wr_id_only);
+int hfi1_get_rwqe(struct rvt_qp *qp, int wr_id_only);
 
-void hfi1_migrate_qp(struct hfi1_qp *qp);
+void hfi1_migrate_qp(struct rvt_qp *qp);
 
 int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
-		       int has_grh, struct hfi1_qp *qp, u32 bth0);
+		       int has_grh, struct rvt_qp *qp, u32 bth0);
 
 u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 		  struct ib_global_route *grh, u32 hwords, u32 nwords);
 
-void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
+void clear_ahg(struct rvt_qp *qp);
+
+void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 			  u32 bth0, u32 bth2, int middle);
 
 void hfi1_do_send(struct work_struct *work);
 
-void hfi1_send_complete(struct hfi1_qp *qp, struct hfi1_swqe *wqe,
+void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 			enum ib_wc_status status);
 
-void hfi1_send_rc_ack(struct hfi1_ctxtdata *, struct hfi1_qp *qp, int is_fecn);
+void hfi1_send_rc_ack(struct hfi1_ctxtdata *, struct rvt_qp *qp, int is_fecn);
 
-int hfi1_make_rc_req(struct hfi1_qp *qp);
+int hfi1_make_rc_req(struct rvt_qp *qp);
 
-int hfi1_make_uc_req(struct hfi1_qp *qp);
+int hfi1_make_uc_req(struct rvt_qp *qp);
 
-int hfi1_make_ud_req(struct hfi1_qp *qp);
+int hfi1_make_ud_req(struct rvt_qp *qp);
 
 int hfi1_register_ib_device(struct hfi1_devdata *);
 
@@ -1046,15 +773,15 @@ void hfi1_ib_rcv(struct hfi1_packet *packet);
 
 unsigned hfi1_get_npkeys(struct hfi1_devdata *);
 
-int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct ahg_ib_header *hdr,
-			u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
+int hfi1_verbs_send_dma(struct rvt_qp *qp, struct ahg_ib_header *hdr,
+			u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			u32 plen, u32 dwords, u64 pbc);
 
-int hfi1_verbs_send_pio(struct hfi1_qp *qp, struct ahg_ib_header *hdr,
-			u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
+int hfi1_verbs_send_pio(struct rvt_qp *qp, struct ahg_ib_header *hdr,
+			u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			u32 plen, u32 dwords, u64 pbc);
 
-struct send_context *qp_to_send_context(struct hfi1_qp *qp, u8 sc5);
+struct send_context *qp_to_send_context(struct rvt_qp *qp, u8 sc5);
 
 extern const enum ib_wc_opcode ib_hfi1_wc_opcode[];
 
@@ -1064,8 +791,6 @@ extern const int ib_hfi1_state_ops[];
 
 extern __be64 ib_hfi1_sys_image_guid;    /* in network order */
 
-extern unsigned int hfi1_lkey_table_size;
-
 extern unsigned int hfi1_max_cqes;
 
 extern unsigned int hfi1_max_cqs;
diff --git a/drivers/staging/rdma/hfi1/verbs_mcast.c b/drivers/staging/rdma/hfi1/verbs_mcast.c
index afc6b4c..49954b9 100644
--- a/drivers/staging/rdma/hfi1/verbs_mcast.c
+++ b/drivers/staging/rdma/hfi1/verbs_mcast.c
@@ -56,7 +56,7 @@
  * mcast_qp_alloc - alloc a struct to link a QP to mcast GID struct
  * @qp: the QP to link
  */
-static struct hfi1_mcast_qp *mcast_qp_alloc(struct hfi1_qp *qp)
+static struct hfi1_mcast_qp *mcast_qp_alloc(struct rvt_qp *qp)
 {
 	struct hfi1_mcast_qp *mqp;
 
@@ -73,7 +73,7 @@ bail:
 
 static void mcast_qp_free(struct hfi1_mcast_qp *mqp)
 {
-	struct hfi1_qp *qp = mqp->qp;
+	struct rvt_qp *qp = mqp->qp;
 
 	/* Notify hfi1_destroy_qp() if it is waiting. */
 	if (atomic_dec_and_test(&qp->refcount))
@@ -241,7 +241,7 @@ bail:
 
 int hfi1_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	struct hfi1_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
 	struct hfi1_ibport *ibp;
 	struct hfi1_mcast *mcast;
@@ -299,7 +299,7 @@ bail:
 
 int hfi1_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	struct hfi1_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = to_iqp(ibqp);
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
 	struct hfi1_ibport *ibp = to_iport(ibqp->device, qp->port_num);
 	struct hfi1_mcast *mcast = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
