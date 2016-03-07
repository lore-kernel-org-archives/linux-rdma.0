From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/10] IB/hfi1: Report pid in qp_stats to aid debug
Date: Mon, 07 Mar 2016 11:35:08 -0800
Message-ID: <20160307193508.4913.59794.stgit@scvm10.sc.intel.com>
References: <20160307193146.4913.42900.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307193146.4913.42900.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Tracking user/QP ownership is needed to debug issues with
user ULPs like OpenMPI.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c   |    5 +++--
 drivers/infiniband/sw/rdmavt/qp.c |    1 +
 include/rdma/rdmavt_qp.h          |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index beaeb4e..a97c182 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -678,7 +678,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 	send_context = qp_to_send_context(qp, priv->s_sc);
 	seq_printf(s,
-		   "N %d %s QP%x R %u %s %u %u %u f=%x %u %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) QP%x LID %x SL %u MTU %u %u %u %u SDE %p,%u SC %p,%u CQ %u %u\n",
+		   "N %d %s QP%x R %u %s %u %u %u f=%x %u %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) QP%x LID %x SL %u MTU %u %u %u %u SDE %p,%u SC %p,%u CQ %u %u PID %d\n",
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,
@@ -712,7 +712,8 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   send_context,
 		   send_context ? send_context->sw_index : 0,
 		   ibcq_to_rvtcq(qp->ibqp.send_cq)->queue->head,
-		   ibcq_to_rvtcq(qp->ibqp.send_cq)->queue->tail);
+		   ibcq_to_rvtcq(qp->ibqp.send_cq)->queue->tail,
+		   qp->pid);
 }
 
 void qp_comm_est(struct rvt_qp *qp)
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index ef82abf..de34474 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -786,6 +786,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 				goto bail_ip;
 			}
 		}
+		qp->pid = current->pid;
 	}
 
 	spin_lock(&rdi->n_qps_lock);
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index f2f4df0..497e590 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -251,6 +251,7 @@ struct rvt_qp {
 
 	enum ib_mtu path_mtu;
 	int srate_mbps;		/* s_srate (below) converted to Mbit/s */
+	pid_t pid;		/* pid for user mode QPs */
 	u32 remote_qpn;
 	u32 qkey;               /* QKEY for this QP (for UD or RD) */
 	u32 s_size;             /* send work queue size */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
