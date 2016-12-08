From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/23] IB/hfi1: Replace qp->refcount release code with
 standard driver wrapper
Date: Wed, 07 Dec 2016 19:33:46 -0800
Message-ID: <20161208033345.21135.5524.stgit@scvm10.sc.intel.com>
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

Some parts of the code don't use the standard release
wrapper rvt_put_qp() for decrementing and testing
the refcount to then try to use a resource.
Replace this code with the standard driver wrapper.

Fixes: Commit 4d6f85c3fa55 ("IB/rdmavt, IB/qib, IB/hfi1: Use new QP put get routines")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c  |    3 +--
 drivers/infiniband/sw/rdmavt/mcast.c |    5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index c5efff2..4fbaee6 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -795,8 +795,7 @@ static inline void process_rcv_qp_work(struct hfi1_packet *packet)
 				hfi1_schedule_send(qp);
 			spin_unlock_irqrestore(&qp->s_lock, flags);
 		}
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
+		rvt_put_qp(qp);
 	}
 }
 
diff --git a/drivers/infiniband/sw/rdmavt/mcast.c b/drivers/infiniband/sw/rdmavt/mcast.c
index 983d319..05c8c2a 100644
--- a/drivers/infiniband/sw/rdmavt/mcast.c
+++ b/drivers/infiniband/sw/rdmavt/mcast.c
@@ -81,7 +81,7 @@ void rvt_driver_mcast_init(struct rvt_dev_info *rdi)
 		goto bail;
 
 	mqp->qp = qp;
-	atomic_inc(&qp->refcount);
+	rvt_get_qp(qp);
 
 bail:
 	return mqp;
@@ -92,8 +92,7 @@ static void rvt_mcast_qp_free(struct rvt_mcast_qp *mqp)
 	struct rvt_qp *qp = mqp->qp;
 
 	/* Notify hfi1_destroy_qp() if it is waiting. */
-	if (atomic_dec_and_test(&qp->refcount))
-		wake_up(&qp->wait);
+	rvt_put_qp(qp);
 
 	kfree(mqp);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
