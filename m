From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/7] dapl mcm: add HST side provider support for device without inline data capability
Date: Fri, 22 May 2015 12:22:43 -0700
Message-ID: <1432322567-9349-3-git-send-email-arlin.r.davis@intel.com>
References: <1432322567-9349-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432322567-9349-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add registered WR buffers for HST->MXS (proxy in) mode
when inline data is not supported by device. Use registered
memory for source WR buffer instead of stack when sending
RDMA write request to peer proxy-in service.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |    4 +-
 dapl/openib_mcm/proxy.c             |  112 +++++++++++++++++++++++++++--------
 2 files changed, 90 insertions(+), 26 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 7b3e5d0..1ac0c12 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2009-2014 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2009-2015 Intel Corporation.  All rights reserved.
  *
  * This Software is licensed under one of the following licenses:
  *
@@ -67,6 +67,8 @@ struct dcm_ib_qp {
 	DAPL_OS_LOCK		 lock;	   /* Proxy WR and WC queues */
 	uint8_t			 ep_map;   /* Peer EP mapping, MXS, MSS, HST */
 	uint32_t		 seg_sz;   /* Peer MXS Proxy-in segment size */
+	char			 *wr_buf_rx; /* mcm_wr_rx_t entries, devices without inline data  */
+	struct ibv_mr		 *wr_buf_rx_mr;
 #endif
 };
 
diff --git a/dapl/openib_mcm/proxy.c b/dapl/openib_mcm/proxy.c
index 5163bca..cb06161 100644
--- a/dapl/openib_mcm/proxy.c
+++ b/dapl/openib_mcm/proxy.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2009-2014 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2009-2015 Intel Corporation.  All rights reserved.
  *
  * This Software is licensed under one of the following licenses:
  *
