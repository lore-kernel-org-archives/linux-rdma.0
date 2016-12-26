From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] qedr: fix MTU returned from QP query
Date: Mon, 26 Dec 2016 08:40:58 +0200
Message-ID: <1482734458-32131-3-git-send-email-Ram.Amrani@cavium.com>
References: <1482734458-32131-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482734458-32131-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

MTU value returned from QP query should include overhead.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 0bb6303..3865d25 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1930,7 +1930,7 @@ int qedr_query_qp(struct ib_qp *ibqp,
 
 	qp_attr->qp_state = qedr_get_ibqp_state(params.state);
 	qp_attr->cur_qp_state = qedr_get_ibqp_state(params.state);
-	qp_attr->path_mtu = iboe_get_mtu(params.mtu);
+	qp_attr->path_mtu = ib_mtu_int_to_enum(params.mtu);
 	qp_attr->path_mig_state = IB_MIG_MIGRATED;
 	qp_attr->rq_psn = params.rq_psn;
 	qp_attr->sq_psn = params.sq_psn;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
