From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 14/18] IB/hfi1: Correct receive packet handler
 assignment
Date: Fri, 01 Jul 2016 16:02:02 -0700
Message-ID: <20160701230201.20160.37247.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Prevent processing receive packet in case when opcode is
accepted by QP but handler for this type of packet is not
defined.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 849c4b9..6ad3f9d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -540,19 +540,15 @@ void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, int release)
 /*
  * Make sure the QP is ready and able to accept the given opcode.
  */
-static inline int qp_ok(int opcode, struct hfi1_packet *packet)
+static inline opcode_handler qp_ok(int opcode, struct hfi1_packet *packet)
 {
-	struct hfi1_ibport *ibp;
-
 	if (!(ib_rvt_state_ops[packet->qp->state] & RVT_PROCESS_RECV_OK))
-		goto dropit;
+		return NULL;
 	if (((opcode & RVT_OPCODE_QP_MASK) == packet->qp->allowed_ops) ||
 	    (opcode == IB_OPCODE_CNP))
-		return 1;
-dropit:
-	ibp = &packet->rcd->ppd->ibport_data;
-	ibp->rvp.n_pkt_drops++;
-	return 0;
+		return opcode_handler_tbl[opcode];
+
+	return NULL;
 }
 
 /**
@@ -571,6 +567,7 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 	struct hfi1_pportdata *ppd = rcd->ppd;
 	struct hfi1_ibport *ibp = &ppd->ibport_data;
 	struct rvt_dev_info *rdi = &ppd->dd->verbs_dev.rdi;
+	opcode_handler packet_handler;
 	unsigned long flags;
 	u32 qp_num;
 	int lnh;
@@ -616,8 +613,11 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 		list_for_each_entry_rcu(p, &mcast->qp_list, list) {
 			packet->qp = p->qp;
 			spin_lock_irqsave(&packet->qp->r_lock, flags);
-			if (likely((qp_ok(opcode, packet))))
-				opcode_handler_tbl[opcode](packet);
+			packet_handler = qp_ok(opcode, packet);
+			if (likely(packet_handler))
+				packet_handler(packet);
+			else
+				ibp->rvp.n_pkt_drops++;
 			spin_unlock_irqrestore(&packet->qp->r_lock, flags);
 		}
 		/*
@@ -634,8 +634,11 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 			goto drop;
 		}
 		spin_lock_irqsave(&packet->qp->r_lock, flags);
-		if (likely((qp_ok(opcode, packet))))
-			opcode_handler_tbl[opcode](packet);
+		packet_handler = qp_ok(opcode, packet);
+		if (likely(packet_handler))
+			packet_handler(packet);
+		else
+			ibp->rvp.n_pkt_drops++;
 		spin_unlock_irqrestore(&packet->qp->r_lock, flags);
 		rcu_read_unlock();
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
