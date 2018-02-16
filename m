From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-rc 3/6] RDMA/bnxt_re: Unpin SQ and RQ memory if QP create fails
Date: Thu, 15 Feb 2018 21:20:10 -0800
Message-ID: <1518758413-20850-4-git-send-email-selvin.xavier@broadcom.com>
References: <1518758413-20850-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518758413-20850-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Driver leaves the QP memory pinned if QP create command
fails from the FW. Avoids this scenario by adding a proper
exit path if the FW command fails.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 7943707..b7eb104 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1184,7 +1184,7 @@ struct ib_qp *bnxt_re_create_qp(struct ib_pd *ib_pd,
 		rc = bnxt_qplib_create_qp(&rdev->qplib_res, &qp->qplib_qp);
 		if (rc) {
 			dev_err(rdev_to_dev(rdev), "Failed to create HW QP");
-			goto fail;
+			goto free_umem;
 		}
 	}
 
@@ -1212,6 +1212,13 @@ struct ib_qp *bnxt_re_create_qp(struct ib_pd *ib_pd,
 	return &qp->ib_qp;
 qp_destroy:
 	bnxt_qplib_destroy_qp(&rdev->qplib_res, &qp->qplib_qp);
+free_umem:
+	if (udata) {
+		if (qp->rumem)
+			ib_umem_release(qp->rumem);
+		if (qp->sumem)
+			ib_umem_release(qp->sumem);
+	}
 fail:
 	kfree(qp);
 	return ERR_PTR(rc);
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