@@ -52,6 +52,7 @@ int mcm_send_pi(struct dcm_ib_qp *m_qp,
 	struct wrc_idata wrc;
 	uint32_t wr_flags, l_off, r_off = 0;
 	uint64_t l_addr;
+	struct mcm_wr_rx *wr_rx_ptr;
 
 	dapl_log(DAPL_DBG_TYPE_EP,
 		 " mcm_send_pi: ep %p qpn %x ln %d sge %d sg %d"
@@ -100,33 +101,44 @@ int mcm_send_pi(struct dcm_ib_qp *m_qp,
 			if (!(wr_idx % MCM_MP_SIG_RATE) || (wr_flags & M_SEND_CN_SIG))
 				wr_flags |= M_SEND_MP_SIG;
 
+			if (!m_qp->wr_buf_rx) {
+				wr_rx_ptr = &m_wr_rx;
+				sge.lkey = 0; /* inline doesn't need registered */
+			} else {
+				wr_rx_ptr = (struct mcm_wr_rx *)
+					    (m_qp->wr_buf_rx + (sizeof(struct mcm_wr_rx) * wr_idx));
+				sge.lkey = m_qp->wr_buf_rx_mr->lkey;
+			}
+			sge.addr = (uint64_t)(uintptr_t) wr_rx_ptr;
+			sge.length = (uint32_t) sizeof(struct mcm_wr_rx); /* 160 byte WR */
+
 			dapl_log(DAPL_DBG_TYPE_EP,
 				 " mcm_send_pi[%d]: seg_ln %d wr_idx %d, tl %d hd %d\n",
 				 i, seg_len, wr_idx, m_qp->wr_tl, m_qp->wr_hd);
 
 			/* build local m_wr_rx for remote PI */
-			memset((void*)&m_wr_rx, 0, sizeof(struct mcm_wr_rx));
-			m_wr_rx.org_id = (uint64_t) htonll((uint64_t)wr->wr_id);
-			m_wr_rx.flags = htonl(wr_flags);
-			m_wr_rx.w_idx = htonl(m_qp->wc_tl); /* snd back wc tail */
-			m_wr_rx.wr.num_sge = htonl(wr->num_sge);
-			m_wr_rx.wr.opcode = htonl(wr->opcode);
+			memset((void*)wr_rx_ptr, 0, sizeof(struct mcm_wr_rx));
+			wr_rx_ptr->org_id = (uint64_t) htonll((uint64_t)wr->wr_id);
+			wr_rx_ptr->flags = htonl(wr_flags);
+			wr_rx_ptr->w_idx = htonl(m_qp->wc_tl); /* snd back wc tail */
+			wr_rx_ptr->wr.num_sge = htonl(wr->num_sge);
+			wr_rx_ptr->wr.opcode = htonl(wr->opcode);
 
 			/* RW_IMM: reset opcode on all segments except last */
 			if (!(wr_flags & M_SEND_LS) &&
 			     (wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM))
-				m_wr_rx.wr.opcode = htonl(IBV_WR_RDMA_WRITE);
+				wr_rx_ptr->wr.opcode = htonl(IBV_WR_RDMA_WRITE);
 
-			m_wr_rx.wr.send_flags = htonl(wr->send_flags);
-			m_wr_rx.wr.imm_data = htonl(wr->imm_data);
-			m_wr_rx.sg[0].addr = htonll(l_addr + l_off);
-			m_wr_rx.sg[0].lkey = htonl(wr->sg_list[i].lkey);
-			m_wr_rx.sg[0].length = htonl(seg_len);
+			wr_rx_ptr->wr.send_flags = htonl(wr->send_flags);
+			wr_rx_ptr->wr.imm_data = htonl(wr->imm_data);
+			wr_rx_ptr->sg[0].addr = htonll(l_addr + l_off);
+			wr_rx_ptr->sg[0].lkey = htonl(wr->sg_list[i].lkey);
+			wr_rx_ptr->sg[0].length = htonl(seg_len);
 
 			if ((wr->opcode == IBV_WR_RDMA_WRITE) ||
 			    (wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM)) {
-				m_wr_rx.wr.wr.rdma.remote_addr = htonll(wr->wr.rdma.remote_addr + r_off);
-				m_wr_rx.wr.wr.rdma.rkey = htonl(wr->wr.rdma.rkey);
+				wr_rx_ptr->wr.wr.rdma.remote_addr = htonll(wr->wr.rdma.remote_addr + r_off);
+				wr_rx_ptr->wr.wr.rdma.rkey = htonl(wr->wr.rdma.rkey);
 			}
 
 			/* setup imm_data for PI rcv engine */
@@ -135,14 +147,15 @@ int mcm_send_pi(struct dcm_ib_qp *m_qp,
 			wrc.flags = 0;
 
 			/* setup local WR for wr_rx transfer - RW_imm inline */
+			memset(&wr_imm, 0, sizeof(struct ibv_send_wr));
 			wr_imm.wr_id = wr->wr_id; /* MUST be original cookie, CQ processing */
-			wr_imm.next = 0;
 			wr_imm.sg_list = &sge;
 			wr_imm.num_sge = 1;
 			wr_imm.opcode = IBV_WR_RDMA_WRITE_WITH_IMM;
-			wr_imm.send_flags = IBV_SEND_INLINE; /* m_wr_rx, 148 bytes */
 			if (wr_flags & M_SEND_MP_SIG)
 				wr_imm.send_flags |= IBV_SEND_SIGNALED;
+			if (!m_qp->wr_buf_rx)
+				wr_imm.send_flags |= IBV_SEND_INLINE;
 			wr_imm.imm_data = htonl(*(uint32_t *)&wrc);
 			wr_imm.wr.rdma.rkey = m_qp->wrc_rem.wr_rkey;
 			wr_imm.wr.rdma.remote_addr =
@@ -175,15 +188,15 @@ int mcm_send_pi(struct dcm_ib_qp *m_qp,
 					" tl %d hd %d\n",
 					m_wr_rx, wr_idx, wr->sg_list[0].addr,
 					wr->sg_list[0].length, wr->sg_list[0].lkey,
-					m_wr_rx.flags, m_qp->wr_tl, m_qp->wr_hd);
+					wr_rx_ptr->flags, m_qp->wr_tl, m_qp->wr_hd);
 				dapl_log(DAPL_DBG_TYPE_ERR,
 					" mcm_send_pi ERR: wr_id %Lx %p sglist %p sge %d op %d flgs %x"
 					" idata 0x%x raddr %p rkey %x \n",
-					m_wr_rx.wr.wr_id, wr->sg_list,
-					m_wr_rx.wr.num_sge, m_wr_rx.wr.opcode,
-					m_wr_rx.wr.send_flags, m_wr_rx.wr.imm_data,
-					m_wr_rx.wr.wr.rdma.remote_addr,
-					m_wr_rx.wr.wr.rdma.rkey);
+					wr_rx_ptr->wr.wr_id, wr->sg_list,
+					wr_rx_ptr->wr.num_sge, wr_rx_ptr->wr.opcode,
+					wr_rx_ptr->wr.send_flags, wr_rx_ptr->wr.imm_data,
+					wr_rx_ptr->wr.wr.rdma.remote_addr,
+					wr_rx_ptr->wr.wr.rdma.rkey);
 				goto bail;
 			}
 			l_len -= seg_len;
@@ -249,8 +262,8 @@ static inline void mcm_dto_rcv(struct dcm_ib_cq *m_cq, struct ibv_wc *wc)
 	mcm_ntoh_wc_rx(m_wc);   /* convert WC contents, pushed via wire */
 
 	dapl_log(DAPL_DBG_TYPE_EP,
-		 " mcm_dto_rcv: MCM evd %p ep %p id %d wc %p wr_id %Lx flgs 0x%x %s\n",
-		 m_qp->req_cq->evd, m_qp->ep, wrc.id, m_wc, m_wc->wc.wr_id,
+		 " mcm_dto_rcv WC: ep %p wc_id %d wc %p wr_id %Lx wr_tl %d flgs 0x%x %s\n",
+		 m_qp->ep, wrc.id, m_wc, m_wc->wc.wr_id, m_wc->wr_tl,
 		 m_wc->flags, m_wc->flags & M_SEND_CN_SIG ? "SIG":"NO_SIG");
 
 	dapl_os_lock(&m_qp->lock);
@@ -381,6 +394,14 @@ void mcm_destroy_wc_q(struct dcm_ib_qp *m_qp)
 		free((void*)m_qp->wrc.wc_addr);
 		m_qp->wrc.wc_addr = 0;
 	}
