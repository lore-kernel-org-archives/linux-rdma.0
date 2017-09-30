From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] i40iw: Do not allow posting WR after QP is flushed
Date: Fri, 29 Sep 2017 20:29:40 -0500
Message-ID: <20170930012942.9128-4-shiraz.saleem@intel.com>
References: <20170930012942.9128-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170930012942.9128-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A Work Request (WR) posted after QP is flushed will not
get a flush completion.

Correct this problem by not allowing posting of WRs
after a QP is flushed.

Fixes: d37498417947 ("i40iw: add files for iwarp interface")
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 28b3d02..58d815f 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2202,6 +2202,12 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 	ukqp = &iwqp->sc_qp.qp_uk;
 
 	spin_lock_irqsave(&iwqp->lock, flags);
+
+	if (iwqp->flush_issued) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	while (ib_wr) {
 		inv_stag = false;
 		memset(&info, 0, sizeof(info));
@@ -2344,6 +2350,7 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 		ib_wr = ib_wr->next;
 	}
 
+out:
 	if (err)
 		*bad_wr = ib_wr;
 	else
@@ -2376,6 +2383,12 @@ static int i40iw_post_recv(struct ib_qp *ibqp,
 
 	memset(&post_recv, 0, sizeof(post_recv));
 	spin_lock_irqsave(&iwqp->lock, flags);
+
+	if (iwqp->flush_issued) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	while (ib_wr) {
 		post_recv.num_sges = ib_wr->num_sge;
 		post_recv.wr_id = ib_wr->wr_id;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
