From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/9] RDMA/nes: Implement IB_SIGNAL_ALL_WR as an iWARP extension
Date: Tue, 1 Dec 2009 16:19:58 -0600
Message-ID: <20091201221958.GA6468@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Add IB_SINGAL_ALL_WR support as an iWARP extension.  If set, make
sure all WR for the QP is signalled.
Consolidate flags used in nesqp structure.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    6 ++++--
 drivers/infiniband/hw/nes/nes_verbs.h |   15 +++++++++------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 42ec5d0..2bdea64 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1407,6 +1407,8 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 			return ERR_PTR(-EINVAL);
 	}
 
+	nesqp->sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR);
+
 	/* update the QP table */
 	nesdev->nesadapter->qp_table[nesqp->hwqp.qp_id-NES_FIRST_QPN] = nesqp;
 	nes_debug(NES_DBG_QP, "netdev refcnt=%u\n",
@@ -3502,9 +3504,9 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 		if (err)
 			break;
 
-		if (ib_wr->send_flags & IB_SEND_SIGNALED) {
+		if ((ib_wr->send_flags & IB_SEND_SIGNALED) || nesqp->sig_all)
 			wqe_misc |= NES_IWARP_SQ_WQE_SIGNALED_COMPL;
-		}
+
 		wqe->wqe_words[NES_IWARP_SQ_WQE_MISC_IDX] = cpu_to_le32(wqe_misc);
 
 		ib_wr = ib_wr->next;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index 89822d7..ac8b86b 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -167,17 +167,20 @@ struct nes_qp {
 	enum ib_event_type    terminate_eventtype;
 	wait_queue_head_t     kick_waitq;
 	u16                   in_disconnect;
+	u16                   active_conn:1;
+	u16                   skip_lsmm:1;
+	u16                   user_mode:1;
+	u16                   hte_added:1;
+	u16                   flush_issued:1;
+	u16                   destroyed:1;
+	u16                   sq_kmapped:1;
+	u16                   sig_all:1;
+	u16                   rsvd:8;
 	u16                   private_data_len;
 	u16                   term_sq_flush_code;
 	u16                   term_rq_flush_code;
-	u8                    active_conn;
-	u8                    skip_lsmm;
-	u8                    user_mode;
-	u8                    hte_added;
 	u8                    hw_iwarp_state;
-	u8                    flush_issued;
 	u8                    hw_tcp_state;
 	u8                    term_flags;
-	u8                    destroyed;
 };
 #endif			/* NES_VERBS_H */
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
