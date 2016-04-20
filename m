From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] IB/hfi1: Fix missing lock/unlock in verbs drain callback
Date: Wed, 20 Apr 2016 06:05:30 -0700
Message-ID: <20160420130529.28231.58580.stgit@scvm10.sc.intel.com>
References: <20160420125205.28231.86818.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160420125205.28231.86818.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The iowait_sdma_drained() callback lacked locking to
protect the qp s_flags field.

This causes the s_flags to be out of sync
on multiple CPUs, potentially corrupting the s_flags.

Fixes: a545f5308b6c ("staging/rdma/hfi: fix CQ completion order issue")
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 29a5ad2..dc9119e 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -519,10 +519,12 @@ static void iowait_sdma_drained(struct iowait *wait)
 	 * do the flush work until that QP's
 	 * sdma work has finished.
 	 */
+	spin_lock(&qp->s_lock);
 	if (qp->s_flags & RVT_S_WAIT_DMA) {
 		qp->s_flags &= ~RVT_S_WAIT_DMA;
 		hfi1_schedule_send(qp);
 	}
+	spin_unlock(&qp->s_lock);
 }
 
 /**

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
