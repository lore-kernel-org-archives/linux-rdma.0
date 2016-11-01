From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] IB/rdmavt: Only put mmap_info ref if it exists
Date: Tue,  1 Nov 2016 13:44:12 -0700
Message-ID: <1478033052-147252-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rvt_create_qp() creates qp->ip only when a qp creation request comes from
userspace (udata is not NULL).  If we exceed the number of available
queue pairs however, the error path always attempts to put a kref to this
structure.  If the requestor is inside the kernel, this leads to a crash.

We fix this by checking that qp->ip is not NULL before caling kref_put().

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 6500c3b..0004e8b 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -884,7 +884,8 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 	return ret;
 
 bail_ip:
-	kref_put(&qp->ip->ref, rvt_release_mmap_info);
+	if (qp->ip)
+		kref_put(&qp->ip->ref, rvt_release_mmap_info);
 
 bail_qpn:
 	free_qpn(&rdi->qp_dev->qpn_table, qp->ibqp.qp_num);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
