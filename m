From: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] bnxt_re: fix a crash in qp error event processing
Date: Tue, 31 Oct 2017 14:59:17 +0530
Message-ID: <20171031092917.18933-1-sriharsha.basavapatna@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In bnxt_qplib_process_qp_event(), for qp error events we look up the
qp-handle and pass it for further processing. But we don't check if the
handle is NULL. This could lead to a crash in the called functions when
that qp-handle is dereferenced, if the qp is destroyed in the meantime.
Fix this by checking for a valid qp-handle in that function.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 2bdb1562bd21..b9b2f5a3c800 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -306,6 +306,8 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 			"QPLIB: qpid 0x%x, req_err=0x%x, resp_err=0x%x\n",
 			qp_id, err_event->req_err_state_reason,
 			err_event->res_err_state_reason);
+		if (!qp)
+			break;
 		bnxt_qplib_acquire_cq_locks(qp, &flags);
 		bnxt_qplib_mark_qp_error(qp);
 		bnxt_qplib_release_cq_locks(qp, &flags);
-- 
2.11.0.258.ge05806da9

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
