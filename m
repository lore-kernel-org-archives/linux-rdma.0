From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/23] IB/qib: Use standard refcount wrapper for QPs
Date: Wed, 07 Dec 2016 19:34:00 -0800
Message-ID: <20161208033358.21135.49455.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use the standard driver wrapper for QP reference counters.
This makes the code more maintainable.

Fixes: Commit 4d6f85c3fa55 ("IB/rdmavt, IB/qib, IB/hfi1: Use new QP put get routines")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c |    3 +--
 drivers/infiniband/hw/qib/qib_verbs.c  |   20 ++++++++------------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 728e0a0..2b5982f 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -420,8 +420,7 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 						if (list_empty(&qp->rspwait)) {
 							qp->r_flags |=
 								RVT_R_RSP_NAK;
-							atomic_inc(
-								&qp->refcount);
+							rvt_get_qp(qp);
 							list_add_tail(
 							 &qp->rspwait,
 							 &rcd->qp_wait_list);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 954f150..2044824 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -464,7 +464,7 @@ static void mem_timer(unsigned long data)
 		priv = list_entry(list->next, struct qib_qp_priv, iowait);
 		qp = priv->owner;
 		list_del_init(&priv->iowait);
-		atomic_inc(&qp->refcount);
+		rvt_get_qp(qp);
 		if (!list_empty(list))
 			mod_timer(&dev->mem_timer, jiffies + 1);
 	}
@@ -477,8 +477,7 @@ static void mem_timer(unsigned long data)
 			qib_schedule_send(qp);
 		}
 		spin_unlock_irqrestore(&qp->s_lock, flags);
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
+		rvt_put_qp(qp);
 	}
 }
 
@@ -762,7 +761,7 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 				  iowait);
 		qp = priv->owner;
 		list_del_init(&priv->iowait);
-		atomic_inc(&qp->refcount);
+		rvt_get_qp(qp);
 		spin_unlock_irqrestore(&dev->rdi.pending_lock, flags);
 
 		spin_lock_irqsave(&qp->s_lock, flags);
@@ -772,8 +771,7 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 		}
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
+		rvt_put_qp(qp);
 	} else
 		spin_unlock_irqrestore(&dev->rdi.pending_lock, flags);
 }
@@ -808,7 +806,7 @@ void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail)
 			break;
 		avail -= qpp->s_tx->txreq.sg_count;
 		list_del_init(&qpp->iowait);
-		atomic_inc(&qp->refcount);
+		rvt_get_qp(qp);
 		qps[n++] = qp;
 	}
 
@@ -822,8 +820,7 @@ void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail)
 			qib_schedule_send(qp);
 		}
 		spin_unlock(&qp->s_lock);
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
+		rvt_put_qp(qp);
 	}
 }
 
@@ -1288,7 +1285,7 @@ void qib_ib_piobufavail(struct qib_devdata *dd)
 		priv = list_entry(list->next, struct qib_qp_priv, iowait);
 		qp = priv->owner;
 		list_del_init(&priv->iowait);
-		atomic_inc(&qp->refcount);
+		rvt_get_qp(qp);
 		qps[n++] = qp;
 	}
 	dd->f_wantpiobuf_intr(dd, 0);
@@ -1306,8 +1303,7 @@ void qib_ib_piobufavail(struct qib_devdata *dd)
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 
 		/* Notify qib_destroy_qp() if it is waiting. */
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
+		rvt_put_qp(qp);
 	}
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
