From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/8] IB/rdmavt: Add destroy qp verb
Date: Sat, 09 Jan 2016 07:00:25 -0800
Message-ID: <20160109150024.8585.25069.stgit@scvm10.sc.intel.com>
References: <20160109145731.8585.48926.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109145731.8585.48926.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds in support the qp destroy verb call.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index b8c7c49..6aa7d6f 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1171,13 +1171,30 @@ inval:
  */
 int rvt_destroy_qp(struct ib_qp *ibqp)
 {
-	/*
-	 * VT-DRIVER-API: qp_flush()
-	 * Driver provies a mechanism to flush and wait for that flush to
-	 * finish.
-	 */
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
+	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
 
-	return -EOPNOTSUPP;
+	spin_lock_irq(&qp->r_lock);
+	spin_lock(&qp->s_lock);
+	rvt_reset_qp(rdi, qp, ibqp->qp_type);
+	spin_unlock(&qp->s_lock);
+	spin_unlock_irq(&qp->r_lock);
+
+	/* qpn is now available for use again */
+	rvt_free_qpn(&rdi->qp_dev->qpn_table, qp->ibqp.qp_num);
+
+	spin_lock(&rdi->n_qps_lock);
+	rdi->n_qps_allocated--;
+	spin_unlock(&rdi->n_qps_lock);
+
+	if (qp->ip)
+		kref_put(&qp->ip->ref, rvt_release_mmap_info);
+	else
+		vfree(qp->r_rq.wq);
+	vfree(qp->s_wq);
+	rdi->driver_f.qp_priv_free(rdi, qp);
+	kfree(qp);
+	return 0;
 }
 
 int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