+	if (m_qp->wr_buf_rx_mr) {
+		ibv_dereg_mr(m_qp->wr_buf_rx_mr);
+		m_qp->wr_buf_rx_mr = NULL;
+	}
+	if(m_qp->wr_buf_rx) {
+		free(m_qp->wr_buf_rx);
+		m_qp->wr_buf_rx = NULL;
+	}
 }
 
 int mcm_create_wc_q(struct dcm_ib_qp *m_qp, int entries)
@@ -420,6 +441,36 @@ int mcm_create_wc_q(struct dcm_ib_qp *m_qp, int entries)
 		m_qp->wrc.wc_addr, m_qp->wc_mr->addr, ALIGN_PAGE(m_qp->wrc.wc_len),
 		entries, m_qp->wc_mr->rkey, m_qp->wc_mr->lkey);
 
+	if (!m_qp->ep->header.owner_ia->hca_ptr->ib_trans.ib_cm.max_inline) {
+
+		if (posix_memalign((void **)&m_qp->wr_buf_rx,
+				   4096, entries * sizeof(mcm_wr_rx_t))) {
+			dapl_log(DAPL_DBG_TYPE_ERR,
+				 "failed to allocate proxy wr_buf_rx, "
+				 "m_qp=%p, wr_rx_len=%d, entries=%d\n",
+				 m_qp, entries * sizeof(mcm_wr_rx_t), entries);
+			goto err;
+		}
+		memset(m_qp->wr_buf_rx, 0, entries * sizeof(mcm_wr_rx_t));
+
+		m_qp->wr_buf_rx_mr = ibv_reg_mr(m_qp->qp->pd, (void*)m_qp->wr_buf_rx,
+						entries * sizeof(mcm_wr_rx_t),
+						IBV_ACCESS_LOCAL_WRITE |
+						IBV_ACCESS_REMOTE_WRITE);
+
+		if (!m_qp->wr_buf_rx_mr) {
+			dapl_log(DAPL_DBG_TYPE_ERR, " IB_register addr=%p,%d failed %s\n",
+					m_qp->wr_buf_rx_mr->addr,
+					entries * sizeof(mcm_wr_rx_t),
+					strerror(errno));
+			goto err;
+		}
+		dapl_log(DAPL_DBG_TYPE_EP,
+			 " no inline support: WR_buf_rx pool %p, LEN %d, mr %x\n",
+			 m_qp->wr_buf_rx, entries * sizeof(mcm_wr_rx_t),
+			 m_qp->wr_buf_rx_mr);
+	}
+
 	/* Put QP's req and rcv CQ on device PI cqlist, mark CQ for indirect signaling */
 	dapl_os_lock(&m_qp->tp->cqlock);
 	m_qp->req_cq->flags |= DCM_CQ_TX_INDIRECT;
@@ -431,6 +482,17 @@ int mcm_create_wc_q(struct dcm_ib_qp *m_qp, int entries)
 	dapls_thread_signal(&m_qp->tp->signal); /* CM thread will process PI */
 
 	return 0;
+
+err:
+        if (m_qp->wr_buf_rx)
+                free(m_qp->wr_buf_rx);
+
+        if (m_qp->wc_mr)
+                ibv_dereg_mr(m_qp->wc_mr);
+
+        free((void*)m_qp->wrc.wc_addr);
+
+        return -1;
 }
 
 void mcm_destroy_pi_cq(struct dcm_ib_qp *m_qp)
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
