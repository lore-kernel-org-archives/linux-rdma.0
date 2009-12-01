From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/9] RDMA/nes: Clean up struct nes_qp
Date: Tue, 1 Dec 2009 16:20:00 -0600
Message-ID: <20091201222000.GA6688@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Remove unused and not really used variables.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    6 ------
 drivers/infiniband/hw/nes/nes_verbs.h |    9 +--------
 2 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 2bdea64..e929684 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1398,8 +1398,6 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 			nes_debug(NES_DBG_QP, "QP%u structure located @%p.Size = %u.\n",
 					nesqp->hwqp.qp_id, nesqp, (u32)sizeof(*nesqp));
 			spin_lock_init(&nesqp->lock);
-			init_waitqueue_head(&nesqp->state_waitq);
-			init_waitqueue_head(&nesqp->kick_waitq);
 			nes_add_ref(&nesqp->ibqp);
 			break;
 		default:
@@ -3005,7 +3003,6 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 								" already done based on hw state.\n",
 								nesqp->hwqp.qp_id);
 						issue_modify_qp = 0;
-						nesqp->in_disconnect = 0;
 					}
 					switch (nesqp->hw_iwarp_state) {
 						case NES_AEQE_IWARP_STATE_CLOSING:
@@ -3018,7 +3015,6 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 							break;
 						default:
 							next_iwarp_state = NES_CQP_QP_IWARP_STATE_CLOSING;
-							nesqp->in_disconnect = 1;
 							nesqp->hw_iwarp_state = NES_AEQE_IWARP_STATE_CLOSING;
 							break;
 					}
@@ -3035,7 +3031,6 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				next_iwarp_state = NES_CQP_QP_IWARP_STATE_TERMINATE;
 				nesqp->hw_iwarp_state = NES_AEQE_IWARP_STATE_TERMINATE;
 				issue_modify_qp = 1;
-				nesqp->in_disconnect = 1;
 				break;
 			case IB_QPS_ERR:
 			case IB_QPS_RESET:
@@ -3058,7 +3053,6 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				if ((nesqp->hw_tcp_state > NES_AEQE_TCP_STATE_CLOSED) &&
 						(nesqp->hw_tcp_state != NES_AEQE_TCP_STATE_TIME_WAIT)) {
 					next_iwarp_state |= NES_CQP_QP_RESET;
-					nesqp->in_disconnect = 1;
 				} else {
 					nes_debug(NES_DBG_MOD_QP, "QP%u NOT setting NES_CQP_QP_RESET since TCP state = %u\n",
 							nesqp->hwqp.qp_id, nesqp->hw_tcp_state);
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index ac8b86b..795aa4f 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -135,19 +135,15 @@ struct nes_qp {
 	struct ib_qp          ibqp;
 	void                  *allocated_buffer;
 	struct iw_cm_id       *cm_id;
-	struct workqueue_struct *wq;
 	struct nes_cq         *nesscq;
 	struct nes_cq         *nesrcq;
 	struct nes_pd         *nespd;
 	void *cm_node; /* handle of the node this QP is associated with */
 	struct ietf_mpa_frame *ietf_frame;
 	dma_addr_t            ietf_frame_pbase;
-	wait_queue_head_t     state_waitq;
 	struct ib_mr          *lsmm_mr;
-	unsigned long         socket;
 	struct nes_hw_qp      hwqp;
 	struct work_struct    work;
-	struct work_struct    ae_work;
 	enum ib_qp_state      ibqp_state;
 	u32                   iwarp_state;
 	u32                   hte_index;
@@ -165,17 +161,14 @@ struct nes_qp {
 	struct page           *page;
 	struct timer_list     terminate_timer;
 	enum ib_event_type    terminate_eventtype;
-	wait_queue_head_t     kick_waitq;
-	u16                   in_disconnect;
 	u16                   active_conn:1;
 	u16                   skip_lsmm:1;
 	u16                   user_mode:1;
 	u16                   hte_added:1;
 	u16                   flush_issued:1;
 	u16                   destroyed:1;
-	u16                   sq_kmapped:1;
 	u16                   sig_all:1;
-	u16                   rsvd:8;
+	u16                   rsvd:9;
 	u16                   private_data_len;
 	u16                   term_sq_flush_code;
 	u16                   term_rq_flush_code;
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
